# 🌾 Panorama of the Agricultural Sector of Ecuador

Big Data system and interactive dashboards for strategic decision-making in the Ecuadorian agricultural sector.

---

> 📊 **Live Dashboards**: [View on Tableau Public](https://public.tableau.com/app/profile/jean.avila7337/viz/PanoramadelSectorAgrcoladelEcuador/ResumenDash)

---

## Featured Dashboard

![Agricultural Sector Dashboard](img_dashboards/Dashboard_1.png)

*Interactive dashboard showing agricultural production overview with dynamic filters by year, product, and province.*

---

## Tech Stack

[![Databricks](https://img.shields.io/badge/-Databricks-FF3621?logo=databricks&style=flat)](https://community.cloud.databricks.com/)
[![Azure](https://img.shields.io/badge/-Azure-0078D4?logo=microsoftazure&style=flat)](https://azure.microsoft.com/services/databricks/)
[![Tableau](https://img.shields.io/badge/-Tableau-E97627?logo=tableau&style=flat)](https://public.tableau.com/)
[![Python](https://img.shields.io/badge/-Python-3776AB?logo=python&style=flat)](https://www.python.org/)
[![SQL](https://img.shields.io/badge/-SQL-CC2927?logo=microsoftsqlserver&style=flat)](https://www.databricks.com/spark-sql)

---

## About This Project

This project addresses a critical challenge in Ecuador's agricultural sector: although the country generates vast amounts of data (production, prices, exports, etc.), this information is scattered across multiple sources, in static formats, and without integration—limiting cross-analysis and strategic decision-making.

### The Solution

A complete analytical system that integrates data from **INEC (ESPAC)**, **MAG**, **Ecuador Open Data**, and **FAOSTAT** covering the period **2014–2024**, built on a **Medallion Architecture** in Databricks and visualized through **Tableau Public**.

### Key Results

| Metric | Result |
|--------|--------|
| Recommendation Rate | **100%** |
| Data Confidence Score | **4.45 / 5** |
| Survey Respondents | 31 agricultural sector professionals |

---

## System Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         DATA SOURCES                                │
│         INEC (ESPAC) │ MAG │ Ecuador Open Data │ FAOSTAT           │
│                        Period: 2014–2024                           │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                       🥉 BRONZE LAYER                                │
│              Raw data (CSV, Excel) as received                      │
│                   25 dimension tables + 14 fact tables              │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                       🥈 SILVER LAYER                                │
│          Cleaned, filtered, and validated data                      │
│              Typification, normalization, deduplication             │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                       🥇 GOLD LAYER                                  │
│        Fact tables and dimensions (Data Warehouse)                 │
│              Thematic Data Marts → Dashboards                       │
└─────────────────────────────────────────────────────────────────────┘
```

### Data Marts

| Data Mart | Description |
|-----------|-------------|
| **Agricultural Production** | Production by product, province, year |
| **Flowers** | Flower yield per hectare |
| **Producer Prices** | Monthly price trends and variations |
| **Producer Profile** | Demographic characteristics (gender, age, ethnicity, education) |
| **Foreign Trade** | Exports and imports by country and product |

---

## Interactive Dashboards

**7 thematic dashboards** were developed in Tableau Public with dynamic filters, enabling exploration by year, product, and province.

### Dashboard Gallery

| Dashboard | Description |
|-----------|-------------|
| **Agricultural Production** | Overview of agricultural production by region and crop |
| **Flowers** | Flower yield and production analysis |
| **Production & Losses** | Permanent and transitory crops with loss causes |
| **Producer Profile** | Demographic characteristics of agricultural producers |
| **Producer Prices** | Monthly price evolution by product |
| **Foreign Trade** | Agricultural exports and imports |
| **Foreign Trade by Country** | Export destinations with ISO codes |

#### Dashboard Previews

| Production Dashboard |
|----------------------|
| ![Production Dashboard](img_dashboards/Dashboard_2.png) |

| Foreign Trade Dashboard |
|------------------------|
| ![Foreign Trade Dashboard](img_dashboards/Dashboard_5.png) |

---

## Tech Stack

| Technology | Purpose |
|------------|---------|
| **Databricks Free Edition** | Medallion Architecture (Bronze → Silver → Gold) |
| **Azure Databricks** | Performance comparison testing |
| **Tableau Public** | Dashboard visualization and public publishing |
| **SQL** | Transformations and analytical queries |
| **Python** | Auxiliary functions (UDFs) |

---

## Key Limitations

- **Databricks Free Edition**: Does not allow public dashboard publishing (closed environments only).
- **Solution**: Complementary use of Tableau Public for publicly accessible interactive visualizations.

---

## Resources

| Resource | Link |
|----------|------|
| 📊 **Live Dashboards** | [Tableau Public - Panorama del Sector Agrícola del Ecuador](https://public.tableau.com/app/profile/jean.avila7337/viz/PanoramadelSectorAgrcoladelEcuador/ResumenDash) |
| 📖 **Research Article** | Digital 2026 Journal |
| 🏛️ **INEC - ESPAC** | [https://www.ecuadorencifras.gob.ec/espac/](https://www.ecuadorencifras.gob.ec/espac/) |
| 🌐 **Ecuador Open Data** | [https://www.datos.gob.ec/](https://www.datos.gob.ec/) |
| 📊 **FAOSTAT** | [https://www.fao.org/faostat/](https://www.fao.org/faostat/) |

---

## Authors

Ing. Ashley Aguilar-Serrano, Ing. Jean Ávila-Villaprado, Ing. Bertha Mazon-Olivo, Ing. Maritza Pinta

> *"Transforming scattered agricultural data into actionable knowledge for Ecuador's productive sector."*

---

*This README presents the analytical system developed. For technical implementation instructions, see the [main README](./README.md).*