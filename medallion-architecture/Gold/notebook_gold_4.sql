-- ============================================================
-- PROCESS: Load Foreign Trade by Country Fact Table
-- TARGET: medallion_lab.gold.fact_comercio_exterior_paises
-- DESCRIPTION: Consolidating foreign trade facts by country, element, and product.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.gold.fact_comercio_exterior_paises AS
SELECT
    t.ID_ANIO,
    a.CE_ANIO,
    t.PAIS_DECLARANTE,
    pi.ID_PAIS AS ID_PAIS,
    pi.PAIS_ES_NORM AS PAIS_SOCIO,
    pi.ISO AS ISO_PAIS_SOCIO,
    e.ID_ELEMENTO,
    e.ELEMENTO,
    p.ID_PRODUCTO,
    p.PRODUCTO,
    p.ID_PRODUCTO_RELATED,
    pr.PRODUCTO AS PRODUCTO_RELATED,
    t.UNIDAD,
    t.VALOR
FROM medallion_lab.silver.th_comercio_exterior_clean t

-- Año
LEFT JOIN medallion_lab.silver.dim_anio_clean a ON t.ID_ANIO = a.ID_ANIO

-- 🌍 PAÍS (ÚNICA DIMENSIÓN)
LEFT JOIN medallion_lab.silver.dim_pais_iso_clean pi ON t.ID_PAISES_SOCIOS = pi.ID_PAIS

-- Elemento
LEFT JOIN medallion_lab.silver.dim_elemento_comercio_exterior_clean e ON t.ID_ELEMENTO = e.ID_ELEMENTO

-- Producto principal
LEFT JOIN medallion_lab.silver.dim_producto_comercio_exterior_clean p ON t.ID_PRODUCTO = p.ID_PRODUCTO

-- Producto relacionado
LEFT JOIN medallion_lab.silver.dim_producto_clean pr ON p.ID_PRODUCTO_RELATED = pr.ID_PRODUCTO;