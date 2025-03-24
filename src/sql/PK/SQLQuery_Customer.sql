SELECT TOP 10
    c.*,  -- Trae todas las columnas de Dim_customer
    f.*,  -- Trae todas las columnas de Fact

	-- lead_sum
    (f.Fue_Lead + f.Lead_compra) AS lead_sum 

FROM dbo.Dim_customer AS c
LEFT JOIN dbo.Fact AS f
    ON c.Customer_ID = f.Customer_ID
