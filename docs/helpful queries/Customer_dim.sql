-- contruccion tabla dimensiona cliente

SELECT 
    Customer_ID
    , Edad
    , Fecha_nacimiento
    , GENERO
    
    , codigopostalid AS CP
    , poblacion
    , provincia

    , STATUS_SOCIAL 
    , [RENTA_MEDIA_ESTIMADA]
    , [ENCUESTA_ZONA_CLIENTE_VENTA]
    , [ENCUESTA_CLIENTE_ZONA_TALLER]

    -- que es U2, Renta_Media, F2, Count?
    , [Renta_Media]
    -- hace falta A1, A2, A3, etc o solo con A sirve?

    -- tampoco pondria las letras pq no aparecen en que letra estan 
    -- o si si dps con la renta media lo clasificaremos
    -- que son los campos A, B, C, D, E, F, G, H, I, J, K?
    , [A], [B], [C], [D], [E], [F], [G], [H], [I], [J], [K], [U2]


FROM
    [DATAEX].[019_Mosaic] mosaic
LEFT JOIN 
    [DATAEX].[005_cp] cp ON cp.codigopostalid = mosaic.CP
LEFT JOIN 
    [DATAEX].[003_clientes] cliente ON cliente.CODIGO_POSTAL = cp.CP