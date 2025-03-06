-- contruccion tabla dimensiona producto

SELECT
    -- cojo todas las fechas o solo las de sales?
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
    [Week]
FROM    
    [DATAEX].[002_date] AS [date]