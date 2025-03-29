# CLTV Data Integration

**Autor:** Alejandro Martínez Ronda  
**Repositorio:**  
- **Usuario GitHub:** alejandromtnz
- **Link repositorio:** [GitHub](https://github.com/alejandromtnz/CLTV-Data-Integration.git)

------

### **Análisis del Customer Lifetime Value**  
Este repositorio contiene la integración de datos y modelado del CLTV (Customer Lifetime Value), incluyendo ETL, modelado predictivo y visualización.

## **Descripción**
El proyecto se centra en la estimación del CLTV utilizando regresión logística para modelar la retención de clientes. Incluye:

- **ETL**: Extracción desde Azure SQL Server y migración de datos.
- **Modelado Dimensional**: Implementación de Data Warehouse con un esquema estrella.
- **Modelado Predictivo**: Estimación de la retención con regresión logística.
- **Cálculo del CLTV**: Proyección a 5 años con tasa de descuento del 7%.
- **Reducción de Dimensionalidad**: Selección de métricas clave enfocadas en clientes.
- **Visualización de Datos**: Tendencias, segmentación y análisis en Power BI.
- **Documentación Técnica**: Informes detallados del proceso.

## **Uso**
1. Explorar los notebooks en `src/notebooks/` para comprender el flujo de trabajo.
2. Revisar los scripts SQL en `src/sql/` para replicar el modelo en bases de datos.
3. Consultar `docs/` para documentación detallada sobre la metodología y resultados.

📌 **Nota:** Algunos archivos pueden estar sujetos a restricciones de acceso.

---

## **Estructura del Proyecto**
```bash
CLTV-Data-Integration/
│
├── docs/                      # Documentación y reportes
│   ├── data/                  
│   │   └── Datalake.xlsx       # Dataset maestro con estructura de tablas
│   ├── diagrams/              
│   │   ├── ER.drawio           # Diagrama Entidad-Relación (editable)
│   │   └── ER.png              # Exportación del diagrama ER
│   ├── model_outputs/         
│   │   └── logistic_coefficients.csv # Coeficientes del modelo predictivo
│   └── reports/                
│       ├── Caso_uso_DW.pdf     # Documentación de caso de uso
│       ├── CLV_article.pdf     # Artículo técnico 1
│       └── CLV_article2.pdf    # Artículo técnico 2
│
├── src/                        # Código fuente y notebooks
│   ├── notebooks/             
│   │   ├── cham_logistic_regression.ipynb # Modelo de retención
│   │   ├── CLTV_visualization.ipynb       # Gráficos y análisis
│   │   ├── environment_migration.ipynb    # ETL Azure → SQL Server
│   │   └── verify_data_integrity.ipynb    # Validación de datos
│   │
│   └── sql/                    # Scripts SQL
│       ├── CLTV/
│       │   └── SQLQuery_CLTV.sql # Cálculo del CLTV
│       ├── dimensional_model/
│       │   ├── Dim_customer.sql  # Dimensión clientes
│       │   ├── Dim_geo.sql       # Dimensión geográfica
│       │   ├── Dim_product.sql   # Dimensión productos
│       │   ├── Dim_t.sql         # Dimensión temporal
│       │   └── Fact.sql          # Tabla de hechos
│       ├── dimensionality_reduction/
│       │   └── SQLQuery_Customer.sql # Reducción dimensional
│       ├── PKs/
│       │   └── SQLQuery_PKs.sql   # Creación de claves primarias
│       └── PowerBI/
│           └── SQLQuery_PowerBI.sql # Consultas para dashboards
│
├── Informe_CLTV.pdf             # Documentación técnica completa
└── README.md                     # Guía rápida del proyecto
