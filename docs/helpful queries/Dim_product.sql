-- contruccion tabla dimensiona producto

SELECT 
    ---- sales
    CODE

    ---- producto (costes + categoria_producto + fuel)
    sales.Id_Producto,
    CATEGORIA_ID,
    Kw,
    TRANSMISION_ID, -- hacefalta? para que sirve si no la podemos unir?
    
    producto.Modelo,
    Margen,
    Costetransporte,
    Margendistribuidor,
    GastosMarketing,
    Mantenimiento_medio,
    Comisión_Marca,

    producto.CATEGORIA_ID,
    Grade_ID,       -- va desde 0 a 4 referenciando 'equipemiento': hace falta equipamiento?
    Equipamiento,

    producto.Fuel_ID,
    FUEL

FROM
    [DATAEX].[006_producto] producto
LEFT JOIN 
    [DATAEX].[007_costes] costes ON producto.Modelo = costes.Modelo
LEFT JOIN 
    [DATAEX].[014_categoría_producto] categoria_producto ON producto.CATEGORIA_ID = categoría_producto.CATEGORIA_ID
LEFT JOIN 
    [DATAEX].[015_fuel] fuel ON producto.Fuel_ID = fuel.Fuel_ID
LEFT JOIN 
    [DATAEX].[001_sales] sales ON sales.Id_Producto = producto.Id_Producto;