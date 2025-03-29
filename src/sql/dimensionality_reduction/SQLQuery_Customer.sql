
-- Cálculo de métricas agregadas por cliente
WITH CustomerAggregates AS (
    SELECT 
        Customer_ID,
        -- Número total de ventas por cliente (frecuencia de compra)
        COUNT(CODE) AS num_ventas,
        
        -- Precio medio de venta (gasto promedio del cliente)
        AVG(CAST(PVP AS DECIMAL(10,2))) AS pvp_medio,
        
        -- Coste medio (para análisis de margen bruto)
        AVG(CAST(COSTE_VENTA_NO_IMPUESTOS AS DECIMAL(10,2))) AS coste_medio,
        
        -- Descuento medio aplicado (efectividad de promociones)
        AVG(CASE 
                WHEN PVP = 0 THEN NULL  -- Evita división por cero
                ELSE CAST((PVP - COSTE_VENTA_NO_IMPUESTOS) AS DECIMAL(10,2)) / CAST(PVP AS DECIMAL(10,2))
            END) AS descuento_medio,
        
        -- Total de revisiones en taller (indicador de fidelización)
        SUM(Revisiones) AS num_revisiones,
        
        -- Número de quejas (medida de satisfacción del cliente)
        SUM(CASE WHEN QUEJA = 'SI' THEN 1 ELSE 0 END) AS num_quejas,
        
        -- Última fecha de compra v�lida (para cálculo de inactividad)
        MAX(CASE 
                WHEN ISDATE(Logistic_date) = 1 THEN CAST(Logistic_date AS DATETIME)
                ELSE NULL  -- Ignora fechas mal formateadas
            END) AS ultima_fecha_compra,
        
        -- Precio mínimo pagado (rango inferior de gasto del cliente)
        MIN(CAST(PVP AS DECIMAL(10,2))) AS pvp_min,
        
        -- Precio máximo pagado (rango superior de gasto del cliente)
        MAX(CAST(PVP AS DECIMAL(10,2))) AS pvp_max,
        
        -- Margen medio por cliente (rentabilidad)
        AVG(CAST(Margen_eur AS DECIMAL(10,2))) AS margen_medio
    FROM dbo.Fact
    GROUP BY Customer_ID
),

-- Limpieza de fechas problemáticas
FechasLimpias AS (
    SELECT 
        Customer_ID,
        -- Convierte solo fechas válidas, descarta el resto
        CASE 
            WHEN ISDATE(Logistic_date) = 1 THEN CAST(Logistic_date AS DATETIME)
            ELSE NULL
        END AS Logistic_date_clean
    FROM dbo.Fact
)

-- Combina datos de dimensiones, hechos y métricas calculadas
SELECT
    -- Columnas de dimensión clientes (Dim_customer)
    c.Customer_ID,
    c.Edad,
    c.Fecha_nacimiento,
    c.GENERO,
    c.CP,
    c.poblacion,
    c.provincia,
    c.STATUS_SOCIAL,
    c.RENTA_MEDIA_ESTIMADA,
    c.ENCUESTA_ZONA_CLIENTE_VENTA,
    c.ENCUESTA_CLIENTE_ZONA_TALLER,
    c.A,
    c.B,
    c.C,
    c.D,
    c.E,
    c.F,
    c.G,
    c.H,
    c.I,
    c.J,
    c.K,
    c.U2,
    c.Max_Mosaic_G,
    c.Max_Mosaic2,
    c.Renta_Media,
    c.F2,
    c.Mosaic_number,

    -- Columnas de hechos (Fact)
    f.CODE,
    f.PVP,
    f.MANTENIMIENTO_GRATUITO,
    f.SEGURO_BATERIA_LARGO_PLAZO,
    f.FIN_GARANTIA,
    f.COSTE_VENTA_NO_IMPUESTOS,
    f.IMPUESTOS,
    f.EXTENSION_GARANTIA,
    f.EN_GARANTIA,
    f.DATE_UTIMA_REV AS DATE_ULTIMA_REV,
    f.DIAS_DESDE_ULTIMA_REVISION,
    f.Km_medio_por_revision,
    f.km_ultima_revision,
    f.Revisiones,
    f.DIAS_DESDE_LA_ULTIMA_ENTRADA_TALLER,
    f.DIAS_EN_TALLER,
    f.QUEJA,
    f.MOTIVO_VENTA_ID,
    f.MOTIVO_VENTA,
    f.FORMA_PAGO_ID,
    f.FORMA_PAGO,
    f.FORMA_PAGO_GRUPO,
    f.Fue_Lead,
    f.Lead_compra,
    f.t_logist_days,
    f.t_prod_date,
    f.t_stock_dates,
    f.Logistic_date,
    f.Prod_date,
    f.Origen_Compra_ID,
    f.Origen,
    f.Car_Age,
    f.Margen_eur_bruto,
    f.Margen_eur,
    f.CHARN,

    -- MÉTRICAS CALCULADAS
    -- Margen por unidad 
    CAST(
        CASE 
            WHEN f.PVP = 0 THEN NULL  -- Caso especial para PVP cero
            ELSE f.Margen_eur / ISNULL(NULLIF(f.PVP, 0), 1)  -- ISNULL protege contra división por cero
        END AS DECIMAL(10,4)  -- Precisión de 4 decimales para porcentajes
    ) AS Margen_por_unidad,

    -- Suma de leads 
    CAST((f.Fue_Lead + f.Lead_compra) AS INT) AS lead_sum,

    -- Interacci�n entre precio y antigüedad del vehículo
    CAST(f.PVP * f.Car_Age AS DECIMAL(10,2)) AS PVP_x_Car_Age,


    -- MÉTRICAS PRECALCULADAS (desde las CTEs)
    
    -- Número total de ventas del cliente
    agg.num_ventas,
    
    -- Precio medio de compra
    agg.pvp_medio,
    
    -- Coste medio para el negocio
    agg.coste_medio,
    
    -- Descuento medio aplicado
    agg.descuento_medio,
    
    -- Visitas al taller (fidelización postventa)
    agg.num_revisiones,
    
    -- Quejas registradas (indicador de satisfacción)
    agg.num_quejas,
    
    -- Días desde la última compra (para campañas de reactivación)
    DATEDIFF(day, agg.ultima_fecha_compra, GETDATE()) AS dias_ultima_compra,
    
    -- Precio mínimo pagado por el cliente
    agg.pvp_min,
    
    -- Precio máximo pagado por el cliente
    agg.pvp_max,
    
    -- Margen medio generado por este cliente
    agg.margen_medio

FROM dbo.Dim_customer AS c
LEFT JOIN dbo.Fact AS f ON c.Customer_ID = f.Customer_ID
LEFT JOIN CustomerAggregates AS agg ON c.Customer_ID = agg.Customer_ID
LEFT JOIN FechasLimpias AS fl ON c.Customer_ID = fl.Customer_ID