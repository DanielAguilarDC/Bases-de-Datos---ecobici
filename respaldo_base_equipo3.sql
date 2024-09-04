--1. Creación de base de datos donde se hará el respaldo
--● Crear base de datos:


--● Crear tabla
USE[ecobici]
GO

--2. Respaldo y recuperación total
--● Respaldo total

Use [master]
GO

BACKUP DATABASE [ecobici]
  TO DISK = 'C:\RESPALDOFULL\ecobici_full.bak'
  with INIT;
  go
GO

--Borramos la base de datos
Use [master]
GO

DROP  DATABASE [ecobici];

--● Recuperación total

RESTORE DATABASE  ecobici
   FROM DISK = 'C:\RESPALDOFULL\ecobici_full.bak'
  WITH REPLACE;
  GO
  