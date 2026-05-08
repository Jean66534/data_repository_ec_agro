-- ============================================================
--  Datos: Nacionales
--  Objetivo: Estructura para produccion, ventas, superficie
--            y productos.
-- ============================================================

-- COMMAND
-- ============================================================
-- PROCESS: Clean Year Dimension
-- TARGET: medallion_lab.silver.dim_anio_clean
-- DESCRIPTION: Cleaning and casting year data from bronze layer.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_anio_clean AS
SELECT
    TRY_CAST (
        REPLACE (CE_ANIO, '[,\\.]', '') AS INT
    ) AS CE_ANIO,
    TRY_CAST (
        REPLACE (`Año_ID`, '[,\\.]', '') AS INT
    ) AS ID_ANIO
FROM medallion_lab.bronze.dim_anio_raw
WHERE
    `Año_ID` IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Condition Dimension
-- TARGET: medallion_lab.silver.dim_condicion_clean
-- DESCRIPTION: Cleaning and casting condition data from bronze layer.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_condicion_clean AS
SELECT
    TRY_CAST (
        REPLACE (id_condicion, '[,\\.]', '') AS INT
    ) AS ID_CONDICION,
    TRY_CAST (
        REPLACE (condicion, '[,\\.]', '') AS VARCHAR(255)
    ) AS CONDICION
FROM medallion_lab.bronze.dim_condicion_raw
WHERE
    id_condicion IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Region Dimension
-- TARGET: medallion_lab.silver.dim_region_clean
-- DESCRIPTION: Cleaning and casting region data from bronze layer.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_region_clean AS
SELECT
    TRY_CAST (
        REPLACE (REGION, '[,\\.]', '') AS VARCHAR(255)
    ) AS REGION,
    TRY_CAST (
        REPLACE (Region_ID, '[,\\.]', '') AS INT
    ) AS ID_REGION
FROM medallion_lab.bronze.dim_region_raw
WHERE
    Region_ID IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Product Dimension
-- TARGET: medallion_lab.silver.dim_producto_clean
-- DESCRIPTION: Cleaning and casting product data from bronze layer.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_producto_clean AS
SELECT
    TRY_CAST (
        REPLACE (PRODUCTO, '[,\\.]', '') AS VARCHAR(255)
    ) AS PRODUCTO,
    TRY_CAST (
        REPLACE (Producto_ID, '[,\\.]', '') AS INT
    ) AS ID_PRODUCTO
FROM medallion_lab.bronze.dim_producto_raw
WHERE
    Producto_ID IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Producer Dimension
-- TARGET: medallion_lab.silver.dim_productor_clean
-- DESCRIPTION: Cleaning and casting producer data from bronze layer.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_productor_clean AS
SELECT
    TRY_CAST (
        REPLACE (PRODUCTOR, '[,\\.]', '') AS VARCHAR(255)
    ) AS PRODUCTOR,
    TRY_CAST (
        REPLACE (Productor_ID, '[,\\.]', '') AS INT
    ) AS ID_PRODUCTOR
FROM medallion_lab.bronze.dim_productor_raw
WHERE
    Productor_ID IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Province Dimension
-- TARGET: medallion_lab.silver.dim_provincia_clean
-- DESCRIPTION: Normalizing province names and casting IDs from bronze layer.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_provincia_clean AS
SELECT
    CASE
        WHEN UPPER(TRIM(PROVINCIA)) = 'AZUAY' THEN 'Azuay'
        WHEN UPPER(TRIM(PROVINCIA)) = 'BOLÍVAR' THEN 'Bolívar'
        WHEN UPPER(TRIM(PROVINCIA)) = 'CAÑAR' THEN 'Cañar'
        WHEN UPPER(TRIM(PROVINCIA)) = 'CARCHI' THEN 'Carchi'
        WHEN UPPER(TRIM(PROVINCIA)) = 'COTOPAXI' THEN 'Cotopaxi'
        WHEN UPPER(TRIM(PROVINCIA)) = 'CHIMBORAZO' THEN 'Chimborazo'
        WHEN UPPER(TRIM(PROVINCIA)) = 'IMBABURA' THEN 'Imbabura'
        WHEN UPPER(TRIM(PROVINCIA)) = 'LOJA' THEN 'Loja'
        WHEN UPPER(TRIM(PROVINCIA)) = 'PICHINCHA' THEN 'Pichincha'
        WHEN UPPER(TRIM(PROVINCIA)) = 'TUNGURAHUA' THEN 'Tungurahua'
        WHEN UPPER(TRIM(PROVINCIA)) = 'SANTO DOMINGO DE LOS TSÁCHILAS' THEN 'Santo Domingo de los Tsáchilas'
        WHEN UPPER(TRIM(PROVINCIA)) = 'EL ORO' THEN 'El Oro'
        WHEN UPPER(TRIM(PROVINCIA)) = 'ESMERALDAS' THEN 'Esmeraldas'
        WHEN UPPER(TRIM(PROVINCIA)) = 'GUAYAS' THEN 'Guayas'
        WHEN UPPER(TRIM(PROVINCIA)) = 'LOS RÍOS' THEN 'Los Ríos'
        WHEN UPPER(TRIM(PROVINCIA)) = 'MANABÍ' THEN 'Manabí'
        WHEN UPPER(TRIM(PROVINCIA)) = 'SANTA ELENA' THEN 'Santa Elena'
        WHEN UPPER(TRIM(PROVINCIA)) = 'MORONA SANTIAGO' THEN 'Morona Santiago'
        WHEN UPPER(TRIM(PROVINCIA)) = 'NAPO' THEN 'Napo'
        WHEN UPPER(TRIM(PROVINCIA)) = 'ORELLANA' THEN 'Orellana'
        WHEN UPPER(TRIM(PROVINCIA)) = 'PASTAZA' THEN 'Pastaza'
        WHEN UPPER(TRIM(PROVINCIA)) = 'SUCUMBÍOS' THEN 'Sucumbíos'
        WHEN UPPER(TRIM(PROVINCIA)) = 'ZAMORA CHINCHIPE' THEN 'Zamora Chinchipe'
        WHEN UPPER(TRIM(PROVINCIA)) = 'ZONAS NO DELIMITADAS' THEN 'Zonas no delimitadas'
        ELSE INITCAP (PROVINCIA)
    END AS PROVINCIA_NORMALIZADA,
    TRY_CAST (
        REPLACE (Provincia_ID, '[,\\.]', '') AS INT
    ) AS ID_PROVINCIA
FROM medallion_lab.bronze.dim_provincia_raw
WHERE
    Provincia_ID IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Surface Dimension
-- TARGET: medallion_lab.silver.dim_superficie_clean
-- DESCRIPTION: Cleaning and casting surface data from bronze layer.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_superficie_clean AS
SELECT
    TRY_CAST (
        REPLACE (SUPERFICIE, '[,\\.]', '') AS VARCHAR(255)
    ) AS SUPERFICIE,
    TRY_CAST (
        REPLACE (SUPERFICIE_ID, '[,\\.]', '') AS INT
    ) AS ID_SUPERFICIE
FROM medallion_lab.bronze.dim_superficie_raw
WHERE
    SUPERFICIE_ID IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Flowers Dimension
-- TARGET: medallion_lab.silver.dim_flores_clean
-- DESCRIPTION: Cleaning and casting flowers species data from bronze layer.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_flores_clean AS
SELECT
    TRY_CAST (
        REPLACE (
                ESPECIE_FLORES_ID,
                '[,\\.]',
                ''
            ) AS INT
    ) AS ID_ESPECIE_FLORES,
    TRY_CAST (
        REPLACE (ESPECIE_FLORES, '[,\\.]', '') AS VARCHAR(255)
    ) AS ESPECIE_FLORES
FROM medallion_lab.bronze.dim_flores_raw
WHERE
    ESPECIE_FLORES_ID IS NOT NULL;

-- COMMAND
-- ============================================================
-- PROCESS: Clean Packaging Dimension
-- TARGET: medallion_lab.silver.dim_empaque_clean
-- DESCRIPTION: Cleaning and casting packaging and unit data from bronze layer.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.dim_empaque_clean AS
SELECT
    TRY_CAST (
        REPLACE (ID_EMPAQUE, '[,\\.]', '') AS INT
    ) AS ID_EMPAQUE,
    TRY_CAST (
        REPLACE (EMPAQUE, '[,\\.]', '') AS VARCHAR(255)
    ) AS EMPAQUE,
    TRY_CAST (
        REPLACE (TIPO_UNIDAD, '[,\\.]', '') AS VARCHAR(255)
    ) AS TIPO_UNIDAD,
    TRY_CAST (
        REPLACE (USO_COMERCIAL, '[,\\.]', '') AS VARCHAR(255)
    ) AS USO_COMERCIAL
FROM medallion_lab.bronze.dim_empaque_raw
WHERE
    ID_EMPAQUE IS NOT NULL;

-- ============================================================
-- PROCESS: Clean Agricultural Production Fact Table
-- TARGET: medallion_lab.silver.th_produccion_agricola_clean
-- DESCRIPTION: Processing agricultural production facts, cleaning numeric values.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.th_produccion_agricola_clean AS
SELECT
    TRY_CAST (
        REGEXP_REPLACE(`Año_ID`, '[,\\.]', '') AS INT
    ) AS ID_ANIO,
    TRY_CAST (
        REGEXP_REPLACE(Region_ID, '[,\\.]', '') AS INT
    ) AS ID_REGION,
    TRY_CAST (
        REGEXP_REPLACE(Provincia_ID, '[,\\.]', '') AS INT
    ) AS ID_PROVINCIA,
    TRY_CAST (
        REGEXP_REPLACE(Productor_ID, '[,\\.]', '') AS INT
    ) AS ID_PRODUCTOR,
    TRY_CAST (
        REGEXP_REPLACE(Producto_ID, '[,\\.]', '') AS INT
    ) AS ID_PRODUCTO,

-- columnas numéricas limpias usando la UDF
clean_number (PLANTADA) AS PLANTADA,
clean_number (COSECHADA) AS COSECHADA,
clean_number (PRODUCCION) AS PRODUCCION,
clean_number (VENTAS) AS VENTAS
FROM medallion_lab.bronze.th_produccion_agricola_raw
WHERE
    `Año_ID` IS NOT NULL
    AND Region_ID IS NOT NULL
    AND Provincia_ID IS NOT NULL
    AND Productor_ID IS NOT NULL
    AND Producto_ID IS NOT NULL;

-- ============================================================
-- PROCESS: Clean Agricultural Surface Fact Table
-- TARGET: medallion_lab.silver.th_superficie_agricola_clean
-- DESCRIPTION: Processing agricultural surface facts, cleaning hectare values.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.th_superficie_agricola_clean AS
SELECT
    TRY_CAST (
        REGEXP_REPLACE(`Año_ID`, '[,\\.]', '') AS INT
    ) AS ID_ANIO,
    TRY_CAST (
        REGEXP_REPLACE(Region_ID, '[,\\.]', '') AS INT
    ) AS ID_REGION,
    TRY_CAST (
        REGEXP_REPLACE(Provincia_ID, '[,\\.]', '') AS INT
    ) AS ID_PROVINCIA,
    TRY_CAST (
        REGEXP_REPLACE(Productor_ID, '[,\\.]', '') AS INT
    ) AS ID_PRODUCTOR,
    TRY_CAST (
        REGEXP_REPLACE(Producto_ID, '[,\\.]', '') AS INT
    ) AS ID_PRODUCTO,
    TRY_CAST (
        REGEXP_REPLACE(id_superficie, '[,\\.]', '') AS INT
    ) AS ID_SUPERFICIE,

-- columna numérica limpia usando la UDF
clean_number (hectareas) AS HECTAREAS
FROM medallion_lab.bronze.th_superficie_agricola_raw
WHERE
    `Año_ID` IS NOT NULL
    AND Region_ID IS NOT NULL
    AND Provincia_ID IS NOT NULL
    AND Productor_ID IS NOT NULL
    AND Producto_ID IS NOT NULL
    AND id_superficie IS NOT NULL;

-- ============================================================
-- PROCESS: Clean Flowers Fact Table
-- TARGET: medallion_lab.silver.th_flores_clean
-- DESCRIPTION: Processing flowers production and packaging facts.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.silver.th_flores_clean AS
SELECT
    TRY_CAST (
        REGEXP_REPLACE(`Año_ID`, '[,\\.]', '') AS INT
    ) AS ID_ANIO,
    TRY_CAST (
        REGEXP_REPLACE(Tipo_ID, '[,\\.]', '') AS INT
    ) AS ID_TIPO,
    TRY_CAST (
        REGEXP_REPLACE(Condicion_ID, '[,\\.]', '') AS INT
    ) AS ID_CONDICION,
    TRY_CAST (
        REGEXP_REPLACE(ESPECIE_ID, '[,\\.]', '') AS INT
    ) AS ID_ESPECIE_FLORES,
    TRY_CAST (
        REGEXP_REPLACE(ID_EMPAQUE, '[,\\.]', '') AS INT
    ) AS ID_EMPAQUE,
    TRY_CAST (
        REPLACE (EMPAQUE, '[,\\.]', '') AS VARCHAR(255)
    ) AS EMPAQUE,

-- columnas numéricas limpias usando la UDF
clean_number (PLANTADA) AS PLANTADA,
clean_number (COSECHADA) AS COSECHADA,
clean_number (TOTAL_TALLOS_CORTADOS) AS TOTAL_TALLOS_CORTADOS,
clean_number (TOTAL_TALLOS_EMPAQUE) AS TOTAL_TALLOS_EMPAQUE
FROM medallion_lab.bronze.th_flores_empaque_raw
WHERE
    `Año_ID` IS NOT NULL
    AND Tipo_ID IS NOT NULL
    AND Condicion_ID IS NOT NULL
    AND ESPECIE_ID IS NOT NULL
    AND ID_EMPAQUE IS NOT NULL;