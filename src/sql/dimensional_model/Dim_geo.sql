-- contruccion tabla dimensiona Geo

SELECT 
    TIENDA_ID,
    tienda.PROVINCIA_ID,
    PROV_DESC,
    tienda.ZONA_ID,
    ZONA,
    TIENDA_DESC
    
FROM
    [DATAEX].[011_tienda] tienda
LEFT JOIN 
    [DATAEX].[012_provincia] provincia ON CAST(tienda.PROVINCIA_ID AS INT) = CAST(provincia.PROVINCIA_ID AS INT)
LEFT JOIN 
    [DATAEX].[013_zona] zona ON CAST(tienda.ZONA_ID AS INT) = CAST(zona.ZONA_ID AS INT) 