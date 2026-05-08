-- ============================================================
--  DIMENSION: PRODUCTOS DE COMERCIO EXTERIOR
--  Objetivo: Estructura para exportaciones, importaciones
--            y análisis de balanza comercial.
-- ============================================================

-- COMMAND
-- ============================================================
-- PROCESS: Clean External Trade Product Dimension
-- TARGET: medallion_lab.silver.dim_producto_ex_im_clean
-- DESCRIPTION: Cleaning and casting product data for external trade.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_producto_ex_im_clean AS
SELECT
    TRY_CAST (
        REPLACE (CE_PRODUCTO, '[,\\.]', '') AS VARCHAR(255)
    ) AS PRODUCTO,
    TRY_CAST (
        REPLACE (Producto_ID, '[,\\.]', '') AS INT
    ) AS ID_PRODUCTO,
    TRY_CAST (
        REPLACE (
                ID_Producto_related,
                '[,\\.]',
                ''
            ) AS INT
    ) AS ID_PRODUCTO_RELATED
FROM medallion_lab.bronze.dim_producto_ex_im_raw
WHERE
    Producto_ID IS NOT NULL
    AND ID_Producto_related IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Period Dimension
-- TARGET: medallion_lab.silver.dim_periodo_clean
-- DESCRIPTION: Cleaning and casting period data from bronze layer.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_periodo_clean AS
SELECT
    TRY_CAST (
        REPLACE (CE_PERIODO, '[,\\.]', '') AS VARCHAR(255)
    ) AS PERIODO,
    TRY_CAST (
        REPLACE (PERIODO_ID, '[,\\.]', '') AS INT
    ) AS ID_PERIODO
FROM medallion_lab.bronze.dim_periodo_raw
WHERE
    PERIODO_ID IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Agricultural Commercial Fact Table
-- TARGET: medallion_lab.silver.th_comercial_agricola_clean
-- DESCRIPTION: Processing commercial agricultural facts, cleaning numeric values.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.th_comercial_agricola_clean AS
SELECT
    TRY_CAST (
        REGEXP_REPLACE(ID_ANIO, '[,\\.]', '') AS INT
    ) AS ID_ANIO,
    TRY_CAST (
        REGEXP_REPLACE(ID_PERIODO, '[,\\.]', '') AS INT
    ) AS ID_PERIODO,
    TRY_CAST (
        REGEXP_REPLACE(ID_PRODUCTO, '[,\\.]', '') AS INT
    ) AS ID_PRODUCTO,

-- CE_EXP_PESO y CE_EXP_VALOR usando la función clean_number
clean_number_flat (CE_EXP_PESO) AS CE_EXP_PESO,
clean_number_flat (CE_EXP_VALOR) AS CE_EXP_VALOR,
clean_number_flat (CE_IMP_PESO) AS CE_IMP_PESO,
clean_number_flat (CE_IMP_VALOR) AS CE_IMP_VALOR,
clean_number_flat (CE_BAL_VALOR) AS CE_BAL_VALOR,
clean_number_flat (CE_BAL_PESO) AS CE_BAL_PESO
FROM medallion_lab.bronze.th_comercial_agricola_raw
WHERE
    ID_ANIO IS NOT NULL
    AND ID_PERIODO IS NOT NULL
    AND ID_PRODUCTO IS NOT NULL;