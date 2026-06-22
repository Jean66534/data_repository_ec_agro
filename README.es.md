# 🌾 Panorama del Sector Agrícola del Ecuador

Sistema de Big Data y dashboards interactivos para la toma de decisiones estratégicas en el sector agrícola ecuatoriano.

---

> 📊 **Dashboards en vivo**: [Ver en Tableau Public](https://public.tableau.com/app/profile/jean.avila7337/viz/PanoramadelSectorAgrcoladelEcuador/ResumenDash)

---

## Dashboard Destacado

![Dashboard del Sector Agrícola](img_dashboards/Dashboard_1.png)

*Dashboard interactivo que muestra una visión general de la producción agrícola con filtros dinámicos por año, producto y provincia.*

---

## Tech Stack

[![Databricks](https://img.shields.io/badge/-Databricks-FF3621?logo=databricks&style=flat)](https://community.cloud.databricks.com/)
[![Azure](https://img.shields.io/badge/-Azure-0078D4?logo=microsoftazure&style=flat)](https://azure.microsoft.com/services/databricks/)
[![Tableau](https://img.shields.io/badge/-Tableau-E97627?logo=tableau&style=flat)](https://public.tableau.com/)
[![Python](https://img.shields.io/badge/-Python-3776AB?logo=python&style=flat)](https://www.python.org/)
[![SQL](https://img.shields.io/badge/-SQL-CC2927?logo=microsoftsqlserver&style=flat)](https://www.databricks.com/spark-sql)

---

## Acerca del Proyecto

Este proyecto aborda un problema crítico en el sector agrícola de Ecuador: aunque el país genera gran cantidad de información (producción, precios, exportaciones, etc.), estos datos están dispersos en múltiples fuentes, en formatos estáticos y sin integración entre sí, lo que limita el análisis cruzado y la toma de decisiones estratégicas.

### La Solución

Un sistema analítico completo que integra datos de **INEC (ESPAC)**, **MAG**, **Ecuador Open Data** y **FAOSTAT** del período **2014–2024**, construido sobre una **Arquitectura Medallion** en Databricks y visualizado en Tableau Public.

### Resultados Clave

| Métrica | Resultado |
|---------|-----------|
| Tasa de recomendación | **100%** |
| Confianza en los datos | **4.45 / 5** |
| Encuestados | 31 profesionales del sector agrícola |

---

## Arquitectura del Sistema

```
┌─────────────────────────────────────────────────────────────────────┐
│                         FUENTES DE DATOS                            │
│         INEC (ESPAC) │ MAG │ Ecuador Open Data │ FAOSTAT           │
│                        Período: 2014–2024                           │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                       🥉 BRONZE LAYER                               │
│              Datos crudos desde las entidades fuente                │
│           ESPAC · FAOSTAT · MAG (CSV / Excel)                      │
└───────────────────────────────┬─────────────────────────────────────┘
                                │  Ingesta y registro de datos
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                       🥈 SILVER LAYER                                │
│              Modelo dimensional + limpieza                         │
│              25 dimensiones limpias + 14 tablas de hechos          │
└───────────────────────────────┬─────────────────────────────────────┘
                                │  Enriquecimiento y cálculo de KPIs
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                       🥇 GOLD LAYER                                  │
│              Datos listos para dashboards y ML                     │
│              14 tablas de hechos + 3 vistas analíticas + KPIs      │
└─────────────────────────────────────────────────────────────────────┘
```

### Guía Rápida por Capa

| Capa | Contenido | Ubicación |
|------|-----------|-----------|
| **🥉 Bronze** | Archivos fuente tal cual recibidos de INEC (ESPAC), FAOSTAT y MAG | `medallion-architecture/Bronze/` |
| **🥈 Silver** | Modelo dimensional limpio: 25 dimensiones + 14 tablas de hechos | `medallion-architecture/Silver/` (notebooks) + `Silver/Data/` (Excel fuente) |
| **🥇 Gold** | Hechos, vistas y KPIs listos para dashboards y ML | `medallion-architecture/Gold/` (notebooks) |

> 📖 Para la estructura detallada archivo por archivo y la guía de reproducción paso a paso, consulta la [guía en español](README.guie.es.md) o la [guía en inglés](README.guie.md). For the English version, see [`README.md`](./README.md).

---

### Data Marts Construidos

| Data Mart | Descripción | Tablas Gold |
|-----------|-------------|-------------|
| **Producción Agrícola** | Producción por producto, provincia, año con rendimiento | `fact_produccion_agricola`, `agg_produccion_region` |
| **Flores** | Rendimiento de flores por hectárea | `fact_flores` |
| **Perfil del Productor** | Demografía (género, edad, etnia, educación) | `fact_genero`, `fact_edad`, `fact_formacion`, `fact_etnia` |
| **Producción y Pérdidas** | Cultivos permanentes, transitorios y causas de pérdida | `fact_product_permanentes`, `fact_product_transitorios`, `fact_causas_*` |
| **Precios** | Tendencias y variaciones mensuales de precios | `fact_precios_productor`, vistas `gold_pp_*` |
| **Comercio Exterior** | Exportaciones e importaciones por país y producto | `fact_comercial_agricola`, `fact_comercio_exterior_paises` |

---

## Dashboards Interactivos

Se desarrollaron **7 dashboards temáticos** en Tableau Public con filtros dinámicos, permitiendo exploración por año, producto y provincia.

### Galería de Dashboards

| Dashboard | Descripción |
|-----------|-------------|
| **Producción Agrícola** | Vista general de la producción agrícola por región y cultivo |
| **Flores** | Análisis de rendimiento y producción florícola |
| **Producción y Pérdidas** | Cultivos permanentes y transitorios con causas de pérdida |
| **Perfil del Productor** | Características demográficas de los productores agrícolas |
| **Precios al Productor** | Evolución de precios mensuales por producto |
| **Comercio Exterior** | Exportaciones e importaciones agrícolas |
| **Comercio Exterior por País** | Destinos de exportación con códigos ISO |

#### Previews de Dashboards

| Dashboard de Producción |
|------------------------|
| ![Dashboard Producción](img_dashboards/Dashboard_2.png) |

| Dashboard de Comercio Exterior |
|-------------------------------|
| ![Dashboard Comercio Exterior](img_dashboards/Dashboard_5.png) |

---

## Stack Tecnológico

| Tecnología | Propósito |
|------------|-----------|
| **Databricks Free Edition** | Arquitectura Medallion (Bronze → Silver → Gold) |
| **Azure Databricks** | Pruebas de rendimiento comparativo |
| **Tableau Public** | Visualización y publicación de dashboards |
| **SQL** | Transformaciones y consultas analíticas |
| **Python** | Funciones auxiliares (UDFs) |

---

## Recursos

| Recurso | Enlace |
|---------|--------|
| 📊 **Dashboards en vivo** | [Tableau Public - Panorama del Sector Agrícola del Ecuador](https://public.tableau.com/app/profile/jean.avila7337/viz/PanoramadelSectorAgrcoladelEcuador/ResumenDash) |
| 🏛️ **INEC - ESPAC** | [https://www.ecuadorencifras.gob.ec/espac/](https://www.ecuadorencifras.gob.ec/espac/) |
| 🌐 **Ecuador Open Data** | [https://www.datos.gob.ec/](https://www.datos.gob.ec/) |
| 📊 **FAOSTAT** | [https://www.fao.org/faostat/](https://www.fao.org/faostat/) |

---

## Autores

Ing. Ashley Aguilar-Serrano, Ing. Jean Ávila-Villaprado, Ing. Bertha Mazon-Olivo, Ing. Maritza Pinta

---

## Contacto

- **Jean Ávila-Villaprado** — [jeanavilavillaprado@hotmail.com](mailto:jeanavilavillaprado@hotmail.com)
- **Ashley Aguilar-Serrano** — [ashleyas23@hotmail.com](mailto:ashleyas23@hotmail.com)

---

*Este README presenta el sistema analítico desarrollado. Para instrucciones técnicas de implementación, consulta la [guía de implementación](./README.guie.md). For the English version, see [`README.md`](./README.md).*