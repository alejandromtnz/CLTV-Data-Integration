-- =============================================
-- DECLARACIÓN DE COEFICIENTES (extraídos del CSV)
-- =============================================
DECLARE @beta0 FLOAT = 3.2230929710994634;
DECLARE @beta_PVP FLOAT = -0.7688575695213695;
DECLARE @beta_CarAge FLOAT = 1.6275430470627636;
DECLARE @beta_KmRevision FLOAT = 2.7571362805903176e-05;
DECLARE @beta_PVPxCarAge FLOAT = -3.5363130212981218e-06;

-- =============================================
-- CTE 1: Métricas agregadas por cliente (de la primera query)
-- =============================================
WITH CustomerAggregates AS (
    SELECT 
        Customer_ID,
        COUNT(CODE) AS num_ventas,
        AVG(CAST(PVP AS DECIMAL(10,2))) AS pvp_medio,
        AVG(CAST(COSTE_VENTA_NO_IMPUESTOS AS DECIMAL(10,2))) AS coste_medio,
        AVG(CASE WHEN PVP = 0 THEN NULL ELSE CAST((PVP - COSTE_VENTA_NO_IMPUESTOS) AS DECIMAL(10,2)) / CAST(PVP AS DECIMAL(10,2)) END) AS descuento_medio,
        SUM(Revisiones) AS num_revisiones,
        SUM(CASE WHEN QUEJA = 'SI' THEN 1 ELSE 0 END) AS num_quejas,
        MAX(CASE WHEN ISDATE(Logistic_date) = 1 THEN CAST(Logistic_date AS DATETIME) ELSE NULL END) AS ultima_fecha_compra,
        MIN(CAST(PVP AS DECIMAL(10,2))) AS pvp_min,
        MAX(CAST(PVP AS DECIMAL(10,2))) AS pvp_max,
        AVG(CAST(Margen_eur AS DECIMAL(10,2))) AS margen_medio
    FROM dbo.Fact
    GROUP BY Customer_ID
),

-- =============================================
-- CTE 2: Limpieza de fechas problemáticas (de la primera query)
-- =============================================
FechasLimpias AS (
    SELECT 
        Customer_ID,
        CASE WHEN ISDATE(Logistic_date) = 1 THEN CAST(Logistic_date AS DATETIME) ELSE NULL END AS Logistic_date_clean
    FROM dbo.Fact
),

-- =============================================
-- CTE 3: Cálculo de retención y CLTV (de la segunda query)
-- =============================================
RetencionCLTV AS (
    SELECT 
        f.Customer_ID,
        f.Margen_eur AS Margen,
        -- Fórmula logística completa con todos los coeficientes
        1 - (1 / (1 + EXP(-(@beta0 + 
                           @beta_PVP * LOG(NULLIF(f.PVP, 0)) + 
                           @beta_CarAge * SQRT(f.Car_Age) +
                           @beta_KmRevision * f.Km_medio_por_revision +
                           @beta_PVPxCarAge * (f.PVP * f.Car_Age)
                  )))) AS Retencion
    FROM dbo.Fact f
    WHERE f.PVP > 0 AND f.Car_Age IS NOT NULL AND f.Margen_eur IS NOT NULL
)

-- =============================================
-- CONSULTA PRINCIPAL COMBINADA
-- =============================================
SELECT
    -- Columnas de dimensión clientes (de la primera query)
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

    -- Columnas de hechos (de la primera query)
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

    -- Métricas calculadas (de la primera query)
    CAST(CASE WHEN f.PVP = 0 THEN NULL ELSE f.Margen_eur / NULLIF(f.PVP, 0) END AS DECIMAL(10,4)) AS Margen_por_unidad,
    CAST((f.Fue_Lead + f.Lead_compra) AS INT) AS lead_sum,
    CAST(f.PVP * f.Car_Age AS DECIMAL(10,2)) AS PVP_x_Car_Age,

    -- Métricas precalculadas (de la primera query)
    agg.num_ventas,
    agg.pvp_medio,
    agg.coste_medio,
    agg.descuento_medio,
    agg.num_revisiones,
    agg.num_quejas,
    DATEDIFF(day, agg.ultima_fecha_compra, GETDATE()) AS dias_ultima_compra,
    agg.pvp_min,
    agg.pvp_max,
    agg.margen_medio,

    -- Resultados del modelo de retención y CLTV (de la segunda query)
    r.Retencion,
    r.Margen * (POWER(r.Retencion, 1)/POWER(1.07, 1)) AS CLTV_Año1,
    r.Margen * (POWER(r.Retencion, 2)/POWER(1.07, 2)) AS CLTV_Año2,
    r.Margen * (POWER(r.Retencion, 3)/POWER(1.07, 3)) AS CLTV_Año3,
    r.Margen * (POWER(r.Retencion, 4)/POWER(1.07, 4)) AS CLTV_Año4,
    r.Margen * (POWER(r.Retencion, 5)/POWER(1.07, 5)) AS CLTV_Año5,
    r.Margen * (POWER(r.Retencion, 1)/POWER(1.07, 1)) AS CLTV_Acum_1Año,
    r.Margen * (POWER(r.Retencion, 1)/POWER(1.07, 1) + POWER(r.Retencion, 2)/POWER(1.07, 2)) AS CLTV_Acum_2Años,
    r.Margen * (POWER(r.Retencion, 1)/POWER(1.07, 1) + POWER(r.Retencion, 2)/POWER(1.07, 2) + POWER(r.Retencion, 3)/POWER(1.07, 3)) AS CLTV_Acum_3Años,
    r.Margen * (POWER(r.Retencion, 1)/POWER(1.07, 1) + POWER(r.Retencion, 2)/POWER(1.07, 2) + POWER(r.Retencion, 3)/POWER(1.07, 3) + POWER(r.Retencion, 4)/POWER(1.07, 4)) AS CLTV_Acum_4Años,
    r.Margen * (POWER(r.Retencion, 1)/POWER(1.07, 1) + POWER(r.Retencion, 2)/POWER(1.07, 2) + POWER(r.Retencion, 3)/POWER(1.07, 3) + POWER(r.Retencion, 4)/POWER(1.07, 4) + POWER(r.Retencion, 5)/POWER(1.07, 5)) AS CLTV_Acum_5Años

FROM dbo.Dim_customer c
LEFT JOIN dbo.Fact f ON c.Customer_ID = f.Customer_ID
LEFT JOIN CustomerAggregates agg ON c.Customer_ID = agg.Customer_ID
LEFT JOIN FechasLimpias fl ON c.Customer_ID = fl.Customer_ID
LEFT JOIN RetencionCLTV r ON c.Customer_ID = r.Customer_ID
ORDER BY CLTV_Acum_5Años DESC;