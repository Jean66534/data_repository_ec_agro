-- ============================================================
-- PROCESS: Load Foreign Trade by Country Fact Table (Enhanced)
-- TARGET: medallion_lab.gold.fact_comercio_exterior_paises
-- DESCRIPTION: Consolidating foreign trade facts with enhanced country and ISO normalization.
-- ============================================================
CREATE
OR
REPLACE
TABLE medallion_lab.gold.fact_comercio_exterior_paises AS
SELECT
    t.ID_ANIO,
    a.CE_ANIO,
    t.PAIS_DECLARANTE,
    ps.ID_PAIS AS ID_PAISES_SOCIOS,
    ps.PAIS_EN_NORM AS PAIS_SOCIO,
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

-- País socio
LEFT JOIN medallion_lab.silver.dim_pais_iso_clean ps ON t.ID_PAISES_SOCIOS = ps.ID_PAIS

-- ISO (JOIN NORMALIZADO CORRECTO)
LEFT JOIN medallion_lab.silver.dim_pais_iso_clean pi ON UPPER(
    TRIM(
        TRANSLATE (
            ps.PAIS_EN_NORM,
            'áéíóúÁÉÍÓÚñÑ',
            'aeiouAEIOUnN'
        )
    )
) = pi.PAIS_EN_NORM

-- Elemento
LEFT JOIN medallion_lab.silver.dim_elemento_comercio_exterior_clean e ON t.ID_ELEMENTO = e.ID_ELEMENTO

-- Producto principal
LEFT JOIN medallion_lab.silver.dim_producto_comercio_exterior_clean p ON t.ID_PRODUCTO = p.ID_PRODUCTO

-- Producto relacionado
LEFT JOIN medallion_lab.silver.dim_producto_clean pr ON p.ID_PRODUCTO_RELATED = pr.ID_PRODUCTO;

-- ============================================================
-- PROCESS: Create Export Quantity by Country View
-- TARGET: medallion_lab.gold.vw_exportacion_cantidad_pais
-- DESCRIPTION: Aggregated view of total export quantities summarized by partner country.
-- ============================================================
CREATE OR REPLACE VIEW medallion_lab.gold.vw_exportacion_cantidad_pais AS
SELECT
    f.ID_PAISES_SOCIOS,
    f.PAIS_SOCIO,
    f.ISO_PAIS_SOCIO,
    SUM(f.VALOR) AS TOTAL_EXPORTACION_CANTIDAD
FROM medallion_lab.gold.fact_comercio_exterior_paises f
WHERE
    f.ID_ELEMENTO = 1 -- Exportación Cantidad
GROUP BY
    f.ID_PAISES_SOCIOS,
    f.PAIS_SOCIO,
    f.ISO_PAIS_SOCIO;