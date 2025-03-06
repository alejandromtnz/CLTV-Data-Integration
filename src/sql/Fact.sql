SELECT
    sales.CODE,
    PVP,
    MANTENIMIENTO_GRATUITO,
    SEGURO_BATERIA_LARGO_PLAZO,
    MANTENIMIENTO_GRATUITO,
    FIN_GARANTIA,
    COSTE_VENTA_NO_IMPUESTOS,
    IMPUESTOS,
    EXTENSION_GARANTIA,
    EN_GARANTIA

    -- 004: rev
    ---- sales.CODE
    DATE_UTIMA_REV,
    DIAS_DESDE_ULTIMA_REVISION,
    Km_medio_por_revision,
    km_ultima_revision,
    Revisiones,

    -- 008: cac
    ---- sales.CODE
    DIAS_DESDE_LA_ULTIMA_ENTRADA_TALLER,
    DIAS_EN_TALLER,
    QUEJA,


    -- 009: motivo_venta
    sales.MOTIVO_VENTA_ID,
    MOTIVO_VENTA,


    -- 010: forma_pago
    sales.FORMA_PAGO_ID,
    FORMA_PAGO,
    FORMA_PAGO_GRUPO,


    -- 017: logist
    ---- sales.CODE
    Fue_Lead,
    Lead_compra,
    t_logist_days,
    t_prod_date,
    t_stock_dates,
    Logistic_date,
    Prod_date,
    ---- Sales_Date,
    
    ---- 016: origen_venta 
    logist.Origen_Compra_ID,
    Origen,


    -- 018: edad_coche
    ---- sales.CODE
    Car_Age
    
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