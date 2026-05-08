-- COMMAND
-- ============================================================
-- PROCESS: Clean Land Use Dimension
-- TARGET: medallion_lab.silver.dim_uso_suelo_clean
-- DESCRIPTION: Cleaning and casting land use classification data.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_uso_suelo_clean AS
SELECT
    TRY_CAST (
        REPLACE (suelo, '[,\\.]', '') AS VARCHAR(255)
    ) AS SUELO,
    TRY_CAST (
        REPLACE (id_uso_suelo, '[,\\.]', '') AS INT
    ) AS ID_USO_SUELO
FROM medallion_lab.bronze.dim_uso_suelo_raw
WHERE
    id_uso_suelo IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Land Use Fact Table
-- TARGET: medallion_lab.silver.th_uso_suelo_clean
-- DESCRIPTION: Processing land use distribution facts and totals.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.th_uso_suelo_clean AS
SELECT
    TRY_CAST (
        REGEXP_REPLACE(ID_ANIO, '[,\\.]', '') AS INT
    ) AS ID_ANIO,
    TRY_CAST (
        REGEXP_REPLACE(Region_ID, '[,\\.]', '') AS INT
    ) AS ID_REGION,
    TRY_CAST (
        REGEXP_REPLACE(ID_PROVINCIA, '[,\\.]', '') AS INT
    ) AS ID_PROVINCIA,
    TRY_CAST (
        REGEXP_REPLACE(id_uso_suelo, '[,\\.]', '') AS INT
    ) AS ID_USO_SUELO,
    clean_number (valor) AS VALOR,
    clean_number (TOTAL) AS TOTAL
FROM medallion_lab.bronze.th_uso_suelo_raw
WHERE
    ID_ANIO IS NOT NULL
    AND Region_ID IS NOT NULL
    AND ID_PROVINCIA IS NOT NULL
    AND id_uso_suelo IS NOT NULL;