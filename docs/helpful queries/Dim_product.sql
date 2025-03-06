-- contruccion tabla dimensiona producto

SELECT 
    Id_Producto,
    Modelo

FROM
    [DATAEX].[006_producto] producto
LEFT JOIN 
    [DATAEX].[007_costes] costes ON producto.Modelo = costes.Modelo
LEFT JOIN 
    [DATAEX].[014_categoría_producto] categoría_producto ON producto.CATEGORIA_ID = categoría_producto.CATEGORIA_ID
LEFT JOIN 
    [DATAEX].[015_fuel] fuel ON producto.Fuel_ID = fuel.Fuel_ID