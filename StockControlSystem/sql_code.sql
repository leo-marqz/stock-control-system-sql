
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

-- Creamos la tabla que contiene datos de proveedores
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY IDENTITY(1,1),
    SupplierName NVARCHAR(100) NOT NULL,
    ContactName NVARCHAR(100),
    PhoneNumber NVARCHAR(20),
    Email NVARCHAR(100),
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    LastModifiedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    DeletedDate DATETIME2 NULL
);
GO

-- Visualizamos la estructura de la tabla.
EXEC sp_help 'Suppliers';
GO

-- Consultando INFORMATION_SCHEMA para conocer la estructura de la tabla opcion #2
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_NAME = 'Suppliers';
GO

-- Insertamos datos en la tabla de Suppliers.
INSERT INTO Suppliers (SupplierName, ContactName, PhoneNumber, Email)
VALUES 
('Tech Innovations Inc.', 'John Smith', '555-1234', 'jsmith@techinnovations.com'),
('Gourmet Goods Co.', 'Maria Rodriguez', '555-5678', 'mrodriguez@gourmetgoods.com'),
('Office Essentials LLC', 'David Chen', '555-9012', 'dchen@officeessentials.com');
GO

-- Obtenemos todos los proveedores.
SELECT * FROM Suppliers;
GO

-- Buscando un proveedor apartir de su nombre y actualizamos su email.
UPDATE Suppliers
SET Email = 'contact@gourmetgoods.com',
    LastModifiedDate = GETDATE()
WHERE SupplierName = 'Gourmet Goods Co.';
GO

-- Aplicamos borrado logico sobre un registro en la tabla de proveedores
UPDATE Suppliers
SET DeletedDate = GETDATE()
WHERE SupplierName = 'Office Essentials LLC';
GO

