
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