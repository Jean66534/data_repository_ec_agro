# 🌾 Data Agro Ecuador — Medallion Architecture on Databricks

A step-by-step guide to reproduce the full data pipeline for Ecuador's agricultural data using Databricks and the **Bronze → Silver → Gold** medallion architecture.

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Repository Structure](#repository-structure)
3. [Step 1 — Set Up Databricks](#step-1--set-up-databricks)
4. [Step 2 — Create the Catalog and Schemas](#step-2--create-the-catalog-and-schemas)
5. [Step 3 — Ingest Data into Bronze](#step-3--ingest-data-into-bronze)
6. [Step 4 — Build Relational Model with Silver Notebooks](#step-4--build-relational-model-with-silver-notebooks)
7. [Step 5 — Build the Gold Layer](#step-5--build-the-gold-layer)
8. [Data Dictionary](#data-dictionary)
9. [Architecture Diagram](#architecture-diagram)

---

## Prerequisites

Before starting, make sure you have:

- A **Databricks** account (free edition available — see link below)
- The source data files located in `medallion-architecture/Bronze/`
- Basic familiarity with SQL and Databricks notebooks

> 🔗 **Databricks Free Edition (Community Edition):**
> - Sign up here: [https://community.cloud.databricks.com/login.html](https://community.cloud.databricks.com/login.html)
> - Official docs: [https://docs.databricks.com/en/getting-started/index.html](https://docs.databricks.com/en/getting-started/index.html)
> - What is included in the free tier: [https://www.databricks.com/try-databricks](https://www.databricks.com/try-databricks)

---

## Repository Structure

```
repository/
├── medallion-architecture/
│   ├── Bronze/                         ← Raw data from source entities
│   │   ├── Indice de publicacion ESPAC-2014/  ← ESPAC 2014 tables (T1.csv … T60.csv)
│   │   ├── Indice de publicacion ESPAC 2015/  ← ESPAC 2015 tables
│   │   ├── Indice de publicacion ESPAC 2016.xlsx
│   │   ├── Indice_de publicacion_ESPAC_2017.xlsx
│   │   ├── Tabulados ESPAC 2018.xlsx
│   │   ├── Tabulados ESPAC CSV ESPAC 2019/    ← ESPAC 2019 tables
│   │   ├── Tabulados CSV_ESPAC_ 2020/         ← ESPAC 2020 tables
│   │   ├── Tabulados CSV_2021/                ← ESPAC 2021 tables
│   │   ├── Tabulados CSV 2022/                ← ESPAC 2022 tables
│   │   ├── TABULADOS_CSV 2023/                ← ESPAC 2023 tables
│   │   ├── TABULADOS_ESPAC_2024_CVS/          ← ESPAC 2024 tables
│   │   ├── FAOSTAT_data_es_12-10-2025.csv     ← Foreign trade from FAO
│   │   └── mag_preciosproductor_2025mayo.csv  ← Producer prices from MAG
│   │
│   ├── Silver/                         ← Cleaned dimensional model
│   │   ├── Data/                       ← Structured source files for the dimensional model
│   │   │   ├── dim_/                   ← Dimension files (25 tables)
│   │   │   │   ├── dim_anio.xlsx
│   │   │   │   ├── dim_causas.xlsx
│   │   │   │   ├── dim_condicion.xlsx
│   │   │   │   ├── dim_edad.xlsx
│   │   │   │   ├── dim_elemento_comercio_exterior.xlsx
│   │   │   │   ├── dim_empaque.xlsx
│   │   │   │   ├── dim_etnia.xlsx
│   │   │   │   ├── dim_flores.xlsx
│   │   │   │   ├── dim_formacion.xlsx
│   │   │   │   ├── dim_genero.xlsx
│   │   │   │   ├── dim_mes.xlsx
│   │   │   │   ├── dim_pais_iso.xlsx
│   │   │   │   ├── dim_periodo.xlsx
│   │   │   │   ├── dim_producto.xlsx
│   │   │   │   ├── dim_producto_comercio_exterior.xlsx
│   │   │   │   ├── dim_producto_ex_im.xlsx
│   │   │   │   ├── dim_producto_precios.xlsx
│   │   │   │   ├── dim_productor.xlsx
│   │   │   │   ├── dim_provincia.xlsx
│   │   │   │   ├── dim_rango_hectareas.xlsx
│   │   │   │   ├── dim_region.xlsx
│   │   │   │   ├── dim_superficie.xlsx
│   │   │   │   ├── dim_tipo_cultivo.xlsx
│   │   │   │   ├── dim_unidad.xlsx
│   │   │   │   └── dim_uso_suelo.xlsx
│   │   │   └── fact_/                  ← Fact source files (14 tables)
│   │   │       ├── fact_causas_permanentes.xlsx
│   │   │       ├── fact_causas_transitorios.xlsx
│   │   │       ├── fact_comercial_agricola.xlsx
│   │   │       ├── fact_comercio_exterior_paises.xlsx
│   │   │       ├── fact_edad.xlsx
│   │   │       ├── fact_etnia.xlsx
│   │   │       ├── fact_flores.xlsx
│   │   │       ├── fact_formacion.xlsx
│   │   │       ├── fact_genero.xlsx
│   │   │       ├── fact_precios_productor.xlsx
│   │   │       ├── fact_produccion_agricola.xlsx
│   │   │       ├── fact_product_permanentes.xlsx
│   │   │       ├── fact_product_transitorios.xlsx
│   │   │       └── fact_uso_suelo_agricola.xlsx
│   │   │
│   │   ├── notebook_1.sql              ← National dimensions + production/sales/surface/flowers
│   │   ├── notebook_2.sql              ← External trade dimensions + commercial facts
│   │   ├── notebook_3.sql              ← Producer characteristics (gender, age, ethnicity)
│   │   ├── notebook_4.sql              ← Producer prices dimensions + facts
│   │   ├── notebook_5.sql              ← Permanent & transitory crops + causes
│   │   ├── notebook_6.sql              ← Land use dimension + facts
│   │   └── notebook_7.sql              ← Foreign trade by country + ISO codes
│   │
│   └── Gold/                           ← SQL notebooks: analytical layer
│       ├── notebook_gold_1.sql         ← Production, flowers, demographics, crops fact tables
│       ├── notebook_gold_2.sql         ← Producer prices fact table + views
│       ├── notebook_gold_3.sql         ← Agricultural commercial fact table
│       ├── notebook_gold_4.sql         ← Foreign trade by country (simple join)
│       └── notebook_gold_5.sql         ← Foreign trade with ISO normalization + export views
│
└── test/                               ← Scalability benchmarks
    ├── benchmark_scalability.sql       ← Notebook: SQL setup + Python benchmarks
    ├── TEST_free_19k.csv               ← Free tier results (19K rows)
    ├── TEST_free_232k.csv              ← Free tier results (232K rows)
    ├── TEST_azure_19k.csv              ← Azure tier results (19K rows)
    └── TEST_azure_232k.csv             ← Azure tier results (232K rows)
```

---

## Step 1 — Set Up Databricks

1. Go to [https://community.cloud.databricks.com/login.html](https://community.cloud.databricks.com/login.html) and create a free account.
2. Log in to your Databricks workspace.
3. Create a **Cluster** (required to run notebooks):
   - In the left sidebar, click **Compute** → **Create Compute**.
   - Choose the default runtime (e.g., `15.x LTS`).
   - Click **Create Compute** and wait for it to start.

> 💡 In the Community Edition, you get a single-node cluster. This is sufficient for this project.

---

## Step 2 — Create the Catalog and Schemas

Open a new SQL notebook in Databricks and run the following commands to set up the three-layer architecture:

```sql
-- Create the main catalog
CREATE CATALOG IF NOT EXISTS medallion_lab;

-- Create the three schemas (layers)
CREATE SCHEMA IF NOT EXISTS medallion_lab.bronze;
CREATE SCHEMA IF NOT EXISTS medallion_lab.silver;
CREATE SCHEMA IF NOT EXISTS medallion_lab.gold;
```

> ℹ️ **Note:** In Databricks Community Edition, Unity Catalog may not be available. In that case, use `hive_metastore` as the default catalog and create the schemas directly:
> ```sql
> CREATE DATABASE IF NOT EXISTS bronze;
> CREATE DATABASE IF NOT EXISTS silver;
> CREATE DATABASE IF NOT EXISTS gold;
> ```
> Then adjust all table references in the notebooks accordingly (e.g., `bronze.dim_anio_raw` instead of `medallion_lab.bronze.dim_anio_raw`).

---

## Step 3 — Ingest Data into Bronze

Upload the raw source files from `medallion-architecture/Bronze/` to Databricks and register them as tables in the `bronze` schema. Data is ingested as-is — no transformations are applied at this stage. The Silver notebooks will later read these tables and build the relational model.

### 3.1 — Upload the file

1. In the left sidebar, go to **Catalog** → select your catalog → `bronze` schema.
2. Click **Create** → **Table**.
3. Upload the source file by dragging it or browsing your computer.
4. Set **First row as header:** ✅ Yes and assign a descriptive name (e.g., `bronze.espac_2014`, `bronze.faostat`, `bronze.mag_precios`).

---

## Step 4 — Build Relational Model with Silver Notebooks

The Silver layer reads the raw Bronze tables and applies the full relational process: data type casting, text normalization, null filtering, and separation into a clean dimensional model of dimensions (`dim_*`) and fact tables (`th_*`).

### 4.1 — How to Create a Notebook in Databricks

1. In the left sidebar, click **Workspace** → navigate to your desired folder.
2. Click **Create** → **Notebook**.
3. Set the **language** to **SQL**.
4. Attach the notebook to your running cluster.

### 4.2 — Run the notebooks in order

Copy and paste the content of each `.sql` file from `Silver/` into a Databricks notebook and run them **in this order**:

| Order | File | What it creates |
|---|---|---|
| 1 | `notebook_1.sql` | `dim_anio_clean`, `dim_condicion_clean`, `dim_region_clean`, `dim_producto_clean`, `dim_productor_clean`, `dim_provincia_clean`, `dim_superficie_clean`, `dim_flores_clean`, `dim_empaque_clean`, `th_produccion_agricola_clean`, `th_superficie_agricola_clean`, `th_flores_clean` |
| 2 | `notebook_2.sql` | `dim_producto_ex_im_clean`, `dim_periodo_clean`, `th_comercial_agricola_clean` |
| 3 | `notebook_3.sql` | `dim_rango_hectareas_clean`, `dim_genero_clean`, `dim_edad_clean`, `dim_etnia_clean`, `dim_formacion_clean`, `th_genero_clean`, `th_formacion_clean`, `th_etnia_clean`, `th_edad_clean` |
| 4 | `notebook_4.sql` | `dim_mes_clean`, `dim_unidad_clean`, `dim_producto_precios_clean`, `th_precios_productor_clean` |
| 5 | `notebook_5.sql` | `dim_causas_clean`, `th_product_permanentes_clean`, `th_product_transitorios_clean`, `th_causas_permanentes_clean`, `th_causas_transitorios_clean` |
| 6 | `notebook_6.sql` | `dim_uso_suelo_clean`, `th_uso_suelo_clean` |
| 7 | `notebook_7.sql` | `dim_producto_comercio_exterior_clean`, `dim_elemento_comercio_exterior_clean`, `dim_paises_socios_clean`, `dim_pais_iso_clean`, `th_comercio_exterior_clean` |

> ⚠️ **Important:** Each notebook cell is separated by `-- COMMAND`. In Databricks, each `-- COMMAND` block should be placed in its own notebook cell. You can split them manually or paste the full file and use **Run All**.

### 4.3 — What the Silver notebooks do

- **Relational modeling**: raw Bronze data is transformed into a clean dimensional model, separating business entities into dimension tables (`dim_*`) and measurements into fact tables (`th_*`).
- **`TRY_CAST` + `REPLACE`**: removes thousands separators (`,` or `.`) and safely casts columns to `INT` or `VARCHAR`.
- **`REGEXP_REPLACE`**: used for numeric columns in fact tables, applying the same cleaning pattern.
- **`CASE / INITCAP`**: normalizes province and country names to proper casing.
- **`clean_number()` UDF**: a custom function that must be registered in your Databricks environment before running. It converts string numbers with regional formatting into `DOUBLE`.

> 💡 **Registering the `clean_number` UDF:** This function must be created in your Databricks session before running Silver notebooks. If you do not have the UDF definition, contact the data team or create a Python/SQL UDF that strips formatting characters and casts to `DOUBLE`.

---

## Step 5 — Build the Gold Layer

The Gold layer joins the clean Silver tables with their dimensions to produce fully enriched, analytics-ready fact tables and views.

### 5.1 — Run the Gold notebooks in order

| Order | File | What it creates |
|---|---|---|
| 1 | `notebook_gold_1.sql` | `fact_produccion_agricola`, `agg_produccion_region`, `fact_flores`, `fact_genero`, `fact_edad`, `fact_formacion`, `fact_etnia`, `fact_product_permanentes`, `fact_product_transitorios`, `fact_causas_permanentes`, `fact_causas_transitorios` |
| 2 | `notebook_gold_2.sql` | `fact_precios_productor`, view `gold_pp_tendencia_mensual`, view `gold_pp_variacion_mensual` |
| 3 | `notebook_gold_3.sql` | `fact_comercial_agricola` |
| 4 | `notebook_gold_4.sql` | `fact_comercio_exterior_paises` (simple version) |
| 5 | `notebook_gold_5.sql` | `fact_comercio_exterior_paises` (enhanced with ISO normalization), view `vw_exportacion_cantidad_pais` |

> ⚠️ **Run `notebook_gold_1.sql` before all others.** It creates the base fact tables that are referenced by the subsequent notebooks.

### 5.2 — What the Gold notebooks do

- **Dimensional enrichment**: each fact table is joined with its dimension tables using `LEFT JOIN`, bringing descriptive attributes (names, labels) alongside IDs.
- **KPI calculation**:
  - `RENDIMIENTO_T_HA` — production yield in tonnes per hectare.
  - `RENDIMIENTO_TALLOS_POR_HA` — flower stem yield per hectare.
  - `VAR_MENSUAL_PCT` — month-over-month price percentage variation using `LAG()` window function.
- **Views**: analytical summaries pre-built for dashboards and reporting.

---

## Step 6 — Benchmarks & Testing

The `test/` folder contains a Databricks notebook and CSV results for scalability benchmarking.

| File | Description |
|------|-------------|
| `benchmark_scalability.sql` | Notebook with SQL setup + Python benchmarks for 4 combinations (free/azure × 19K/232K rows), 5 query types × 10 repetitions each |
| `TEST_free_19k.csv` | Free tier results on original table (19,345 rows) |
| `TEST_free_232k.csv` | Free tier results on monthly-expanded table (232,140 rows) |
| `TEST_azure_19k.csv` | Azure tier results on original table (19,345 rows) |
| `TEST_azure_232k.csv` | Azure tier results on monthly-expanded table (232,140 rows) |

The notebook first creates `fact_produccion_agricola_mensual` (CROSS JOIN with `dim_mes_clean`), then runs 5 benchmark queries (SELECT *, COUNT(*), WHERE, GROUP BY, JOIN) 10 times each on both table sizes, and saves results to `medallion_lab.gold.benchmark_stats`.

---

## Data Dictionary

### Dimension Tables (Silver)

| Table | Description |
|---|---|
| `dim_anio_clean` | Calendar year |
| `dim_region_clean` | Geographic regions of Ecuador |
| `dim_provincia_clean` | Provinces (normalized names) |
| `dim_producto_clean` | Agricultural products |
| `dim_productor_clean` | Producer types |
| `dim_condicion_clean` | Crop condition |
| `dim_superficie_clean` | Land surface types |
| `dim_flores_clean` | Flower species |
| `dim_empaque_clean` | Packaging types and commercial use |
| `dim_rango_hectareas_clean` | Hectare range classification |
| `dim_genero_clean` | Gender categories |
| `dim_edad_clean` | Age range categories |
| `dim_etnia_clean` | Ethnicity categories |
| `dim_formacion_clean` | Education level categories |
| `dim_mes_clean` | Months |
| `dim_unidad_clean` | Measurement units |
| `dim_producto_precios_clean` | Products for price analysis |
| `dim_periodo_clean` | Trade periods |
| `dim_producto_ex_im_clean` | Products for import/export analysis |
| `dim_causas_clean` | Agricultural loss causes |
| `dim_uso_suelo_clean` | Land use classification |
| `dim_paises_socios_clean` | Partner countries (Spanish names normalized to English) |
| `dim_pais_iso_clean` | Country ISO codes |
| `dim_elemento_comercio_exterior_clean` | Foreign trade elements |
| `dim_producto_comercio_exterior_clean` | Products for foreign trade |

### Fact Tables (Gold)

| Table | Description |
|---|---|
| `fact_produccion_agricola` | Agricultural production with yield KPI |
| `agg_produccion_region` | Production aggregated by region and year |
| `fact_flores` | Flower production with stem yield KPI |
| `fact_genero` | Gender distribution by hectare range |
| `fact_edad` | Age distribution by hectare range |
| `fact_formacion` | Education distribution by hectare range |
| `fact_etnia` | Ethnicity distribution by hectare range |
| `fact_product_permanentes` | Permanent crops production |
| `fact_product_transitorios` | Transitory crops production |
| `fact_causas_permanentes` | Loss causes for permanent crops |
| `fact_causas_transitorios` | Loss causes for transitory crops |
| `fact_precios_productor` | Monthly producer prices |
| `fact_comercial_agricola` | Agricultural import/export commercial data |
| `fact_comercio_exterior_paises` | Foreign trade by partner country with ISO |

### Analytical Views (Gold)

| View | Description |
|---|---|
| `gold_pp_tendencia_mensual` | Monthly price trend with formatted date column |
| `gold_pp_variacion_mensual` | Month-over-month price percentage variation |
| `vw_exportacion_cantidad_pais` | Total export quantities aggregated by country |

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        DATA SOURCES                             │
│          Raw source files — medallion-architecture/Bronze/      │
└─────────────────────────┬───────────────────────────────────────┘
                          │  Manual upload via Databricks UI
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                    🥉 BRONZE LAYER                              │
│              medallion_lab.bronze.*_raw                         │
│   Raw tables ingested as-is from entity source files            │
│   Data: ESPAC crop surveys, FAOSTAT trade, MAG prices           │
└─────────────────────────┬───────────────────────────────────────┘
                          │  Silver notebooks: relational modeling + cleaning
                          │  • TRY_CAST / REPLACE / REGEXP_REPLACE
                          │  • CASE normalization
                          │  • NULL filtering
                          │  • clean_number() UDF
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                    🥈 SILVER LAYER                              │
│              medallion_lab.silver.*_clean                       │
│   Dimensional model: typed, normalized, deduplicated            │
│   25 clean dimensions + 14 clean fact tables                    │
└─────────────────────────┬───────────────────────────────────────┘
                          │  Gold notebooks (notebook_gold_1 to 5)
                          │  • LEFT JOIN with dimensions
                          │  • KPI calculation (yield, price variation)
                          │  • Aggregation views
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                    🥇 GOLD LAYER                                │
│              medallion_lab.gold.*                               │
│   Analytics-ready facts + KPIs for dashboards & ML              │
│   14 fact tables + 3 analytical views + yield/price KPIs        │
└─────────────────────────────────────────────────────────────────┘
```

---

## Useful Databricks Links

| Resource | Link |
|---|---|
| 🆓 Databricks Community Edition (Free) | [https://community.cloud.databricks.com/login.html](https://community.cloud.databricks.com/login.html) |
| 📝 Try Databricks | [https://www.databricks.com/try-databricks](https://www.databricks.com/try-databricks) |
| 📚 Getting Started Guide | [https://docs.databricks.com/en/getting-started/index.html](https://docs.databricks.com/en/getting-started/index.html) |
| 🗂️ Unity Catalog Overview | [https://docs.databricks.com/en/data-governance/unity-catalog/index.html](https://docs.databricks.com/en/data-governance/unity-catalog/index.html) |
| 📓 Create a Notebook | [https://docs.databricks.com/en/notebooks/notebooks-manage.html](https://docs.databricks.com/en/notebooks/notebooks-manage.html) |
| 📥 Upload Files & Create Tables | [https://docs.databricks.com/en/ingestion/file-upload/upload-data.html](https://docs.databricks.com/en/ingestion/file-upload/upload-data.html) |
| ⚡ SQL in Databricks Notebooks | [https://docs.databricks.com/en/sql/language-manual/index.html](https://docs.databricks.com/en/sql/language-manual/index.html) |
| 🔧 Create a Cluster | [https://docs.databricks.com/en/compute/clusters-manage.html](https://docs.databricks.com/en/compute/clusters-manage.html) |

---

*README generated for the Data Agro Ecuador — Medallion Architecture project. Versión en español: [`README.guie.es.md`](./README.guie.es.md).*
