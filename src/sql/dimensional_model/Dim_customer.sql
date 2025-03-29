-- contruccion tabla dimensiona Customer

SELECT
    CAST([Customer_ID] AS INT) AS Customer_ID,
    CAST([Edad] AS INT) AS Edad,
    Fecha_nacimiento,
    GENERO,
    CAST([codigopostalid] AS INT) AS CP,
    poblacion,
    provincia,
    STATUS_SOCIAL,
    CAST([RENTA_MEDIA_ESTIMADA] AS INT) AS RENTA_MEDIA_ESTIMADA,
    CAST([ENCUESTA_ZONA_CLIENTE_VENTA] AS INT) AS ENCUESTA_ZONA_CLIENTE_VENTA,
    CAST([ENCUESTA_CLIENTE_ZONA_TALLER] AS INT) AS ENCUESTA_CLIENTE_ZONA_TALLER,
    CAST([A] AS FLOAT) AS A,
    CAST([B] AS FLOAT) AS B,
    CAST([C] AS FLOAT) AS C,
    CAST([D] AS FLOAT) AS D,
    CAST([E] AS FLOAT) AS E,
    CAST([F] AS FLOAT) AS F,
    CAST([G] AS FLOAT) AS G,
    CAST([H] AS FLOAT) AS H,
    CAST([I] AS FLOAT) AS I,
    CAST([J] AS FLOAT) AS J,
    CAST([K] AS FLOAT) AS K,
    CAST([U2] AS FLOAT) AS U2,
    [Max_Mosaic_G],
    CAST([Max_Mosaic2] AS FLOAT) AS Max_Mosaic2,
    CAST([Renta_Media] AS INT) AS Renta_Media,
    CAST([F2] AS INT) AS F2,
    CAST([Mosaic_number] AS INT) AS Mosaic_number
FROM
    [DATAEX].[003_clientes] cliente
LEFT JOIN  
    [DATAEX].[005_cp] cp ON cliente.CODIGO_POSTAL = cp.CP
LEFT JOIN
    [DATAEX].[019_mosaic] mosaic ON try_cast(cp.codigopostalid AS INT) = try_cast(mosaic.CP AS INT)