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
│              Datos crudos (CSV, Excel) tal cual ingresan            │
│                   25 tablas de dimensiones + 14 hechos               │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                       🥈 SILVER LAYER                                │
│          Datos limpios, filtrados y validados                      │
│              Tipificación, normalización, deduplicación            │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                       🥇 GOLD LAYER                                  │
│        Tablas de hechos y dimensiones (Data Warehouse)             │
│              Data Marts temáticos → Dashboards                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Data Marts Construidos

| Data Mart | Descripción |
|-----------|-------------|
| **Producción Agrícola** | Producción por producto, provincia, año |
| **Flores** | Rendimiento de flores por hectárea |
| **Precios** | Tendencias y variaciones mensuales de precios |
| **Perfil del Productor** | Características demográficas (género, edad, etnia, educación) |
| **Comercio Exterior** | Exportaciones e importaciones por país y producto |

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

## Limitaciones Documentadas

- **Databricks Free Edition**: No permite publicación pública de dashboards (solo entornos cerrados).
- **Solución**: Uso complementario de Tableau Public para publicación de visualizaciones interactivas accesibles públicamente.

---

## Recursos

| Recurso | Enlace |
|---------|--------|
| 📊 **Dashboards en vivo** | [Tableau Public - Panorama del Sector Agrícola del Ecuador](https://public.tableau.com/app/profile/jean.avila7337/viz/PanoramadelSectorAgrcoladelEcuador/ResumenDash) |
| 📖 **Artículo de Investigación** | Revista Digital 2026 |
| 🏛️ **INEC - ESPAC** | [https://www.ecuadorencifras.gob.ec/espac/](https://www.ecuadorencifras.gob.ec/espac/) |
| 🌐 **Ecuador Open Data** | [https://www.datos.gob.ec/](https://www.datos.gob.ec/) |
| 📊 **FAOSTAT** | [https://www.fao.org/faostat/](https://www.fao.org/faostat/) |

---

## Autor

**Jean Avila** — Proyecto de investigación para Revista Digital 2026

> *"Transformando datos agrícolas dispersos en conocimiento accionable para el sector productivo del Ecuador."*

---

*Este README presenta el sistema analítico desarrollado. Para instrucciones técnicas de implementación, consulta el [README principal](./README.md).*