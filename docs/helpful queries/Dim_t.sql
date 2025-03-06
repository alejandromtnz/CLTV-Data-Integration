-- contruccion tabla dimensiona producto

SELECT
    -- cojo todas las fechas o solo las de sales?
    sales.Sales_Date,
    Anno,
    Annomes,
    Dia,
    Diadelasemana,
    Diadelesemana_desc,
    Festivo,
    Findesemana,
    FinMes,
    InicioMes,
    Laboral,
    Mes,
    Mes_desc,
    Week
FROM    
    [DATAEX].[002_date] AS [date]
LEFT JOIN
    [DATAEX].[001_sales] AS sales ON sales.Sales_Date = [date].[Date]