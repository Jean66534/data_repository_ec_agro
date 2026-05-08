-- COMMAND
-- ============================================================
-- PROCESS: Clean Foreign Trade Product Dimension
-- TARGET: medallion_lab.silver.dim_producto_comercio_exterior_clean
-- DESCRIPTION: Cleaning and casting product data for foreign trade.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_producto_comercio_exterior_clean AS
SELECT
    TRY_CAST (
        REPLACE (producto, '[,\\.]', '') AS VARCHAR(255)
    ) AS PRODUCTO,
    TRY_CAST (
        REPLACE (id_producto, '[,\\.]', '') AS INT
    ) AS ID_PRODUCTO,
    TRY_CAST (
        REPLACE (
                id_producto_related,
                '[,\\.]',
                ''
            ) AS INT
    ) AS ID_PRODUCTO_RELATED
FROM medallion_lab.bronze.dim_producto_comercio_exterior_raw
WHERE
    id_producto IS NOT NULL
    AND id_producto_related IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Foreign Trade Element Dimension
-- TARGET: medallion_lab.silver.dim_elemento_comercio_exterior_clean
-- DESCRIPTION: Cleaning and casting element data for foreign trade.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_elemento_comercio_exterior_clean AS
SELECT
    TRY_CAST (
        REPLACE (elemento, '[,\\.]', '') AS VARCHAR(255)
    ) AS ELEMENTO,
    TRY_CAST (
        REPLACE (id_elemento, '[,\\.]', '') AS INT
    ) AS ID_ELEMENTO
FROM medallion_lab.bronze.dim_elemento_comercio_exterior_raw
WHERE
    id_elemento IS NOT NULL;

-- ============================================================
-- PROCESS: Clean Partner Countries Dimension
-- TARGET: medallion_lab.silver.dim_paises_socios_clean
-- DESCRIPTION: Normalizing and translating partner country names to English.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_paises_socios_clean AS
SELECT
    TRY_CAST (
        REPLACE (id_pais, '[,\\.]', '') AS INT
    ) AS ID_PAIS,
    TRIM(pais) AS PAIS_ORIGINAL,
    CASE
        WHEN UPPER(pais) LIKE 'PAÍSES BAJOS%' THEN 'Netherlands'
        WHEN UPPER(pais) LIKE 'CHINA, TAIWÁN%' THEN 'Taiwan'
        WHEN UPPER(pais) LIKE 'IRÁN%' THEN 'Iran'
        WHEN UPPER(pais) LIKE 'REPÚBLICA ÁRABE SIRIA%' THEN 'Syria'
        WHEN UPPER(pais) LIKE 'REPÚBLICA DOMINICANA%' THEN 'Dominican Republic'
        WHEN UPPER(pais) LIKE 'REPÚBLICA DE MOLDOVA%' THEN 'Moldova'
        WHEN UPPER(pais) LIKE 'SUDÁFRICA%' THEN 'South Africa'
        WHEN UPPER(pais) LIKE 'RUMANÍA%' THEN 'Romania'
        WHEN UPPER(pais) LIKE 'LETONIA%' THEN 'Latvia'
        WHEN UPPER(pais) LIKE 'KAZAJSTÁN%' THEN 'Kazakhstan'
        WHEN UPPER(pais) LIKE 'KIRGUISTÁN%' THEN 'Kyrgyzstan'
        WHEN UPPER(pais) LIKE 'TAYIKISTÁN%' THEN 'Tajikistan'
        WHEN UPPER(pais) LIKE 'TÚNEZ%' THEN 'Tunisia'
        WHEN UPPER(pais) LIKE 'SUIZA%' THEN 'Switzerland'
        WHEN UPPER(pais) LIKE 'SUECIA%' THEN 'Sweden'
        WHEN UPPER(pais) LIKE 'JAPÓN%' THEN 'Japan'
        WHEN UPPER(pais) LIKE 'BÉLGICA%' THEN 'Belgium'
        WHEN UPPER(pais) LIKE 'BRASIL%' THEN 'Brazil'
        WHEN UPPER(pais) LIKE 'ESPAÑA%' THEN 'Spain'
        WHEN UPPER(pais) LIKE 'RUSSIA%' THEN 'Russia'
        WHEN UPPER(pais) LIKE 'LÍBANO%' THEN 'Lebanon'
        ELSE INITCAP (pais)
    END AS PAIS_CANONICO_EN
FROM medallion_lab.bronze.dim_paises_socios_raw
WHERE
    id_pais IS NOT NULL;

-- ============================================================
-- PROCESS: Clean Country ISO Dimension
-- TARGET: medallion_lab.silver.dim_pais_iso_clean
-- DESCRIPTION: Cleaning and normalizing country ISO codes and names.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_pais_iso_clean AS
SELECT
    UPPER(
        TRIM(
            TRANSLATE (
                pais_es,
                'áéíóúÁÉÍÓÚñÑ',
                'aeiouAEIOUnN'
            )
        )
    ) AS PAIS_ES_NORM,
    UPPER(
        TRIM(
            TRANSLATE (
                pais_en,
                'áéíóúÁÉÍÓÚñÑ',
                'aeiouAEIOUnN'
            )
        )
    ) AS PAIS_EN_NORM,
    UPPER(TRIM(iso)) AS ISO,
    TRY_CAST (
        REPLACE (id_pais, '[,\\.]', '') AS INT
    ) AS ID_PAIS
FROM medallion_lab.bronze.dim_paises_iso_raw
WHERE
    id_pais IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Foreign Trade Fact Table
-- TARGET: medallion_lab.silver.th_comercio_exterior_clean
-- DESCRIPTION: Processing foreign trade facts, including partner and product IDs.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.th_comercio_exterior_clean AS
SELECT
    TRY_CAST (
        REGEXP_REPLACE(id_anio, '[,\\.]', '') AS INT
    ) AS ID_ANIO,
    TRY_CAST (
        REPLACE (pais_declarante, '[,\\.]', '') AS VARCHAR(255)
    ) AS PAIS_DECLARANTE,
    TRY_CAST (
        REGEXP_REPLACE(
            id_paises_socios,
            '[,\\.]',
            ''
        ) AS INT
    ) AS ID_PAISES_SOCIOS,
    TRY_CAST (
        REGEXP_REPLACE(id_elemento, '[,\\.]', '') AS INT
    ) AS ID_ELEMENTO,
    TRY_CAST (
        REGEXP_REPLACE(id_producto, '[,\\.]', '') AS INT
    ) AS ID_PRODUCTO,
    TRY_CAST (
        REPLACE (unidad, '[,\\.]', '') AS VARCHAR(255)
    ) AS UNIDAD,
    clean_number (valor) AS VALOR
FROM medallion_lab.bronze.th_comercio_exterior_raw
WHERE
    id_anio IS NOT NULL
    AND id_paises_socios IS NOT NULL
    AND id_elemento IS NOT NULL
    AND id_producto IS NOT NULL;