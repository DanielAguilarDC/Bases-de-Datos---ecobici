/*

	ARCHIVO valida_Triggers.SQL

*/


/*
	---------------------------------------------------TRIGGER  1---------------------------------------------------------

	Autor: Karla Vel�zquez

	Fecha de creaci�n: 11 / 06 / 2023

	Descripcion: Trigger para validar la integridad de la jerarqu�a de tipos en la tabla de agente.
	Verifica que no exista en la tabla de Mantenimiento ni Administrador. Ademas, valida que tampoco
	exista en la tabla de empleado con el tipo 'R' (recursos humanos)
	
	----------------------------------------------------------------------------------------------------------------------

*/


CREATE OR ALTER TRIGGER empleados.tr_usuarios
ON empleados.agente
INSTEAD OF INSERT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM empleados.mantenimiento WHERE id_empleado = (SELECT id_empleado FROM inserted))
		BEGIN
			PRINT 'No es posible realizar Insersi�n, existe en la tabla de mantenimiento'
			RETURN
		END
	IF EXISTS (SELECT 1 FROM empleados.administrador WHERE id_empleado = (SELECT id_empleado FROM inserted))
	    BEGIN
			PRINT 'No es posible realizar Insersi�n, existe en la tabla de administrador'
			RETURN
		END
	IF EXISTS (SELECT 1 FROM empleados.empleado e inner join inserted i on e.id_empleado = i.id_empleado where e.tipo_empleado = 'R')
		BEGIN
			PRINT 'No es posible realizar la insersi�n, es un empleado de recursos humanos'
			RETURN
		END
	IF EXISTS (SELECT 1 FROM empleados.empleado e inner join inserted i on e.id_empleado = i.id_empleado where e.tipo_empleado ='G')
		BEGIN
			INSERT INTO empleados.agente (id_empleado)
			SELECT id_empleado FROM inserted
		END
	ELSE
		PRINT 'NO EXISTE EL ID PREVIAMENTE EN EMPLEADO o EXISTE PERO NO TIENE EL TIPO AGENTE (G)'

END
--- FIN TRIGGER





SELECT * FROM empleados.empleado

--Probando trigger con alguien de mantenimiento
INSERT empleados.agente (id_empleado) VALUES (1)

--Probando trigger con alguien de recursos humanos
INSERT empleados.agente (id_empleado) VALUES (21)

--Probando trigger con alguien de administracion
INSERT empleados.agente (id_empleado) VALUES (13)

--Probando trigger 
--Se tiene que agregar primero un empleado ya que si se agrega en agente directamnete
--saltar� el error de la llave for�nea
dbcc checkident('empleados.empleado',reseed,21) --ejecutar esto despues de haber ejecutado el begin - rollback para 
									--restablecer identity en su valor original

BEGIN TRAN

INSERT INTO empleados.empleado
(id_supervisor, tipo_empleado, genero, nombre, paterno, materno, calle, colonia, alcaldia, num_Ext, num_int, telefono, rfc, sueldo,estado_civil, edad)
VALUES (21, 'G', 'H', 'Jose','Alcaraz', 'Gonzales', 'Calle jos�', 'el rosario', 'coyoacan',21,100,'5610295444','AUMS4000DFGG', 45000,'soltero', 25)

INSERT into empleados.agente(id_empleado) VALUES (22)

SELECT 'EMPLEADO AGREGADO'
SELECT TOP 1 * FROM empleados.empleado order by id_empleado desc
SELECT 'AGENTE AGREGADO'
SELECT TOP 1 *  FROM empleados.agente order by id_empleado desc

ROLLBACK TRAN


/*
	---------------------------------------------------TRIGGER  2---------------------------------------------------------

	Autor: Daniel Aguilar

	Fecha de creaci�n: 12 / 06 / 2023

	Descripcion: Trigger para validar que al insertar un viaje,haya coherencia en la informaci�n ingresada. Es decir, para
	un viaje dado, verifica que al ingresar el id de la bicicleta cuya estaci�n de partida es X y la estaci�n de llegada 
	es Y, se revise si dicha bicicleta a insertar efectivamente su estaci�n en la que est� es la estaci�n X. En caso de
	no estarlo no se permite la inserci�n. Por el contrario, si la informaci�n del viaje se ingresa adecuadamente, entonces
	en la tabla de bicicleta se cambia el id de la estaci�n en la que se encuentra por la estaci�n de llegada Y de dicho
	viaje.	

	----------------------------------------------------------------------------------------------------------------------

*/
GO
CREATE OR ALTER TRIGGER usuarios.tr_InsertarViaje
ON usuarios.viaje
INSTEAD OF INSERT
AS
BEGIN

	IF EXISTS(SELECT 1  FROM estacion.bicicleta b inner join inserted i on b.id_bicicleta = i.id_bicicleta where b.id_estacion = i.estacionPartida)
		BEGIN
			PRINT 'La bicicleta coincide con la estaci�n de partida. Se ha efectuado el insert exitosamente'
			
			--ACTUALIZAMOS LA ESTACION EN DONDE EST� LA BICICLETA
			UPDATE estacion.bicicleta 
			SET id_estacion = (SELECT estacionLlegada FROM inserted)
			WHERE id_bicicleta = (SELECT id_bicicleta FROM inserted)
			
			--SE INSERTA EL VIAJE EXITOSAMENTE
			INSERT INTO viaje (id_bicicleta, id_usuario, hora_fin, hora_ini, hora_llegada, fecha, ruta, estacionPartida, estacionLlegada)
			SELECT id_bicicleta, id_usuario, hora_fin, hora_ini, hora_llegada, fecha, ruta, estacionPartida, estacionLlegada
			FROM inserted
		END
	ELSE
		BEGIN
			--NO SE REALIZA LA INSERCI�N DEL VIAJE
			PRINT 'La bici que trataste de insertar no pertenece a la estaci�n de partida'
			RETURN
		END


END
--- FIN TRIGGER







--PRUEBA CON INFORMACI�N �RRONEA
BEGIN TRAN
	--Probamos con una bicicleta cuya estaci�n de partida no concuerda con el lugar en donde se encuentra la bici
	-- en ese momento

	--La bicicleta 10 est� en la estaci�n 2
	SELECT 'BICICLETA DE LA ESTACI�N 2 (ADVERTENCIA EN MESSAGES)'
	SELECT  id_bicicleta, id_estacion FROM estacion.bicicleta WHERE id_bicicleta = 10

	--Manda mensaje ya que la bici 10 no est� en la estaci�n 3
	INSERT INTO usuarios.viaje (id_bicicleta, id_usuario, hora_fin, hora_ini, hora_llegada, fecha, ruta, estacionPartida, estacionLlegada)
	VALUES (10, 5, '15:11:00', '12:10:05', '15:30:00', '2022-11-01', 'Ruta 5 - Bosque Rojo - Estacion' , 3, 5)
ROLLBACK TRAN


--PRUEBA CON INFORMACI�N CORRECTA
BEGIN TRAN
	SELECT 'ANTES'
	SELECT  id_bicicleta, id_estacion FROM estacion.bicicleta WHERE id_bicicleta = 10

	--Insert correcto
	SELECT 'DESPUES DE LA ACTUALIZACION CORRECTA'

	INSERT INTO usuarios.viaje (id_bicicleta, id_usuario, hora_fin, hora_ini, hora_llegada, fecha, ruta, estacionPartida, estacionLlegada)
	VALUES (10, 5, '15:11:00', '12:10:05', '15:30:00', '2022-11-01', 'Ruta 5 - Bosque Rojo - Estacion' , 2, 5)
		
	SELECT  id_bicicleta, id_estacion FROM estacion.bicicleta WHERE id_bicicleta = 10

	SELECT 'VIAJE INSERTADO' 
	SELECT TOP 1 * FROM usuarios.viaje ORDER BY id_viaje DESC

ROLLBACK TRAN

DBCC CHECKIDENT('usuarios.viaje',reseed, 43)
GO
--Deshabilitar un trigger:
DISABLE TRIGGER tr_InsertarViaje on usuarios.viaje

GO
--Habilitar un trigger:
ENABLE TRIGGER tr_InsertarViaje on usuarios.viaje
