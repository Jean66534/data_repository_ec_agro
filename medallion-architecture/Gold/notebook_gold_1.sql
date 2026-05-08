-- COMMAND
-- ============================================================
-- PROCESS: Load Agricultural Production Fact Table
-- TARGET: medallion_lab.gold.fact_produccion_agricola
-- DESCRIPTION: Consolidating agricultural production data with dimensions and performance KPIs.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.gold.fact_produccion_agricola AS
SELECT t.ID_ANIO, a.CE_ANIO, r.ID_REGION, r.REGION, pr.ID_PROVINCIA, pr.PROVINCIA_NORMALIZADA, prod.ID_PRODUCTOR, prod.PRODUCTOR, dp.ID_PRODUCTO, dp.PRODUCTO, t.PLANTADA, t.COSECHADA, t.PRODUCCION, t.VENTAS,

-- Rendimiento t/ha
ROUND(
    COALESCE(
        COALESCE(t.PRODUCCION, 0) / NULLIF(COALESCE(t.COSECHADA, 0), 0),
        0
    ),
    2
) AS RENDIMIENTO_T_HA
FROM
    medallion_lab.silver.th_produccion_agricola_clean t
    LEFT JOIN medallion_lab.silver.dim_anio_clean a ON t.ID_ANIO = a.ID_ANIO
    LEFT JOIN medallion_lab.silver.dim_region_clean r ON t.ID_REGION = r.ID_REGION
    LEFT JOIN medallion_lab.silver.dim_provincia_clean pr ON t.ID_PROVINCIA = pr.ID_PROVINCIA
    LEFT JOIN medallion_lab.silver.dim_productor_clean prod ON t.ID_PRODUCTOR = prod.ID_PRODUCTOR
    LEFT JOIN medallion_lab.silver.dim_producto_clean dp ON t.ID_PRODUCTO = dp.ID_PRODUCTO;

-- COMMAND
-- ============================================================
-- PROCESS: Load Regional Production Aggregation
-- TARGET: medallion_lab.gold.agg_produccion_region
-- DESCRIPTION: Aggregating production and sales by region and year.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.gold.agg_produccion_region AS
SELECT
    t.REGION,
    t.CE_ANIO,
    SUM(t.PRODUCCION) AS TOTAL_PRODUCCION,
    SUM(t.VENTAS) AS TOTAL_VENTAS
FROM medallion_lab.gold.fact_produccion_agricola t
GROUP BY
    t.REGION,
    t.CE_ANIO;

-- COMMAND
-- ============================================================
-- PROCESS: Load Flowers Fact Table
-- TARGET: medallion_lab.gold.fact_flores
-- DESCRIPTION: Consolidating flowers production data with species, packaging, and yield KPIs.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.gold.fact_flores AS
SELECT
    t.ID_ANIO,
    a.CE_ANIO,
    r.ID_CONDICION,
    r.CONDICION,
    dp.ID_ESPECIE_FLORES,
    dp.ESPECIE_FLORES,
    t.ID_EMPAQUE,
    e.EMPAQUE,
    t.ID_TIPO,
    s.TIPO,
    e.TIPO_UNIDAD,
    e.USO_COMERCIAL,
    t.PLANTADA,
    t.COSECHADA,
    t.TOTAL_TALLOS_CORTADOS, -- producción total
    t.TOTAL_TALLOS_EMPAQUE, -- producción total

-- KPI: Rendimiento (tallos por hectárea)
COALESCE(
    t.TOTAL_TALLOS_CORTADOS / NULLIF(t.COSECHADA, 0),
    0
) AS RENDIMIENTO_TALLOS_POR_HA
FROM
    medallion_lab.silver.th_flores_clean t
    LEFT JOIN medallion_lab.silver.dim_anio_clean a ON t.ID_ANIO = a.ID_ANIO
    LEFT JOIN medallion_lab.silver.dim_condicion_clean r ON t.ID_CONDICION = r.ID_CONDICION
    LEFT JOIN medallion_lab.silver.dim_tipo_cultivo_clean s ON t.ID_TIPO = s.TIPO_ID
    LEFT JOIN medallion_lab.silver.dim_flores_clean dp ON t.ID_ESPECIE_FLORES = dp.ID_ESPECIE_FLORES
    LEFT JOIN medallion_lab.silver.dim_empaque_clean e ON t.ID_EMPAQUE = e.ID_EMPAQUE;

-- COMMAND
-- ============================================================
-- PROCESS: Load Gender Distribution Fact Table
-- TARGET: medallion_lab.gold.fact_genero
-- DESCRIPTION: Consolidating producer gender distribution by hectare range.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.gold.fact_genero AS
SELECT t.ID_ANIO, a.CE_ANIO, r.ID_GENERO, r.GENERO, s.ID_RANGO_HA, s.RANGO_HA, t.PORCENTAJE
FROM medallion_lab.silver.th_genero_clean t
    LEFT JOIN medallion_lab.silver.dim_anio_clean a ON t.ID_ANIO = a.ID_ANIO
    LEFT JOIN medallion_lab.silver.dim_genero_clean r ON t.ID_GENERO = r.ID_GENERO
    LEFT JOIN medallion_lab.silver.dim_rango_hectareas_clean s ON t.ID_RANGO_HA = s.ID_RANGO_HA;

-- COMMAND
-- ============================================================
-- PROCESS: Load Age Distribution Fact Table
-- TARGET: medallion_lab.gold.fact_edad
-- DESCRIPTION: Consolidating producer age distribution by hectare range.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.gold.fact_edad AS
SELECT t.ID_ANIO, a.CE_ANIO, r.ID_EDAD, r.EDAD, s.ID_RANGO_HA, s.RANGO_HA, t.PORCENTAJE
FROM medallion_lab.silver.th_edad_clean t
    LEFT JOIN medallion_lab.silver.dim_anio_clean a ON t.ID_ANIO = a.ID_ANIO
    LEFT JOIN medallion_lab.silver.dim_edad_clean r ON t.ID_EDAD = r.ID_EDAD
    LEFT JOIN medallion_lab.silver.dim_rango_hectareas_clean s ON t.ID_RANGO_HA = s.ID_RANGO_HA;

-- COMMAND
-- ============================================================
-- PROCESS: Load Education Distribution Fact Table
-- TARGET: medallion_lab.gold.fact_formacion
-- DESCRIPTION: Consolidating producer education levels by hectare range.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.gold.fact_formacion AS
SELECT t.ID_ANIO, a.CE_ANIO, r.ID_FORMACION, r.FORMACION, s.ID_RANGO_HA, s.RANGO_HA, t.PORCENTAJE
FROM medallion_lab.silver.th_formacion_clean t
    LEFT JOIN medallion_lab.silver.dim_anio_clean a ON t.ID_ANIO = a.ID_ANIO
    LEFT JOIN medallion_lab.silver.dim_formacion_clean r ON t.ID_FORMACION = r.ID_FORMACION
    LEFT JOIN medallion_lab.silver.dim_rango_hectareas_clean s ON t.ID_RANGO_HA = s.ID_RANGO_HA;

-- COMMAND
-- ============================================================
-- PROCESS: Load Ethnicity Distribution Fact Table
-- TARGET: medallion_lab.gold.fact_etnia
-- DESCRIPTION: Consolidating producer ethnicity distribution by hectare range.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.gold.fact_etnia AS
SELECT t.ID_ANIO, a.CE_ANIO, r.ID_ETNIA, r.ETNIA, s.ID_RANGO_HA, s.RANGO_HA, t.PORCENTAJE
FROM medallion_lab.silver.th_etnia_clean t
    LEFT JOIN medallion_lab.silver.dim_anio_clean a ON t.ID_ANIO = a.ID_ANIO
    LEFT JOIN medallion_lab.silver.dim_etnia_clean r ON t.ID_ETNIA = r.ID_ETNIA
    LEFT JOIN medallion_lab.silver.dim_rango_hectareas_clean s ON t.ID_RANGO_HA = s.ID_RANGO_HA;

-- COMMAND
-- ============================================================
-- PROCESS: Load Permanent Crops Fact Table
-- TARGET: medallion_lab.gold.fact_product_permanentes
-- DESCRIPTION: Consolidating production and sales data for permanent crops.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.gold.fact_product_permanentes AS
SELECT t.ID_ANIO, da.CE_ANIO, t.ID_PRODUCTO, dp.PRODUCTO, t.ID_PRODUCTOR, dpr.PRODUCTOR, t.PLANTADA, t.EDAD_PRODUCT, t.COSECHADA, t.PRODUCCION, t.VENTAS
FROM medallion_lab.silver.th_product_permanentes_clean t
    LEFT JOIN medallion_lab.silver.dim_anio_clean da ON t.ID_ANIO = da.ID_ANIO
    LEFT JOIN medallion_lab.silver.dim_producto_clean dp ON t.ID_PRODUCTO = dp.ID_PRODUCTO
    LEFT JOIN medallion_lab.silver.dim_productor_clean dpr ON t.ID_PRODUCTOR = dpr.ID_PRODUCTOR;

-- COMMAND
-- ============================================================
-- PROCESS: Load Transitory Crops Fact Table
-- TARGET: medallion_lab.gold.fact_product_transitorios
-- DESCRIPTION: Consolidating production and sales data for transitory crops.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.gold.fact_product_transitorios AS
SELECT t.ID_ANIO, da.CE_ANIO, t.ID_PRODUCTO, dp.PRODUCTO, t.ID_PRODUCTOR, dpr.PRODUCTOR, t.PLANTADA, t.COSECHADA, t.PRODUCCION, t.VENTAS
FROM medallion_lab.silver.th_product_transitorios_clean t
    LEFT JOIN medallion_lab.silver.dim_anio_clean da ON t.ID_ANIO = da.ID_ANIO
    LEFT JOIN medallion_lab.silver.dim_producto_clean dp ON t.ID_PRODUCTO = dp.ID_PRODUCTO
    LEFT JOIN medallion_lab.silver.dim_productor_clean dpr ON t.ID_PRODUCTOR = dpr.ID_PRODUCTOR;

-- COMMAND
-- ============================================================
-- PROCESS: Load Permanent Crops Loss Causes Fact Table
-- TARGET: medallion_lab.gold.fact_causas_permanentes
-- DESCRIPTION: Analyzing loss causes and totals for permanent agricultural crops.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.gold.fact_causas_permanentes AS
SELECT t.ID_ANIO, da.CE_ANIO, dp.ID_PRODUCTO, dp.PRODUCTO, dpr.ID_PRODUCTOR, dpr.PRODUCTOR, dc.ID_CAUSAS, dc.CAUSAS, t.VALOR, t.TOTAL
FROM
    medallion_lab.silver.th_causas_permanentes_clean t
    LEFT JOIN medallion_lab.silver.dim_anio_clean da ON t.ID_ANIO = da.ID_ANIO
    LEFT JOIN medallion_lab.silver.dim_producto_clean dp ON t.ID_PRODUCTO = dp.ID_PRODUCTO
    LEFT JOIN medallion_lab.silver.dim_productor_clean dpr ON t.ID_PRODUCTOR = dpr.ID_PRODUCTOR
    LEFT JOIN medallion_lab.silver.dim_causas_clean dc ON t.ID_CAUSA = dc.ID_CAUSAS;

-- COMMAND
-- ============================================================
-- PROCESS: Load Transitory Crops Loss Causes Fact Table
-- TARGET: medallion_lab.gold.fact_causas_transitorios
-- DESCRIPTION: Analyzing loss causes and totals for transitory agricultural crops.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.gold.fact_causas_transitorios AS
SELECT t.ID_ANIO, da.CE_ANIO, dp.ID_PRODUCTO, dp.PRODUCTO, dpr.ID_PRODUCTOR, dpr.PRODUCTOR, dc.ID_CAUSAS, dc.CAUSAS, t.VALOR, t.TOTAL
FROM
    medallion_lab.silver.th_causas_transitorios_clean t
    LEFT JOIN medallion_lab.silver.dim_anio_clean da ON t.ID_ANIO = da.ID_ANIO
    LEFT JOIN medallion_lab.silver.dim_producto_clean dp ON t.ID_PRODUCTO = dp.ID_PRODUCTO
    LEFT JOIN medallion_lab.silver.dim_productor_clean dpr ON t.ID_PRODUCTOR = dpr.ID_PRODUCTOR
    LEFT JOIN medallion_lab.silver.dim_causas_clean dc ON t.ID_CAUSA = dc.ID_CAUSAS;