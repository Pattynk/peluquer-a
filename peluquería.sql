--Crear la base de datos y usarla
CREATE DATABASE peluqueria;
    USE peluqueria;

--Crear la tabla clientes
CREATE TABLE Cliente (
  Id_Cliente INT AUTO_INCREMENT PRIMARY KEY,
  Nombre VARCHAR(50) NOT NULL,
  Apellido VARCHAR(50) NOT NULL,
  Telefono VARCHAR(20),
  Email VARCHAR(100)
);

--Crear la tabla empleados
CREATE TABLE Empleado (
  Id_Empleado INT AUTO_INCREMENT PRIMARY KEY,
  Nombre VARCHAR(50) NOT NULL,
  Apellido VARCHAR(50) NOT NULL,
  Especialidad VARCHAR(100)
);

--Crear la tabla servicios
CREATE TABLE Servicio (
  Id_Servicio INT AUTO_INCREMENT PRIMARY KEY,
  Nombre VARCHAR(100) NOT NULL,
  Precio DECIMAL(10, 2) NOT NULL
);

--Crear la tabla citas
CREATE TABLE Cita (
  Id_Cita INT AUTO_INCREMENT PRIMARY KEY,
  Fecha DATE NOT NULL,
  Hora TIME NOT NULL,
  Id_Cliente INT,
  Id_Empleado INT,
  Id_Servicio INT,
  FOREIGN KEY (Id_Cliente) REFERENCES Cliente(Id_Cliente),
  FOREIGN KEY (Id_Empleado) REFERENCES Empleado(Id_Empleado),
  FOREIGN KEY (Id_Servicio) REFERENCES Servicio(Id_Servicio)
);

    -- Relación: Cliente ↔ Cita (1 cliente puede tener muchas citas)
    ALTER TABLE Cita
    ADD CONSTRAINT fk_cita_cliente
    FOREIGN KEY (Id_Cliente) REFERENCES Cliente(Id_Cliente);

    -- Relación: Empleado ↔ Cita (1 empleado puede atender muchas citas)
    ALTER TABLE Cita
    ADD CONSTRAINT fk_cita_empleado
    FOREIGN KEY (Id_Empleado) REFERENCES Empleado(Id_Empleado);

    -- Relación: Servicio ↔ Cita (1 servicio puede ser parte de muchas citas)
    ALTER TABLE Cita
    ADD CONSTRAINT fk_cita_servicio
    FOREIGN KEY (Id_Servicio) REFERENCES Servicio(Id_Servicio);

--Insertar 10 clientes aleatorios
INSERT INTO Cliente (Nombre, Apellido, Telefono, Email) VALUES 
('Juan', 'Pérez', '555-1234', 'juan.perez@example.com'),
('María', 'López', '555-5678', 'maria.lopez@example.com'),
('Carlos', 'Gómez', '555-8765', 'carlos.gomez@example.com'),
('Laura', 'Díaz', '555-4321', 'laura.diaz@example.com'),
('Luis', 'Martínez', '555-9988', 'luis.martinez@example.com'),
('Ana', 'Torres', '555-1111', 'ana.torres@example.com'),
('Jorge', 'Ramírez', '555-2222', 'jorge.ramirez@example.com'),
('Carmen', 'Vega', '555-3333', 'carmen.vega@example.com'),
('Roberto', 'Suárez', '555-4444', 'roberto.suarez@example.com'),
('Lucía', 'Mendoza', '555-5555', 'lucia.mendoza@example.com');

--Insertar 10 empleados aleatorios
INSERT INTO Empleado (Nombre, Apellido, Especialidad) VALUES 
('Ana', 'García', 'Corte de Cabello'),
('Pedro', 'Luna', 'Tinte'),
('Lucía', 'Morales', 'Peinados'),
('Diego', 'Fernández', 'Manicura'),
('Sofía', 'Reyes', 'Maquillaje'),
('Carlos', 'Núñez', 'Depilación'),
('Elena', 'Silva', 'Tratamientos Faciales'),
('Javier', 'Cruz', 'Corte de Caballero'),
('Verónica', 'Ortega', 'Alisado'),
('Raúl', 'Ibáñez', 'Extensiones');

--Insertar 10 servicios aleatorios
INSERT INTO Servicio (Nombre, Precio) VALUES 
('Corte de Cabello', 15.00),
('Tinte', 30.00),
('Peinados', 25.00),
('Manicura', 20.00),
('Maquillaje', 35.00),
('Depilación', 18.00),
('Tratamiento Facial', 40.00),
('Corte de Caballero', 12.00),
('Alisado', 50.00),
('Extensiones', 60.00);

--Insertar 10 citas aleatorias
INSERT INTO Cita (Fecha, Hora, Id_Cliente, Id_Empleado, Id_Servicio) VALUES 
('2024-09-10', '10:00:00', 1, 1, 1),
('2024-09-11', '11:30:00', 2, 2, 2),
('2024-09-12', '09:00:00', 3, 3, 3),
('2024-09-13', '14:00:00', 4, 4, 4),
('2024-09-14', '15:30:00', 5, 5, 5),
('2024-09-15', '16:45:00', 6, 6, 6),
('2024-09-16', '12:15:00', 7, 7, 7),
('2024-09-17', '13:00:00', 8, 8, 8),
('2024-09-18', '17:30:00', 9, 9, 9),
('2024-09-19', '18:00:00', 10, 10, 10);


--Mostrar todas las citas
SELECT * FROM Cita;

--Mostrar citas de un cliente en especial
SELECT * FROM Cita
WHERE Id_Cliente = 1;

--Mostrar el número de citas de un cliente
SELECT COUNT(*) AS Total_Citas
FROM Cita
WHERE Id_Cliente = 1;

--Mostrar el costo total de un cliente
SELECT SUM(Servicio.Precio) AS Total_Gastado
FROM Cita
JOIN Servicio ON Cita.Id_Servicio = Servicio.Id_Servicio
WHERE Cita.Id_Cliente = 1;

--Mostrar el nombre de el cliente que tiene más citas
SELECT Cliente.Nombre, Cliente.Apellido, COUNT(Cita.Id_Cita) AS Numero_Citas
FROM Cita
JOIN Cliente ON Cita.Id_Cliente = Cliente.Id_Cliente
GROUP BY Cita.Id_Cliente
ORDER BY Numero_Citas DESC
LIMIT 1;


--Consulta que obtiene el nombre y apellido del cliente que tiene una cita exactamente el 2024-09-10
SELECT Nombre, Apellido 
FROM Cliente 
WHERE Id_Cliente = (
  SELECT Id_Cliente 
  FROM Cita 
  WHERE Fecha = '2024-09-10'
);


--Consulta que muestra el nombre y apellido de todos los empleados que atendieron citas el día 2024-09-10
SELECT Nombre, Apellido 
FROM Empleado 
WHERE Id_Empleado IN (
  SELECT Id_Empleado 
  FROM Cita 
  WHERE Fecha = '2024-09-10'
);

--Consulta que muestra el nombre y precio de los servicios que ha solicitado el cliente con Id_Cliente = 1
SELECT Nombre, Precio 
FROM Servicio 
WHERE Id_Servicio IN (
  SELECT Id_Servicio 
  FROM Cita 
  WHERE Id_Cliente = 1
);

--Consulta que muestra el nombre del cliente que tuvo una cita más reciente
SELECT Nombre, Apellido 
FROM Cliente 
WHERE Id_Cliente = (
  SELECT Id_Cliente 
  FROM Cita 
  ORDER BY Fecha DESC, Hora DESC 
  LIMIT 1
);

--Consulta que muestra todos los empleados que han brindado el servicio más caro
SELECT Nombre, Apellido 
FROM Empleado 
WHERE Id_Empleado IN (
  SELECT Id_Empleado 
  FROM Cita 
  WHERE Id_Servicio = (
    SELECT Id_Servicio 
    FROM Servicio 
    ORDER BY Precio DESC 
    LIMIT 1
  )
);

--Consulta que muestra el nombre del servicio más solicitado
SELECT Nombre 
FROM Servicio 
WHERE Id_Servicio = (
  SELECT Id_Servicio 
  FROM Cita 
  GROUP BY Id_Servicio 
  ORDER BY COUNT(*) DESC 
  LIMIT 1
);

--Actualizar el teléfono de un cliente
UPDATE Cliente 
SET Telefono = '555-9876' 
WHERE Id_Cliente = 1;

--Actualizar el precio de un servicio
UPDATE Servicio 
SET Precio = 20.00 
WHERE Id_Servicio = 1;


--Aumentar el precio del servicio más barato un 10%
UPDATE Servicio 
SET Precio = Precio * 1.10 
WHERE Id_Servicio = (
  SELECT Id_Servicio 
  FROM (
    SELECT Id_Servicio 
    FROM Servicio 
    ORDER BY Precio ASC 
    LIMIT 1
  ) AS subconsulta
);


--Cambiar el email del cliente con más citas
UPDATE Cliente 
SET Email = 'vipcliente@example.com' 
WHERE Id_Cliente = (
  SELECT Id_Cliente 
  FROM (
    SELECT Id_Cliente 
    FROM Cita 
    GROUP BY Id_Cliente 
    ORDER BY COUNT(*) DESC 
    LIMIT 1
  ) AS subconsulta
);


--Cambiar la especialidad del empleado que dio el servicio más caro
UPDATE Empleado 
SET Especialidad = 'Especialista Premium' 
WHERE Id_Empleado = (
  SELECT Id_Empleado 
  FROM (
    SELECT Id_Empleado 
    FROM Cita 
    WHERE Id_Servicio = (
      SELECT Id_Servicio 
      FROM Servicio 
      ORDER BY Precio DESC 
      LIMIT 1
    ) 
    LIMIT 1
  ) AS subconsulta
);

--Mostrar todas las tablas
SHOW TABLES;

--Vista de datos
CREATE VIEW VistaCitas AS
SELECT 
    Cita.Id_Cita, 
    Cita.Fecha, 
    Cita.Hora, 
    Cliente.Nombre AS NombreCliente,
    Cliente.Apellido AS ApellidoCliente,
    Empleado.Nombre AS NombreEmpleado, 
    Empleado.Apellido AS ApellidoEmpleado,
    Servicio.Nombre AS NombreServicio, 
    Servicio.Precio
FROM Cita
JOIN Cliente ON Cita.Id_Cliente = Cliente.Id_Cliente
JOIN Empleado ON Cita.Id_Empleado = Empleado.Id_Empleado
JOIN Servicio ON Cita.Id_Servicio = Servicio.Id_Servicio;

--Consulta de la vista creada
SELECT * FROM VistaCitas;



--Creación de la vista clientes citas
CREATE VIEW VistaClientesCitas AS
SELECT 
    Cliente.Id_Cliente, 
    Cliente.Nombre, 
    Cliente.Apellido, 
    Cita.Id_Cita,
    Cita.Fecha, 
    Cita.Hora
FROM Cliente
JOIN Cita ON Cliente.Id_Cliente = Cita.Id_Cliente;

--Consulta de la vista creada
SELECT * FROM VistaClientesCitas;



--Crear la vista Empleados Servicios
CREATE VIEW VistaEmpleadosServicios AS
SELECT 
    Empleado.ID_Empleado, 
    Empleado.Nombre, 
    Empleado.Apellido, 
    Servicio.Nombre AS NombreServicio, 
    Servicio.Precio
FROM Empleado
JOIN Cita ON Empleado.ID_Empleado = Cita.ID_Empleado
JOIN Servicio ON Cita.ID_Servicio = Servicio.ID_Servicio;

--Consulta de la vista creada
SELECT * FROM VistaEmpleadosServicios;



--Manera en la que se consultan las vistas en las bases de datos
SHOW FULL TABLES IN peluquería WHERE TABLE_TYPE = 'VIEW';


--Manera en la que puede actualizarse una vista en la base de datos
DROP VIEW IF EXISTS nombre_de_la_vista;
CREATE VIEW nombre_de_la_vista AS
-- nueva definición aquí


--Manera en la que se puede borrar una vista en la base de datos
DROP VIEW IF EXISTS VistaEmpleadosServicios;


--Manera en la que puede actualizarse una vista existente
--Eliminar la versión anterior
DROP VIEW IF EXISTS VistaClientesCitas;
--Crear una nueva versión más informada
CREATE VIEW VistaClientesCitas AS
SELECT 
    Cliente.Id_Cliente, 
    Cliente.Nombre, 
    Cliente.Apellido, 
    Cita.Id_Cita,
    Cita.Fecha, 
    Cita.Hora,
    Servicio.Nombre AS NombreServicio
FROM Cliente
JOIN Cita ON Cliente.Id_Cliente = Cita.Id_Cliente
JOIN Servicio ON Cita.Id_Servicio = Servicio.Id_Servicio;
--Consultar la vista actualizada
SELECT * FROM VistaClientesCitas;







