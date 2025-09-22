
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

-- Ya que no garantizamos un orden concreto de los registros al obtenerlos con la vista vw_ActiveSuppliers.
-- Crearemos un Stored Procedure para realizar la tarea y estar seguros del orden en que se obtendra la informacion
-- de la taba de proveedores.
CREATE PROCEDURE sp_GetActiveSuppliers
AS
BEGIN
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
        DeletedDate IS NULL
    ORDER BY 
        SupplierName ASC;
END;
GO

-- Llamamos al stored procedure para verificar que todo funciona como queremos.
EXEC sp_GetActiveSuppliers;
GO

-- Creamos la tabla de productos
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1),
    ProductName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    Price DECIMAL(10, 2) NOT NULL,
    Cost DECIMAL(10, 2) NOT NULL,
    StockQuantity INT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1, -- disponibilidad o mantenimiento del producto
    CategoryID INT,
    SupplierID INT,
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    LastModifiedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    DeletedDate DATETIME2 NULL, -- si no es null, significa que este producto ha sido borrado y no debe usarse.
    CONSTRAINT PK_Products PRIMARY KEY (ProductID),
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    CONSTRAINT FK_Products_Suppliers FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);
GO

-- Agregamos productos con sus respectivas relaciones con proveedores y categorias.
INSERT INTO Products (ProductName, Description, Price, Cost, StockQuantity, CategoryID, SupplierID)
VALUES 
('Intel Core i9-13900K', 'Procesador de 24 núcleos para rendimiento extremo en gaming y creación de contenido.', 599.99, 450.00, 50, 8, 1),
('NVIDIA GeForce RTX 4090', 'Tarjeta gráfica de alto rendimiento para gaming 4K y ray tracing.', 1599.99, 1200.00, 20, 9, 2),
('Corsair Vengeance RGB 32GB', 'Kit de memoria RAM DDR5 de 32GB con iluminación RGB personalizable.', 149.99, 105.00, 100, 10, 3),
('Razer DeathAdder V3 Pro', 'Mouse inalámbrico ultraligero para esports con sensor óptico de 30K DPI.', 149.99, 90.00, 75, 5, 4),
('ASUS ROG Strix B650E-F', 'Placa base ATX con soporte para procesadores AMD Ryzen y conectividad PCIe 5.0.', 249.99, 180.00, 30, 7, 5),
('Acer Nitro XV272U RV', 'Monitor de 27 pulgadas, QHD, 170Hz para una experiencia de juego fluida.', 299.99, 210.00, 40, 3, 1),
('Seagate FireCuda 530 1TB', 'Unidad SSD M.2 PCIe Gen4 con velocidades de hasta 7300 MB/s.', 119.99, 85.00, 90, 11, 2),
('Logitech G Pro X Keyboard', 'Teclado mecánico TKL compacto con switches intercambiables y retroiluminación RGB.', 129.99, 88.00, 60, 4, 3),
('be quiet! Pure Base 500DX', 'Gabinete de PC con diseño optimizado para flujo de aire y panel de vidrio templado.', 109.99, 75.00, 55, 13, 5),
('Cooler Master Hyper 212', 'Disipador de CPU con 4 heatpipes de contacto directo para una refrigeración eficiente.', 49.99, 32.00, 120, 8, 4);
GO

-- Visualizamos los registros ingresados a la tabla de productos.
SELECT * FROM Products;
GO

-- Agregaremos 4 productos mas, dos de los cuales los marcaremos como inactivos y los otros dos
-- como inactivos y que ademas se han borrado, el borrado es un soft-delete o borrado logico.
-- Insertar 4 productos adicionales
INSERT INTO Products (ProductName, Description, Price, Cost, StockQuantity, CategoryID, SupplierID)
VALUES 
('Logitech G Pro X Headset', 'Auriculares gaming con sonido envolvente 7.1 y micrófono Blue VO!CE.', 129.99, 85.00, 35, 6, 3),
('EVGA Supernova 750W G6', 'Fuente de alimentación modular de 750W con certificación 80 Plus Gold.', 119.99, 78.00, 50, 12, 2),
('AMD Ryzen 9 7950X', 'Procesador de 16 núcleos de alto rendimiento con arquitectura Zen 4.', 699.99, 520.00, 15, 8, 2),
('Cooler Master MasterCase H500', 'Gabinete de PC con dos ventiladores frontales RGB de 200mm para un flujo de aire óptimo.', 119.99, 80.00, 25, 13, 1);
GO

-- Marcar el producto 'EVGA Supernova 750W G6' como inactivo (IsActive = 0).
UPDATE Products
SET IsActive = 0
WHERE ProductName = 'EVGA Supernova 750W G6';
GO

-- Aplicar borrado lógico al producto 'Cooler Master MasterCase H500' rellenando DeletedDate.
UPDATE Products
SET DeletedDate = GETDATE()
WHERE ProductName = 'Cooler Master MasterCase H500';
GO

-- Creamos la tabla de movimientos.
-- Creamos la tabla de movimientos de inventario
CREATE TABLE InventoryMovements (
    MovementID INT IDENTITY(1,1),
    ProductID INT NOT NULL,
    Quantity INT NOT NULL, -- positivo = entrada, negativo = salida
    MovementType NVARCHAR(20) NOT NULL, -- IN, OUT, ADJUST
    Reason NVARCHAR(200) NULL, -- detalle adicional
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_InventoryMovements PRIMARY KEY (MovementID),
    CONSTRAINT FK_InventoryMovements_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CONSTRAINT CK_InventoryMovements_Type CHECK (MovementType IN ('IN', 'OUT', 'ADJUST'))
);
GO

-- Agregamos un campo llamado ReferenceMovementID.
-- Este nos permitira referenciar a un movimiento anterior sea por razones de corregir datos o anular.
-- Esto nos permite llevar una trazabilidad inmutable.
-- Aplicamos el patron llamado self-referencing foreign key.
ALTER TABLE InventoryMovements
ADD ReferenceMovementID INT NULL
    CONSTRAINT FK_InventoryMovements_Self
    FOREIGN KEY (ReferenceMovementID) REFERENCES InventoryMovements(MovementID);

-- Visualizamos la estructura de la tabla.
EXEC sp_help 'InventoryMovements';

--Visualizamos los datos de la tabla sin realizar uniones aun.
SELECT * FROM InventoryMovements;

-- Eliminamos el stock para seguir de la forma correcta.
-- Agregar stock a los productos o debitarles a traves de movimientos.
UPDATE Products
SET StockQuantity = 0,
    LastModifiedDate = GETDATE();

-- Consultamos la tabla de Products.
SELECT * FROM Products;





















