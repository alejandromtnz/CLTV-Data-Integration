-- contruccion tabla dimensiona producto

SELECT 
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
    Car_Age,


    -- 006: producto (costes + categoria_producto + fuel)
    sales.Id_Producto,
    Kw,
    TRANSMISION_ID, -- hacefalta? para que sirve si no la podemos unir?

    ---- 014: categoria_producto
    producto.CATEGORIA_ID,
    Grade_ID,       -- va desde 0 a 4 referenciando 'equipemiento': hace falta equipamiento?
    Equipamiento,

    ---- 015: fuel
    producto.Fuel_ID,
    FUEL,

    ---- 007: costes
    producto.Modelo,
    Margen,
    Costetransporte,
    Margendistribuidor,
    GastosMarketing,
    Mantenimiento_medio,
    Comisión_Marca

FROM
    [DATAEX].[006_producto] producto
LEFT JOIN 
    [DATAEX].[007_costes] costes ON producto.Modelo = costes.Modelo
LEFT JOIN 
    [DATAEX].[014_categoría_producto] categoria_producto ON producto.CATEGORIA_ID = categoria_producto.CATEGORIA_ID
LEFT JOIN 
    [DATAEX].[015_fuel] fuel ON producto.Fuel_ID = fuel.Fuel_ID
LEFT JOIN 
    [DATAEX].[001_sales] sales ON sales.Id_Producto = producto.Id_Producto

-- review
LEFT JOIN 
    [DATAEX].[004_rev] revisions ON sales.CODE = revisions.CODE
LEFT JOIN 
    [DATAEX].[008_cac] cac ON sales.CODE = cac.CODE
LEFT JOIN 
    [DATAEX].[009_motivo_venta] motivo_venta ON sales.MOTIVO_VENTA_ID = motivo_venta.MOTIVO_VENTA_ID
LEFT JOIN 
    [DATAEX].[010_forma_pago] forma_pago ON sales.FORMA_PAGO_ID = forma_pago.FORMA_PAGO_ID

-- logist + origen_venta
-- LEFT JOIN 
--     [DATAEX].[016_origen_venta] origen_venta ON [017_logist].[Origen_Compra_ID] = origen_venta.Origen_Compra_ID
-- LEFT JOIN
--     [DATAEX].[017_logist] logist ON sales.CODE = logist.CODE

LEFT JOIN 
    [DATAEX].[017_logist] logist ON sales.CODE = logist.CODE
LEFT JOIN 
    [DATAEX].[016_origen_venta] origen_venta ON logist.Origen_Compra_ID = origen_venta.Origen_Compra_ID

-- edad
LEFT JOIN 
    [DATAEX].[018_edad] edad_coche ON sales.CODE = edad_coche.CODE