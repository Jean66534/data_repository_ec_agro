-- ============================================================
--  DIMENSION: PRECIOS AL PRODUCTOR
--  Objetivo:
-- ============================================================

-- COMMAND
-- ============================================================
-- PROCESS: Clean Month Dimension
-- TARGET: medallion_lab.silver.dim_mes_clean
-- DESCRIPTION: Cleaning and casting month data from bronze layer.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_mes_clean AS
SELECT TRY_CAST (
        REPLACE (PP_MES, '[,\\.]', '') AS VARCHAR(255)
    ) AS MES, TRY_CAST (
        REPLACE (id_mes, '[,\\.]', '') AS INT
    ) AS ID_MES
FROM medallion_lab.bronze.dim_mes_raw
WHERE
    id_mes IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Unit Dimension
-- TARGET: medallion_lab.silver.dim_unidad_clean
-- DESCRIPTION: Cleaning and casting measurement unit data from bronze layer.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_unidad_clean AS
SELECT
    TRY_CAST (
        REPLACE (PP_UNIDAD, '[,\\.]', '') AS VARCHAR(255)
    ) AS UNIDAD,
    TRY_CAST (
        REPLACE (id_unidad, '[,\\.]', '') AS INT
    ) AS ID_UNIDAD
FROM medallion_lab.bronze.dim_unidad_raw
WHERE
    id_unidad IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Price Product Dimension
-- TARGET: medallion_lab.silver.dim_producto_precios_clean
-- DESCRIPTION: Cleaning and casting product data for pricing analysis.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_producto_precios_clean AS
SELECT
    TRY_CAST (
        REPLACE (PP_PRODUCTO, '[,\\.]', '') AS VARCHAR(255)
    ) AS PRODUCTO,
    TRY_CAST (
        REPLACE (id_producto, '[,\\.]', '') AS INT
    ) AS ID_PRODUCTO,
    TRY_CAST (
        REPLACE (
                ID_producto_relacionado,
                '[,\\.]',
                ''
            ) AS INT
    ) AS ID_PRODUCTO_RELATED
FROM medallion_lab.bronze.dim_producto_precios_raw
WHERE
    id_producto IS NOT NULL
    AND ID_producto_relacionado IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Producer Prices Fact Table
-- TARGET: medallion_lab.silver.th_precios_productor_clean
-- DESCRIPTION: Processing producer price facts, cleaning USD and USD/KG values.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.th_precios_productor_clean AS
SELECT
    TRY_CAST (
        REGEXP_REPLACE(id_anio, '[,\\.]', '') AS INT
    ) AS ID_ANIO,
    TRY_CAST (
        REGEXP_REPLACE(id_mes, '[,\\.]', '') AS INT
    ) AS ID_MES,
    TRY_CAST (
        REGEXP_REPLACE(id_producto, '[,\\.]', '') AS INT
    ) AS ID_PRODUCTO,
    TRY_CAST (
        REGEXP_REPLACE(id_unidad, '[,\\.]', '') AS INT
    ) AS ID_UNIDAD,
    clean_number (PP_PONDERADO_USD) AS PP_PONDERADO_USD,
    clean_number (PP_PONDERADO_USD_KG) AS PP_PONDERADO_USD_KG
FROM medallion_lab.bronze.th_precios_productor_raw
WHERE
    id_anio IS NOT NULL
    AND id_mes IS NOT NULL
    AND id_producto IS NOT NULL
    AND id_unidad IS NOT NULL;