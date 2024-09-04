/*-------------------------------------------------------------------------------------------------------------------------------
	
	SCRIPT INFORMES.SQL
	TEMAS DE CONTABILIDAD Y ADMINISTRACION
	
---------------------------------------------------------------------------------------------------------------------------------*/




/*
	---------------------------------------------------ESTAD�STICA  1---------------------------------------------------------

	Autor: Elias Eduardo Gonz�lez

	Fecha de creaci�n: 10 / 06 / 2023

	Descripcion: Estad�sticas de los da�os en las bicicletas con mayor frecuencia. Top 5 de los
	accidentes m�s frecuentes (descripci�n del da�o, cantidad)
	
	----------------------------------------------------------------------------------------------------------------------

*/

--Estad�sticas de los da�os en las bicicletas con mayor frecuencia. Top 5 de los
--accidentes m�s frecuentes (descripci�n del da�o, cantidad)
SELECT TOP 5 i.idTipoInc as 'ID_Tipo_Accidente',ti.tipo as 'Tipo de accidente',ti.descripcion as 'Descripci�n del da�o', count(*) AS  'N�mero de incidentes'
FROM usuarios.incidente i INNER JOIN usuarios.tipo_incidente ti ON
i.idTipoInc = ti.idTipoInc
GROUP BY i.idTipoInc, ti.tipo, ti.descripcion
ORDER BY 'N�mero de incidentes' DESC


/*
	---------------------------------------------------ESTAD�STICA  2 ---------------------------------------------------------

	Autor: Daniel Aguilar

	Fecha de creaci�n: 11 / 06 / 2023

	Descripcion: Estaciones con m�s reportes de accidentes con mayor frecuencia. Listado e estaciones con el n�mero
	de accidentes en un periodo de tiempo (fecha inicio � fecha fin) ordenados de mayor a menor
	
	----------------------------------------------------------------------------------------------------------------------

*/

-- Metodolog�a: Partimos del siguiente supuesto:
--En un viaje de la estaci�n A a la estaci�n B, si llega a haber un accidente
--Se le atribuir� a la estaci�n de llegada, es decir a la estaci�n B
GO
CREATE OR ALTER PROCEDURE usuarios.pa_reporteIncidentes
	--Variables de entrada (fecha inicio y fecha fin)
	@fecha1 date,
	@fecha2 date
AS
BEGIN
	--Declaraci�n de tabla artificial de salida
	CREATE TABLE #EstacionIncidentes(
		id_estacion int,
		nombre varchar(20),
		incidentes int,
		fechas varchar(200)
	)

	--DECLARACION DE VARIABLES DEL CURSOR INTERNO (ITERAR SOBRE ACCIDENTES PARA CADA ESTACI�N DADA)
	DECLARE @fechaAcc varchar(12)
	DECLARE @estacionAcc int
	
	--VARIABLE AUXILIAR PARA EL N�MERO DE INCIDENTES Y JUNTAR FECHAS EN UN SOLO REGISTRO
	DECLARE @numIncidentes int 
	DECLARE @fechas varchar(200)

	--DECLARACION DE VARIABLES DEL CURSOR EXTERNO (ITERAR SOBRE ESTACIONES)
	DECLARE @id_estacion int
	DECLARE @nombre varchar(20)
	
	--DECLARACI�N CURSOR EXTERNO
	DECLARE cursor_Estacion CURSOR
	FOR 
	SELECT id_estacion, nombre
	FROM estacion.estacion

	--APERTURA CURSOR EXTERNO
	OPEN cursor_Estacion

	--LECTURA PRIMERA FILA EXTERNA
	FETCH cursor_Estacion INTO @id_estacion, @nombre

	WHILE (@@FETCH_STATUS = 0)
		BEGIN

			DECLARE cursor_Incidente CURSOR
			FOR
			SELECT v.estacionLlegada,v.fecha
			FROM estacion.estacion e 
			INNER JOIN usuarios.viaje v  ON e.id_Estacion = v.estacionLlegada
			INNER JOIN usuarios.incidente i ON v.id_viaje = i.id_viaje
			WHERE v.fecha < @fecha2 and v.fecha > @fecha1
				  and v.estacionLlegada =  @id_estacion

			OPEN cursor_Incidente

			SET @numIncidentes = 0 
			SET @fechas = ''

			FETCH cursor_Incidente INTO @estacionAcc, @fechaAcc
			WHILE (@@FETCH_STATUS = 0)
				BEGIN
						SET @fechas = @fechas + @fechaAcc + ' || '
						SET @numIncidentes = @numIncidentes + 1
						FETCH cursor_Incidente INTO @estacionAcc, @fechaAcc
				END
		
			INSERT INTO #EstacionIncidentes (id_estacion, nombre, incidentes, fechas) VALUES
			(@id_estacion, @nombre, @numIncidentes, @fechas)

			CLOSE cursor_Incidente
			DEALLOCATE cursor_Incidente
	

		FETCH cursor_Estacion INTO @id_estacion, @nombre
	END

	CLOSE cursor_Estacion
	DEALLOCATE cursor_Estacion

	SELECT @fecha1 AS FechaInicial, @fecha2 AS FechaFinal

	SELECT * FROM #EstacionIncidentes
	ORDER BY incidentes DESC

	DROP TABLE #EstacionIncidentes


END
GO

EXECUTE usuarios.pa_reporteIncidentes '2022-02-22','2022-10-30'


/*
	---------------------------------------------------ESTAD�STICA  3---------------------------------------------------------

	Autor: Karla Vel�zquez

	Fecha de creaci�n: 11 / 06 / 2023

	Descripcion:  Total de accidentes en un rango de fechas, listados de mayor a menor
	
	----------------------------------------------------------------------------------------------------------------------

*/

SELECT CASE		WHEN v.fecha >= '2022-01-01' AND v.fecha < '2022-04-01' THEN 'Enero-Marzo'		WHEN v.fecha >= '2022-04-01' AND v.fecha < '2022-07-01' THEN 'Abril-Junio'		WHEN v.fecha >= '2022-07-01' AND v.fecha <= '2022-10-01' THEN 'Julio-Septiembre'		WHEN v.fecha >= '2022-10-01' AND v.fecha <= '2022-12-31' THEN 'Octubre-Diciembre'	END  AS Rango_Fechas, COUNT(*) as Numero_IncidentesFROM usuarios.viaje v INNER JOIN usuarios.incidente i ON v.id_viaje = i.id_viajeGROUP BY  	CASE		WHEN v.fecha >= '2022-01-01' AND v.fecha < '2022-04-01' THEN 'Enero-Marzo'		WHEN v.fecha >= '2022-04-01' AND v.fecha < '2022-07-01' THEN 'Abril-Junio'		WHEN v.fecha >= '2022-07-01' AND v.fecha <= '2022-10-01' THEN 'Julio-Septiembre'		WHEN v.fecha >= '2022-10-01' AND v.fecha <= '2022-12-31' THEN 'Octubre-Diciembre'	ENDORDER BY Numero_Incidentes

/*
	---------------------------------------------------ESTAD�STICA  4 ---------------------------------------------------------

	Autor: Elias Eduardo Gonz�lez

	Fecha de creaci�n: 11 / 06 / 2023

	Descripcion:  Total de usuarios por rangos de fechas y rangos de edades (10 a 215 a�os, 15-20 a�os, 20 a 30 a�os,
	m�s de 30 a�os)
	
	----------------------------------------------------------------------------------------------------------------------

*/
-- No tenemos usuarios coon edad de 10 a 15 a�os, por lo que creamos a uno-- De 15 a 20 a�os creamos a 2INSERT INTO usuarios.USUARIO (app_saldo, materno, nombre, paterno, fecha_nac, correo, codigo_ine, genero)	VALUES	(0, 'Rodr�guez', 'Agust�n','Arriaga', '2005-04-23','AgustinArr@gmail.com', '134678543', 'H'),	(1, 'Perez', 'Omar','Razo', '2006-06-25','OmarRaz@gmail.com', '954334200', 'H'),	(1, 'Mancera', 'Roc�o','Razo', '2012-02-28','RocioRaz@gmail.com', '998665335', 'M')-- Creaci�n de funci�n para segmentar por edades:GOCREATE or ALTER FUNCTION usuarios.edades()
RETURNS TABLE
AS

RETURN (SELECT CASE
			WHEN edad <=15 THEN '10-15 A�OS'
			WHEN edad <=20 THEN '15-20 A�OS'
			WHEN edad <=30 THEN '20-30 A�OS'
			ELSE '+30 A�OS'
		    	END AS rango_edades, COUNT(*) AS 'Numero de Usuarios'
		FROM usuarios.USUARIO 
		GROUP BY CASE
			WHEN edad <=15 THEN '10-15 A�OS'
			WHEN edad <=20 THEN '15-20 A�OS'
			WHEN edad <=30 THEN '20-30 A�OS'
			ELSE '+30 A�OS'
		    	END
		)
GOSELECT * FROM usuarios.edades()ORDER BY [Numero de Usuarios] DESC/*
	---------------------------------------------------ESTAD�STICA  5 ---------------------------------------------------------

	Autor: Daniel Aguilar

	Fecha de creaci�n: 11 / 06 / 2023

	Descripcion: Inventario de las bicicletas (todos los datos de las bicicletas) por estaciones con el n�mero de viajes,
	por un periodo de tiempo, incluir el nuemro de accidentes si ha tenido
	
	----------------------------------------------------------------------------------------------------------------------

*/
go
CREATE OR ALTER PROCEDURE estacion.InventarioBicicletas 
	@fecha1 date,
	@fecha2 date
AS
BEGIN
	--Variables del cursor de bicicletas
	DECLARE @id_bicicleta int, @color varchar(15), @modelo varchar(12),@nserie varchar(12), @tama�o varchar(12), @estado varchar(10), @id_estacion int
	
	--Salida deseada para el reporte de bicicletas
	CREATE TABLE #inventarioBicicletas (
		id_bicicleta int,
		color varchar(15),
		modelo varchar(12),
		nserie varchar(12),
		tama�o varchar(12), 
		estado varchar(5),
		id_estacion int,
		numViajes int,
		numAccidentes int
	)
	--Variables auxiliares del numero de viajes y n�mero de accidentes
	DECLARE @numViajes int, @numAccidentes int


	--Declarando cursor
	DECLARE cursor_Bicicletas CURSOR
		FOR 
		SELECT b.id_bicicleta, c.color, m.modelo, b.nserie, b.tama�o,
				b.estado, b.id_estacion
		
		FROM estacion.bicicleta b
				INNER JOIN estacion.color c ON c.id_color = b.id_color
				INNER JOIN estacion.modelo m on m.id_modelo = b.id_modelo

	OPEN cursor_Bicicletas
	FETCH  cursor_Bicicletas INTO @id_bicicleta, @color, @modelo, @nserie, @tama�o, @estado, @id_estacion

	WHILE (@@FETCH_STATUS = 0)
		BEGIN
			SET @numViajes = (SELECT count(*) FROM usuarios.viaje WHERE id_bicicleta =@id_bicicleta and fecha >= @fecha1 and fecha <= @fecha2)
			SET @numAccidentes = (SELECT count(*) FROM usuarios.viaje v INNER JOIN usuarios.incidente i ON v.id_viaje = i.id_viaje 
									WHERE v.id_bicicleta = @id_bicicleta and v.fecha >= @fecha1 and v.fecha <= @fecha2)
			INSERT INTO #inventarioBicicletas (id_bicicleta, color, modelo, nserie, tama�o,estado, id_estacion, numViajes,numAccidentes)
			VALUES (@id_bicicleta, @color, @modelo, @nserie, @tama�o, @estado, @id_estacion, @numViajes, @numAccidentes)
		
			FETCH  cursor_Bicicletas INTO @id_bicicleta, @color, @modelo, @nserie, @tama�o, @estado, @id_estacion
		END

		
	CLOSE cursor_Bicicletas
	DEALLOCATE cursor_Bicicletas

	SELECT * FROM #inventarioBicicletas
	ORDER BY id_estacion, id_bicicleta
	DROP TABLE #inventarioBicicletas

END

EXECUTE estacion.InventarioBicicletas '2022-01-04', '2022-12-30'

/*
	---------------------------------------------------ESTAD�STICA  6 ---------------------------------------------------------

	Autor: Karla Vel�zquez

	Fecha de creaci�n: 11 / 06 / 2023

	Descripcion: Listado de usuarios (datos generales), datos de su membres�a y el tiempo en meses que tienen la
	membresia
	
	----------------------------------------------------------------------------------------------------------------------

*/


DELETE FROM usuarios.membresia
DBCC CHECKIDENT ('usuarios.membresia', reseed, 0) -- Ejecutar dos veces
-- NUEVAS INSERCIONES PARA TENER UNA MEMBRES�A POR USUARIO
INSERT INTO usuarios.membresia (fecha, id_tipo, precio_tarjeta, codigoQR, id_pago) VALUES
		('2023-02-14', 1, 50.00, 1245.323, 1),
		('2021-05-11', 3, 50.00, 9876.222, 5),
		('2021-05-11', 2, 50.00, 2453.222, 6),
		('2021-03-01', 1, 50.00, 1435.336, 7),
		('2021-05-12', 2, 50.00, 4321.789, 8),
		('2021-06-15', 3, 50.00, 5678.987, 9),
		('2021-02-25', 1, 50.00, 2468.135, 10),
		('2021-10-26', 2, 50.00, 8795.642, 11),
		('2021-11-27', 3, 50.00, 7531.864, 12),
		('2021-12-12', 1, 50.00, 3198.572, 13)

GO
CREATE OR ALTER PROCEDURE usuarios.InformeMembresias
AS
BEGIN
	SELECT u.nombre + ' ' + u.paterno + ' ' + u.materno as NombreCompleto, u.fecha_nac, u.correo, u.codigo_ine, u.genero, u.edad,
	m.id_membresia, m.fecha 'Fecha Suscripcion', m.beneficio, m.duracionDiasSuscripcion, 
	CASE WHEN m.duracionDiasSuscripcion = 1 THEN '1 d�a, 0 meses'
	     WHEN m.duracionDiasSuscripcion = 30 THEN '1 mes'
		 WHEN m.duracionDiasSuscripcion = 365 THEN '12 meses'
	END as 'Duracion Membresia'
	,
	mp.tipo_pago
	FROM usuarios.membresia m inner join usuarios.metodo_pago mp on m.id_pago = mp.id_pago 
	right join usuarios.usuario u
			on u.id_usuario = mp.id_usuario

END


EXEC usuarios.InformeMembresias

/*
	---------------------------------------------------ESTAD�STICA  7 ---------------------------------------------------------

	Autor: Eduardo Elias Gonz�lez

	Fecha de creaci�n: 11 / 06 / 2023

	Descripcion: Agentes mejor recocidos en un mes especifico, para eso cada que un agente auxilia a un usuario en
	alg�n incidente el usuario llena una peque�a encuesta
	
	----------------------------------------------------------------------------------------------------------------------

*/
INSERT INTO usuarios.incidente (id_empleado, hora, fecha, coordenadas, calle, numero, codigoPostal, alcaldia, colonia, id_viaje, idTipoInc)
VALUES (11, '23:03:00', NULL, '156.665.546', 'Av. San Monk', 60, '50666', 'Madrigal', 'Pedregal Monk', 33,4)

INSERT INTO usuarios.viaje VALUES (30,7, '20:10:00','18:10:00','21:12:00','2022-11-05','Av Rojas - AvE - Estacion ', 4,5)
INSERT INTO usuarios.incidente (id_empleado, hora, fecha, coordenadas, calle, numero, codigoPostal, alcaldia, colonia, id_viaje, idTipoInc)
VALUES (11, '21:03:00', NULL, '156.633.546', 'Av. San Crack', 2, '50336', 'Madrigal', 'Pedregal Crack', 43,2)

GO
CREATE OR ALTER FUNCTION empleados.AgentesReporte(@mes int)
RETURNS TABLE 
AS
RETURN(
SELECT  a.id_empleado,  CONCAT(e.nombre, ' ', e.paterno) as 'Nombre Completo', count(*) 'Numero de incidentes auxiliados'
		FROM usuarios.incidente i inner join empleados.agente a on i.id_empleado = a.id_empleado
			inner join usuarios.viaje v on v.id_viaje = i.id_viaje inner join
			empleados.empleado e on e.id_empleado =  a.id_empleado
		WHERE MONTH (v.fecha) = @mes
		GROUP BY a.id_empleado, CONCAT(e.nombre, ' ', e.paterno)
		--ORDER BY 'Numero de incidentes auxiliados' DESC
);
go

SELECT 'MES DE NOVIEMBRE 11'
SELECT * FROM empleados.AgentesReporte(11)
ORDER BY [Numero de incidentes auxiliados] DESC

/*
	-------------------------------------ESTAD�STICA  8 (otra estad�stica a la mencionada)--------------------------------

	Autor: Daniel Aguilar

	Fecha de creaci�n: 11 / 06 / 2023

	Descripcion: Informe de todos los empleados administradores y las bicicletas que auxiliaron para su mantenimiento
	
	----------------------------------------------------------------------------------------------------------------------

*/
--Variables externas
DECLARE @id_empleado int,@nombre varchar(15), @paterno varchar(20), @materno varchar(20), @especialidad varchar(25)
--Variables internas
DECLARE @id_bicicleta int, @fecha date, @servicio varchar(20), @color varchar(20), @modelo varchar(30)


DECLARE cursorMantenimiento CURSOR
FOR
	SELECT m.id_empleado,nombre, paterno, materno, especialidad 
	FROM empleados.mantenimiento m INNER join empleados.empleado e on m.id_empleado = e.id_empleado

OPEN cursorMantenimiento

FETCH cursorMantenimiento INTO @id_empleado,@nombre, @paterno, @materno, @especialidad
	
WHILE (@@FETCH_STATUS = 0)
	BEGIN
		PRINT 'Emp. Mantenimiento: ' + @nombre + ' ' + @paterno + ' ' + @materno + ' / Especialidad: ' + @especialidad
		PRINT ''

		DECLARE cursorBicicletas CURSOR FOR
			SELECT b.id_bicicleta,bc.fecha, bc.servicio, c.color, m.modelo
			FROM estacion.bicimantenimiento bc INNER JOIN estacion.bicicleta  b on b.id_bicicleta = bc.id_bicicleta
			INNER JOIN estacion.modelo m ON m.id_modelo = b.id_modelo 
			INNER JOIN estacion.color c on c.id_color = b.id_color
			WHERE bc.id_empleado = @id_empleado

		OPEN cursorBicicletas
		FETCH cursorBicicletas INTO @id_bicicleta, @fecha, @servicio, @color, @modelo
		
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
			PRINT 'BICICLETA: ' + CAST(@id_bicicleta as VARCHAR(3)) + ' / Fecha: ' + CAST(@fecha as varchar(15)) + ' / Servicio: ' + @servicio
					+ ' /Color: ' + @color + ' /Modelo: ' + @modelo
			FETCH cursorBicicletas INTO @id_bicicleta, @fecha, @servicio, @color, @modelo

		END
		PRINT '------------------------------------------------------------------------------------------------------------------------'
		CLOSE cursorBicicletas 
		DEALLOCATE cursorBicicletas

		FETCH cursorMantenimiento INTO @id_empleado,@nombre, @paterno, @materno, @especialidad
		
	END

CLOSE cursorMantenimiento
DEALLOCATE cursorMantenimiento

/*
	-------------------------------------ESTAD�STICA  9  ------------------------------------------------------------------

	Autor: Karla Vel�zquez, Elias Eduardo Gonz�lez

	Fecha de creaci�n: 11 / 06 / 2023

	Descripcion: Listado de empleados con su tipo
	
	----------------------------------------------------------------------------------------------------------------------

*/

goCREATE or ALTER PROCEDURE empleados.InformeEmpleadosASBEGIN	DECLARE @contador int	SET @contador = 1		WHILE @contador <= 4	BEGIN		IF @contador = 1 			BEGIN				SELECT 'Recursos Humanos'				SELECT id_empleado, id_supervisor, tipo_empleado, genero, nombre +  ' ' + paterno + ' ' + materno 				 AS 'Nombre_Completo', calle, colonia, alcaldia, num_ext, num_int, telefono, rfc, sueldo, estado_civil,				 edad				FROM empleados.empleado WHERE tipo_empleado = 'R'			END		ELSE IF @contador = 2			 BEGIN				 SELECT 'Mantenimiento'				 SELECT e.id_empleado, id_supervisor, e.tipo_empleado, e.genero, e.nombre +  ' ' + e.paterno + ' ' + e.materno 				 AS 'Nombre_Completo', e.calle, e.colonia, e.alcaldia, e.num_ext, e.num_int, e.telefono, e.rfc, e.sueldo, e.estado_civil,				 e.edad, m.especialidad 				 FROM empleados.empleado e INNER JOIN empleados.mantenimiento m ON e.id_empleado = m.id_empleado			 END			 		ELSE IF @contador = 3			 BEGIN				SELECT 'Agentes'				SELECT e.id_empleado, id_supervisor, e.tipo_empleado, e.genero, e.nombre +  ' ' + e.paterno + ' ' + e.materno 				 AS 'Nombre_Completo', e.calle, e.colonia, e.alcaldia, e.num_ext, e.num_int, e.telefono, e.rfc, e.sueldo, e.estado_civil,				 e.edad				FROM empleados.empleado e INNER JOIN empleados.agente a on e.id_empleado = a.id_empleado			 END		ELSE			BEGIN				SELECT 'Administracion'				SELECT e.id_empleado, id_supervisor, e.tipo_empleado, e.genero, e.nombre +  ' ' + e.paterno + ' ' + e.materno 				 AS 'Nombre_Completo', e.calle, e.colonia, e.alcaldia, e.num_ext, e.num_int, e.telefono, e.rfc, e.sueldo, e.estado_civil,				 e.edad, a.descripcionfuncion, a.tipo_trabajo, a.ubicacion				FROM empleados.empleado e INNER JOIN empleados.administrador a on a.id_empleado = e.id_empleado			END		SET @contador = @contador + 1	ENDENDEXEC empleados.InformeEmpleados/*
	-------------------------------------ESTAD�STICA  10  ------------------------------------------------------------------

	Autor: Daniel Aguilar

	Fecha de creaci�n: 09 / 06 / 2023

	Descripcion: Informe de los recorridos, por estaci�n y/o por periodo de tiempo (fecha inicio y fecha fin); nombre
	del usuario, estaci�n de partida, lugar de llegada, tiempo en minutos del recorrido y costo
	
	----------------------------------------------------------------------------------------------------------------------

*/go
CREATE OR ALTER FUNCTION estacion.recorridoPeriodo(@fecha1 DATE, @fecha2 DATE)-- RECORRIDOS DE ACUERDO A UN PERIODO DE TIEMPO
RETURNS TABLE
AS
	RETURN (
		SELECT u.nombre + ' ' +u.paterno + ' ' + u.materno as NombreUsuario, e.nombre as EstacionPartida,
			   ep.nombre as EstacionLlegada,v.fecha, v.tarifa as Costo, DATEDIFF(MINUTE,hora_ini, v.hora_llegada) AS DuracionMinutos
		FROM usuarios.viaje v inner join usuarios.USUARIO u on
		v.id_usuario = u.id_usuario inner join estacion.estacion e on v.estacionPartida = e.id_estacion
		inner join estacion.estacion ep on v.estacionLlegada = ep.id_estacion
		where v.fecha > @fecha1 and v.fecha < @fecha2
	)
GO
CREATE OR ALTER FUNCTION estacion.recorridoEstacion(@estacion INT) -- RECORRIDOS DE ACUERDO A UNA ESTACI�N EN PARTICULAR
RETURNS TABLE
AS
	RETURN (
		SELECT u.nombre + ' ' +u.paterno + ' ' + u.materno as NombreUsuario, e.nombre as EstacionPartida,
			   ep.nombre as EstacionLlegada, v.fecha, v.tarifa as Costo, DATEDIFF(MINUTE,hora_ini, v.hora_llegada) AS DuracionMinutos
		FROM usuarios.viaje v inner join usuarios.USUARIO u on
		v.id_usuario = u.id_usuario inner join estacion.estacion e on v.estacionPartida = e.id_estacion
		inner join estacion.estacion ep on v.estacionLlegada = ep.id_estacion
		where v.estacionPartida = @estacion
	)
GO

CREATE OR ALTER PROCEDURE estacion.recorridos -- PROCEDIMIENTO PARA ESCOGER INFORME POR ESTACION Y/O POR PERIODO DE TIEMPO
	@parametro1 INT = NULL,
	@fecha1 DATE= NULL,
	@fecha2 DATE = NULL
AS
BEGIN
	IF @fecha1 IS NOT NULL and @fecha2 IS NOT NULL and @parametro1 IS NULL
		BEGIN
			SELECT 'INFORME POR PERIODO DE TIEMPO'
			SELECT @fecha1 AS FechaInicio, @fecha2 AS FechaFin
			SELECT * from estacion.recorridoPeriodo(@fecha1, @fecha2)
		END
	ELSE IF @fecha1 IS NOT NULL and @fecha2 IS NOT NULL and @parametro1 IS NOT NULL
		BEGIN
			SELECT 'INFORME POR PERIODO DE TIEMPO'
			SELECT * from estacion.recorridoPeriodo(@fecha1,@fecha2)
			SELECT 'INFORME POR ESTACION'
			SELECT * FROM estacion.recorridoEstacion(@parametro1)
		END
	ELSE IF @parametro1 IS NOT NULL and (@fecha1 IS NULL or @fecha2 IS NULL)
		BEGIN
			SELECT 'INFORME POR ESTACION'
			SELECT * FROM estacion.recorridoEstacion(@parametro1)
		END
	ELSE
		PRINT 'NO FUE POSIBLE GENERAR UNA SALIDA'

END

--Primer par�metro: Una estacion del 1 al 5
--Segundo par�metro: fecha inicial
--Tercer par�metro: fecha final

--PROBANDO POR PERIODO DE TIEMPO (SOLO MUESTRA UN SELECT)
EXEC estacion.recorridos NULL, '2022-02-20', '2022-10-30'

--PROBANDO POR AMBOS CASOS (MUESTRA DOS SELECT'S)
EXEC estacion.recorridos 5, '2022-02-20', '2022-10-30'

--PROBANDO POR ESTACION NADA MAS (MUESTRA UN SELECT)
EXEC estacion.recorridos 5, '2022-02-20', NULL

--PROBANDO UN CASO QUE NO GENERE REPORTE
EXEC estacion.recorridos NULL, '2022-02-20', NULL

/*
	-------------------------------------ESTAD�STICA  11  ------------------------------------------------------------------

	Autor: Karla Vel�zquez

	Fecha de creaci�n: 08 / 06 / 2023

	Descripcion: �pocas del a�o con n�mero de recorridos ordenados de mayor a menor
	
	----------------------------------------------------------------------------------------------------------------------

*/

go
CREATE OR ALTER FUNCTION dbo.fechaTemporada( @fecha date)
returns varchar(30)
as
begin
	declare @estacion varchar(30)
	declare @mes INT

	SET @mes = MONTH(@fecha)

	IF @mes IN (12,1,2)
		SET @estacion = 'INVIERNO'
	ELSE IF @mes IN (3,4,5)
		SET @estacion = 'PRIMERAVERA'
	ELSE IF @mes in (6,7,8)
		SET @estacion = 'VERANO'
	ELSE
		SET @estacion = 'OTO�O'
	RETURN @estacion
end
go

SELECT t.Temporada, count(*) as 'Numero De Recorridos'
FROM (
SELECT  dbo.fechaTemporada(fecha) as Temporada, fecha
FROM usuarios.viaje ) as t
group by Temporada
order by [Numero De Recorridos] DESC

/*
	-------------------------------------ESTAD�STICA  12  ------------------------------------------------------------------

	Autor: Eduardo Elias Sotelo / Karla Vel�zquez / Daniel Aguilar

	Fecha de creaci�n: 08 / 06 / 2023

	Descripcion:Obtener pada cada agente sus datos personales y el listado de los accidentes que han atendido (tipo
	de accidente, fecha, lugar)	
	
	----------------------------------------------------------------------------------------------------------------------

*/
go
CREATE OR ALTER PROCEDURE empleados.AgentesAccidentesASBEGIN	--Cursor externo variables	DECLARE @id_empleado int, @nombre varchar(20), @paterno varchar(20), @materno varchar(20), @calle varchar(20), @colonia varchar(20),	@alcaldia varchar(25), @num_ext int, @num_int int, @telefono varchar(15),@rfc varchar(14), @sueldo money, @estado_civil varchar(20), @edad int		--Cursor interno variables	DECLARE @id_empleadoAcc int, @tipo varchar(20), @fecha date, @ruta varchar(150)	DECLARE curAgente CURSOR	FOR	SELECT a.id_empleado,e.nombre, e.paterno, e.materno, e.calle, e.colonia, e.alcaldia, e.num_ext, e.num_int, e.telefono, e.rfc, e.sueldo, e.estado_civil,		e.edad	FROM EMPLEADOS.agente a inner join empleados.empleado e  on a.id_empleado = e.id_empleado	OPEN curAgente	FETCH curAgente into @id_empleado, @nombre, @paterno, @materno,@calle, @colonia, @alcaldia, @num_ext, @num_int, @telefono, @rfc, @sueldo, @estado_civil, @edad	WHILE (@@FETCH_STATUS = 0)	BEGIN		PRINT 'Nombre: ' + @nombre + ' ' + @paterno + ' ' + @materno 		PRINT 'Domicilio: ' + @calle +  ' ' + @colonia + ' .Num Ext: ' + CAST(@num_ext as varchar(3)) + ' .Num_int: ' + CAST(@num_int as varchar(4)) + ' .'  + @alcaldia 		PRINT 'Datos: ' + @telefono + ' . RFC: ' + @rfc + ' . Edo civil: ' + @estado_civil + ' .Edad : ' + CAST(@edad as varchar(4))		DECLARE curAgenteDetalle CURSOR		FOR SELECT i.id_empleado,ti.tipo,v.fecha,v.ruta FROM usuarios.incidente i INNER join usuarios.tipo_incidente ti ON i.idTipoInc = ti.idTipoInc inner join		usuarios.viaje v on v.id_viaje = i.id_viaje WHERE  id_empleado = @id_empleado		OPEN curAgenteDetalle 		FETCH curAgenteDetalle into @id_empleadoAcc, @tipo, @fecha, @ruta		WHILE (@@FETCH_STATUS = 0)			BEGIN				PRINT 'Tipo Incidente: ' + @tipo + ' / ' + CAST(@fecha AS VARCHAR(13)) + ' / ' + @ruta				FETCH curAgenteDetalle into @id_empleadoAcc, @tipo, @fecha, @ruta			END		PRINT '------------------------------------------------------------------------------------------------'		CLOSE curAgenteDetalle		DEALLOCATE curAgenteDetalle		FETCH curAgente into @id_empleado, @nombre, @paterno, @materno,@calle, @colonia, @alcaldia, @num_ext, @num_int, @telefono, @rfc, @sueldo, @estado_civil, @edad	END	CLOSE curAgente	DEALLOCATE curAgenteENDEXEC empleados.AgentesAccidentes/*
	---------------------------------------------------ESTAD�STICA  13 -------------------------------------------------------

	Autor: Elias Eduardo Gonz�lez

	Fecha de creaci�n: 10 / 06 / 2023

	Descripcion: Para el �rea de recursos humanos es importante un informe mensual
	de todos los empleados y sus datos: RFC, nombre completo y sueldo,
	asimismo nombre de los empleados y puesto de los que tengan un
	sueldo de 13000 mensuales y pertenezcan a la tercera edad.
	
	----------------------------------------------------------------------------------------------------------------------

*/-- usando vista (dml)go
CREATE OR ALTER VIEW empleados.visEmpleados as
select rfc , nombre + ' ' + paterno + ' ' + materno AS Nombre, sueldo, tipo_empleado, edad
from empleados.empleado 
go

-- salida 1
SELECT *, case
	when tipo_empleado ='R' then 'Recursos Humanos'
	when tipo_empleado ='G' then 'Agente'
	when tipo_empleado ='M' then 'Mantenimiento'
	when tipo_empleado ='A' then 'Administraci�n'
	end as 'Puesto'
FROM empleados.visEmpleados 

UPDATE empleados.empleadoSET sueldo = 13000WHERE id_empleado in (3,7,9,10,11)UPDATE empleados.empleadoSET edad = 70WHERE id_empleado in (10,11)UPDATE empleados.empleadoSET edad = 77WHERE id_empleado in (3)UPDATE empleados.empleadoSET edad = 77WHERE id_empleado in (15)--salida 2SELECT nombre,
case
	when tipo_empleado ='R' then 'Recursos Humanos'
	when tipo_empleado ='G' then 'Agente'
	when tipo_empleado ='M' then 'Mantenimiento'
	when tipo_empleado ='A' then 'Administraci�n'
	end as 'Puesto',edad,sueldofrom empleados.visEmpleadoswhere edad > 65 and sueldo =13000