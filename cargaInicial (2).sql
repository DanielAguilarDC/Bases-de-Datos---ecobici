/*
	Nombres: Aguilar Maya Daniel
	        González Sotelo Elias Eduardo
			Velázquez Martínez Karla Andrea

	Asignatura: Bases de datos Grupo: 02

	Profesora: Martha López Pelcastre

*/


/*
	INSERCIÓN DE EMPLEADOS (PK NONCLUSTERED)
	--CALCULANDO EDAD A PARTIR DE LA FECHA DE NACIMIENTO
	--GENERO H , M , O
	--CODIGO INE DE 9 DIGITOS
	--INDICE NONCLUSTERED en id_usuario IDENTITY
*/

INSERT INTO usuarios.USUARIO (app_saldo, materno, nombre, paterno, fecha_nac, correo, codigo_ine, genero) 
VALUES		(1, 'Martínez', 'Braulio', 'Fernández','1995-05-12', 'Braulio_Martinez@gmail.com', '126054319','H'),
          (1, 'González', 'María', 'López', '1982-07-18', 'maria_lopez@gmail.com', '563029857', 'M'),
          (1, 'Hernández', 'Juan', 'García', '1987-11-23', 'juan_garcia@gmail.com', '732916845', 'O'),
          (0, 'Torres', 'Laura', 'Vargas', '1992-09-30', 'laura_vargas@gmail.com', '429187536', 'M'),
          (1, 'Rojas', 'Carlos', 'Sánchez', '1983-04-05', 'carlos_sanchez@gmail.com', '903457218', 'H'),
          (0, 'Fernández', 'Ana', 'Jiménez', '1988-12-15', 'ana_jimenez@gmail.com', '628743591', 'M'),
          (1, 'López', 'Pedro', 'González', '1997-02-28', 'pedro_gonzalez@gmail.com', '182456903', 'O'),
          (0, 'García', 'Mónica', 'Hernández', '1985-08-08', 'monica_hernandez@gmail.com', '347819524', 'M'),
          (1, 'Vargas', 'Jorge', 'Torres', '1994-06-20', 'jorge_torres@gmail.com', '519672430', 'H'),
          (0, 'Sánchez', 'María', 'Rojas', '1981-03-11', 'maria_rojas@gmail.com', '683927541', 'M')


/*
	INSERCIÓN DE TELEFONOS DE EMPLEADOS (PK CLUSTERED)
	--TELEFONO (CHECK LIKE DE 10 DIGITOS)
	--UNIQUE
*/
INSERT INTO usuarios.telefono (id_usuario, tel) 
VALUES
    (1, '5610246429'),
    (1, '5620394857'),
    (2, '5639283746'),
    (2, '5647291830'),
    (3, '5657392018'),
    (4, '5668457293'),
    (5, '5672819403'),
    (6, '5689382740'),
    (7, '5693748291'),
    (7, '5602938471'),
    (7, '5619384752'),
    (8, '5629384019'),
    (9, '5634958710'),
    (10, '5643092817'),
    (10, '5616250312')


/*
	INSERCIÓN DE METODOS DE PAGO
  -- (PK CLUSTERED)
	-- CHECK TIPO DE PAGO : 'CREDITO', 'DEBITO' , 'PAYPAL'
  -- id_usuario NONCLUSTERED
*/

INSERT INTO usuarios.metodo_pago  (activo, tipo_pago, id_usuario)
VALUES	(1, 'CREDITO', 1),
		(1, 'DEBITO', 1),
		(1, 'PAYPAL', 1),
		(1, 'CREDITO', 2),
		(0, 'PAYPAL', 2),
		(1, 'CREDITO', 3),
		(0, 'CREDITO', 4),
		(1, 'DEBITO', 5),
		(1, 'DEBITO', 6),
		(1, 'DEBITO', 7),
		(0, 'DEBITO', 8),
		(1, 'DEBITO', 9),
		(1, 'PAYPAL', 10),
		(0, 'CREDITO', 10),
		(1, 'DEBITO', 10),
		(1, 'DEBITO', 4)


/*
	INSERCIÓN DE tipo_membresia
	-- Check tipo: 'B', 'I', 'P'
  -- PK CLUSTERED
*/
INSERT INTO usuarios.tipo_membresia (tipo) VALUES ('B'), ('I') , ('P')

UPDATE usuarios.tipo_membresia
SET costo = CASE tipo
                    WHEN 'B' THEN 118
                    WHEN 'I' THEN 400
                    WHEN 'P' THEN 1000
			END

/*
	INSERCIÓN DE membresia 
	-- precio de tarjeta: todas en 50, luego con triggers verificar 50 o 80 para inserts y update
	-- beneficio y duracionDiasSuscripcion calculado
	(pk CLUSTERED)
*/


INSERT INTO usuarios.membresia (fecha, id_tipo, precio_tarjeta, codigoQR, id_pago) VALUES
		('2023-02-14', 1, 50.00, 1245.323, 1),
		('2021-05-11', 3, 50.00, 9876.222, 3),
		('2021-05-11', 2, 50.00, 2453.222, 5),
		('2021-03-01', 1, 50.00, 1435.336, 6),
		('2021-05-12', 2, 50.00, 4321.789, 7),
		('2021-06-15', 3, 50.00, 5678.987, 8),
		('2021-02-25', 1, 50.00, 2468.135, 9),
		('2021-10-26', 2, 50.00, 8795.642, 10),
		('2021-11-27', 3, 50.00, 7531.864, 11),
		('2021-12-12', 1, 50.00, 3198.572, 12),
		('2021-08-08', 2, 50.00, 6482.947, 13),
		('2021-09-02', 3, 50.00, 9274.516, 15),
		('2021-10-10', 1, 50.00, 1584.247, 16);



/*
	INSERCIÓN DE empleado 
	-- tipo empleado: -- M: Mantenimiento, G: Agente, A: Administrador, R: Recursos humanos
	-- genero : H M O
	-- ESTADO CIVIL: 'SOLTERO','CASADO','VIUDO','DIVORCIADO'
	(pk nonClustered)
*/


INSERT INTO empleados.empleado(nombre, paterno, materno, calle, colonia, alcaldia,num_ext, num_int, telefono, rfc, sueldo, estado_civil,edad, genero, tipo_empleado)
VALUES ('Daniel', 'Aguilar', 'Maya', 'santa ursula', 'san pedro', 'coyoacan', 20,3,5618326010, 'ASSS302010GYM', 30000, 'soltero', 20, 'H', 'M'),
			 ('Luis', 'Martinez', 'Olivares', 'almendros', 'el rosario', 'gustavo madero', 5,1,5618326016, 'MAOL710610H30', 28000, 'casado', 52, 'H', 'M'),
       ('Fernanda', 'Vazquez', 'Rojas', 'olivos', 'santa maria', 'iztapalapa', 22,7,5618326017, 'VZRF940505MB4', 27000, 'soltero', 29, 'O', 'M'),
       ('Eduardo', 'Juarez', 'Lopez', 'romero', 'el vergel', 'iztacalco', 12,3,5618326018, 'JULE840910HG8', 45000, 'viudo', 39, 'H', 'M'),
       ('Sandra', 'Herrera', 'Diaz', 'rosales', 'el paraiso', 'xochimilco', 19,2,5618326019, 'HEDS810208M45', 35000, 'casado', 42, 'M', 'M'),
       ('Roberto', 'Guerrero', 'Mendez', 'girasoles', 'la noria', 'magdalena C.', 15,4,5618326020, 'GUMR750615H50', 38000, 'divorciado', 48, 'H', 'M'),
       ('Veronica', 'Cruz', 'Salinas', 'azaleas', 'los girasoles', 'milpa alta', 25,6,5618326021, 'CRSV870805M47', 30000, 'soltero', 36, 'M', 'G'),
       ('Jose', 'Morales', 'Gonzalez', 'sauces', 'san jose', 'miguel hidalgo', 11,1,5618326022, 'MOGJ730920H28', 33000, 'casado', 50, 'O', 'G'),
       ('Alejandra', 'Duran', 'Barrera', 'limoneros', 'el laurel', 'venustiano c.', 8,3,5618326023, 'DUBA820530M49', 28000, 'divorciado', 41, 'M', 'G'),
       ('David', 'Zamora', 'Torres', 'manzanos', 'los cedros', 'cuajimalpa', 33,5,5618326024, 'ZATD770810H35', 40000, 'soltero', 46, 'H', 'G'),
       ('Lorena', 'Vega', 'Santos', 'higueras', 'san angel', 'tlahuac', 7,2,5618326025, 'VESL900515M48', 32000, 'casado', 33, 'M', 'G'),
       ('Hector', 'Delgado', 'Castillo', 'laureles', 'san bernabe', 'tlalpan', 20,8,5618326026, 'DECH810425H21', 36000, 'viudo', 42, 'H', 'A'),
       ('Adriana', 'Lara', 'Navarro', 'pino', 'la concepcion', 'coyoacan', 23,6,5618326027, 'LANA900715M46', 37000, 'casado', 33, 'M', 'A'),
       ('Gabriel', 'Ortiz', 'Romero', 'abedul', 'el bosque', 'azcapotzalco', 9,4,5618326028, 'ORRG820610H39', 34000, 'divorciado', 41, 'O', 'A'),
       ('Patricia', 'Perez', 'Ramos', 'cerezos', 'san pablo', 'benito juarez', 27,2,5618326029, 'PERR850825M37', 33000, 'soltero', 38, 'M', 'A'),
       ('Jorge', 'Aguilar', 'Ponce', 'encinos', 'santa rosa', 'alvaro O.', 14,6,5618326030, 'AGPJ790310H23', 39000, 'casado', 44, 'H', 'A'),
       ('Yolanda', 'Trejo', 'Alvarez', 'olmos', 'el parque', 'cuauhtemoc', 19,3,5618326031, 'TRAY840705M43', 28000, 'divorciado', 39, 'M', 'A'),
       ('Miguel', 'Camacho', 'Hernandez', 'magnolias', 'la hacienda', 'venustiano c', 6,8,5618326032, 'CAMH780210H29', 42000, 'soltero', 45, 'H', 'R'),
       ('Isabel', 'Guerra', 'Salazar', 'sabinos', 'la pradera', 'gustavo a.', 30,7,5618326033, 'GUSI890620M52', 30000, 'viudo', 34, 'M', 'R'),
       ('Ricardo', 'Santos', 'Lopez', 'nogales', 'las aguilas', 'iztapalapa', 15,5,5618326034, 'SALR810920H38', 40000, 'soltero', 42, 'H', 'R'),
       ('Rebeca', 'Molina', 'Campos', 'acacias', 'san miguel', 'iztacalco', 22,9,5618326035, 'MOCR850305M39', 35000, 'casado', 38, 'M', 'R');


/*
	INSERCIÓN DE idioma
  pk clustered
*/


INSERT INTO empleados.idioma ( idioma)
VALUES ( 'Español'),
	    ( 'Frances'),
	    ( 'Italiano'),
	    ( 'Chino'),
      ( 'Aleman');




/* 
  INSERSIÓN DE EMPLEADO_IDIOMA
  ID DEL IDIOMA Y ID DEL EMPLEADO
*/

INSERT INTO EMPLEADOS.EMPLEADO_IDIOMA (id_empleado, id_idioma)
VALUES (1, 1), 	(1, 2), (1, 5),
	   (2,3), (2,1),
	   (3,5), (3,1),
       (4, 1), (4, 2),
       (5, 1), (5, 3),
       (6, 1), (6, 4),
       (7, 1), (7, 2), (7, 5),
       (8, 1), (8, 3),
       (9, 1), (9, 2), (9, 4),
       (10, 1), (10, 3), (10, 5),
       (11, 1), (11, 4),
       (12, 1), (12, 3), (12, 5),
       (13, 1), (13, 2),
       (14, 1), (14, 4),
       (15, 1), (15, 3), (15, 5),
       (16, 1), (16, 2),
       (17, 1), (17, 4),
       (18, 1), (18, 3),
       (19, 1), (19, 5),
       (20, 1), (20, 2),
       (21, 1), (21, 4);


/*
	Insersión tabla motivo
	--Causa: Enfermedad, accidente, situacion familiar, otros
*/

INSERT INTO EMPLEADOS.motivo(causa)
VALUES ('Enfermedad'),
	     ('Accidente'),
       ('Situacion Familiar'),
       ('Otros');

select * from empleados.motivo
order by id_motivo

/*
	inserción historial_falta
  pk compuesta nonclustered
*/
INSERT INTO empleados.historial_falta (id_empleado, id_motivo, fecha)
VALUES (1, 1, '2022-01-01'), (1, 3, '2022-05-05'),
	   	 (2, 4, '2022-11-14'), (2,1, '2022-12-12'),
     	 (3, 1, '2022-02-04'), (3, 2, '2022-06-22'),
       (4, 4, '2022-02-15'), (4, 3, '2022-07-30'), (4, 2, '2022-10-05'),
       (5, 1, '2022-03-12'),
       (6, 3, '2022-04-26'), (6, 1, '2022-08-13'),
       (7, 2, '2022-05-03'), (7, 3, '2022-09-25'), (7, 4, '2022-12-02'),
       (9, 4, '2022-02-24'), (9, 2, '2022-04-18'), (9, 1, '2022-09-01'), (9, 4, '2022-12-10'),
       (10, 2, '2022-03-05'), (10, 1, '2022-08-21'),
       (11, 3, '2022-01-19'), (11, 4, '2022-07-14'), (11, 4, '2022-11-22'),
       (12, 1, '2022-05-10'),
       (14, 3, '2022-02-07'), (14, 1, '2022-07-18'),
       (15, 1, '2022-04-04'), (15, 4, '2022-10-31'), (15, 2, '2022-11-27'),
       (16, 4, '2022-01-13'),
       (17, 1, '2022-02-20'), (17, 3, '2022-05-08'), (17, 3, '2022-08-24'), (17, 4, '2022-11-12'),
       (18, 2, '2022-03-17'), (18, 1, '2022-06-07'),
       (19, 3, '2022-04-12'), (19, 2, '2022-07-27'), (19, 4, '2022-10-13'),
       (21, 4, '2022-01-29'), (21, 2, '2022-03-30'), (21, 2, '2022-06-18'), (21, 3, '2022-09-07'), (21, 2, '2022-11-29');


/*
	Insersión de tabla agente. Id's 7 8 9 10 11
*/
INSERT INTO empleados.agente (id_empleado)
SELECT id_empleado FROM empleados.empleado WHERE tipo_empleado ='G'


/*
	Inserción tabla administrador
	id_empleado = 12,13,14,15,16,17
*/
INSERT INTO empleados.administrador (id_empleado, descripcionfuncion, tipo_trabajo, ubicacion) VALUES
(12,'Revisión constante de las estaciones a su cargo y su auditoría' , 'AUDITORIA', 'ECOBICI.0331'),
(13,'Vigilancia en que las actividades de la estación sean efectuadas en tiempo y forma' , 'REVISOR', 'ECOBICI.0431'),
(14,'Ayuda a las estaciones a su cargo a efectuar las labores para dar un mejor servicio' , 'APOYO', 'ECOBICI.0443'),
(15,'Fomenta el trabajo colaborativo entre los empleados a partir de metodologías ágiles' , 'MET. AGIL', 'ECOBICI.0451'),
(16,'Supervisa el trabajo de los empleados y premia el servicio de aquellos que dan el mejor servicio' , 'SUPERVISOR', 'ECOBICI.553'),
(17,'Comunica las problemáticas con otros administradores para fomentar el trabajo ágil' , 'COMUNICADOR', 'ECOBICI.0991')

/*
	inserción tabla mantenimiento, id's: 1 2 3 4 5 6
*/
INSERT INTO empleados.mantenimiento (id_empleado, especialidad) VALUES
(1,'ING. MECANICO'), (2,'ING. AUTOPARTES'),(3,'MECÁNICO'),(4,'REPARADOR'),(5,'SENIOR ING.'),(6,'CICLISTA PROF.')

/* 
  insersión tabla plan_seguro 
  (AÑADIR TRIGGER DESPUÉS PARA QUE NO PUEDA MODIFICARSE YA QUE NO HAY UN CHECK en el tipo de cobertura)
*/
INSERT INTO usuarios.plan_seguro (tipo_cobertura, id_tipo) VALUES 
		('Daños a terceros', 1), ('Daños a terceros y compostura bicicleta',2), ('Full',3)


/*
	inserción tabla color
  pk clustered
*/
INSERT INTO estacion.color (color)
VALUES  ( 'Rojo'),
	  	  ( 'Azul'),
        ( 'Amarillo');
select * from estacion.color

/* 
  inserción tabla estación
  pk clustered
  id_empleado de los de administracion 
*/
INSERT INTO estacion.estacion (ubicacion,nombre, id_empleado) VALUES
	('Av. Norte ST. 12','Est. 1', 12), 
	('Av. Pedregal. ST. 15','Est. 2', 13),
	('Av. Luz ST. 05','Est. 3', 14),
	('Av. Base Sur ST. 01', 'Est. 4',15),
	('Av. Strokes ST. 03','Est. 5',16)

/* 
	Insersión tabla terminal
*/
INSERT INTO estacion.terminal (id_estacion, consecutivo, descripcion) VALUES
	(1,1,'T. 1.01'), (1,2, 'T. 1.02'),(1,3,'T. 1.03'),
	(2,1,'T. 2.01'), (2,2, 'T. 2.02'),(2,3,'T. 2.03'),
	(3,1,'T. 3.01'), (3,2, 'T. 3.02'),(3,3,'T. 3.03'),
	(4,1,'T. 4.01'), (4,2, 'T. 4.02'),(4,3,'T. 4.03'),
	(5,1,'T. 5.01'), (5,2, 'T. 5.02'),(5,3,'T. 5.03')



/*
 	Insersión catalogo de modelo de bicicleta
*/
INSERT INTO estacion.modelo VALUES (1, 'BICYCLE ROD 26'), (2, 'BICYCLE ROD 29'), (3,'BICYCLE ROD 28')

/*
  Insersión de bicicleta
  --color con id 1 2 o 3
  --modelo 1 2 o 3
  -- tamaño chica, mediana o grande
  --estado F: funcionamiento, D: dañada o B: baja
*/
INSERT INTO estacion.bicicleta (id_color, id_modelo, nserie,tamaño, estado, id_estacion) VALUES
	(1, 1, 'BYCL-0001', 'Chica', 'F', 1),
	(2, 1, 'BYCL-0002', 'Mediana', 'F', 1),
	(2, 2, 'BYCL-0003', 'Chica', 'F', 1),
	(1, 1, 'BYCL-0004', 'Chica', 'F', 1),
	(2, 2, 'BYCL-0005', 'Mediana', 'F', 1),
	(1, 3, 'BYCL-0006', 'Grande', 'F', 1),
	(1, 3, 'BYCL-0007', 'Mediana', 'D', 1),
	(1, 3, 'BYCL-0008', 'Grande', 'B', 1), --8 bicicletas en estación 1
	(3, 1, 'BYCL-0009', 'Chica', 'F', 2),
	(3, 2, 'BYCL-0010', 'Grande', 'F', 2),
	(1, 2, 'BYCL-0011', 'Mediana', 'F', 2),
	(2, 1, 'BYCL-0012', 'Mediana', 'F', 2),
	(2, 1, 'BYCL-0013', 'Mediana', 'D', 2),
	(1, 3, 'BYCL-0014', 'Mediana', 'F', 2),
	(1, 3, 'BYCL-0015', 'Mediana', 'F', 2),
	(2, 2, 'BYCL-0016', 'Chica', 'B', 2),--8 bicicletas en estacion 2
	(3, 2, 'BYCL-0017', 'Grande', 'F', 3),
	(3, 3, 'BYCL-0018', 'Chica', 'F', 3),
	(1, 1, 'BYCL-0019', 'Mediana', 'F', 3),
	(1, 1, 'BYCL-0020', 'Chica', 'D', 3),
	(1, 3, 'BYCL-0021', 'Mediana', 'F', 3),
	(1, 2, 'BYCL-0022', 'Grande', 'F', 3),
	(2, 3, 'BYCL-0023', 'Mediana', 'F', 3),
	(2, 1, 'BYCL-0024', 'Mediana', 'B', 3),--8 biciletas en estacion 3
	(3, 3, 'BYCL-0025', 'Mediana', 'F', 4),
	(3, 2, 'BYCL-0026', 'Chica', 'F', 4),
	(2, 1, 'BYCL-0027', 'Chica', 'F', 4),
	(1, 1, 'BYCL-0028', 'Grande', 'F', 4),
	(1, 2, 'BYCL-0029', 'Grande', 'F', 4),
	(2, 2, 'BYCL-0030', 'Chica', 'F', 4),
	(3, 3, 'BYCL-0031', 'Chica', 'D', 4),
	(3, 3, 'BYCL-0032', 'Mediana', 'D', 4),--8 bicicletas en estacion 4
	(1, 1, 'BYCL-0033', 'Grande', 'F', 5),
	(1, 1, 'BYCL-0034', 'Mediana', 'F', 5),
	(2, 1, 'BYCL-0035', 'Chica', 'F', 5),
	(3, 2, 'BYCL-0036', 'Grande', 'F', 5),
	(1, 1, 'BYCL-0037', 'Mediana', 'F', 5),
	(3, 2, 'BYCL-0038', 'Mediana', 'F', 5),
	(2, 3, 'BYCL-0039', 'Mediana', 'F', 5),
	(2, 2, 'BYCL-0040', 'Mediana', 'F', 5)--8 bicicletas en estacion 5


/*
	Inserción bicimantenimiento 
	id's empleado (de mantenimiento 1-6)
	servicio: 'REPARACION', 'LIMPIEZA', 'TRANSPORTE'
*/

INSERT INTO estacion.bicimantenimiento (id_empleado,id_bicicleta,fecha, descripcion, servicio) VALUES
(1, 5, '2022-04-13', 'Reparación de frenos', 'REPARACIÓN'),
(1, 26, '2022-02-01', 'Cambio de estación', 'TRANSPORTE'),
(5, 16, '2022-03-16', 'Limpieza general', 'LIMPIEZA'),
(3, 4, '2022-07-04', 'Reparación de ruedas', 'REPARACIÓN'),
(2, 38, '2022-03-11', 'Mandada a matenimiento full', 'TRANSPORTE'),
(6, 32, '2022-05-05', 'Limpieza general', 'LIMPIEZA'),
(4, 18, '2022-06-07', 'Reparación de cadena y piñones', 'REPARACIÓN'),
(6, 14, '2022-08-17', NULL, 'REPARACIÓN'),
(1, 14, '2022-04-24', 'Reparación de radios', 'REPARACIÓN'),
(2, 34, '2022-06-16', 'Limpieza general', 'LIMPIEZA'),
(3, 9, '2022-09-09', NULL, 'TRANSPORTE'),
(5, 23, '2022-05-12', 'Limpieza superficial', 'LIMPIEZA'),
(4, 28, '2022-03-21', 'Limpieza profunda', 'LIMPIEZA'),
(1, 33, '2022-02-05', 'Reparación de horquilla', 'REPARACIÓN'),
(3, 14, '2022-07-22', 'Limpieza general', 'LIMPIEZA'),
(2, 7, '2022-05-02', 'Cambio de estación', 'TRANSPORTE'),
(6, 39, '2022-03-19', 'Limpieza de manillar', 'LIMPIEZA'),
(4, 13, '2022-09-14', 'Limpieza sencilla', 'LIMPIEZA'),
(5, 7, '2022-05-18', 'Reemplazo de bicicleta', 'TRANSPORTE'),
(2, 10, '2022-06-10', 'Reparación de frenos', 'LIMPIEZA'),
(1, 5, '2022-07-03',NULL, 'LIMPIEZA');


/*
	Inserción tabla viaje id non clustered
  --atributo de tarifa calculado a partir de la hora de inicio y la hora de llegada
*/
INSERT INTO usuarios.viaje (id_bicicleta, id_usuario, hora_ini, hora_llegada, hora_fin, fecha, ruta, estacionPartida, estacionLlegada) VALUES
	(1,5,'12:46:00', '13:46:00', '16:00:00', '2022-11-01', 'Paso por reforma, Av. Iman y llegó a la estación', 1,5),
    (27, 1, '09:30:00', '10:40:00', '10:10:00', '2022-01-15', 'Paso por iman a santa ursula y llegó a la estación', 2, 3),
    (15, 2, '14:45:00', '18:20:00', '17:30:00', '2022-03-02', 'Paso por santa lucía y llegó a cholula y llegó a la estación', 4, 1),
    (6, 3, '10:00:00', '11:00:00', '11:30:00', '2022-06-10', 'Av. Iman - Av. LEATHER - Estacion', 1, 5),
    (12, 4, '12:30:00', '14:00:00', '14:30:00', '2022-07-18', 'Av. Juan - Av. Dog - Estacion', 3, 2),
    (35, 8, '16:15:00', '17:30:00', '18:00:00', '2022-09-05', 'Av. Daniel - Av. Cat - Estacion', 5, 4),
    (8, 10, '11:45:00', '14:50:00', '13:30:00', '2022-11-21', 'Av. Gomez - Av. Sancho - Estacion', 1, 5),
    (19, 9, '15:30:00', '16:30:00', '17:00:00', '2022-02-14', 'Av. Flores - Av. Sol - Estacion', 2, 3),
    (29, 6, '13:00:00', '14:30:00', '15:00:00', '2022-04-29', 'Av. Luna - Av. Estrella - Estacion', 4, 1),
    (11, 7, '09:15:00', '10:00:00', '09:48:00', '2022-08-03', 'Av. Montaña - Av. Río - Estacion', 3, 2),
    (37, 10, '16:45:00', '18:00:00', '17:30:00', '2022-10-12', 'Av. Montaña - Av. Río - Estacion', 5, 4),
    (22, 1, '14:00:00', '15:30:00', '16:00:00', '2022-05-17', 'Av. Juan - Av. Dog - Estacion', 1, 5),
    (23, 1, '11:30:00', '12:30:00', '12:10:00', '2022-07-03', 'Av. Avenida - Av. Boulevard - Estacion', 2, 3),
    (18, 2, '16:30:00', '20:00:00', '19:30:00', '2022-09-20', 'Av. Nube - Av. Viento - Estacion', 3, 2),
    (31, 2, '10:45:00', '12:00:00', '12:30:00', '2022-11-08', 'Av. Puente - Av. Túnel - Estacion', 4, 1),
    (13, 3, '15:15:00', '16:15:00', '16:45:00', '2022-01-25', 'Av. Montaña - Av. Valle - Estacion', 5, 4),
    (5, 5, '12:00:00', '14:55:00', '14:00:00', '2022-03-11', 'Av. Ruta - Av. Sendero - Estacion', 1, 5),
    (36, 7, '14:30:00', '15:30:00', '16:00:00', '2022-06-28', 'Av. Nube - Av. Viento - Estacion', 2, 3),
    (20, 8, '09:45:00', '11:00:00', '10:30:00', '2022-08-15', 'Av. Montaña - Av. Valle - Estacion', 4, 1),
    (10, 10, '13:30:00', '14:45:00', '15:15:00', '2022-10-02', 'Av. Juan - Av. Dog - Estacion', 3, 2),
    (38, 7, '16:00:00', '18:15:00', '17:45:00', '2022-12-09', 'Av. Puente - Av. Túnel - Estacion', 5, 4),
    (7, 9, '10:30:00', '11:30:00', '12:00:00', '2022-03-15', 'Av. Luna - Av. Estrella - Estacion', 2, 4),
    (22, 6, '14:45:00', '16:15:00', '15:50:00', '2022-06-10', 'Av. Montaña - Av. Valle - Estacion', 3, 1),
    (29, 6, '12:15:00', '13:30:00', '14:00:00', '2022-09-27', 'Av. Luna - Av. Estrella - Estacion', 4, 5),
    (12, 4, '16:00:00', '17:30:00', '18:00:00', '2022-11-14', 'Av. Avenida - Av. Boulevard - Estacion', 5, 3),
    (2, 3, '11:00:00', '12:00:00', '12:30:00', '2022-02-03', 'Av. Cielo - Av. Mar - Estacion', 1, 2),
    (24, 8, '15:30:00', '18:45:00', '17:15:00', '2022-04-20', 'Av. Ruta - Av. Sendero - Estacion', 2, 4),
    (34, 9, '14:00:00', '15:00:00', '15:30:00', '2022-07-16', 'Av. Flores - Av. Sol - Estacion', 3, 1),
    (19, 1, '10:30:00', '12:55:00', '12:15:00', '2022-10-23', 'Av. Paso - Av. Cruce - Estacion', 4, 5),
    (6, 2, '13:15:00', '14:30:00', '15:00:00', '2022-12-01', 'Av. Escalera - Av. Ascensor - Estacion', 5, 3),
    (28, 4, '15:45:00', '17:00:00', '16:50:00', '2022-05-08', 'Av. Nube - Av. Viento - Estacion', 1, 2),
    (11, 6, '09:30:00', '10:30:00', '11:00:00', '2022-08-05', 'Av. Lago - Av. Río - Estacion', 2, 4),
	 (31, 7, '13:45:00', '15:00:00', '15:30:00', '2022-01-18', 'Av. Puente - Av. Túnel - Estacion', 3, 1),
    (17, 8, '11:15:00', '13:30:00', '13:00:00', '2022-04-03', 'Av. Cielo - Av. Mar - Estacion', 4, 5),
    (8, 9, '16:30:00', '19:45:00', '18:15:00', '2022-06-29', 'Av. Paso - Av. Cruce - Estacion', 5, 3),
    (35, 10, '12:00:00', '13:00:00', '13:30:00', '2022-09-15', 'Av. Escalera - Av. Ascensor - Estacion', 1, 2),
    (22, 8, '15:00:00', '17:15:00', '16:10:00', '2022-11-28', 'Av. Nube - Av. Viento - Estacion', 2, 4),
    (39, 5, '14:30:00', '15:30:00', '16:00:00', '2022-03-12', 'Av. Montaña - Av. Valle - Estacion', 3, 1),
    (14, 1, '10:45:00', '12:00:00', '12:30:00', '2022-08-19', 'Av. Paso - Av. Cruce - Estacion', 4, 5),
    (4, 3, '13:30:00', '14:45:00', '14:30:00', '2022-10-06', 'Av. Flores - Av. Sol - Estacion', 5, 3),
    (27, 5, '15:00:00', '16:15:00', '16:45:00', '2022-02-22', 'Av. Ruta - Av. Sendero - Estacion', 1, 2),
    (10, 9, '09:45:00', '10:45:00', '10:20:00', '2022-05-17', 'Av. Cielo - Av. Mar - Estacion', 2, 4);


/*
	Inserción incidentes
  'P. BICI','P. COCHE', 'P. MOTO', 'P. Peatón', 'Caída', 'Otros'
*/

INSERT INTO usuarios.incidente (id_empleado, tipo_incidente, hora, coordenadas, calle, numero, codigoPostal, alcaldia, colonia, descripcion, id_viaje) VALUES
 (10, 'P. BICI', '17:12:00', '124.235.222', 'Av. San Ricardo', 35, '04670', 'Coyoacan', 'Pedegal Ricardo', 'Me caí de la bicicleta al chocar con un peatón', 1),
 (9, 'P. COCHE', '19:00:00', '144.531.456', 'Av. San Pepe', 35, '65864', 'Magdalena', 'Pedegal Pepe', 'Choqué con otra bicicleta bruscamente', 5),
 (8, 'P. Peatón', '10:30:00', '176.892.124', 'Av. San Juan', 12, '04580', 'Benito Juarez', 'Pedegal Juan', 'Casi atropello a un peatón', 15),
 (10, 'P. MOTO', '14:45:00', '123.456.789', 'Av. San Pedro', 45, '06430', 'Cuauhtemoc', 'Pedegal Pedro', 'Dañé una bicicleta estacionada', 16),
 (11, 'Caída', '16:20:00', '987.654.321', 'Av. San Lucas', 28, '03240', 'Iztacalco', 'Pedegal Lucas', 'Fui golpeado por un automóvil', 3),
 (7, 'P. MOTO', '09:15:00', '789.123.456', 'Av. San Ignacio', 56, '05670', 'Gustavo A. Madero', 'Pedegal Ignacio', 'Me robaron la bicicleta', 25),
 (9, 'P. BICI', '12:40:00', '555.666.777', 'Av. San Roberto', 9, '04980', 'Tlahuac', 'Pedegal Roberto', 'Perdí mi tarjeta de acceso', 8),
 (8, 'P. BICI', '18:30:00', '777.888.999', 'Av. San Martín', 76, '07740', 'Venustiano C.', 'Pedegal Martín', 'Mi bicicleta se descompuso', 12),
 (10, 'P. BICI', '21:50:00', '999.888.777', 'Av. San Andrés', 18, '03100', 'Azcapotzalco', 'Pedegal Andrés', 'Me quedé sin batería en la tarjeta', 17),
 (11, 'P. COCHE', '15:10:00', '111.222.333', 'Av. San Miguel', 64, '04700', 'Alvaro Obregon', 'Pedegal Miguel', 'Nada', 30),
 (7, 'Otros', '13:20:00', '222.333.444', 'Av. San Manuel', 29, '06880', 'Iztapalapa', 'Pedegal Manuel', 'Mmmmmmmmmmm', 19),
 (8, 'Otros', '11:55:00', '333.444.555', 'Av. San Diego', 78, '06100', 'Miguel Hidalgo', 'Pedegal Diego', 'Se me pinchó una rueda', 38),
 (9, 'P. BICI', '19:40:00', '444.555.666', 'Av. San Felipe', 51, '04780', 'Cuajimalpa', 'Pedegal Felipe', 'Casi me caigo al pasar un tope', 20),
 (11, 'Otros', '16:15:00', '666.555.444', 'Av. San Luis', 43, '04230', 'Xochimilco', 'Pedegal Luis', 'Perdí mi casco durante el viaje', 7),
 (7, 'P. BICI', '16:30:00', '777.888.999', 'Av. San Rafael', 18, '04280', 'Alvaro Obregon', 'Pedegal Rafael', 'Se me salió la cadena de la bicicleta', 2),
 (9, 'P. MOTO', '10:00:00', '555.666.777', 'Av. San Ignacio', 35, '04940', 'Coyoacan', 'Pedegal Ignacio', 'Perdí mi tarjeta de acceso en el viaje', 6),
 (8, 'P. Peatón', '13:45:00', '444.555.666', 'Av. San Roberto', 27, '06120', 'Magdalena', 'Pedegal Roberto', 'Tuve una caída por un bache en el camino', 18),
 (10, 'P. BICI', '18:20:00', '666.555.444', 'Av. San Manuel', 14, '04370', 'Benito Juarez', 'Pedegal Manuel', 'Me robaron el celular mientras iba en la bicicleta', 4),
  (11, 'P. BICI', '12:15:00', '888.999.000', 'Av. San EXCELSO', 62, '04760', 'Cuajimalpa', 'Pedegal EXCELSO', 'Me encontré con un obstáculo en el carril bici', 39),
  (7, 'P. BICI', '15:50:00', '999.000.111', 'Av. San Macario', 45, '04050', 'Iztacalco', 'Pedegal Macario', 'Perdí mi tarjeta de acceso durante el viaje', 40)


/*
	Inserts tabla historial viaje
*/

INSERT INTO usuarios.historial_viaje VALUES 
	(1,124.3122, 125.3312), (1, 504.1445, 391.0122),
    (2, 223.3122, 126.3312),(2, 156.3, 585.0),
    (3, 333.1445, 391.0122),(3, 555.2121, 422.102),
    (4, 435.3111, 443.2122), (4, 212.341, 442.202),
    (5, 553.1245, 543.2221),(5, 654.1, 543.1),
    (6, 665.4444, 212.1243),(6, 325.4444, 212.12),
    (7, 767.2321, 655.211),(7, 871.2321, 615.31),
    (8, 887.1234, 777.555),(8, 312.1234, 127.5),
    (9, 988.2121, 253.4332),(9, 621.2121, 254.4332),
    (10, 1000.5432, 221.2221),(10, 432.5432, 112.1),
    (11, 1121.0000, 568.7777),
	(12, 1223.1231, 377.2345), (12, 999.0000, 888.74),
    (13, 1344.6543, 543.1254),(13, 432.6543, 543.1234),
    (14, 1432.5432, 33.9856),(14, 876.5432, 345.9876),
    (15, 1577.2222, 3.4444),(15, 111.24, 334.144),
    (16, 1665.5555, 55.7777), (16, 444.5555, 6.77),
    (17, 1788.9999, 566.4444),(17, 888.949, 555.44),
    (18, 1876.4567, 33.4321),(18, 123.427, 765.4321),
    (19, 1902.6666, 2552.33),(19, 767.64, 222.3333),
    (20, 2012.4444, 866.9999),(20, 555.4244, 778.99),
    (21, 2144.1234, 455.6543),(21, 321.1234, 432.6543),
	(22, 2243.1231, 312.2345),(22, 212.1231, 321.2345),
    (23, 2355.6543, 512.1234),(23, 432.643, 543.1234),
    (24, 2407.5432, 32.9876),(24, 876.5232, 345.9876),
    (25, 2576.2222, 313.444), (25, 111.2, 333.44),
    (26, 2676.5555, 6446.557), (26, 42.4, 626.77),
    (27, 2765.9999, 5522.4),
    (28, 2894.4567, 735.21),(28, 123.4567, 765.4321),
    (29, 2943.666, 2232.33),
    (30, 3012.4444, 828.929),(30, 9.4444, 88.999),
    (31, 3153.1234, 1.6343),(31, 45.444, 8.999),
	(32, 3245.1231, 43.2345),(32, 212.1231, 321.245),
    (33, 3345.6543, 31.134),(33, 432.6543, 543.124),
    (34, 3454.5432, 344.9876),
    (35, 3542.2222, 343.4444),
    (36, 3644.5555, 12.7777),
    (37, 3786.9999, 5.4444),
    (38, 3843.4567, 3.4321),(38, 123.567, 76.431),
    (39, 3966.6666, 44.3333),
    (40, 4012.4444, 6.9999),
    (41, 1234.44, 74.6543),(42, 5.1234, 2.6543),(42, 31.34, 42.63)


----------------------------------------------------------

-- Poniendo supervisores en empleado
SELECT * FROM empleados.empleado
UPDATE empleados.empleado
SET id_supervisor = 18
WHERE id_empleado IN (2,4,6,8,10)

UPDATE empleados.empleado
SET id_supervisor = 21
WHERE id_empleado IN (1,3,5,7,9)

UPDATE empleados.empleado
SET id_supervisor = 15
WHERE id_empleado IN (11,12,20)

UPDATE empleados.empleado
SET id_supervisor = 13
WHERE id_empleado IN (14,16,17,19)
---------------------------------------------------------

-- SELECT'S

SELECT * FROM empleados.administrador
SELECT * FROM empleados.agente
SELECT * FROM empleados.empleado
SELECT * FROM empleados.EMPLEADO_IDIOMA
SELECT * FROM empleados.historial_falta
SELECT * FROM empleados.idioma
SELECT * FROM empleados.mantenimiento
SELECT * FROM empleados.motivo

SELECT COUNT(*) FROM empleados.administrador
SELECT COUNT(*) FROM empleados.agente
SELECT COUNT(*) FROM empleados.empleado
SELECT COUNT(*) FROM empleados.EMPLEADO_IDIOMA
SELECT COUNT(*) FROM empleados.historial_falta
SELECT COUNT(*) FROM empleados.idioma
SELECT COUNT(*) FROM empleados.mantenimiento
SELECT COUNT(*) FROM empleados.motivo
----------------------------------------------------------

SELECT * FROM estacion.bicicleta
SELECT * FROM estacion.bicimantenimiento
SELECT * FROM estacion.color
SELECT * FROM estacion.estacion
SELECT * from estacion.terminal
SELECT * FROM estacion.modelo

SELECT COUNT(*) FROM estacion.bicicleta
SELECT COUNT(*) FROM estacion.bicimantenimiento
SELECT COUNT(*) FROM estacion.color
SELECT COUNT(*) FROM estacion.estacion
SELECT COUNT(*) from estacion.terminal
SELECT COUNT(*) FROM estacion.modelo
----------------------------------------------------------

SELECT * FROM usuarios.historial_viaje
SELECT * FROM usuarios.incidente
SELECT * FROM usuarios.membresia
SELECT * FROM usuarios.metodo_pago
SELECT * FROM usuarios.plan_seguro
SELECT * FROM usuarios.telefono
SELECT * FROM usuarios.tipo_membresia
SELECT * FROM usuarios.USUARIO
SELECT * FROM usuarios.viaje

SELECT count(*) FROM usuarios.historial_viaje
SELECT count(*) FROM usuarios.incidente
SELECT count(*) FROM usuarios.membresia
SELECT count(*) FROM usuarios.metodo_pago
SELECT count(*) FROM usuarios.plan_seguro
SELECT count(*) FROM usuarios.telefono
SELECT count(*) FROM usuarios.tipo_membresia
SELECT count(*) FROM usuarios.USUARIO
SELECT count(*) FROM usuarios.viaje
------------------------------------------------------------------
--ACTUALIZACIÓN 10 DE JUNIO DEL 2023
/*
	Tabla de tipo de incidentes es un catálogo que se hará uso en los registros de la tabla de incidente
	para así poder dar solución a la primer estadística
*/
INSERT INTO tipo_incidente VALUES
	(1, 'P. BICI', 'Problema al chocar con otra bicicleta'),
	(2, 'P. Coche', 'Problema al chocar con un coche'),
	(3, 'P. Moto', 'Problema al chocar con una moto'),
	(4, 'Caída', 'Caída debido a problemas externos'),
	(5, 'Otros', 'Problema sin especificaciones'),
	(6, 'P. PEATÓN', 'Problema al chocar/toparse con un peatón')

UPDATE usuarios.incidente 
SET idTipoInc = CASE 
	 WHEN tipo_incidente = 'P. BICI' THEN 1
	 WHEN tipo_incidente = 'P. COCHE' THEN 2
	 WHEN tipo_incidente = 'P. MOTO' THEN 3
	 WHEN tipo_incidente = 'Caída' THEN 4
	 WHEN tipo_incidente = 'Otros' THEN 5
	 WHEN tipo_incidente = 'P. Peatón'  THEN 6
	 END

ALTER TABLE usuarios.incidente
ADD FOREIGN KEY (idTipoInc) REFERENCES tipo_incidente (idTipoInc);

--ELIMINAMOS LA COLUMNA DEL TIPO DE INCIDENTE 
ALTER TABLE usuarios.incidente
DROP CONSTRAINT ck_tipoInc
ALTER TABLE usuarios.incidente
DROP COLUMN tipo_incidente

ALTER TABLE usuarios.incidente
DROP CONSTRAINT df_descripcion
ALTER TABLE usuarios.incidente
DROP COLUMN descripcion

ALTER SCHEMA usuarios TRANSFER dbo.tipo_incidente;


----------------------------------------------------------