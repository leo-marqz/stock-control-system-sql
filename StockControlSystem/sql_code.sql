
-- Verificamos que la base de datos no existe en el servidor
IF DB_ID('StockControlSystem') IS NULL
BEGIN
    -- Creamos la base de datos en el servidor MSSQL Server.
    CREATE DATABASE StockControlSystem;
END;

-- Llamamos la base de datos para ejecutar comandos sobre esta
USE StockControlSystem;
GO

--Tablas sin dependencias:
-- * Categories
-- * Suppliers

--Tablas con dependencias (dependen de las anteriores):
-- * Products (depende de Categories y Suppliers)

--Tablas con dependencias (dependen de Products):
-- * InventoryMovements (depende de Products)

-- Creamos la tabla de categorias
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1),
    CategoryName NVARCHAR(50) NOT NULL,
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    LastModifiedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    DeletedDate DATETIME2 NULL,
    CONSTRAINT PK_Categories PRIMARY KEY (CategoryID)
);
GO

-- Cargamos datos a la tabla de categorias
INSERT INTO Categories (CategoryName)
VALUES 
('Laptops'),
('Desktop Computers'),
('Monitors'),
('Keyboards'),
('Mice'),
('Headsets'),
('Motherboards'),
('Processors (CPUs)'),
('Graphics Cards (GPUs)'),
('Memory (RAM)'),
('Storage (SSD & HDD)'),
('Power Supplies (PSU)'),
('PC Cases'),
('Case Fans'),
('RGB Lighting');
GO

-- Visualizamos los datos ingresados
SELECT * FROM Categories;
GO

-- Ingresamos datos erroneos al que no van con el rubro.
-- Con  estos practicaremos con el resto de operaciones.
INSERT INTO Categories (CategoryName)
VALUES 
('Libros de Cocina'),
('Artículos de Jardinería'),
('Ropa de Invierno');
GO

-- Actualizamos uno de los registros erroneos
UPDATE Categories
SET CategoryName = 'Libros',
    LastModifiedDate = GETDATE()
WHERE CategoryName = 'Libros de Cocina';
GO

-- Aplicamos el borrado suave sobre los registros erroneos
UPDATE Categories
SET DeletedDate = GETDATE()
WHERE CategoryName IN ('Libros', 'Artículos de Jardinería', 'Ropa de Invierno');
GO

-- Visualizamos los registros a los que se les aplico el borrado suave o logico
SELECT *
FROM Categories
WHERE DeletedDate IS NOT NULL;
GO