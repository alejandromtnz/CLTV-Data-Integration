---- PK de Fact
-- 1. Asegurar que CODE no permita valores NULL y que sea de tipo NVARCHAR(255)
ALTER TABLE Fact
ALTER COLUMN CODE NVARCHAR(255) NOT NULL;

-- 2. Eliminar la clave primaria existente (si hay alguna)
ALTER TABLE Fact
DROP CONSTRAINT IF EXISTS PK_Fact;  

-- 3. Agregar CODE como Primary Key
ALTER TABLE Fact  
ADD CONSTRAINT PK_Fact PRIMARY�KEY�(CODE);


---- PK de Dim_customer
-- 1. Asegurar que "Customer_ID" no permita valores NULL y que sea de tipo NVARCHAR(255)
ALTER TABLE Dim_customer  
ALTER COLUMN Customer_ID NVARCHAR(255) NOT NULL;

-- 2. Eliminar la clave primaria existente (si hay alguna)
ALTER TABLE Dim_customer  
DROP CONSTRAINT IF EXISTS PK_Dim_customer;  

-- 3. Agregar "Customer_ID" como Primary Key
ALTER TABLE Dim_customer  
ADD CONSTRAINT PK_Dim_customer PRIMARY�KEY�(Customer_ID);


---- PK de Dim_geo
-- 1. Asegurar que "TIENDA_ID" no permita valores NULL y que sea de tipo NVARCHAR(255)
ALTER TABLE Dim_geo  
ALTER COLUMN TIENDA_ID NVARCHAR(255) NOT NULL;

-- 2. Eliminar la clave primaria existente (si hay alguna)
ALTER TABLE Dim_geo  
DROP CONSTRAINT IF EXISTS PK_Dim_geo;  

-- 3. Agregar "TIENDA_ID" como Primary Key
ALTER TABLE Dim_geo  
ADD CONSTRAINT PK_Dim_geo PRIMARY�KEY�(TIENDA_ID);


---- PK de Dim_product
-- 1. Asegurar que "Id_Producto" no permita valores NULL y que sea de tipo NVARCHAR(255)
ALTER TABLE Dim_product  
ALTER COLUMN Id_Producto NVARCHAR(255) NOT NULL;

-- 2. Eliminar la clave primaria existente (si hay alguna)
ALTER TABLE Dim_product  
DROP CONSTRAINT IF EXISTS PK_Dim_product;  

-- 3. Agregar "Id_Producto" como Primary Key
ALTER TABLE Dim_product  
ADD CONSTRAINT PK_Dim_product PRIMARY�KEY�(Id_Producto);


---- PK de Dim_t
-- 1. Asegurar que "Date" no permita valores NULL y que sea de tipo NVARCHAR(255)
ALTER TABLE Dim_t  
ALTER COLUMN [Date] NVARCHAR(255) NOT NULL;

-- 2. Eliminar la clave primaria existente (si hay alguna)
ALTER TABLE Dim_t  
DROP CONSTRAINT IF EXISTS PK_Dim_t;  

-- 3. Agregar "Date" como Primary Key
ALTER TABLE Dim_t  
ADD CONSTRAINT PK_Dim_t PRIMARY�KEY�([Date]);