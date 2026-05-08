-- ============================================================
--  DIMENSION: CARACTERISTICAS GENERALES DE PERSONA PRODUCTORA
--  Objetivo:
-- ============================================================

-- COMMAND
-- ============================================================
-- PROCESS: Clean Hectares Range Dimension
-- TARGET: medallion_lab.silver.dim_rango_hectareas_clean
-- DESCRIPTION: Cleaning and casting hectares range data from bronze layer.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_rango_hectareas_clean AS
SELECT
    TRY_CAST (
        REPLACE (Rango_HA, '[,\\.]', '') AS VARCHAR(255)
    ) AS RANGO_HA,
    TRY_CAST (
        REPLACE (ID_Rango_HA, '[,\\.]', '') AS INT
    ) AS ID_RANGO_HA
FROM medallion_lab.bronze.dim_rango_hectareas_raw
WHERE
    ID_Rango_HA IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Gender Dimension
-- TARGET: medallion_lab.silver.dim_genero_clean
-- DESCRIPTION: Cleaning and casting gender data from bronze layer.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_genero_clean AS
SELECT
    TRY_CAST (
        REPLACE (Genero, '[,\\.]', '') AS VARCHAR(255)
    ) AS GENERO,
    TRY_CAST (
        REPLACE (ID_Genero, '[,\\.]', '') AS INT
    ) AS ID_GENERO
FROM medallion_lab.bronze.dim_genero_raw
WHERE
    ID_Genero IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Age Dimension
-- TARGET: medallion_lab.silver.dim_edad_clean
-- DESCRIPTION: Cleaning and casting age range data from bronze layer.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_edad_clean AS
SELECT
    TRY_CAST (
        REPLACE (Edad, '[,\\.]', '') AS VARCHAR(255)
    ) AS EDAD,
    TRY_CAST (
        REPLACE (ID_edad, '[,\\.]', '') AS INT
    ) AS ID_EDAD
FROM medallion_lab.bronze.dim_edad_raw
WHERE
    ID_edad IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Ethnicity Dimension
-- TARGET: medallion_lab.silver.dim_etnia_clean
-- DESCRIPTION: Cleaning and casting ethnicity data from bronze layer.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_etnia_clean AS
SELECT
    TRY_CAST (
        REPLACE (Etnia, '[,\\.]', '') AS VARCHAR(255)
    ) AS ETNIA,
    TRY_CAST (
        REPLACE (ID_Etnia, '[,\\.]', '') AS INT
    ) AS ID_ETNIA
FROM medallion_lab.bronze.dim_etnia_raw
WHERE
    ID_Etnia IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Education Dimension
-- TARGET: medallion_lab.silver.dim_formacion_clean
-- DESCRIPTION: Cleaning and casting education/training data from bronze layer.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_formacion_clean AS
SELECT
    TRY_CAST (
        REPLACE (Formacion, '[,\\.]', '') AS VARCHAR(255)
    ) AS FORMACION,
    TRY_CAST (
        REPLACE (ID_Formacion, '[,\\.]', '') AS INT
    ) AS ID_FORMACION
FROM medallion_lab.bronze.dim_formacion
WHERE
    ID_Formacion IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Gender Fact Table
-- TARGET: medallion_lab.silver.th_genero_clean
-- DESCRIPTION: Processing gender distribution facts, cleaning percentage values.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.th_genero_clean AS
SELECT
    TRY_CAST (
        REGEXP_REPLACE(`ID_Años`, '[,\\.]', '') AS INT
    ) AS ID_ANIO,
    TRY_CAST (
        REGEXP_REPLACE(ID_Genero, '[,\\.]', '') AS INT
    ) AS ID_GENERO,
    TRY_CAST (
        REGEXP_REPLACE(ID_rango_Ha, '[,\\.]', '') AS INT
    ) AS ID_RANGO_HA,
    clean_number (Porcentaje) AS PORCENTAJE
FROM medallion_lab.bronze.th_genero_raw
WHERE
    `ID_Años` IS NOT NULL
    AND ID_Genero IS NOT NULL
    AND ID_rango_Ha IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Education Fact Table
-- TARGET: medallion_lab.silver.th_formacion_clean
-- DESCRIPTION: Processing education distribution facts, cleaning percentage values.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.th_formacion_clean AS
SELECT
    TRY_CAST (
        REGEXP_REPLACE(`ID_Año`, '[,\\.]', '') AS INT
    ) AS ID_ANIO,
    TRY_CAST (
        REGEXP_REPLACE(ID_Formacion, '[,\\.]', '') AS INT
    ) AS ID_FORMACION,
    TRY_CAST (
        REGEXP_REPLACE(`ID_rango_Ha `, '[,\\.]', '') AS INT
    ) AS ID_RANGO_HA,
    clean_number (Porcentaje) AS PORCENTAJE
FROM medallion_lab.bronze.th_formacion_raw
WHERE
    `ID_Año` IS NOT NULL
    AND ID_Formacion IS NOT NULL
    AND `ID_rango_Ha ` IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Ethnicity Fact Table
-- TARGET: medallion_lab.silver.th_etnia_clean
-- DESCRIPTION: Processing ethnicity distribution facts, cleaning percentage values.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.th_etnia_clean AS
SELECT
    TRY_CAST (
        REGEXP_REPLACE(`ID_Año`, '[,\\.]', '') AS INT
    ) AS ID_ANIO,
    TRY_CAST (
        REGEXP_REPLACE(ID_Etnia, '[,\\.]', '') AS INT
    ) AS ID_ETNIA,
    TRY_CAST (
        REGEXP_REPLACE(`ID_rango_Ha `, '[,\\.]', '') AS INT
    ) AS ID_RANGO_HA,
    clean_number (Porcentaje) AS PORCENTAJE
FROM medallion_lab.bronze.th_etnia_raw
WHERE
    `ID_Año` IS NOT NULL
    AND ID_Etnia IS NOT NULL
    AND `ID_rango_Ha ` IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Age Fact Table
-- TARGET: medallion_lab.silver.th_edad_clean
-- DESCRIPTION: Processing age distribution facts, cleaning percentage values.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.th_edad_clean AS
SELECT
    TRY_CAST (
        REGEXP_REPLACE(`ID_Año`, '[,\\.]', '') AS INT
    ) AS ID_ANIO,
    TRY_CAST (
        REGEXP_REPLACE(ID_edad, '[,\\.]', '') AS INT
    ) AS ID_EDAD,
    TRY_CAST (
        REGEXP_REPLACE(`ID_rango_Ha `, '[,\\.]', '') AS INT
    ) AS ID_RANGO_HA,
    clean_number (Porcentaje) AS PORCENTAJE
FROM medallion_lab.bronze.th_edad_raw
WHERE
    `ID_Año` IS NOT NULL
    AND ID_edad IS NOT NULL
    AND `ID_rango_Ha ` IS NOT NULL;