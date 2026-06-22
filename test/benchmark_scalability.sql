-- ============================================================
-- BENCHMARK: Scalability Tests - fact_produccion_agricola
-- COMPARISON: Original (19,345) vs Mensual (232,140)
-- PLATFORMS: free vs azure
-- DESCRIPTION: Crea tabla mensual, ejecuta benchmarks en
--              4 combinaciones (free/azure x 19K/232K)
-- ============================================================

-- ============================================================
-- CELL 1 - SETUP: Expand fact_produccion_agricola
-- ============================================================
CREATE OR REPLACE TABLE medallion_lab.gold.fact_produccion_agricola_mensual AS
SELECT
    f.ID_ANIO,
    f.CE_ANIO,
    m.ID_MES,
    m.MES,
    f.ID_REGION,
    f.REGION,
    f.ID_PROVINCIA,
    f.PROVINCIA_NORMALIZADA,
    f.ID_PRODUCTOR,
    f.PRODUCTOR,
    f.ID_PRODUCTO,
    f.PRODUCTO,
    f.PLANTADA,
    f.COSECHADA,
    f.PRODUCCION,
    f.VENTAS,
    f.RENDIMIENTO_T_HA
FROM medallion_lab.gold.fact_produccion_agricola f
CROSS JOIN medallion_lab.silver.dim_mes_clean m;

-- ============================================================
-- CELL 2 - BENCHMARK: Free 19K
-- ============================================================
%python
from pyspark.sql import SparkSession
import time, statistics

queries = {
    "SELECT *": "SELECT * FROM medallion_lab.gold.fact_produccion_agricola",
    "COUNT(*)": "SELECT COUNT(*) FROM medallion_lab.gold.fact_produccion_agricola",
    "WHERE": "SELECT COUNT(*) FROM medallion_lab.gold.fact_produccion_agricola WHERE CE_ANIO >= 2018",
    "GROUP BY": "SELECT REGION, CE_ANIO, COUNT(*) FROM medallion_lab.gold.fact_produccion_agricola GROUP BY REGION, CE_ANIO",
    "JOIN": "SELECT COUNT(*) FROM medallion_lab.gold.fact_produccion_agricola f LEFT JOIN medallion_lab.silver.dim_anio_clean a ON f.ID_ANIO = a.ID_ANIO LEFT JOIN medallion_lab.silver.dim_region_clean r ON f.ID_REGION = r.ID_REGION LEFT JOIN medallion_lab.silver.dim_provincia_clean pr ON f.ID_PROVINCIA = pr.ID_PROVINCIA LEFT JOIN medallion_lab.silver.dim_productor_clean prod ON f.ID_PRODUCTOR = prod.ID_PRODUCTOR LEFT JOIN medallion_lab.silver.dim_producto_clean dp ON f.ID_PRODUCTO = dp.ID_PRODUCTO"
}

results = []
for name, sql in queries.items():
    times = []
    for i in range(10):
        start = time.time()
        spark.sql(sql).count()
        elapsed = time.time() - start
        times.append(round(elapsed, 4))

    results.append((
        name, 'free', '19K', 10,
        round(statistics.mean(times), 4),
        round(statistics.stdev(times), 4),
        round(min(times), 4),
        round(max(times), 4)
    ))

spark.createDataFrame(results,
    schema=['test_type','platform','scale','repetitions','mean_s','stdev_s','min_s','max_s']
).write.mode('overwrite').saveAsTable('medallion_lab.gold.benchmark_stats')

display(spark.table('medallion_lab.gold.benchmark_stats'))

-- ============================================================
-- CELL 3 - BENCHMARK: Free 232K
-- ============================================================
%python
from pyspark.sql import SparkSession
import time, statistics

queries = {
    "SELECT *": "SELECT * FROM medallion_lab.gold.fact_produccion_agricola_mensual",
    "COUNT(*)": "SELECT COUNT(*) FROM medallion_lab.gold.fact_produccion_agricola_mensual",
    "WHERE": "SELECT COUNT(*) FROM medallion_lab.gold.fact_produccion_agricola_mensual WHERE CE_ANIO >= 2018",
    "GROUP BY": "SELECT REGION, CE_ANIO, COUNT(*) FROM medallion_lab.gold.fact_produccion_agricola_mensual GROUP BY REGION, CE_ANIO",
    "JOIN": "SELECT COUNT(*) FROM medallion_lab.gold.fact_produccion_agricola_mensual f LEFT JOIN medallion_lab.silver.dim_anio_clean a ON f.ID_ANIO = a.ID_ANIO LEFT JOIN medallion_lab.silver.dim_region_clean r ON f.ID_REGION = r.ID_REGION LEFT JOIN medallion_lab.silver.dim_provincia_clean pr ON f.ID_PROVINCIA = pr.ID_PROVINCIA LEFT JOIN medallion_lab.silver.dim_productor_clean prod ON f.ID_PRODUCTOR = prod.ID_PRODUCTOR LEFT JOIN medallion_lab.silver.dim_producto_clean dp ON f.ID_PRODUCTO = dp.ID_PRODUCTO"
}

results = []
for name, sql in queries.items():
    times = []
    for i in range(10):
        start = time.time()
        spark.sql(sql).count()
        elapsed = time.time() - start
        times.append(round(elapsed, 4))

    results.append((
        name, 'free', '232K', 10,
        round(statistics.mean(times), 4),
        round(statistics.stdev(times), 4),
        round(min(times), 4),
        round(max(times), 4)
    ))

spark.createDataFrame(results,
    schema=['test_type','platform','scale','repetitions','mean_s','stdev_s','min_s','max_s']
).write.mode('append').saveAsTable('medallion_lab.gold.benchmark_stats')

display(spark.table('medallion_lab.gold.benchmark_stats'))

-- ============================================================
-- CELL 4 - BENCHMARK: Azure 19K
-- ============================================================
%python
from pyspark.sql import SparkSession
import time, statistics

queries = {
    "SELECT *": "SELECT * FROM medallion_lab.gold.fact_produccion_agricola",
    "COUNT(*)": "SELECT COUNT(*) FROM medallion_lab.gold.fact_produccion_agricola",
    "WHERE": "SELECT COUNT(*) FROM medallion_lab.gold.fact_produccion_agricola WHERE CE_ANIO >= 2018",
    "GROUP BY": "SELECT REGION, CE_ANIO, COUNT(*) FROM medallion_lab.gold.fact_produccion_agricola GROUP BY REGION, CE_ANIO",
    "JOIN": "SELECT COUNT(*) FROM medallion_lab.gold.fact_produccion_agricola f LEFT JOIN medallion_lab.silver.dim_anio_clean a ON f.ID_ANIO = a.ID_ANIO LEFT JOIN medallion_lab.silver.dim_region_clean r ON f.ID_REGION = r.ID_REGION LEFT JOIN medallion_lab.silver.dim_provincia_clean pr ON f.ID_PROVINCIA = pr.ID_PROVINCIA LEFT JOIN medallion_lab.silver.dim_productor_clean prod ON f.ID_PRODUCTOR = prod.ID_PRODUCTOR LEFT JOIN medallion_lab.silver.dim_producto_clean dp ON f.ID_PRODUCTO = dp.ID_PRODUCTO"
}

results = []
for name, sql in queries.items():
    times = []
    for i in range(10):
        start = time.time()
        spark.sql(sql).count()
        elapsed = time.time() - start
        times.append(round(elapsed, 4))

    results.append((
        name, 'azure', '19K', 10,
        round(statistics.mean(times), 4),
        round(statistics.stdev(times), 4),
        round(min(times), 4),
        round(max(times), 4)
    ))

spark.createDataFrame(results,
    schema=['test_type','platform','scale','repetitions','mean_s','stdev_s','min_s','max_s']
).write.mode('append').saveAsTable('medallion_lab.gold.benchmark_stats')

display(spark.table('medallion_lab.gold.benchmark_stats'))

-- ============================================================
-- CELL 5 - BENCHMARK: Azure 232K
-- ============================================================
%python
from pyspark.sql import SparkSession
import time, statistics

queries = {
    "SELECT *": "SELECT * FROM medallion_lab.gold.fact_produccion_agricola_mensual",
    "COUNT(*)": "SELECT COUNT(*) FROM medallion_lab.gold.fact_produccion_agricola_mensual",
    "WHERE": "SELECT COUNT(*) FROM medallion_lab.gold.fact_produccion_agricola_mensual WHERE CE_ANIO >= 2018",
    "GROUP BY": "SELECT REGION, CE_ANIO, COUNT(*) FROM medallion_lab.gold.fact_produccion_agricola_mensual GROUP BY REGION, CE_ANIO",
    "JOIN": "SELECT COUNT(*) FROM medallion_lab.gold.fact_produccion_agricola_mensual f LEFT JOIN medallion_lab.silver.dim_anio_clean a ON f.ID_ANIO = a.ID_ANIO LEFT JOIN medallion_lab.silver.dim_region_clean r ON f.ID_REGION = r.ID_REGION LEFT JOIN medallion_lab.silver.dim_provincia_clean pr ON f.ID_PROVINCIA = pr.ID_PROVINCIA LEFT JOIN medallion_lab.silver.dim_productor_clean prod ON f.ID_PRODUCTOR = prod.ID_PRODUCTOR LEFT JOIN medallion_lab.silver.dim_producto_clean dp ON f.ID_PRODUCTO = dp.ID_PRODUCTO"
}

results = []
for name, sql in queries.items():
    times = []
    for i in range(10):
        start = time.time()
        spark.sql(sql).count()
        elapsed = time.time() - start
        times.append(round(elapsed, 4))

    results.append((
        name, 'azure', '232K', 10,
        round(statistics.mean(times), 4),
        round(statistics.stdev(times), 4),
        round(min(times), 4),
        round(max(times), 4)
    ))

spark.createDataFrame(results,
    schema=['test_type','platform','scale','repetitions','mean_s','stdev_s','min_s','max_s']
).write.mode('append').saveAsTable('medallion_lab.gold.benchmark_stats')

display(spark.table('medallion_lab.gold.benchmark_stats'))
