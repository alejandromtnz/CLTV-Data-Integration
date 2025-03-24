SELECT
	-- Trae todas las columnas de Dim_customer
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

	-- Trae todas las columnas de Fact
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

	-- margen por unidad
    CAST(
        CASE 
            WHEN f.PVP = 0 THEN NULL
            ELSE f.Margen_eur / f.PVP 
        END AS FLOAT
    ) AS Margen_por_unidad,

	-- lead_sum
    CAST((f.Fue_Lead + f.Lead_compra) AS INT) AS lead_sum,

	-- Interacción PVP x Car_Age 
    CAST(f.PVP * f.Car_Age AS FLOAT) AS PVP_x_Car_Age,

	-- Número total de ventas por cliente (frecuencia de compra)
	COUNT(f.CODE) OVER (PARTITION BY c.Customer_ID) AS num_ventas,

	-- Precio medio de venta (gasto promedio)
	AVG(f.PVP) OVER (PARTITION BY c.Customer_ID) AS pvp_medio,

	-- Coste medio (para calcular margen bruto)
	AVG(f.COSTE_VENTA_NO_IMPUESTOS) OVER (PARTITION BY c.Customer_ID) AS coste_medio,

	-- Descuento medio aplicado (efectividad promociones)
	AVG((f.PVP - f.COSTE_VENTA_NO_IMPUESTOS)/NULLIF(f.PVP, 0)) OVER (PARTITION BY c.Customer_ID) AS descuento_medio,

	-- Total de revisiones en taller (fidelización postventa)
	SUM(f.Revisiones) OVER (PARTITION BY c.Customer_ID) AS num_revisiones,

	-- Número de quejas (indicador de satisfacción)
	SUM(CASE WHEN f.QUEJA = 'SI' THEN 1 ELSE 0 END) OVER (PARTITION BY c.Customer_ID) AS num_quejas,

	-- Días desde última compra (para reactivación)
	DATEDIFF(day, MAX(f.Logistic_date) OVER (PARTITION BY c.Customer_ID), CURRENT_DATE) AS dias_ultima_compra,

	-- Precio mínimo pagado (rango de gasto)
	MIN(f.PVP) OVER (PARTITION BY c.Customer_ID) AS pvp_min,

	-- Precio máximo pagado (gasto tope)
	MAX(f.PVP) OVER (PARTITION BY c.Customer_ID) AS pvp_max,

	-- Margen medio por cliente (rentabilidad)
	AVG(f.Margen_eur) OVER (PARTITION BY c.Customer_ID) AS margen_medio

FROM dbo.Dim_customer AS c
LEFT JOIN dbo.Fact AS f
    ON c.Customer_ID = f.Customer_ID