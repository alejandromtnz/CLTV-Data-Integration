-- Extraer el intercepto (beta0) y coeficientes necesarios
DECLARE @beta0 FLOAT, @beta_PVP FLOAT, @beta_CarAge FLOAT;

SELECT @beta0 = ISNULL(Coeficiente, 0) FROM [dbo].[Coeficientes_churn] WHERE variable = 'Intercepto';
SELECT @beta_PVP = ISNULL(Coeficiente, 0) FROM [dbo].[Coeficientes_churn] WHERE variable = 'log_PVP';
SELECT @beta_CarAge = ISNULL(Coeficiente, 0) FROM [dbo].[Coeficientes_churn] WHERE variable = 'sqrt_Car_Age';

-- Calcular probabilidad de retención para cada cliente
WITH RetencionClientes AS (
    SELECT 
        f.Customer_ID,
        ROUND(f.Margen_eur, 2) AS Margen,
        -- Fórmula logística para retención con manejo de NULLs
        CASE 
            WHEN f.PVP IS NULL OR f.Car_Age IS NULL OR f.Margen_eur IS NULL THEN NULL
            ELSE ROUND(1 - (1 / (1 + EXP(-(@beta0 + 
                           @beta_PVP * LOG(NULLIF(f.PVP, 0)) + 
                           @beta_CarAge * SQRT(NULLIF(f.Car_Age, 0)))))), 2)
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
    -- CLTV por año individual
    CASE WHEN Retencion IS NULL THEN NULL ELSE ROUND(Margen * (POWER(Retencion, 1)/POWER(1.07, 1)), 2) END AS CLTV_Año1,
    CASE WHEN Retencion IS NULL THEN NULL ELSE ROUND(Margen * (POWER(Retencion, 2)/POWER(1.07, 2)), 2) END AS CLTV_Año2,
    CASE WHEN Retencion IS NULL THEN NULL ELSE ROUND(Margen * (POWER(Retencion, 3)/POWER(1.07, 3)), 2) END AS CLTV_Año3,
    CASE WHEN Retencion IS NULL THEN NULL ELSE ROUND(Margen * (POWER(Retencion, 4)/POWER(1.07, 4)), 2) END AS CLTV_Año4,
    CASE WHEN Retencion IS NULL THEN NULL ELSE ROUND(Margen * (POWER(Retencion, 5)/POWER(1.07, 5)), 2) END AS CLTV_Año5,
    -- CLTV acumulado progresivo
    CASE WHEN Retencion IS NULL THEN NULL ELSE ROUND(Margen * (POWER(Retencion, 1)/POWER(1.07, 1)), 2) END AS CLTV_Acum_1Año,
    CASE WHEN Retencion IS NULL THEN NULL ELSE ROUND(Margen * (
        POWER(Retencion, 1)/POWER(1.07, 1) +
        POWER(Retencion, 2)/POWER(1.07, 2)
    ), 2) END AS CLTV_Acum_2Años,
    CASE WHEN Retencion IS NULL THEN NULL ELSE ROUND(Margen * (
        POWER(Retencion, 1)/POWER(1.07, 1) +
        POWER(Retencion, 2)/POWER(1.07, 2) +
        POWER(Retencion, 3)/POWER(1.07, 3)
    ), 2) END AS CLTV_Acum_3Años,
    CASE WHEN Retencion IS NULL THEN NULL ELSE ROUND(Margen * (
        POWER(Retencion, 1)/POWER(1.07, 1) +
        POWER(Retencion, 2)/POWER(1.07, 2) +
        POWER(Retencion, 3)/POWER(1.07, 3) +
        POWER(Retencion, 4)/POWER(1.07, 4)
    ), 2) END AS CLTV_Acum_4Años,
    CASE WHEN Retencion IS NULL THEN NULL ELSE ROUND(Margen * (
        POWER(Retencion, 1)/POWER(1.07, 1) +
        POWER(Retencion, 2)/POWER(1.07, 2) +
        POWER(Retencion, 3)/POWER(1.07, 3) +
        POWER(Retencion, 4)/POWER(1.07, 4) +
        POWER(Retencion, 5)/POWER(1.07, 5)
    ), 2) END AS CLTV_Acum_5Años
FROM
    RetencionClientes
WHERE
    Retencion IS NOT NULL
ORDER BY
    CLTV_Acum_5Años DESC;