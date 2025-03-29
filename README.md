# CLTV Data Integration

**Autor:** Alejandro Martínez Ronda  
**Repositorio:**  
- **Usuario GitHub:** alejandru00  
- **Link repositorio:** [GitHub](https://github.com/alejandru00/Entrega_Investigacion_Operativa.git)

------

# Proyecto CLTV

**Análisis del Customer Lifetime Value**  
Solución integral para calcular el customer lifetime value (CLTV) de clientes mediante modelado predictivo y arquitectura ETL.

## Componentes Principales
- **Modelo Entidad-Relación**: Diseñado a partir de 19 tablas de Azure SQL
- **Modelo Dimensional**: Esquema estrella con 5 dimensiones + tablas de hechos
- **Reducción de Dimensionalidad**: Métricas clave enfocado a clientes
- **Modelado Predictivo**: Regresión logística para retención de clientes
- **Cálculo CLTV**: Proyección a 5 años con tasa de descuento del 7%
- **Visualización de Datos**: Distribución, tendencias y análisis de segmentación
- **Documentación Técnica**: Documentación completa del proceso

## Tecnologías Utilizadas
- **Azure SQL**: Sistema fuente de datos
- **SQL Server Management Studio**: Almacén de datos local
- **Visual Studio Code**: Desarrollo de ETL y modelado

## Estructura del Proyecto
CLTV-Data-Integration/
│
├── docs/
│ ├── data/
│ │ └── Datalake.xlsx # Dataset maestro con estructura de tablas
│ ├── diagrams/
│ │ ├── ER.drawio # Diagrama Entidad-Relación (editable)
│ │ └── ER.png # Exportación del diagrama ER
│ ├── model_outputs/
│ │ └── logistic_coefficients.csv # Coeficientes del modelo predictivo
│ └── reports/
│ ├── Caso_uso_DW.pdf # Documentación de caso de uso
│ ├── CLV_article.pdf # Artículo técnico 1
│ └── CLV_article2.pdf # Artículo técnico 2
│
├── src/
│ ├── notebooks/
│ │ ├── cham_logistic_regression.ipynb # Modelo de retención
│ │ ├── CLTV_visualization.ipynb # Gráficos y análisis
│ │ ├── environment_migration.ipynb # ETL Azure → SQL Server
│ │ └── verify_data_integrity.ipynb # Validación de datos
│ │
│ └── sql/
│ ├── CLTV/
│ │ └── SQLQuery_CLTV.sql # Cálculo del CLTV
│ ├── dimensional_model/
│ │ ├── Dim_customer.sql # Dimensión clientes
│ │ ├── Dim_geo.sql # Dimensión geográfica
│ │ ├── Dim_product.sql # Dimensión productos
│ │ ├── Dim_t.sql # Dimensión temporal
│ │ └── Fact.sql # Tabla de hechos
│ ├── dimensionality_reduction/
│ │ └── SQLQuery_Customer.sql # Reducción dimensional
│ ├── PKs/
│ │ └── SQLQuery_PKs.sql # Creación de claves primarias
│ └── PowerBI/
│ └── SQLQuery_PowerBI.sql # Consultas para dashboards
│
├── Informe_CLTV.pdf # Documentación técnica completa
└── README.md # Guía rápida del proyecto
