-- contruccion tabla dimensiona producto

SELECT 
    -- sales
    sales.CODE

    -- producto (costes + categoria_producto + fuel)
    Id_Producto,
    producto.CATEGORIA_ID,
    Kw,
    TRANSMISION_ID, -- hacefalta? para que sirve si no la podemos unir?
    ---- costes
    producto.Modelo,
    Margen,
    Costetransporte,
    Margendistribuidor,
    GastosMarketing,
    Mantenimiento_medio,
    Comisión_Marca,
    ---- categoria_producto
    producto.CATEGORIA_ID,
    Grade_ID,       -- va desde 0 a 4 referenciando 'equipemiento': hace falta equipamiento?
    Equipamiento,
    ---- fuel
    producto.Fuel_ID,
    FUEL

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
-- 
LEFT JOIN 
    [DATAEX].[004_rev] revisions ON sales.CODE = revisions.CODE
LEFT JOIN 
    [DATAEX].[008_cac] cac ON sales.CODE = cac.CODE
LEFT JOIN 
    [DATAEX].[009_motivo_venta] motivo_venta ON sales.MOTIVO_VENTA_ID = motivo_venta.MOTIVO_VENTA_ID
LEFT JOIN 
    [DATAEX].[010_forma_pago] forma_pago ON sales.FORMA_PAGO_ID = forma_pago.FORMA_PAGO_ID

-- logistic + origen_venta
-- edad