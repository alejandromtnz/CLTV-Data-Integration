SELECT TOP 10
    c.*,  -- Trae todas las columnas de Dim_customer
    f.*,  -- Trae todas las columnas de Fact

	-- margen por unidad
	CAST(
        CASE 
            WHEN PVP = 0 THEN NULL
            ELSE Margen_eur / PVP 
        END AS FLOAT
    ) AS Margen_por_unidad,

	-- lead_sum
    CAST((f.Fue_Lead + f.Lead_compra) AS INT) AS lead_sum

FROM dbo.Dim_customer AS c
LEFT JOIN dbo.Fact AS f
    ON c.Customer_ID = f.Customer_ID
