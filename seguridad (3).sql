/*
	Nombres: Aguilar Maya Daniel
	        González Sotelo Elias Eduardo
			Velázquez Martínez Karla Andrea

	Asignatura: Bases de datos Grupo: 02

	Profesora: Martha López Pelcastre

*/



-- Crear el usuario de solo lectura
CREATE LOGIN usuarioConsulta WITH PASSWORD = '1234zaq*';
CREATE USER usuarioConsulta FOR LOGIN usuarioConsulta;
GO

-- Otorgar permisos de solo lectura
ALTER ROLE db_datareader ADD MEMBER usuarioConsulta;
GO
-- Crear el usuario gestor
CREATE LOGIN usuarioGestor WITH PASSWORD = '1234zaq*';
CREATE USER usuarioGestor FOR LOGIN usuarioGestor;
GO

-- Otorgar permisos para agregar y actualizar información
GRANT INSERT, UPDATE TO usuarioGestor;
GO
-- Crear el usuario administrador
CREATE LOGIN usuarioAdministrador WITH PASSWORD = '1234zaq*';
CREATE USER usuarioAdministrador FOR LOGIN usuarioAdministrador;
GO

-- Otorgar permisos de administrador
ALTER ROLE db_owner ADD MEMBER usuarioAdministrador;
GO

----------------------------------------------------------------------
----------- PROCEDIMIENTOS ALMACENADOS PARA CREAR USUARIOS -----------
----------------------------------------------------------------------



----------------------------------------------------------------------
-------------------PROCEDIMIENTO PARA SOLO LECTURA -------------------
----------------------------------------------------------------------

CREATE PROCEDURE CrearUsuarioConsulta 
    @nombreUsuario NVARCHAR(50), 
    @contrasena NVARCHAR(50)
AS
BEGIN
    -- Declaramos la consulta SQL como una variable NVARCHAR para poder utilizar parámetros dinámicos
    DECLARE @SQL NVARCHAR(500);

    -- Creamos el inicio de sesión con los detalles proporcionados
    SET @SQL = N'CREATE LOGIN ' + QUOTENAME(@nombreUsuario) + ' WITH PASSWORD = N' + QUOTENAME(@contrasena, '''') + ';'
    EXEC sp_executesql @SQL;
    
    -- Creamos el usuario para el inicio de sesión creado
    SET @SQL = N'CREATE USER ' + QUOTENAME(@nombreUsuario) + ' FOR LOGIN ' + QUOTENAME(@nombreUsuario) + ';'
    EXEC sp_executesql @SQL;
    
    -- Otorgamos los permisos de solo lectura
    SET @SQL = N'ALTER ROLE db_datareader ADD MEMBER ' + QUOTENAME(@nombreUsuario) + ';'
    EXEC sp_executesql @SQL;
    
    PRINT 'Usuario ' + @nombreUsuario + ' creado exitosamente.'
END;
GO
EXEC CrearUsuarioConsulta @nombreUsuario = 'MiNuevoUsuario', @contrasena = 'MiNuevaContrasena';

----------------------------------------------------------------------
------------------ PROCEDIMIENTO PARA USUARIO GESTOR -----------------
----------------------------------------------------------------------


CREATE PROCEDURE CrearUsuarioGestor
    @nombreUsuario NVARCHAR(50), 
    @contrasena NVARCHAR(50)
AS
BEGIN
    -- Declaramos la consulta SQL como una variable NVARCHAR para poder utilizar parámetros dinámicos
    DECLARE @SQL NVARCHAR(500);

    -- Creamos el inicio de sesión con los detalles proporcionados
    SET @SQL = N'CREATE LOGIN ' + QUOTENAME(@nombreUsuario) + ' WITH PASSWORD = N' + QUOTENAME(@contrasena, '''') + ';'
    EXEC sp_executesql @SQL;

    -- Creamos el usuario para el inicio de sesión creado
    SET @SQL = N'CREATE USER ' + QUOTENAME(@nombreUsuario) + ' FOR LOGIN ' + QUOTENAME(@nombreUsuario) + ';'
    EXEC sp_executesql @SQL;

    -- Otorgamos los permisos para agregar y actualizar información
    SET @SQL = N'GRANT INSERT, UPDATE TO ' + QUOTENAME(@nombreUsuario) + ';'
    EXEC sp_executesql @SQL;

    PRINT 'Usuario ' + @nombreUsuario + ' creado exitosamente.'
END;
GO

EXEC CrearUsuarioGestor @nombreUsuario = 'MiNuevoGestor', @contrasena = 'MiNuevaContrasena';

----------------------------------------------------------------------
----------- PROCEDIMIENTO PARA USUARIO ADMINISTRADOR -----------------
----------------------------------------------------------------------
CREATE PROCEDURE CrearUsuarioAdministrador 
    @nombreUsuario NVARCHAR(50), 
    @contrasena NVARCHAR(50)
AS
BEGIN
    -- Declaramos la consulta SQL como una variable NVARCHAR para poder utilizar parámetros dinámicos
    DECLARE @SQL NVARCHAR(500);

    -- Creamos el inicio de sesión con los detalles proporcionados
    SET @SQL = N'CREATE LOGIN ' + QUOTENAME(@nombreUsuario) + ' WITH PASSWORD = N' + QUOTENAME(@contrasena, '''') + ';'
    EXEC sp_executesql @SQL;
    
    -- Creamos el usuario para el inicio de sesión creado
    SET @SQL = N'CREATE USER ' + QUOTENAME(@nombreUsuario) + ' FOR LOGIN ' + QUOTENAME(@nombreUsuario) + ';'
    EXEC sp_executesql @SQL;
    
    -- Otorgamos los permisos de administrador
    SET @SQL = N'ALTER ROLE db_owner ADD MEMBER ' + QUOTENAME(@nombreUsuario) + ';'
    EXEC sp_executesql @SQL;
    
    PRINT 'Usuario ' + @nombreUsuario + ' creado exitosamente.'
END;
GO

EXEC CrearUsuarioAdministrador @nombreUsuario = 'MiNuevoAdministrador', @contrasena = 'MiNuevaContrasena';
