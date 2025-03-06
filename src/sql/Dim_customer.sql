-- contruccion tabla dimensiona cliente

SELECT 
    Customer_ID INT,
    Edad INT,
    Fecha_nacimiento DATE,
    GENERO TEXT,
    
    CAST(codigopostalid AS INT) AS CP,
    poblacion TEXT,
    provincia TEXT,

    STATUS_SOCIAL TEXT,
    [RENTA_MEDIA_ESTIMADA] INT,
    [ENCUESTA_ZONA_CLIENTE_VENTA] INT,
    [ENCUESTA_CLIENTE_ZONA_TALLER] INT,

    [A] FLOAT, [B] FLOAT, [C] FLOAT, [D] FLOAT, [E] FLOAT, [F] FLOAT, [G] FLOAT, [H] FLOAT, [I] FLOAT, [J] FLOAT, [K] FLOAT, [U2] FLOAT,
    [Max_Mosaic_G] TEXT, [Max_Mosaic2] FLOAT, [Renta_Media] INT, [F2] INT, [Mosaic_number] INT

FROM
    [DATAEX].[003_clientes] cliente
LEFT JOIN  
    [DATAEX].[005_cp] cp ON cliente.CODIGO_POSTAL = cp.CP
LEFT JOIN 
    [DATAEX].[019_mosaic] mosaic ON try_cast(cp.codigopostalid AS INT) = try_cast(mosaic.CP AS INT)