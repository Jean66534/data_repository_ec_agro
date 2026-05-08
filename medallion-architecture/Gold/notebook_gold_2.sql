-- COMMAND
-- ============================================================
-- PROCESS: Load Producer Prices Fact Table
-- TARGET: medallion_lab.gold.fact_precios_productor
-- DESCRIPTION: Consolidating producer price data with dimensions for time, product, and units.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.gold.fact_precios_productor AS
SELECT
    t.ID_ANIO,
    a.CE_ANIO,
    r.ID_MES,
    r.MES,
    p.ID_PRODUCTO,
    p.PRODUCTO,
    p.ID_PRODUCTO_RELATED,
    pc.PRODUCTO AS PRODUCTO_RELATED,
    u.ID_UNIDAD,
    u.UNIDAD,
    t.PP_PONDERADO_USD,
    t.PP_PONDERADO_USD_KG
FROM
    medallion_lab.silver.th_precios_productor_clean t
    LEFT JOIN medallion_lab.silver.dim_anio_clean a ON t.ID_ANIO = a.ID_ANIO
    LEFT JOIN medallion_lab.silver.dim_mes_clean r ON t.ID_MES = r.ID_MES
    LEFT JOIN medallion_lab.silver.dim_producto_precios_clean p ON t.ID_PRODUCTO = p.ID_PRODUCTO
    LEFT JOIN medallion_lab.silver.dim_unidad_clean u ON t.ID_UNIDAD = u.ID_UNIDAD
    LEFT JOIN medallion_lab.silver.dim_producto_clean pc ON p.ID_PRODUCTO_RELATED = pc.ID_PRODUCTO;

-- COMMAND
-- ============================================================
-- PROCESS: Create Monthly Price Trend View
-- TARGET: gold_pp_tendencia_mensual
-- DESCRIPTION: View for analyzing price trends over time with temporal data formatting.
-- ============================================================
CREATE OR REPLACE VIEW gold_pp_tendencia_mensual AS
SELECT
    CE_ANIO AS ANIO,
    MES,
    ID_MES,
    PRODUCTO,
    ROUND(PP_PONDERADO_USD_KG, 3) AS PRECIO_USD_KG,
    -- Crear fecha (primer día del mes) para un eje X temporal real
    TO_DATE (
        CONCAT(CE_ANIO, '-', ID_MES, '-01')
    ) AS FECHA
FROM medallion_lab.gold.fact_precios_productor;

-- COMMAND
-- ============================================================
-- PROCESS: Create Monthly Price Variation View
-- TARGET: gold_pp_variacion_mensual
-- DESCRIPTION: View for calculating month-to-month price percentage variations.
-- ============================================================
CREATE OR REPLACE VIEW gold_pp_variacion_mensual AS
SELECT
    PRODUCTO_RELATED, --Product general
    PRODUCTO, --Product deri
    CE_ANIO AS ANIO,
    MES,
    ROUND(PP_PONDERADO_USD_KG, 3) AS PRECIO_ACTUAL,
    -- PRECIO_ANTERIOR = 0 si no hay mes previo
    COALESCE(
        LAG(PP_PONDERADO_USD_KG) OVER (
            PARTITION BY
                PRODUCTO
            ORDER BY CE_ANIO, ID_MES
        ),
        0
    ) AS PRECIO_ANTERIOR,
    -- VAR_MENSUAL_PCT = 0 si no hay mes previo, de lo contrario cálculo normal
    ROUND(
        COALESCE(
            (
                PP_PONDERADO_USD_KG - LAG(PP_PONDERADO_USD_KG) OVER (
                    PARTITION BY
                        PRODUCTO
                    ORDER BY CE_ANIO, ID_MES
                )
            ) / NULLIF(
                LAG(PP_PONDERADO_USD_KG) OVER (
                    PARTITION BY
                        PRODUCTO
                    ORDER BY CE_ANIO, ID_MES
                ),
                0
            ),
            0
        ),
        4
    ) AS VAR_MENSUAL_PCT
FROM medallion_lab.gold.fact_precios_productor;