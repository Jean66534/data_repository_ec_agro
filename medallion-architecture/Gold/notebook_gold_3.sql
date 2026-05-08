-- COMMAND
-- ============================================================
-- PROCESS: Load Agricultural Commercial Fact Table
-- TARGET: medallion_lab.gold.fact_comercial_agricola
-- DESCRIPTION: Consolidating import/export weights and values for agricultural products.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.gold.fact_comercial_agricola AS
SELECT
    t.ID_ANIO,
    a.CE_ANIO,
    t.ID_PERIODO,
    r.PERIODO,
    t.ID_PRODUCTO,
    dp.PRODUCTO, -- producto derivado
    dp.ID_PRODUCTO_RELATED,
    pc.PRODUCTO AS PRODUCTO_RELATED, -- producto general
    t.CE_EXP_PESO,
    t.CE_EXP_VALOR,
    t.CE_IMP_PESO,
    t.CE_IMP_VALOR,
    t.CE_BAL_PESO,
    t.CE_BAL_VALOR
FROM
    medallion_lab.silver.th_comercial_agricola_clean t
    LEFT JOIN medallion_lab.silver.dim_anio_clean a ON t.ID_ANIO = a.ID_ANIO
    LEFT JOIN medallion_lab.silver.dim_periodo_clean r ON t.ID_PERIODO = r.ID_PERIODO
    LEFT JOIN medallion_lab.silver.dim_producto_ex_im_clean dp ON t.ID_PRODUCTO = dp.ID_PRODUCTO
    LEFT JOIN medallion_lab.silver.dim_producto_clean pc ON dp.ID_PRODUCTO_RELATED = pc.ID_PRODUCTO;

--- variacion interanual