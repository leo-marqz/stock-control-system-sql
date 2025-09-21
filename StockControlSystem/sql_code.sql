
-- Creamos la base de datos para el sistema de control de existencias.
CREATE DATABASE StockControlSystem;
GO

-- Llamamos la base de datos
USE StockControlSystem;

--Tablas sin dependencias:
-- * Categories
-- * Suppliers

--Tablas con dependencias (dependen de las anteriores):
-- * Products (depende de Categories y Suppliers)

--Tablas con dependencias (dependen de Products):
-- * InventoryMovements (depende de Products)

-- Creamos la tabla de categorias
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(50) NOT NULL,
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    LastModifiedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    DeletedDate DATETIME2 NULL
);
GO

-- Insertamos datos en la tabla de Categorias.
INSERT INTO Categories (CategoryName)
VALUES 
('Electronics'),
('Home Appliances'),
('Office Supplies');
GO

-- Leemos todos los datos de la tabla de categorias.
SELECT * FROM Categories;
GO

-- Actualizamos la categoria con id 1 'Electronics' a 'Smartphones'
UPDATE Categories
SET CategoryName = 'Smartphones',
    LastModifiedDate = GETDATE()
WHERE CategoryID = 1;
GO

-- Actualizamos la categoria con id 2 'Home Appliances' a 'Kitchen Appliances'
UPDATE Categories
SET CategoryName = 'Kitchen Appliances',
    LastModifiedDate = GETDATE()
WHERE CategoryID = 2;
GO

-- Insertamos mas categorias.
INSERT INTO Categories (CategoryName)
VALUES 
('Laptops'),
('Smart TVs'),
('Gaming Consoles'),
('Headphones'),
('Webcams'),
('Home Security');
GO

-- Insertamos dos categorias mas que usaremos para aplicar 
-- algo llamado soft-delete.
INSERT INTO Categories (CategoryName)
VALUES 
('Drones'),
('Fitness Trackers');
GO

-- Aplicamos el Soft Delete
UPDATE Categories
SET DeletedDate = GETDATE()
WHERE CategoryName IN ('Drones', 'Fitness Trackers');
GO

-- Visualizamos todos los datos
SELECT * FROM Categories;
GO

-- Visualizamos las categorias activas.
SELECT * FROM Categories
WHERE DeletedDate IS NULL;
GO

-- Visualizamos solo las categorias con el soft delete activo
SELECT *
FROM Categories
WHERE DeletedDate IS NOT NULL;
GO
