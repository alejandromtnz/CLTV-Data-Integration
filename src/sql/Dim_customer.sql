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

    -- que es U2, Renta_Media, F2, Count?
    [Renta_Media] INT,
    -- hace falta A1, A2, A3, etc o solo con A sirve?

    -- tampoco pondria las letras pq no aparecen en que letra estan 
    -- o si si dps con la renta media lo clasificaremos
    -- que son los campos A, B, C, D, E, F, G, H, I, J, K?
    [A], [B], [C], [D], [E], [F], [G], [H], [I], [J], [K], [U2],
    [A1]

FROM
    [DATAEX].[019_Mosaic] mosaic
LEFT JOIN 
    [DATAEX].[005_cp] cp ON cp.codigopostalid = mosaic.CP
LEFT JOIN 
    [DATAEX].[003_clientes] cliente ON cliente.CODIGO_POSTAL = cp.CP