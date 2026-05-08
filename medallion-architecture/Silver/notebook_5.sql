-- ============================================================
--  DIMENSION: Cultivos Permanentes y transitorios
--  Objetivo:
-- ============================================================

-- COMMAND
-- ============================================================
-- PROCESS: Clean Causes Dimension
-- TARGET: medallion_lab.silver.dim_causas_clean
-- DESCRIPTION: Cleaning and casting agricultural loss causes data.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_causas_clean AS
SELECT
    TRY_CAST (
        REPLACE (causa, '[,\\.]', '') AS VARCHAR(255)
    ) AS CAUSAS,
    TRY_CAST (
        REPLACE (id_causa, '[,\\.]', '') AS INT
    ) AS ID_CAUSAS
FROM medallion_lab.bronze.dim_causas_raw
WHERE
    id_causa IS NOT NULL;

-- ============================================================
-- PROCESS: Clean Permanent Crops Production Fact Table
-- TARGET: medallion_lab.silver.th_product_permanentes_clean
-- DESCRIPTION: Processing production facts for permanent crops.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.th_product_permanentes_clean AS
SELECT
    TRY_CAST (
        REGEXP_REPLACE(ID_ANIO, '[,\\.]', '') AS INT
    ) AS ID_ANIO,
    TRY_CAST (
        REGEXP_REPLACE(ID_PRODUCTO, '[,\\.]', '') AS INT
    ) AS ID_PRODUCTO,
    TRY_CAST (
        REGEXP_REPLACE(ID_PRODUCTOR, '[,\\.]', '') AS INT
    ) AS ID_PRODUCTOR,

-- columna numérica limpia usando la UDF
clean_number (PLANTADA) AS PLANTADA,
clean_number (EDAD_PRODUCT) AS EDAD_PRODUCT,
clean_number (COSECHADA) AS COSECHADA,
clean_number (PRODUCCION) AS PRODUCCION,
clean_number (VENTAS) AS VENTAS
FROM medallion_lab.bronze.th_product_permanentes_raw
WHERE
    ID_ANIO IS NOT NULL
    AND ID_PRODUCTO IS NOT NULL
    AND ID_PRODUCTOR IS NOT NULL;

-- ============================================================
-- PROCESS: Clean Transitory Crops Production Fact Table
-- TARGET: medallion_lab.silver.th_product_transitorios_clean
-- DESCRIPTION: Processing production facts for transitory crops.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.th_product_transitorios_clean AS
SELECT
    TRY_CAST (
        REGEXP_REPLACE(ID_ANIO, '[,\\.]', '') AS INT
    ) AS ID_ANIO,
    TRY_CAST (
        REGEXP_REPLACE(ID_PRODUCTO, '[,\\.]', '') AS INT
    ) AS ID_PRODUCTO,
    TRY_CAST (
        REGEXP_REPLACE(ID_PRODUCTOR, '[,\\.]', '') AS INT
    ) AS ID_PRODUCTOR,

-- columna numérica limpia usando la UDF
clean_number (PLANTADA) AS PLANTADA,
clean_number (COSECHADA) AS COSECHADA,
clean_number (PRODUCCION) AS PRODUCCION,
clean_number (VENTAS) AS VENTAS
FROM medallion_lab.bronze.th_product_transitorios_raw
WHERE
    ID_ANIO IS NOT NULL
    AND ID_PRODUCTO IS NOT NULL
    AND ID_PRODUCTOR IS NOT NULL;

-- ============================================================
-- PROCESS: Clean Permanent Crops Causes Fact Table
-- TARGET: medallion_lab.silver.th_causas_permanentes_clean
-- DESCRIPTION: Processing loss cause facts for permanent crops.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.th_causas_permanentes_clean AS
SELECT
    TRY_CAST (
        REGEXP_REPLACE(ID_ANIO, '[,\\.]', '') AS INT
    ) AS ID_ANIO,
    TRY_CAST (
        REGEXP_REPLACE(ID_PRODUCTO, '[,\\.]', '') AS INT
    ) AS ID_PRODUCTO,
    TRY_CAST (
        REGEXP_REPLACE(ID_PRODUCTOR, '[,\\.]', '') AS INT
    ) AS ID_PRODUCTOR,
    TRY_CAST (
        REGEXP_REPLACE(id_causa, '[,\\.]', '') AS INT
    ) AS ID_CAUSA,
    TRY_CAST (
        REPLACE (causa, '[,\\.]', '') AS VARCHAR(255)
    ) AS CAUSA,
    clean_number (valor) AS VALOR,
    clean_number (TOTAL) AS TOTAL
FROM medallion_lab.bronze.th_causas_permanentes_raw
WHERE
    ID_ANIO IS NOT NULL
    AND ID_PRODUCTO IS NOT NULL
    AND ID_PRODUCTOR IS NOT NULL
    AND id_causa IS NOT NULL;

-- ============================================================
-- PROCESS: Clean Transitory Crops Causes Fact Table
-- TARGET: medallion_lab.silver.th_causas_transitorios_clean
-- DESCRIPTION: Processing loss cause facts for transitory crops.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.th_causas_transitorios_clean AS
SELECT
    TRY_CAST (
        REGEXP_REPLACE(ID_ANIO, '[,\\.]', '') AS INT
    ) AS ID_ANIO,
    TRY_CAST (
        REGEXP_REPLACE(ID_PRODUCTO, '[,\\.]', '') AS INT
    ) AS ID_PRODUCTO,
    TRY_CAST (
        REGEXP_REPLACE(ID_PRODUCTOR, '[,\\.]', '') AS INT
    ) AS ID_PRODUCTOR,
    TRY_CAST (
        REGEXP_REPLACE(id_causa, '[,\\.]', '') AS INT
    ) AS ID_CAUSA,
    TRY_CAST (
        REPLACE (causa, '[,\\.]', '') AS VARCHAR(255)
    ) AS CAUSA,
    clean_number (valor) AS VALOR,
    clean_number (TOTAL) AS TOTAL
FROM medallion_lab.bronze.th_causas_transitorios_raw
WHERE
    ID_ANIO IS NOT NULL
    AND ID_PRODUCTO IS NOT NULL
    AND ID_PRODUCTOR IS NOT NULL
    AND id_causa IS NOT NULL;