-- contruccion tabla dimensiona producto

SELECT 
    -- 006: producto (costes + categoria_producto + fuel)
    Id_Producto,
    Kw INT,
    TRANSMISION_ID TEXT, -- hacefalta? para que sirve si no la podemos unir?

    ---- 014: categoria_producto
    producto.CATEGORIA_ID,
    Grade_ID INT,       -- va desde 0 a 4 referenciando 'equipemiento': hace falta equipamiento?
    Equipamiento,

    ---- 015: fuel
    producto.Fuel_ID TEXT,
    FUEL,

    ---- 007: costes
    producto.Modelo TEXT,
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
