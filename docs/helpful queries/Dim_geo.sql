-- contruccion tabla dimensiona GEO

SELECT [TIENDA_ID]
    , tienda.[PROVINCIA_ID]
    , [PROV_DESC]
    , tienda.[ZONA_ID]
    , [ZONA]
    , [TIENDA_DESC]
FROM
    [DATAEX].[011_tienda] tienda
LEFT JOIN 
    [DATAEX].[012_provincia] provincia ON tienda.PROVINCIA_ID = provincia.PROVINCIA_ID
LEFT JOIN 
    [DATAEX].[013_zona] zona ON tienda.ZONA_ID = zona.ZONA_ID