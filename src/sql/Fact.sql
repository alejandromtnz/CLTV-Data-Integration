SELECT  
    sales.CODE,  
    CAST(PVP AS FLOAT) AS PVP,  
    CAST(MANTENIMIENTO_GRATUITO AS FLOAT) AS MANTENIMIENTO_GRATUITO,  
    SEGURO_BATERIA_LARGO_PLAZO,  
    TRY_CAST(FIN_GARANTIA AS DATE) AS FIN_GARANTIA,  
    CAST(COSTE_VENTA_NO_IMPUESTOS AS FLOAT) AS COSTE_VENTA_NO_IMPUESTOS,  
    CAST(IMPUESTOS AS FLOAT) AS IMPUESTOS,  
    EXTENSION_GARANTIA,  
    EN_GARANTIA,  

    -- 004: rev  
    ---- sales.CODE  
    DATE_UTIMA_REV,  
    CAST(DIAS_DESDE_ULTIMA_REVISION AS FLOAT) AS DIAS_DESDE_ULTIMA_REVISION,  
    CAST(Km_medio_por_revision AS FLOAT) AS Km_medio_por_revision,  
    CAST(km_ultima_revision AS FLOAT) AS km_ultima_revision,  
    CAST(Revisiones AS FLOAT) AS Revisiones,  

    -- 008: cac  
    ---- sales.CODE  
    CAST(DIAS_DESDE_LA_ULTIMA_ENTRADA_TALLER AS FLOAT) AS DIAS_DESDE_LA_ULTIMA_ENTRADA_TALLER,  
    CAST(DIAS_EN_TALLER AS FLOAT) AS DIAS_EN_TALLER,  
    QUEJA,  

    -- 009: motivo_venta  
    CAST(sales.MOTIVO_VENTA_ID AS INT) AS MOTIVO_VENTA_ID,  
    MOTIVO_VENTA,  

    -- 010: forma_pago  
    CAST(sales.FORMA_PAGO_ID AS INT) AS FORMA_PAGO_ID,  
    FORMA_PAGO,  
    FORMA_PAGO_GRUPO,  

    -- 017: logist  
    ---- sales.CODE  
    CAST(Fue_Lead AS INT) AS Fue_Lead,  
    CAST(Lead_compra AS INT) AS Lead_compra,  
    CAST(t_logist_days AS FLOAT) AS t_logist_days,  
    CAST(t_prod_date AS FLOAT) AS t_prod_date,  
    CAST(t_stock_dates AS FLOAT) AS t_stock_dates,  
    TRY_CAST(Logistic_date AS DATE) AS Logistic_date,  
    TRY_CAST(Prod_date AS DATE) AS Prod_date,  
    ---- Sales_Date,  

    ---- 016: origen_venta   
    CAST(logist.Origen_Compra_ID AS INT) AS Origen_Compra_ID,  
    Origen,  

    -- 018: edad_coche  
    ---- sales.CODE  
    CAST(Car_Age AS INT) AS Car_Age,


    -- fórmulas: producto y costes
    ROUND(sales.PVP * (Margen)*0.01 * (1 - IMPUESTOS / 100), 2) AS Margen_eur_bruto,
    ROUND(sales.PVP * (Margen)*0.01 * (1 - IMPUESTOS / 100) - sales.COSTE_VENTA_NO_IMPUESTOS - (Margendistribuidor*0.01 + GastosMarketing*0.01-Comisión_Marca*0.01) * sales.PVP * (1 - IMPUESTOS / 100) - Costetransporte, 2) AS Margen_eur,

    CAST(
        CASE 
            WHEN TRY_CAST(DIAS_DESDE_ULTIMA_REVISION AS FLOAT) > 400 THEN 1 
            ELSE 0 
        END 
    AS INT) AS CHARN   

FROM  
    [DATAEX].[001_sales] AS sales  

-- 004: rev  
LEFT JOIN  
    [DATAEX].[004_rev] revisions ON sales.CODE = revisions.CODE  

-- 008: cac  
LEFT JOIN  
    [DATAEX].[008_cac] cac ON sales.CODE = cac.CODE  

-- 009: motivo_venta  
LEFT JOIN  
    [DATAEX].[009_motivo_venta] motivo_venta ON sales.MOTIVO_VENTA_ID = motivo_venta.MOTIVO_VENTA_ID  

-- 010: forma_pago  
LEFT JOIN  
    [DATAEX].[010_forma_pago] forma_pago ON sales.FORMA_PAGO_ID = forma_pago.FORMA_PAGO_ID  

-- 017: logist & 016: origen_venta  
LEFT JOIN  
    [DATAEX].[017_logist] logist ON sales.CODE = logist.CODE  
LEFT JOIN  
    [DATAEX].[016_origen_venta] origen_venta ON logist.Origen_Compra_ID = origen_venta.Origen_Compra_ID  

-- 018: edad_coche  
LEFT JOIN  
    [DATAEX].[018_edad] edad_coche ON sales.CODE = edad_coche.CODE

-- fórmulas: producto y costes
LEFT JOIN  
    [DATAEX].[006_producto] producto ON sales.Id_Producto = producto.Id_Producto
LEFT JOIN
    [DATAEX].[007_costes] costes ON producto.Modelo = costes.Modelo