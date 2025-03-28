-- Verificar y eliminar la tabla temporal si ya existe
IF OBJECT_ID('tempdb..#TempCoeficientes') IS NOT NULL
    DROP TABLE #TempCoeficientes;

-- Crear tabla temporal con las columnas exactas de tu CSV
CREATE TABLE #TempCoeficientes (
    Variable NVARCHAR(100),
    Coeficiente FLOAT,
    Odds_Ratio FLOAT
);

-- Importar datos del CSV
BULK INSERT #TempCoeficientes
FROM 'C:\Users\aleja\OneDrive\Documentos\GitHub\3r\2n cuatri\gestion de datos - jacinto\Caso_DW\CLTV-Data-Integration\docs\model_outputs\logistic_coefficients_calculated.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,            -- Ignorar encabezados
    FIELDTERMINATOR = ',',   -- Columnas separadas por coma
    ROWTERMINATOR = '\n',    -- Filas separadas por salto de línea
    TABLOCK
);

-- Extraer el intercepto (beta0) y coeficientes necesarios
DECLARE @beta0 FLOAT, @beta_PVP FLOAT, @beta_CarAge FLOAT;

SELECT @beta0 = ISNULL(Coeficiente, 0) FROM #TempCoeficientes WHERE Variable = 'Intercepto';
SELECT @beta_PVP = ISNULL(Coeficiente, 0) FROM #TempCoeficientes WHERE Variable = 'log_PVP';
SELECT @beta_CarAge = ISNULL(Coeficiente, 0) FROM #TempCoeficientes WHERE Variable = 'sqrt_Car_Age';

-- Calcular probabilidad de retención para cada cliente (esta es la única consulta que devolverá resultados)
WITH RetencionClientes AS (
    SELECT 
        f.Customer_ID,
        f.Margen_eur AS Margen,
        -- Fórmula logística para retención con manejo de NULLs
        CASE 
            WHEN f.PVP IS NULL OR f.Car_Age IS NULL OR f.Margen_eur IS NULL THEN NULL
            ELSE 1 - (1 / (1 + EXP(-(@beta0 + 
                           @beta_PVP * LOG(NULLIF(f.PVP, 0)) + 
                           @beta_CarAge * SQRT(NULLIF(f.Car_Age, 0))))))
        END AS Retencion
    FROM 
        Fact f
    WHERE
        f.PVP > 0 
        AND f.Car_Age IS NOT NULL
        AND f.Margen_eur IS NOT NULL
)
-- Calcular el CLTV con acumulados progresivos
SELECT
    Customer_ID,
    Margen,
    Retencion,
    -- CLTV por año individual (opcional)
    CASE WHEN Retencion IS NULL THEN NULL ELSE Margen * (POWER(Retencion, 1)/POWER(1.07, 1)) END AS CLTV_Año1,
    CASE WHEN Retencion IS NULL THEN NULL ELSE Margen * (POWER(Retencion, 2)/POWER(1.07, 2)) END AS CLTV_Año2,
    CASE WHEN Retencion IS NULL THEN NULL ELSE Margen * (POWER(Retencion, 3)/POWER(1.07, 3)) END AS CLTV_Año3,
    CASE WHEN Retencion IS NULL THEN NULL ELSE Margen * (POWER(Retencion, 4)/POWER(1.07, 4)) END AS CLTV_Año4,
    CASE WHEN Retencion IS NULL THEN NULL ELSE Margen * (POWER(Retencion, 5)/POWER(1.07, 5)) END AS CLTV_Año5,
    -- CLTV acumulado progresivo (mejor formato para análisis)
    CASE WHEN Retencion IS NULL THEN NULL ELSE Margen * (POWER(Retencion, 1)/POWER(1.07, 1)) END AS CLTV_Acum_1Año,
    CASE WHEN Retencion IS NULL THEN NULL ELSE Margen * (
        POWER(Retencion, 1)/POWER(1.07, 1) +
        POWER(Retencion, 2)/POWER(1.07, 2)
    ) END AS CLTV_Acum_2Años,
    CASE WHEN Retencion IS NULL THEN NULL ELSE Margen * (
        POWER(Retencion, 1)/POWER(1.07, 1) +
        POWER(Retencion, 2)/POWER(1.07, 2) +
        POWER(Retencion, 3)/POWER(1.07, 3)
    ) END AS CLTV_Acum_3Años,
    CASE WHEN Retencion IS NULL THEN NULL ELSE Margen * (
        POWER(Retencion, 1)/POWER(1.07, 1) +
        POWER(Retencion, 2)/POWER(1.07, 2) +
        POWER(Retencion, 3)/POWER(1.07, 3) +
        POWER(Retencion, 4)/POWER(1.07, 4)
    ) END AS CLTV_Acum_4Años,
    CASE WHEN Retencion IS NULL THEN NULL ELSE Margen * (
        POWER(Retencion, 1)/POWER(1.07, 1) +
        POWER(Retencion, 2)/POWER(1.07, 2) +
        POWER(Retencion, 3)/POWER(1.07, 3) +
        POWER(Retencion, 4)/POWER(1.07, 4) +
        POWER(Retencion, 5)/POWER(1.07, 5)
    ) END AS CLTV_Acum_5Años
FROM
    RetencionClientes
WHERE
    Retencion IS NOT NULL
ORDER BY
    CLTV_Acum_5Años DESC;