-- SELECT * FROM [DATAEX].[001_sales]           -- seleccionar tabla
-- SELECT COUNT(*) FROM [DATAEX].[001_sales]    -- contar numero registros 

-- VER QUE HAY EN LA TABLA
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS                 -- info de las columnas
WHERE TABLE_NAME = '001_sales'


-- agrupar la tabla de ventas por producto y contar el numero de productos  y el precio medio
SELECT 
    [Id_Producto], 
    COUNT([Id_Producto]) AS [Numero_Ventas],                -- existe COUNT/DISTINCT para contar el numero de productos cambiando el nombre a [Numero_Ventas]; usamos count y no sum pq no podemos sumar texto pero si contarlo
    ROUND(AVG([PVP]), 2) AS [Precio_Medio]                  -- AVG para calcular la media del precio (redondeado) de los productos cambiando el nombre a [Precio_Medio]
FROM 
    [DATAEX].[001_sales]                                    -- seleccionar tabla
GROUP BY
    [Id_Producto]                                           -- agrupar por producto !!!! IMPORTANTE siempre que op => que quiero mostrar


-- agrupar por producto y contar distintivamente el numero de productos quitando los nulos == distintivosny
SELECT 
    [Id_Producto],
    COUNT([Id_Producto]) AS [Numero_Productos],             -- contamos los productos
    COUNT(DISTINCT [Id_Producto]) AS [Productos_Unicos],    -- contamos distintos
    ROUND(AVG(CAST([PVP] AS FLOAT)), 2) AS [Precio_Medio]   -- redondeamos la media // CAST: para convertir el tipo de dato a de texto FLOAT: decimal
FROM
    [DATAEX].[001_sales]
WHERE 
    [Id_Producto] IS NOT NULL                               -- quitamos los nulos
GROUP BY
    [Id_Producto]                                           -- agrupamos por producto !!

    -- ESQUELETO (donde hago op.):
        -- SELECT: variables que quiero mostrar + operaciones
        -- FROM: de donde saco los datos
        -- WHERE: condiciones / filtros
        -- GROUP BY: como agrupar       -- coge variables categoricas y hace la agrupacion por ello


-- convertir la fecha de formato texto a formato numero 
SELECT
   Sales_Date,                                              -- seleccionamos la fecha y asi printear las dos
   CAST(CONVERT(DATE, Sales_Date, 103) AS DATE) AS [Fecha_Convertida]   -- CAST: convertimos la fecha de texto a numero // CONVERT: ya que hacemos cosas dentro de la fecha, no solo convierte el tipo de dato
FROM 
    [DATAEX].[001_sales]                                    


---- ventas por años, por año y mes, y la tasa d evariacion

SELECT 
    YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) AS Año,
    COUNT(*) AS Total_Ventas
FROM [DATAEX].[001_sales]
GROUP BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))
ORDER BY Año DESC;

SELECT 
    YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) AS Año,
    MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) AS Mes,
    COUNT(*) AS Total_Ventas
FROM [DATAEX].[001_sales]
GROUP BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)), 
         MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))
ORDER BY Año DESC, Mes DESC;

--- el máximo de ventas de la base de datos

SELECT TOP 1
    CAST(CONVERT(DATE, Sales_Date, 103) AS DATE) AS Fecha_Convertida,
    COUNT(*) AS Total_Ventas,
    'Máximo Global' AS Tipo
FROM [DATAEX].[001_sales]
GROUP BY CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)
ORDER BY Total_Ventas DESC;


-- Máximo de ventas de 2023 

SELECT TOP 1 
--WITH TIES
    CAST(CONVERT(DATE, Sales_Date, 103) AS DATE) AS Fecha_Convertida,
    COUNT(*) AS Total_Ventas,
    'Máximo 2023' AS Tipo
FROM [DATAEX].[001_sales]
WHERE YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) = 2023
GROUP BY CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)
ORDER BY Total_Ventas DESC;


--------------------------------------------
---- Calcula la tasa de variacion por año 
SELECT 
    YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) AS Año,      -- convertir la fecha de texto a numero sacando el únicamente el año
    COUNT(*) AS Total_Ventas,                                       
    
    -- Calcula las ventas del año anterior usando LAG()
    LAG(COUNT(*)) OVER (                                            -- LAG(): función que nos permite acceder a la fila anterior ---> contar ventas sobre el año anterior: venta de 2025, la misma pero de 2024
        ORDER BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) -- fechas ordenadas
    ) AS Ventas_Año_Anterior,

    -- Cálculo de la tasa de variación en porcentaje: 1 - (ventas año actual / ventas año anterior) *100
    CASE                                                                    -- == if *
        WHEN LAG(COUNT(*)) OVER (                                           -- ** 
            ORDER BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))
        ) IS NULL                                                           -- por si las ventas del año anterior son nulas que no de error
        THEN NULL
        ELSE 
            ROUND(
                100.0 * (COUNT(*) - LAG(COUNT(*)) OVER (
                                ORDER BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))
                            )) 
                / NULLIF(LAG(COUNT(*)) OVER (                               -- NULLIF: si el denominador es 0, lo convierte en NULL 
                                ORDER BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))
                            ), 0), 2)
    END AS Tasa_Variacion_Porcentual

FROM [DATAEX].[001_sales]
GROUP BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))
ORDER BY Año DESC;

-- *    CASE
--          WHEN condicion: C or NULL
--              THEN resultado
--          ELSE 

-- **   OVER ... ORDER BY ...: para acceder a la fila anterior
--                  tienes una tabla con el dato desagregado con toda la info.; si queremos cuantos clientes hay en el año pasado,
--                              la manera logica seria crear una nueva tabla que te diga las ventas de t-1,
--                              creamos otra con t, y hacemos la operacion a partir de las dos tablas
--                  eso = un royo; la fincion OVER...: calcula y agrupa por año en una sola funcion sin necesidad de crear mas tablas 
--                  => HACER OP EN UNA SOLA FUNCION SIN NECESIDAD DE CREAR NUEVAS TABLAS COGIENDO LA PARTE DE LA OPERACION QUE QUERAMOS  




--- calcula las ventas  pro año y mes y su tasa d evariacion
SELECT 
    YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) AS Año,
    MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) AS Mes,
    COUNT(*) AS Total_Ventas,
    LAG(COUNT(*)) OVER (PARTITION BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))                             -- LAG(): función que nos permite acceder a la fila anterior // OVER: agrupar por año
                        ORDER BY MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))) AS Ventas_Mes_Anterior,       -- PARTITION BY: agrupar DOS variables a la vez: partir por año y ordenar mes en este caso
    CASE                                                                                                            -- == if *
        WHEN LAG(COUNT(*)) OVER (PARTITION BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))                    -- OVER: coger algo en concreto dentro deuna variable ordenado por dos variables
                                 ORDER BY MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))) IS NULL 
        THEN NULL
        ELSE 
            ROUND(
                100.0 * (COUNT(*) - LAG(COUNT(*)) OVER (PARTITION BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) 
                                                         ORDER BY MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))))
                / NULLIF(LAG(COUNT(*)) OVER (PARTITION BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) 
                                             ORDER BY MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))), 0), 2)
    END AS Tasa_Variacion_Porcentual
FROM [DATAEX].[001_sales]
GROUP BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)), 
         MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))
ORDER BY Año DESC, Mes DESC;






-------------------------------------------- el tema de los joins: JOIN
-- inner join: datos que COINCIDEN en ambas tablas

-- left join: datos de la tabla A y los que coinciden en la B
    -- left join ... where __ is null: datos de la tabla A sin los que coinciden en la B

-- right join: datos de la tabla B y los que coinciden en la A
    -- right join ... where __ is null: datos de la tabla B sin los que coinciden en la A

-- full outter join: todos los datos de ambas tablas
    -- full outter join ... where __ is null: datos que NO COINCIDEN en ambas tablas

-- **** hay que ir con cuidado si hacemos una consulta con muchos joins pq en tablas muy grandes puede ser muy lento  ==> optimizar consultas: reduccion de la dimensionalidad (tema 2)



-- Obtener productos y sus formas de pago
SELECT                                      -- cosas a seleccionar
    sales.Id_Producto, 
    fp.Forma_Pago,
    COUNT(*) AS [Numero_Ventas]
FROM  
    [DATAEX].[001_sales] sales              -- de que tabla sacarlo y que nombre le ponemos (sals) para evitar poner todo el rato []    
LEFT JOIN 
    [DATAEX].[010_products] fp
ON 
    sales.Id_Producto = fp.Id_Producto      -- como se relacionan las tablas   
GROUP BY
    sales.Id_Producto, 
    fp.Forma_Pago
ORDER BY 
    [Numero_Ventas] DESC;


-- FROM TABLA sales
-- left join TABLA fp
-- on sales.Id_Producto = fp.Id_Producto




---

-- filtra por la forma de pago 3
-- dos left joins con la forma de pago y el producto
-- y nos quedamos en la consulta con el dato que nos interesa



--------------------------------------------
--- explorar tablas
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS                 
WHERE TABLE_NAME = '001_sales'

SELECT COLUMN_NAME,
       (SELECT COUNT(*) 
        FROM [DATAEX].[001_sales]
        WHERE COLUMN_NAME IS NOT NULL) AS non_null_count
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = '001_sales';


--- buscar distintos
SELECT 
    COUNT(*) AS Total_Registros,
    COUNT(DISTINCT Sales_Date) AS Total_Fechas
FROM [DATAEX].[001_sales];

SELECT 
    COUNT(*) AS Total_Registros,
    COUNT(DISTINCT Sales_Date) AS Fechas_Unicas
FROM [DATAEX].[017_logist];



--- revisar PK
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS              
WHERE TABLE_NAME = '002_date'

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS              
WHERE TABLE_NAME = '003_clientes'

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS              
WHERE TABLE_NAME = '004_rev'

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS              
WHERE TABLE_NAME = '005_cp'



--- saber si es PK
----- SELECTO CountDistinct(Code) from 

----- numero de filas = numero de codigos

--- saber si FK
----- 54 PK y 500 prductos => variios a uno