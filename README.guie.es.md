# 🌾 Data Agro Ecuador — Arquitectura Medallion en Databricks

Guía paso a paso para reproducir el pipeline completo de datos agrícolas de Ecuador usando Databricks y la arquitectura medallion **Bronce → Plata → Oro**.

---

## 📋 Tabla de Contenidos

1. [Requisitos Previos](#requisitos-previos)
2. [Estructura del Repositorio](#estructura-del-repositorio)
3. [Paso 1 — Configurar Databricks](#paso-1--configurar-databricks)
4. [Paso 2 — Crear el Catálogo y los Esquemas](#paso-2--crear-el-catálogo-y-los-esquemas)
5. [Paso 3 — Ingresar Datos a Bronze](#paso-3--ingresar-datos-a-bronze)
6. [Paso 4 — Construir Modelo Relacional con Notebooks Silver](#paso-4--construir-modelo-relacional-con-notebooks-silver)
7. [Paso 5 — Construir la Capa Gold](#paso-5--construir-la-capa-gold)
8. [Benchmarks y Pruebas](#benchmarks-y-pruebas)
9. [Diccionario de Datos](#diccionario-de-datos)
10. [Diagrama de Arquitectura](#diagrama-de-arquitectura)

---

## Requisitos Previos

Antes de comenzar, asegúrate de tener:

- Una cuenta de **Databricks** (edición gratuita disponible — ver enlace abajo)
- Los archivos fuente de datos ubicados en `medallion-architecture/Bronze/`
- Familiaridad básica con SQL y notebooks de Databricks

> 🔗 **Databricks Free Edition (Community Edition):**
> - Regístrate aquí: [https://community.cloud.databricks.com/login.html](https://community.cloud.databricks.com/login.html)
> - Documentación oficial: [https://docs.databricks.com/en/getting-started/index.html](https://docs.databricks.com/en/getting-started/index.html)
> - Qué incluye la capa gratuita: [https://www.databricks.com/try-databricks](https://www.databricks.com/try-databricks)

---

## Estructura del Repositorio

```
repository/
├── medallion-architecture/
│   ├── Bronze/                         ← Datos crudos desde entidades fuente
│   │   ├── Indice de publicacion ESPAC-2014/  ← Tablas ESPAC 2014 (T1.csv … T60.csv)
│   │   ├── Indice de publicacion ESPAC 2015/  ← Tablas ESPAC 2015
│   │   ├── Indice de publicacion ESPAC 2016.xlsx
│   │   ├── Indice_de publicacion_ESPAC_2017.xlsx
│   │   ├── Tabulados ESPAC 2018.xlsx
│   │   ├── Tabulados ESPAC CSV ESPAC 2019/    ← Tablas ESPAC 2019
│   │   ├── Tabulados CSV_ESPAC_ 2020/         ← Tablas ESPAC 2020
│   │   ├── Tabulados CSV_2021/                ← Tablas ESPAC 2021
│   │   ├── Tabulados CSV 2022/                ← Tablas ESPAC 2022
│   │   ├── TABULADOS_CSV 2023/                ← Tablas ESPAC 2023
│   │   ├── TABULADOS_ESPAC_2024_CVS/          ← Tablas ESPAC 2024
│   │   ├── FAOSTAT_data_es_12-10-2025.csv     ← Comercio exterior desde FAO
│   │   └── mag_preciosproductor_2025mayo.csv  ← Precios al productor desde MAG
│   │
│   ├── Silver/                         ← Modelo dimensional limpio
│   │   ├── Data/                       ← Archivos fuente estructurados para el modelo dimensional
│   │   │   ├── dim_/                   ← Archivos de dimensiones (25 tablas)
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
│   │   │   └── fact_/                  ← Archivos fuente de hechos (14 tablas)
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
│   │   ├── notebook_1.sql              ← Dimensiones nacionales + producción/ventas/superficie/flores
│   │   ├── notebook_2.sql              ← Dimensiones de comercio exterior + hechos comerciales
│   │   ├── notebook_3.sql              ← Características del productor (género, edad, etnia)
│   │   ├── notebook_4.sql              ← Dimensiones y hechos de precios al productor
│   │   ├── notebook_5.sql              ← Cultivos permanentes y transitorios + causas
│   │   ├── notebook_6.sql              ← Dimensión y hechos de uso de suelo
│   │   └── notebook_7.sql              ← Comercio exterior por país + códigos ISO
│   │
│   └── Gold/                           ← Notebooks SQL: capa analítica
│       ├── notebook_gold_1.sql         ← Hechos de producción, flores, demografía, cultivos
│       ├── notebook_gold_2.sql         ← Hechos de precios al productor + vistas
│       ├── notebook_gold_3.sql         ← Hechos comerciales agrícolas
│       ├── notebook_gold_4.sql         ← Comercio exterior por país (join simple)
│       └── notebook_gold_5.sql         ← Comercio exterior con normalización ISO + vistas de exportación
│
└── test/                               ← Benchmarks de escalabilidad
    ├── benchmark_scalability.sql       ← Notebook: setup SQL + benchmarks Python
    ├── TEST_free_19k.csv               ← Resultados capa gratuita (19K filas)
    ├── TEST_free_232k.csv              ← Resultados capa gratuita (232K filas)
    ├── TEST_azure_19k.csv              ← Resultados Azure (19K filas)
    └── TEST_azure_232k.csv             ← Resultados Azure (232K filas)
```

---

## Paso 1 — Configurar Databricks

1. Ve a [https://community.cloud.databricks.com/login.html](https://community.cloud.databricks.com/login.html) y crea una cuenta gratuita.
2. Inicia sesión en tu workspace de Databricks.
3. Crea un **Cluster** (necesario para ejecutar notebooks):
   - En la barra lateral izquierda, haz clic en **Compute** → **Create Compute**.
   - Elige el runtime por defecto (ej. `15.x LTS`).
   - Haz clic en **Create Compute** y espera a que se inicie.

> 💡 En la Community Edition obtienes un clúster de un solo nodo. Es suficiente para este proyecto.

---

## Paso 2 — Crear el Catálogo y los Esquemas

Abre un nuevo notebook SQL en Databricks y ejecuta los siguientes comandos para configurar la arquitectura de tres capas:

```sql
-- Crear el catálogo principal
CREATE CATALOG IF NOT EXISTS medallion_lab;

-- Crear los tres esquemas (capas)
CREATE SCHEMA IF NOT EXISTS medallion_lab.bronze;
CREATE SCHEMA IF NOT EXISTS medallion_lab.silver;
CREATE SCHEMA IF NOT EXISTS medallion_lab.gold;
```

> ℹ️ **Nota:** En Databricks Community Edition, Unity Catalog puede no estar disponible. En ese caso, usa `hive_metastore` como catálogo predeterminado y crea los esquemas directamente:
> ```sql
> CREATE DATABASE IF NOT EXISTS bronze;
> CREATE DATABASE IF NOT EXISTS silver;
> CREATE DATABASE IF NOT EXISTS gold;
> ```
> Luego ajusta todas las referencias a tablas en los notebooks (ej. `bronze.dim_anio_raw` en lugar de `medallion_lab.bronze.dim_anio_raw`).

---

## Paso 3 — Ingresar Datos a Bronze

Sube los archivos fuente de `medallion-architecture/Bronze/` a Databricks y regístralos como tablas en el esquema `bronze`. Los datos se ingieren tal cual — no se aplican transformaciones en esta etapa. Los notebooks Silver leerán estas tablas y construirán el modelo relacional.

### 3.1 — Subir el archivo

1. En la barra lateral izquierda, ve a **Catalog** → selecciona tu catálogo → esquema `bronze`.
2. Haz clic en **Create** → **Table**.
3. Sube el archivo fuente arrastrándolo o explorando tu computadora.
4. Marca **First row as header:** ✅ Sí y asigna un nombre descriptivo (ej. `bronze.espac_2014`, `bronze.faostat`, `bronze.mag_precios`).

---

## Paso 4 — Construir Modelo Relacional con Notebooks Silver

La capa Silver lee las tablas Bronze y aplica el proceso relacional completo: casting de tipos, normalización de texto, filtrado de nulos y separación en un modelo dimensional limpio de dimensiones (`dim_*`) y tablas de hechos (`th_*`).

### 4.1 — Cómo crear un notebook en Databricks

1. En la barra lateral izquierda, haz clic en **Workspace** → navega a la carpeta deseada.
2. Haz clic en **Create** → **Notebook**.
3. Establece el **idioma** en **SQL**.
4. Asigna el notebook a tu clúster en ejecución.

### 4.2 — Ejecutar los notebooks en orden

Copia y pega el contenido de cada archivo `.sql` de `Silver/` en un notebook de Databricks y ejecútalos **en este orden**:

| Orden | Archivo | Lo que crea |
|---|---|---|
| 1 | `notebook_1.sql` | `dim_anio_clean`, `dim_condicion_clean`, `dim_region_clean`, `dim_producto_clean`, `dim_productor_clean`, `dim_provincia_clean`, `dim_superficie_clean`, `dim_flores_clean`, `dim_empaque_clean`, `th_produccion_agricola_clean`, `th_superficie_agricola_clean`, `th_flores_clean` |
| 2 | `notebook_2.sql` | `dim_producto_ex_im_clean`, `dim_periodo_clean`, `th_comercial_agricola_clean` |
| 3 | `notebook_3.sql` | `dim_rango_hectareas_clean`, `dim_genero_clean`, `dim_edad_clean`, `dim_etnia_clean`, `dim_formacion_clean`, `th_genero_clean`, `th_formacion_clean`, `th_etnia_clean`, `th_edad_clean` |
| 4 | `notebook_4.sql` | `dim_mes_clean`, `dim_unidad_clean`, `dim_producto_precios_clean`, `th_precios_productor_clean` |
| 5 | `notebook_5.sql` | `dim_causas_clean`, `th_product_permanentes_clean`, `th_product_transitorios_clean`, `th_causas_permanentes_clean`, `th_causas_transitorios_clean` |
| 6 | `notebook_6.sql` | `dim_uso_suelo_clean`, `th_uso_suelo_clean` |
| 7 | `notebook_7.sql` | `dim_producto_comercio_exterior_clean`, `dim_elemento_comercio_exterior_clean`, `dim_paises_socios_clean`, `dim_pais_iso_clean`, `th_comercio_exterior_clean` |

> ⚠️ **Importante:** Cada celda del notebook está separada por `-- COMMAND`. En Databricks, cada bloque `-- COMMAND` debe colocarse en su propia celda. Puedes dividirlas manualmente o pegar todo el archivo y usar **Run All**.

### 4.3 — Qué hacen los notebooks Silver

- **Modelo relacional**: los datos crudos de Bronze se transforman en un modelo dimensional limpio, separando las entidades de negocio en tablas de dimensiones (`dim_*`) y las mediciones en tablas de hechos (`th_*`).
- **`TRY_CAST` + `REPLACE`**: elimina separadores de miles (`,` o `.`) y convierte columnas a `INT` o `VARCHAR` de forma segura.
- **`REGEXP_REPLACE`**: se usa en columnas numéricas de tablas de hechos, aplicando el mismo patrón de limpieza.
- **`CASE / INITCAP`**: normaliza nombres de provincias y países a mayúscula inicial.
- **`clean_number()` UDF**: una función personalizada que debe registrarse en tu entorno Databricks antes de ejecutar. Convierte cadenas numéricas con formato regional a `DOUBLE`.

> 💡 **Registrar la UDF `clean_number`:** Esta función debe crearse en tu sesión de Databricks antes de ejecutar los notebooks Silver. Si no tienes la definición de la UDF, contacta al equipo de datos o crea una UDF en Python/SQL que elimine caracteres de formato y convierta a `DOUBLE`.

---

## Paso 5 — Construir la Capa Gold

La capa Gold une las tablas limpias de Silver con sus dimensiones para producir tablas de hechos y vistas completamente enriquecidas y listas para análisis.

### 5.1 — Ejecutar los notebooks Gold en orden

| Orden | Archivo | Lo que crea |
|---|---|---|
| 1 | `notebook_gold_1.sql` | `fact_produccion_agricola`, `agg_produccion_region`, `fact_flores`, `fact_genero`, `fact_edad`, `fact_formacion`, `fact_etnia`, `fact_product_permanentes`, `fact_product_transitorios`, `fact_causas_permanentes`, `fact_causas_transitorios` |
| 2 | `notebook_gold_2.sql` | `fact_precios_productor`, vista `gold_pp_tendencia_mensual`, vista `gold_pp_variacion_mensual` |
| 3 | `notebook_gold_3.sql` | `fact_comercial_agricola` |
| 4 | `notebook_gold_4.sql` | `fact_comercio_exterior_paises` (versión simple) |
| 5 | `notebook_gold_5.sql` | `fact_comercio_exterior_paises` (mejorada con normalización ISO), vista `vw_exportacion_cantidad_pais` |

> ⚠️ **Ejecuta `notebook_gold_1.sql` antes que los demás.** Crea las tablas de hechos base referenciadas por los notebooks siguientes.

### 5.2 — Qué hacen los notebooks Gold

- **Enriquecimiento dimensional**: cada tabla de hechos se une con sus tablas de dimensiones usando `LEFT JOIN`, incorporando atributos descriptivos (nombres, etiquetas) junto a los IDs.
- **Cálculo de KPIs**:
  - `RENDIMIENTO_T_HA` — rendimiento de producción en toneladas por hectárea.
  - `RENDIMIENTO_TALLOS_POR_HA` — rendimiento de tallos florales por hectárea.
  - `VAR_MENSUAL_PCT` — variación porcentual mes a mes de precios usando la función ventana `LAG()`.
- **Vistas**: resúmenes analíticos preconstruidos para dashboards y reportes.

---

## Benchmarks y Pruebas

La carpeta `test/` contiene un notebook de Databricks y archivos CSV con resultados de benchmarks de escalabilidad.

| Archivo | Descripción |
|---|---|
| `benchmark_scalability.sql` | Notebook con setup SQL + benchmarks Python para 4 combinaciones (free/azure × 19K/232K filas), 5 tipos de consulta × 10 repeticiones cada una |
| `TEST_free_19k.csv` | Resultados capa gratuita en tabla original (19,345 filas) |
| `TEST_free_232k.csv` | Resultados capa gratuita en tabla expandida mensual (232,140 filas) |
| `TEST_azure_19k.csv` | Resultados Azure en tabla original (19,345 filas) |
| `TEST_azure_232k.csv` | Resultados Azure en tabla expandida mensual (232,140 filas) |

El notebook primero crea `fact_produccion_agricola_mensual` (CROSS JOIN con `dim_mes_clean`), luego ejecuta 5 consultas de benchmark (SELECT *, COUNT(*), WHERE, GROUP BY, JOIN) 10 veces cada una en ambos tamaños de tabla, y guarda los resultados en `medallion_lab.gold.benchmark_stats`.

---

## Diccionario de Datos

### Tablas de Dimensiones (Silver)

| Tabla | Descripción |
|---|---|
| `dim_anio_clean` | Año calendario |
| `dim_region_clean` | Regiones geográficas de Ecuador |
| `dim_provincia_clean` | Provincias (nombres normalizados) |
| `dim_producto_clean` | Productos agrícolas |
| `dim_productor_clean` | Tipos de productor |
| `dim_condicion_clean` | Condición del cultivo |
| `dim_superficie_clean` | Tipos de superficie |
| `dim_flores_clean` | Especies de flores |
| `dim_empaque_clean` | Tipos de empaque y uso comercial |
| `dim_rango_hectareas_clean` | Clasificación por rango de hectáreas |
| `dim_genero_clean` | Categorías de género |
| `dim_edad_clean` | Rangos de edad |
| `dim_etnia_clean` | Categorías de etnia |
| `dim_formacion_clean` | Niveles de educación |
| `dim_mes_clean` | Meses |
| `dim_unidad_clean` | Unidades de medida |
| `dim_producto_precios_clean` | Productos para análisis de precios |
| `dim_periodo_clean` | Períodos comerciales |
| `dim_producto_ex_im_clean` | Productos para análisis de importación/exportación |
| `dim_causas_clean` | Causas de pérdida agrícola |
| `dim_uso_suelo_clean` | Clasificación de uso de suelo |
| `dim_paises_socios_clean` | Países socios (nombres en español normalizados a inglés) |
| `dim_pais_iso_clean` | Códigos ISO de países |
| `dim_elemento_comercio_exterior_clean` | Elementos de comercio exterior |
| `dim_producto_comercio_exterior_clean` | Productos para comercio exterior |

### Tablas de Hechos (Gold)

| Tabla | Descripción |
|---|---|
| `fact_produccion_agricola` | Producción agrícola con KPI de rendimiento |
| `agg_produccion_region` | Producción agregada por región y año |
| `fact_flores` | Producción de flores con KPI de rendimiento de tallos |
| `fact_genero` | Distribución de género por rango de hectáreas |
| `fact_edad` | Distribución de edad por rango de hectáreas |
| `fact_formacion` | Distribución de educación por rango de hectáreas |
| `fact_etnia` | Distribución de etnia por rango de hectáreas |
| `fact_product_permanentes` | Producción de cultivos permanentes |
| `fact_product_transitorios` | Producción de cultivos transitorios |
| `fact_causas_permanentes` | Causas de pérdida para cultivos permanentes |
| `fact_causas_transitorios` | Causas de pérdida para cultivos transitorios |
| `fact_precios_productor` | Precios mensuales al productor |
| `fact_comercial_agricola` | Datos comerciales de importación/exportación agrícola |
| `fact_comercio_exterior_paises` | Comercio exterior por país socio con ISO |

### Vistas Analíticas (Gold)

| Vista | Descripción |
|---|---|
| `gold_pp_tendencia_mensual` | Tendencia mensual de precios con columna de fecha formateada |
| `gold_pp_variacion_mensual` | Variación porcentual mes a mes de precios |
| `vw_exportacion_cantidad_pais` | Cantidades totales de exportación agregadas por país |

---

## Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────────────┐
│                        FUENTES DE DATOS                          │
│          Archivos fuente — medallion-architecture/Bronze/        │
└─────────────────────────┬───────────────────────────────────────┘
                          │  Carga manual via Databricks UI
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                    🥉 CAPA BRONZE                                │
│              medallion_lab.bronze.*_raw                         │
│   Tablas crudas ingeridas tal cual desde archivos fuente        │
│   Datos: encuestas ESPAC, comercio FAOSTAT, precios MAG        │
└─────────────────────────┬───────────────────────────────────────┘
                          │  Notebooks Silver: modelo relacional + limpieza
                          │  • TRY_CAST / REPLACE / REGEXP_REPLACE
                          │  • Normalización CASE
                          │  • Filtrado de nulos
                          │  • clean_number() UDF
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                    🥈 CAPA SILVER                                │
│              medallion_lab.silver.*_clean                       │
│   Modelo dimensional: tipificado, normalizado, deduplicado      │
│   25 dimensiones limpias + 14 tablas de hechos limpias          │
└─────────────────────────┬───────────────────────────────────────┘
                          │  Notebooks Gold (notebook_gold_1 to 5)
                          │  • LEFT JOIN con dimensiones
                          │  • Cálculo de KPIs (rendimiento, variación de precios)
                          │  • Vistas de agregación
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                    🥇 CAPA GOLD                                  │
│              medallion_lab.gold.*                               │
│   Hechos + KPIs listos para dashboards y ML                     │
│   14 tablas de hechos + 3 vistas analíticas + KPIs              │
└─────────────────────────────────────────────────────────────────┘
```

---

## Enlaces Útiles de Databricks

| Recurso | Enlace |
|---|---|
| 🆓 Databricks Community Edition (Gratis) | [https://community.cloud.databricks.com/login.html](https://community.cloud.databricks.com/login.html) |
| 📝 Probar Databricks | [https://www.databricks.com/try-databricks](https://www.databricks.com/try-databricks) |
| 📚 Guía de inicio | [https://docs.databricks.com/en/getting-started/index.html](https://docs.databricks.com/en/getting-started/index.html) |
| 🗂️ Descripción de Unity Catalog | [https://docs.databricks.com/en/data-governance/unity-catalog/index.html](https://docs.databricks.com/en/data-governance/unity-catalog/index.html) |
| 📓 Crear un notebook | [https://docs.databricks.com/en/notebooks/notebooks-manage.html](https://docs.databricks.com/en/notebooks/notebooks-manage.html) |
| 📥 Subir archivos y crear tablas | [https://docs.databricks.com/en/ingestion/file-upload/upload-data.html](https://docs.databricks.com/en/ingestion/file-upload/upload-data.html) |
| ⚡ SQL en notebooks Databricks | [https://docs.databricks.com/en/sql/language-manual/index.html](https://docs.databricks.com/en/sql/language-manual/index.html) |
| 🔧 Crear un clúster | [https://docs.databricks.com/en/compute/clusters-manage.html](https://docs.databricks.com/en/compute/clusters-manage.html) |

---

*README generado para el proyecto Data Agro Ecuador — Arquitectura Medallion.*
