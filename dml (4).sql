/*
	*Proyecto: Ecobici
	*Autores: Daniel Aguilar
			  Gonzalez Sotelo Elías Eduardo
			  Velazquez Martinez Karla Andrea
	*Facultad de Ingeniería UNAM
	*Profesora: Martha Lopez Pelcastre
	*Bases de datos: Grupo 02
	*Equipo: 3
	*ARCHIVO DML
*/


/*------------------------------    FUNCION 1       ---------------------------------------------------

	FUNCION PARA ESTADÍSTICA 4
	Autor: Elias Eduardo González

	Fecha de creación: 11 / 06 / 2023
	
	Descripcion: Función util para segmentar por edades particulares para la estadística 4

------------------------------------------------------------------------------------------------------*/


--FUNCION PARA ESTADÍSTICA 4
CREATE or ALTER FUNCTION usuarios.edades()
RETURNS TABLE
AS

RETURN (SELECT CASE
			WHEN edad <=15 THEN '10-15 AÑOS'
			WHEN edad <=20 THEN '15-20 AÑOS'
			WHEN edad <=30 THEN '20-30 AÑOS'
			ELSE '+30 AÑOS'
		    	END AS rango_edades, COUNT(*) AS 'Numero de Usuarios'
		FROM usuarios.USUARIO 
		GROUP BY CASE
			WHEN edad <=15 THEN '10-15 AÑOS'
			WHEN edad <=20 THEN '15-20 AÑOS'
			WHEN edad <=30 THEN '20-30 AÑOS'
			ELSE '+30 AÑOS'
		    	END
		)

GO

/*------------------------------    FUNCION 2       ---------------------------------------------------


	FUNCION PARA ESTADÍSTICA 7

	Autor: Eduardo Elias González

	Fecha de creación: 11 / 06 / 2023

	Descripcion: funcion que recibe el numero entero del mes para retornar el una tabla
	con el numero de incidentes de acuerdo a una segmentación por un mes dado

------------------------------------------------------------------------------------------*/

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


/*------------------------------    FUNCION 3 Y FUNCION 4  ---------------------------------------------------



	FUNCIONES PARA ESTADÍSTICA 10
	
	Autor: Daniel Aguilar

	Fecha de creación: 09 / 06 / 2023

	Descripcion: Regresa una tabla cada función. Una regresa una tabla segmentada por un intervalo de fechas.
	La segunda hace lo mismo pero segmentando por un numero entero, referente al id de la estación en cuestión.


-------------------------------------------------------------------------------------------------------------*/

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

CREATE OR ALTER FUNCTION estacion.recorridoEstacion(@estacion INT) -- RECORRIDOS DE ACUERDO A UNA ESTACIÓN EN PARTICULAR
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



/*---------------------------------------   TRIGGER  1 -----------------------------------------------------------------



	Autor: Karla Velázquez

	Fecha de creación: 11 / 06 / 2023

	Descripcion: Trigger para validar la integridad de la jerarquía de tipos en la tabla de agente.
	Verifica que no exista en la tabla de Mantenimiento ni Administrador. Ademas, valida que tampoco
	exista en la tabla de empleado con el tipo 'R' (recursos humanos)


--------------------------------------------------------------------------------------------------------------------*/

CREATE OR ALTER TRIGGER empleados.tr_usuarios
ON empleados.agente
INSTEAD OF INSERT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM empleados.mantenimiento WHERE id_empleado = (SELECT id_empleado FROM inserted))
		BEGIN
			PRINT 'No es posible realizar Insersión, existe en la tabla de mantenimiento'
			RETURN
		END
	IF EXISTS (SELECT 1 FROM empleados.administrador WHERE id_empleado = (SELECT id_empleado FROM inserted))
	    BEGIN
			PRINT 'No es posible realizar Insersión, existe en la tabla de administrador'
			RETURN
		END
	IF EXISTS (SELECT 1 FROM empleados.empleado e inner join inserted i on e.id_empleado = i.id_empleado where e.tipo_empleado = 'R')
		BEGIN
			PRINT 'No es posible realizar la insersión, es un empleado de recursos humanos'
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

/*---------------------------------------------------TRIGGER  2---------------------------------------------------------

	Autor: Daniel Aguilar

	Fecha de creación: 12 / 06 / 2023

	Descripcion: Trigger para validar que al insertar un viaje,haya coherencia en la información ingresada. Es decir, para
	un viaje dado, verifica que al ingresar el id de la bicicleta cuya estación de partida es X y la estación de llegada 
	es Y, se revise si dicha bicicleta a insertar efectivamente su estación en la que está es la estación X. En caso de
	no estarlo no se permite la inserción. Por el contrario, si la información del viaje se ingresa adecuadamente, entonces
	en la tabla de bicicleta se cambia el id de la estación en la que se encuentra por la estación de llegada Y de dicho
	viaje.	

----------------------------------------------------------------------------------------------------------------------*/
GO
CREATE OR ALTER TRIGGER usuarios.tr_InsertarViaje
ON usuarios.viaje
INSTEAD OF INSERT
AS
BEGIN

	IF EXISTS(SELECT 1  FROM estacion.bicicleta b inner join inserted i on b.id_bicicleta = i.id_bicicleta where b.id_estacion = i.estacionPartida)
		BEGIN
			PRINT 'La bicicleta coincide con la estación de partida. Se ha efectuado el insert exitosamente'
			
			--ACTUALIZAMOS LA ESTACION EN DONDE ESTÁ LA BICICLETA
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
			--NO SE REALIZA LA INSERCIÓN DEL VIAJE
			PRINT 'La bici que trataste de insertar no pertenece a la estación de partida'
			RETURN
		END


END


/*---------------------------------------   VISTA  1 -----------------------------------------------------------------



	VISTA PARA ESTADÍSTICA 13
	
	Autor: Daniel Aguilar

	Fecha de creación: 12 / 06 / 2023

	Descripcion: Regresa una tabla con toda la información de los empleados, lo que facilita evitar tener que nombrar
	todos los atributos para cada select en el que se use la tabla de empleado. Además, se juntan los 3 nombres en uno


--------------------------------------------------------------------------------------------------------------------*/
go
CREATE OR ALTER VIEW empleados.visEmpleados as
select rfc , nombre + ' ' + paterno + ' ' + materno AS Nombre, sueldo, tipo_empleado, edad
from empleados.empleado 
go

/*------------------------------------------- VISTA 2---------------------------------------------------------------------

	
	Autor: Daniel Aguilar

	Fecha de creación: 12 / 06 / 2023

	Descripcion: Vista con cada uno de los idiomas que habla cada empleado. Da la información del id_empleado,
				nombre e idiomas


--------------------------------------------------------------------------------------------------------------------*/

CREATE OR ALTER VIEW empleados.visEmpleadosIdiomas as
select e.id_empleado, nombre + ' ' + paterno + ' ' + materno as Nombre, id.idioma 
from EMPLEADOS.empleado e inner join empleados.EMPLEADO_IDIOMA ei on e.id_empleado = ei.id_empleado
inner join empleados.idioma id on ei.id_idioma = id.id_idioma

go

/*------------------------------------------- VISTA 3---------------------------------------------------------------------

	
	Autor: Eduardo Elias González

	Fecha de creación: 12 / 06 / 2023

	Descripcion: Vista util para tener información sobre todas las bicicletas


--------------------------------------------------------------------------------------------------------------------*/
go
CREATE OR ALTER VIEW estacion.visBicicleta as
select id_bicicleta, color, modelo, nserie, tamaño, es.nombre, es.ubicacion
FROM estacion.bicicleta b inner join estacion.color c on b.id_color = c.id_color
inner join estacion.modelo m on m.id_modelo = b.id_modelo inner join estacion.estacion es
on es.id_estacion  = b.id_estacion

go

/*------------------------------------------- USO DE TRANSACCIONES Y MANEJO DE ERRORES -----------------------------------------------

	
	EL USO DE TRANSACCIONES SE UTILIZA EN LOS TRIGGERS DE ESTE DOCUMENTO PARA TENER UN CONTROL SOBRE LAS ESTRUCTURAS CONDICIONALES.
	ADEMÁS, EL USO DE TRANSACCIONES SE USAN EN EL ARCHIVO DE ESTADÍSTICAS PARA PROBAR LA SALIDA, USANDO ROLLBACK TRANSACTION Y 
	COMMIT TRANSACTION. 

	EL MANEJO DE ERRORES VIENE VALIDADO EN EL MANEJO DE TRIGGERS PARA CONSERVAR LA INTEGRIDAD DE LA INFORMACIÓN, ADEMÁS DE QUE LOS 
	POSIBLES ERRORES SE MANDAN MENSAJES DE POR QUÉ NO SE PUDO REALIZAR UNA INSERCIÓN, POR EJEMPLO

--------------------------------------------------------------------------------------------------------------------------------------*/

--------------------------------------------------- LLAMADAS A PROCEDIMIENTOS ----------------------------------------------------------

--ESTADISTICA 1
EXECUTE usuarios.pa_reporteIncidentes '2022-02-22','2022-10-30'

--ESTADÍSTICA 5
EXECUTE estacion.InventarioBicicletas '2022-01-04', '2022-12-30'

--ESTADÍSTICA 6
EXEC usuarios.InformeMembresias

--ESTADÍSTICA 9
EXEC empleados.InformeEmpleados


--ESTADÍSTICA 10

--PROBANDO POR PERIODO DE TIEMPO (SOLO MUESTRA UN SELECT)
EXEC estacion.recorridos NULL, '2022-02-20', '2022-10-30'

--PROBANDO POR AMBOS CASOS (MUESTRA DOS SELECT'S)
EXEC estacion.recorridos 5, '2022-02-20', '2022-10-30'

--PROBANDO POR ESTACION NADA MAS (MUESTRA UN SELECT)
EXEC estacion.recorridos 5, '2022-02-20', NULL

--PROBANDO UN CASO QUE NO GENERE REPORTE
EXEC estacion.recorridos NULL, '2022-02-20', NULL

-- ESTADÍSTICA 12
EXEC empleados.AgentesAccidentes


-- USUARIOS

EXEC CrearUsuarioConsulta @nombreUsuario = 'MiNuevoUsuario', @contrasena = 'MiNuevaContrasena';


EXEC CrearUsuarioGestor @nombreUsuario = 'MiNuevoGestor', @contrasena = 'MiNuevaContrasena';

EXEC CrearUsuarioAdministrador @nombreUsuario = 'MiNuevoAdministrador', @contrasena = 'MiNuevaContrasena';


-- USO DEL LIKE

--Seleccionar nombre de empleados cuya segunda letra es una e
-- y en su rfc haya un 5
SELECT * from  empleados.visEmpleados where nombre LIKE LOWER('_e%') AND RFC LIKE '%5%'


