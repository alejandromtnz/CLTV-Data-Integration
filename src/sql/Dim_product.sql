-- contruccion tabla dimensiona producto

SELECT 
    -- 006: producto (costes + categoria_producto + fuel)
    Id_Producto,
    CAST(Kw AS INT) AS Kw,
    CAST(TRANSMISION_ID AS TEXT) AS TRANSMISION_ID, -- hacefalta? para que sirve si no la podemos unir?

    ---- 014: categoria_producto
    CAST(producto.CATEGORIA_ID AS INT) AS CATEGORIA_ID,
    CAST(Grade_ID AS INT) AS Grade_ID,       -- va desde 0 a 4 referenciando 'equipemiento': hace falta equipamiento?
    Equipamiento,

    ---- 015: fuel
    producto.Fuel_ID,
    FUEL,

    ---- 007: costes
    producto.Modelo,
    CAST([Margen] AS INT) AS Margen,
    CAST([Costetransporte] AS INT) AS Costetransporte,
    CAST([Margendistribuidor] AS INT) AS Margendistribuidor,
    CAST([GastosMarketing] AS INT) AS GastosMarketing,
    CAST([Mantenimiento_medio] AS INT) AS Mantenimiento_medio,
    CAST([Comisión_Marca] AS INT) AS Comisión_Marca

FROM
    [DATAEX].[006_producto] producto
LEFT JOIN 
    [DATAEX].[007_costes] costes ON producto.Modelo = costes.Modelo
LEFT JOIN 
    [DATAEX].[014_categoría_producto] categoria_producto ON producto.CATEGORIA_ID = categoria_producto.CATEGORIA_ID
LEFT JOIN 
    [DATAEX].[015_fuel] fuel ON producto.Fuel_ID = fuel.Fuel_ID
