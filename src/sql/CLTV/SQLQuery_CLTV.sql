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
    ROWTERMINATOR = '\n',    -- Filas separadas por salto de l�nea
    TABLOCK
);

-- Extraer el intercepto (beta0) y coeficientes necesarios
DECLARE @beta0 FLOAT, @beta_PVP FLOAT, @beta_CarAge FLOAT;

SELECT @beta0 = Coeficiente FROM #TempCoeficientes WHERE Variable = 'Intercepto';
SELECT @beta_PVP = Coeficiente FROM #TempCoeficientes WHERE Variable = 'log_PVP';
SELECT @beta_CarAge = Coeficiente FROM #TempCoeficientes WHERE Variable = 'sqrt_Car_Age';

-- Mostrar coeficientes clave (para verificaci�n)
SELECT 
    @beta0 AS Intercepto,
    @beta_PVP AS Coef_log_PVP,
    @beta_CarAge AS Coef_sqrt_Car_Age;

-- Calcular probabilidad de retenci�n para cada cliente
WITH RetencionClientes AS (
    SELECT 
        f.Customer_ID,
        f.Margen_eur AS Margen,
        -- F�rmula log�stica para retenci�n
        1 - (1 / (1 + EXP(-(@beta0 + 
                           @beta_PVP * LOG(f.PVP) + 
                           @beta_CarAge * SQRT(f.Car_Age))))) AS Retencion
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
    -- CLTV por a�o individual (opcional)
    Margen * (POWER(Retencion, 1)/POWER(1.07, 1)) AS CLTV_A�o1,
    Margen * (POWER(Retencion, 2)/POWER(1.07, 2)) AS CLTV_A�o2,
    Margen * (POWER(Retencion, 3)/POWER(1.07, 3)) AS CLTV_A�o3,
    Margen * (POWER(Retencion, 4)/POWER(1.07, 4)) AS CLTV_A�o4,
    Margen * (POWER(Retencion, 5)/POWER(1.07, 5)) AS CLTV_A�o5,
    -- CLTV acumulado progresivo (mejor formato para an�lisis)
    Margen * (POWER(Retencion, 1)/POWER(1.07, 1)) AS CLTV_Acum_1A�o,
    Margen * (
        POWER(Retencion, 1)/POWER(1.07, 1) +
        POWER(Retencion, 2)/POWER(1.07, 2)
    ) AS CLTV_Acum_2A�os,
    Margen * (
        POWER(Retencion, 1)/POWER(1.07, 1) +
        POWER(Retencion, 2)/POWER(1.07, 2) +
        POWER(Retencion, 3)/POWER(1.07, 3)
    ) AS CLTV_Acum_3A�os,
    Margen * (
        POWER(Retencion, 1)/POWER(1.07, 1) +
        POWER(Retencion, 2)/POWER(1.07, 2) +
        POWER(Retencion, 3)/POWER(1.07, 3) +
        POWER(Retencion, 4)/POWER(1.07, 4)
    ) AS CLTV_Acum_4A�os,
    Margen * (
        POWER(Retencion, 1)/POWER(1.07, 1) +
        POWER(Retencion, 2)/POWER(1.07, 2) +
        POWER(Retencion, 3)/POWER(1.07, 3) +
        POWER(Retencion, 4)/POWER(1.07, 4) +
        POWER(Retencion, 5)/POWER(1.07, 5)
    ) AS CLTV_Acum_5A�os
FROM
    RetencionClientes
ORDER BY
    CLTV_Acum_5A�os DESC
