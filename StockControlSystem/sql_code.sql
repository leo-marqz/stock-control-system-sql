
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

-- Visualizamos todas las categorias activas
SELECT *
FROM Categories
WHERE DeletedDate IS NULL;
GO

-- Visualizamos todas las categorias sin excepcion.
-- Select all categories from the table.
SELECT *
FROM Categories;
GO

-- Creamos la tabla de proveedores.
-- seguimos las mismas reglas que en la anterior tabla.
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1),
    SupplierName NVARCHAR(100) NOT NULL,
    ContactName NVARCHAR(100),
    PhoneNumber NVARCHAR(20),
    Email NVARCHAR(100),
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    LastModifiedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    DeletedDate DATETIME2 NULL,
    CONSTRAINT PK_Suppliers PRIMARY KEY (SupplierID)
);
GO

-- Agregamos el campo descripcion para conocer de forma breve que nos 
-- vende un proveedor o cual es su nicho.
ALTER TABLE Suppliers
ADD ShortDescription NVARCHAR(200);
GO

-- Visualizamos la estructura de la tabla de proveedores
EXEC sp_help 'Suppliers';

-- Comando sql para visualizar datos de la tabla de proveedores
-- en el orden de columnas que deseemos.
SELECT 
    SupplierID, 
    SupplierName,
    ShortDescription,
    ContactName, 
    PhoneNumber,
    Email,
    CreatedDate,
    LastModifiedDate,
    DeletedDate
FROM Suppliers;

-- Insertar 5 proveedores internacionales
INSERT INTO Suppliers (SupplierName, ContactName, PhoneNumber, Email, ShortDescription)
VALUES 
('Intel Corporation', 'Lisa Su', '+1 (408) 765-8080', 'lisa.su@intel.com', 'Líder global en fabricación de semiconductores, CPUs y chipsets.'),
('NVIDIA', 'Jensen Huang', '+1 (408) 486-2000', 'jhuang@nvidia.com', 'Pionero en la computación GPU, especializado en tarjetas gráficas y IA.'),
('Corsair', 'Andy Paul', '+1 (888) 222-4346', 'andy.paul@corsair.com', 'Fabricante de periféricos y componentes de alto rendimiento para gaming.'),
('Razer Inc.', 'Min-Liang Tan', '+1 (855) 872-9371', 'mlt@razer.com', 'Marca global de estilo de vida para gamers, con hardware y software de alto nivel.'),
('ASUS', 'Jonney Shih', '+886-2-2894-3447', 'j.shih@asus.com', 'Multinacional de hardware y electrónica, conocida por sus placas base y laptops.');

-- Insertar 5 proveedores nacionales de El Salvador (ejemplos ficticios)
INSERT INTO Suppliers (SupplierName, ContactName, PhoneNumber, Email, ShortDescription)
VALUES
('Tecno Red Salvadoreña S.A.', 'Carlos Ramirez', '+503 2234-5678', 'c.ramirez@tecnoredsv.com', 'Distribuidor de componentes de red y equipos de conectividad.'),
('Innovación Digital SV', 'Ana Torres', '+503 2289-0123', 'a.torres@innovaciondigitalsv.com', 'Proveedor de hardware de PC, almacenamiento y accesorios.'),
('Compu Mayorista El Salvador', 'Luis Galdamez', '+503 2277-8899', 'l.galdamez@compumayorista.com', 'Mayorista local de equipos de cómputo y periféricos de marcas populares.'),
('Data Express S.A.', 'Silvia Fuentes', '+503 2290-0011', 's.fuentes@dataexpress.sv', 'Especialista en soluciones de servidores, seguridad y sistemas de enfriamiento.'),
('Vanguardia Tech SV', 'Roberto Castro', '+503 2265-4321', 'r.castro@vanguardia.com', 'Proveedor de hardware de alta gama y sistemas personalizados.');
GO

-- Visualizamos los datos en el orden deseado nuevamente luego de la carga de datos
SELECT 
    SupplierID, SupplierName, ShortDescription, ContactName,  PhoneNumber, Email, 
    CreatedDate, LastModifiedDate, DeletedDate
FROM Suppliers;

-- Comando para actualizar la informacion de la descripcion de un proveedor en caso de necesitarlo
UPDATE Suppliers
SET ShortDescription = 'Distribuidor de componentes de red y equipos de conectividad.'
WHERE SupplierName = 'Tecno Red Salvadoreña S.A.';

-- Ingresamos dos proveedores por error que no van con nuestro rubro.
-- No llevan una descripcion.
INSERT INTO Suppliers (SupplierName, ContactName, PhoneNumber, Email)
VALUES 
('Fresh Veggies Inc.', 'Jane Doe', '555-0001', 'jane.d@freshveggies.com'),
('Global Textiles', 'Omar Khan', '555-0002', 'omar.k@globaltextiles.com');
GO

-- Actualizamos la informacion del primer proveedor erroneo y el otro lo marcaremos con eliminado logico.

-- Actualizamos
UPDATE Suppliers
SET SupplierName = 'Chipset Solutions Corp.',
    ContactName = 'Liam Jones',
    PhoneNumber = '+1 555-7890',
    Email = 'liam.j@chipsetsolutions.com',
    ShortDescription = 'Especializado en componentes de chipsets y circuitos integrados.'
WHERE SupplierName = 'Fresh Veggies Inc.';
GO

-- Eliminado logico o suave.
UPDATE Suppliers
SET DeletedDate = GETDATE()
WHERE SupplierName = 'Global Textiles';
GO

-- Creamos una vista
-- Nos permitira usar un comando corto para ver los registros activos.
CREATE VIEW vw_ActiveSuppliers AS
SELECT 
    SupplierID, 
    SupplierName,
    ShortDescription,
    ContactName, 
    PhoneNumber,
    Email,
    CreatedDate,
    LastModifiedDate
FROM 
    Suppliers
WHERE 
    DeletedDate IS NULL;
GO

-- Visualizamos los proveedores activos llamando la vista que recien creamos.
SELECT * FROM vw_ActiveSuppliers;
GO