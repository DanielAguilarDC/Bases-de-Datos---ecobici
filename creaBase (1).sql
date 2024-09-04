/*
	*Proyecto: Ecobici
	*Autores: Daniel Aguilar
			  Gonzalez Sotelo Elías Eduardo
			  Velazquez Martinez Karla Andrea
	*Facultad de Ingeniería UNAM
	*Profesora: Martha Lopez Pelcastre
	*Bases de datos: Grupo 02
	*Equipo: 3
*/


--CREACIÓN DE LA BASE DE DATOS
CREATE DATABASE ecobici

-------------------------------------------------------------------------------------------------------------------------
/* 
 * TABLE: USUARIO 
*/

CREATE TABLE USUARIO(
    id_usuario         int				NOT NULL IDENTITY(1,1),
    app_saldo          bit              NOT NULL,
    materno            varchar(10)      NOT NULL,
    nombre             varchar(15)      NOT NULL,
    paterno            varchar(10)      NOT NULL,
    fecha_nac          date             NOT NULL,
    correo             varchar(50)      NOT NULL,
    codigo_ine         varchar(9)       NOT NULL,
    genero             char(1)			NOT NULL constraint ck_Genero check (genero in ('H','M','O')),
    CONSTRAINT PK1 PRIMARY KEY NONCLUSTERED (id_usuario)
)
go
ALTER TABLE USUARIO
ADD edad AS DATEDIFF(YEAR, fecha_nac, GETDATE()) 

ALTER TABLE USUARIO 
ADD CONSTRAINT uq_correo UNIQUE(correo)

ALTER TABLE USUARIO 
ADD CONSTRAINT uq_codigo_ine UNIQUE(codigo_ine)

ALTER TABLE USUARIO
ADD CONSTRAINT ck_codigo_ine CHECK (codigo_ine LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')

-------------------------------------------------------------------------------------------------------------------------
/*
 *TABLE: telefono
*/

CREATE TABLE telefono(
    id_telefono      int			NOT NULL IDENTITY(1,1),
    id_usuario       int			NOT NULL,
    tel				 varchar(10)    NOT NULL,
    CONSTRAINT PK2 PRIMARY KEY CLUSTERED (id_telefono),
	CONSTRAINT fk_id_usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
		ON DELETE CASCADE
		ON UPDATE CASCADE
)
go
ALTER TABLE telefono
ADD CONSTRAINT uq_telefono UNIQUE(tel)

ALTER TABLE telefono
ADD CONSTRAINT ck_telefono_usuario CHECK (tel LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')


-------------------------------------------------------------------------------------------------------------------------


/* 
 * TABLE: metodo_pago
 */

CREATE TABLE metodo_pago(
    id_pago                int				 NOT NULL IDENTITY(1,1),
    activo                 bit               NOT NULL,
    tipo_pago              varchar(30)		 NOT NULL constraint ck_tipoPago check (tipo_pago in ('CREDITO','DEBITO','PAYPAL')),
    id_usuario             int				 NOT NULL,
    CONSTRAINT PK3 PRIMARY KEY CLUSTERED (id_pago),
	CONSTRAINT fk_id_usuario_metodoPago FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
		ON DELETE CASCADE
		ON UPDATE CASCADE
)
go
CREATE NONCLUSTERED INDEX idx_id_usuario
ON metodo_pago (id_usuario);
-------------------------------------------------------------------------------------------------------------------------
/* 
 * TABLE: tipo_membresia 
*/
CREATE TABLE tipo_membresia(
    id_tipo       int					NOT NULL IDENTITY(1,1),
    tipo          char(1)				NOT NULL CONSTRAINT ck_tipo CHECK (tipo in ('B','I','P')), -- BÁSICA, INTERMEDIA, PREMIUM
    costo	      int					 NULL,
	CONSTRAINT PK4 PRIMARY KEY CLUSTERED (id_tipo)
)
go
ALTER TABLE tipo_membresia
ADD CONSTRAINT uq_tipo UNIQUE(tipo)



-------------------------------------------------------------------------------------------------------------------------
/* 
 * TABLE: membresia 
 */

CREATE TABLE membresia(
    id_membresia             int				NOT NULL IDENTITY(1,1),
    fecha                    date				NOT NULL,
    id_tipo                  int				NOT NULL, 
    precio_tarjeta			 money				NOT NULL CONSTRAINT CHK_ValoresPermitidos CHECK (precio_tarjeta IN (50.00, 80.00)),
    codigoQR				 numeric(20, 5)		NOT NULL,
    id_pago                 int					NOT NULL,
    CONSTRAINT PK5 PRIMARY KEY CLUSTERED (id_membresia),
	CONSTRAINT fk_id_tipoMembresia FOREIGN KEY (id_tipo) REFERENCES tipo_membresia(id_tipo)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_id_pago FOREIGN KEY (id_pago) REFERENCES metodo_pago(id_pago)
		ON DELETE CASCADE
		ON UPDATE CASCADE,

)
go
ALTER TABLE membresia
ADD CONSTRAINT uq_codigoQR UNIQUE(codigoQR)

go
ALTER TABLE membresia --Relación uno a uno, conservando unicidad
ADD CONSTRAINT uq_id_pago UNIQUE(id_pago)


ALTER TABLE membresia
ADD beneficio AS (
		CASE
            WHEN id_tipo = 1 THEN 'Descuento'
            WHEN id_tipo = 2 THEN 'Viaje'
            WHEN id_tipo = 3 THEN 'Cashback'
        END
)


ALTER TABLE membresia
ADD duracionDiasSuscripcion AS (
        CASE
            WHEN id_tipo = 1 THEN 1
            WHEN id_tipo = 2 THEN 30
            WHEN id_tipo = 3 THEN 365
        END
)
-------------------------------------------------------------------------------------------------------------------------

/* 
 * TABLE: EMPLEADO 
 */
CREATE TABLE empleado(
    id_empleado					  int			    NOT NULL IDENTITY(1,1),
    id_supervisor                 int			    NULL,
	-- M: Mantenimiento, G: Agente, A: Administrador, R: Recursos humanos
    tipo_empleado				  char(1)           NOT NULL CONSTRAINT ck_tipoEmpleado CHECK (tipo_empleado in ('M','G','A','R')), 
    genero						  char(1)			NOT NULL constraint ck_GeneroEmpleado check (genero in ('H','M','O')),
    nombre                        varchar(20)       NOT NULL,
    paterno                       varchar(10)       NOT NULL,
    materno                       varchar(10)       NOT NULL,
    calle                         varchar(15)       NOT NULL,
    colonia                       varchar(15)       NOT NULL,
    alcaldia                      varchar(15)       NOT NULL,
    num_ext                       int               NOT NULL,
    num_int	                      int               NOT NULL,
    telefono		              varchar(10)       NOT NULL CONSTRAINT uq_telefonoEmp UNIQUE,
    rfc							  varchar(13)       NOT NULL CONSTRAINT uq_rfc UNIQUE,
    sueldo                        money             NOT NULL,
    estado_civil				  varchar(11)       NOT NULL constraint ck_estadoCivil check (estado_civil in ('SOLTERO','CASADO','VIUDO','DIVORCIADO')),
    edad                          int               NOT NULL,
    CONSTRAINT PK6 PRIMARY KEY NONCLUSTERED (id_empleado),
	CONSTRAINT fk_Supervisor_Empleado FOREIGN KEY (id_supervisor) REFERENCES empleado(id_empleado)

)
go
ALTER TABLE empleado
ADD CONSTRAINT ck_telefono_empleado CHECK (telefono LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
-------------------------------------------------------------------------------------------------------------------------

/* 
 * TABLE: idioma 
*/

CREATE TABLE idioma(
    id_idioma		int					NOT NULL IDENTITY(1,1),
    idioma			varchar(20)			NOT NULL,
    CONSTRAINT PK7 PRIMARY KEY CLUSTERED (id_idioma)
)
go
ALTER TABLE idioma
ADD CONSTRAINT uq_idioma UNIQUE(idioma)
-------------------------------------------------------------------------------------------------------------------------

/* 
 * TABLE: EMPLEADO_IDIOMA 
 */

CREATE TABLE EMPLEADO_IDIOMA(
    id_empleado    int    NOT NULL,
    id_idioma      int    NOT NULL,
    CONSTRAINT PK8 PRIMARY KEY CLUSTERED (id_empleado, id_idioma),
	CONSTRAINT fk_idempleado FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT fk_idioma FOREIGN KEY (id_idioma) REFERENCES idioma(id_idioma)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
)
go
-------------------------------------------------------------------------------------------------------------------------
/* 
 * TABLE: motivo 
*/

CREATE TABLE motivo(
    id_motivo      int			NOT NULL IDENTITY(1,1),
    causa  varchar(30)		    NOT NULL CONSTRAINT uq_causa UNIQUE,
    CONSTRAINT PK9 PRIMARY KEY CLUSTERED (id_motivo)
)
go
-------------------------------------------------------------------------------------------------------------------------


/* 
 * TABLE: historial_falta 
 */

CREATE TABLE historial_falta(
    consecutivo    int              IDENTITY(1,1),  --Para ver el número consecutivo por cada empleado se usará la función ROW_NUMBER() Al usar el select
    id_empleado    int				NOT NULL,
    id_motivo      int				NOT NULL,
    fecha          date             NOT NULL,
    CONSTRAINT PK10 PRIMARY KEY NONCLUSTERED (consecutivo, id_empleado),
	CONSTRAINT fk_idempleadoFalta FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_motivoFalta FOREIGN KEY (id_motivo) REFERENCES motivo(id_motivo)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
)
go
-------------------------------------------------------------------------------------------------------------------------

/* 
 * TABLE: agente 
 */

CREATE TABLE agente(
    id_empleado    int   NOT NULL,
    CONSTRAINT PK11 PRIMARY KEY CLUSTERED (id_empleado),
	CONSTRAINT fk_empleadoAgente FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
)
go
-------------------------------------------------------------------------------------------------------------------------
/* 
 * TABLE: administrador 
 */

CREATE TABLE administrador(
    id_empleado			  int				NOT NULL,
	descripcionfuncion    char(100)         NOT NULL,
    tipo_trabajo          varchar(20)       NOT NULL,
    ubicacion             varchar(40)       NOT NULL,
    CONSTRAINT PK12 PRIMARY KEY CLUSTERED (id_empleado),
	CONSTRAINT fk_empleadoAdmin FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
)
go

-------------------------------------------------------------------------------------------------------------------------

/* 
 * TABLE: mantenimiento 
*/

CREATE TABLE mantenimiento(
	id_empleado    int   NOT NULL,
    especialidad    varchar(20)       NOT NULL,
    CONSTRAINT PK13 PRIMARY KEY CLUSTERED (id_empleado),
	CONSTRAINT fk_empleadoMant FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
)
go
-------------------------------------------------------------------------------------------------------------------------
/* 
 * TABLE: plan_seguro 
 */

CREATE TABLE plan_seguro(
    id_seguro                     int    NOT NULL identity(1,1),
    tipo_cobertura				  varchar(50),
    id_tipo					      int	 NOT NULL,
    CONSTRAINT PK14 PRIMARY KEY CLUSTERED (id_seguro),
	CONSTRAINT fk_tipoMem FOREIGN KEY (id_tipo) REFERENCES tipo_membresia(id_tipo)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
)
go

-------------------------------------------------------------------------------------------------------------------------

/* 
 * TABLE: color 
*/

CREATE TABLE color(
    id_color             int				NOT NULL identity(1,1),
    color				varchar(20)			NOT NULL CONSTRAINT uq_color UNIQUE,
    CONSTRAINT PK15		PRIMARY KEY CLUSTERED (id_color)
)
go

-------------------------------------------------------------------------------------------------------------------------

/* 
 * TABLE: estacion 
 */

CREATE TABLE estacion(
    id_estacion    int				 NOT NULL IDENTITY(1,1),
	nombre		  varchar(45)        NOT NULL CONSTRAINT uq_nombre UNIQUE,
    ubicacion      varchar(45)       NOT NULL,
    id_empleado    int				 NOT NULL,
    CONSTRAINT PK16 PRIMARY KEY CLUSTERED (id_estacion),
	CONSTRAINT fk_empleadoAdminEstacion FOREIGN KEY (id_empleado) REFERENCES administrador(id_empleado)
)
go
-------------------------------------------------------------------------------------------------------------------------
/* 
 * TABLE: terminal 
 */
CREATE TABLE terminal(
    consecutivo			  int		NOT NULL,
    id_estacion           int		NOT NULL,
    descripcion           varchar(25)       NOT NULL,
    CONSTRAINT PK17 PRIMARY KEY CLUSTERED (consecutivo, id_estacion),
	CONSTRAINT fk_id_estacion FOREIGN KEY (id_estacion) REFERENCES estacion(id_estacion)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
)
go

-------------------------------------------------------------------------------------------------------------------------

/* 
 * TABLE: modelo 
 */

CREATE TABLE modelo (
	id_modelo int NOT NULL primary key,
	modelo varchar(20) NOT NULL Constraint uq_mod UNIQUE
)
-------------------------------------------------------------------------------------------------------------------------
/* 
 * TABLE: bicicleta 
 */
CREATE TABLE bicicleta(
    id_bicicleta         int				NOT NULL IDENTITY(1,1),
    id_color             int				NOT NULL,
    id_modelo            int				NOT NULL,
    nserie               varchar(15)		NOT NULL CONSTRAINT uq_nserie UNIQUE,
    tamaño				 varchar(10)		NOT NULL CONSTRAINT ck_tamaño check (tamaño in ('Chica','Mediana','Grande')),
    estado               varchar(15)        NOT NULL CONSTRAINT ck_estado check (estado in ('D','F','B')), --D: DAÑADA, F:FUNCIONAL, B: BAJA
    id_estacion          int				NOT NULL,
    CONSTRAINT PK18 PRIMARY KEY NONCLUSTERED (id_bicicleta),
	CONSTRAINT fk_color FOREIGN KEY (id_color) REFERENCES color(id_color)
		ON UPDATE CASCADE,
	CONSTRAINT fk_modelo FOREIGN KEY (id_modelo) REFERENCES modelo(id_modelo),
	CONSTRAINT fk_NumEstacion FOREIGN KEY (id_estacion) REFERENCES estacion(id_estacion)
		ON DELETE CASCADE
		ON UPDATE CASCADE
)
go


--------------------------------------------------------------------------------------------------------------------------
/* 
 * TABLE: bici_mantenimiento 
 */
CREATE TABLE bicimantenimiento(
    id_mantenimiento    int		          NOT NULL identity(1,1),
    id_empleado         int               NOT NULL,
    id_bicicleta        int				  NOT NULL,
    fecha               date              NOT NULL,
    descripcion         varchar(100)       NULL,
	servicio            varchar(20)      NOT NULL CONSTRAINT ck_servicio CHECK (servicio in('REPARACIÓN','LIMPIEZA','TRANSPORTE'))
    CONSTRAINT PK19 PRIMARY KEY CLUSTERED (id_mantenimiento),
	CONSTRAINT fk_empleadoMantenimiento FOREIGN KEY (id_empleado) REFERENCES mantenimiento(id_empleado),
	CONSTRAINT fk_bicicletaMantenimiento FOREIGN KEY (id_bicicleta) REFERENCES bicicleta(id_bicicleta)

)
go

-------------------------------------------------------------------------------------------------------------------------


/* 
 * TABLE: viaje 
 */
CREATE TABLE viaje(
    id_viaje            int				  NOT NULL IDENTITY(1,1),
    id_bicicleta        int			      NOT NULL,
    id_usuario          int			      NOT NULL,
    hora_fin            time			  NOT NULL,
    hora_ini            time		      NOT NULL,
    hora_llegada        time	          NOT NULL,
    fecha               date              NOT NULL,
    ruta                varchar(100)       NOT NULL,
    estacionPartida     int               NOT NULL,
    estacionLlegada     int               NOT NULL,
    CONSTRAINT PK21 PRIMARY KEY NONCLUSTERED (id_viaje),
	CONSTRAINT fk_id_bicicletaViaje FOREIGN KEY (id_bicicleta) REFERENCES bicicleta(id_bicicleta),
	CONSTRAINT fk_id_usuarioViaje FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_estacionPartida FOREIGN KEY (estacionPartida) REFERENCES estacion(id_estacion),
	CONSTRAINT fk_estacionLlegada FOREIGN KEY (estacionLlegada) REFERENCES estacion(id_estacion)
)
go

ALTER TABLE viaje
ADD tarifa AS (
		CASE
            WHEN hora_llegada < hora_fin THEN 0
            ELSE
				5 * FLOOR(         DATEDIFF(MINUTE, hora_fin, hora_llegada) /10   )
        END
)

-------------------------------------------------------------------------------------------------------------------------

/* 
 * TABLE: incidente 
 */
CREATE TABLE incidente(
    id_incidente int NOT NULL IDENTITY(1,1),
    id_empleado        int			     NOT NULL,
    tipo_incidente     varchar(50)       NOT NULL CONSTRAINT ck_tipoInc CHECK(tipo_incidente in('P. BICI','P. COCHE', 'P. MOTO', 'P. Peatón', 'Caída', 'Otros')),
    hora               time              NOT NULL, 
	fecha			   date              NULL, --IMPLEMENTAR TRIGGER PARA ACTUALIZAR FECHAS
    coordenadas        varchar(30)       NOT NULL,
    calle              varchar(20)       NOT NULL,
    numero             int               NOT NULL,
    codigoPostal       char(5)           NOT NULL CONSTRAINT CK_CodigoPostal CHECK (LEN(codigoPostal) = 5),
    alcaldia           varchar(20)       NOT NULL,
    colonia            varchar(20)       NOT NULL,
    descripcion        varchar(50)       NOT NULL,
	id_viaje		   int				 NOT NULL UNIQUE,
    CONSTRAINT PK20 PRIMARY KEY CLUSTERED (id_incidente),
	CONSTRAINT fk_empleadoAgenteIncidente FOREIGN KEY (id_empleado) REFERENCES agente(id_empleado)
		ON UPDATE CASCADE,
	CONSTRAINT fk_idViajeIncidente FOREIGN KEY (id_viaje) REFERENCES viaje(id_viaje)
)
go
ALTER TABLE incidente
ADD CONSTRAINT df_descripcion DEFAULT 'Incidente' FOR descripcion

-------------------------------------------------------------------------------------------------------------------------
/* 
 * TABLE: HISTORIAL_VIAJE 
 */

CREATE TABLE historial_viaje(
    id_viajeH          int				NOT NULL IDENTITY(1,1),
    id_viaje           int				NOT NULL,
	latitud            decimal(12,4)	NOT NULL,
    longitud		   decimal(12,4)      NOT NULL,
    CONSTRAINT PK22 PRIMARY KEY CLUSTERED (id_viajeH),
	CONSTRAINT fk_idViajeHistorico FOREIGN KEY (id_viaje) REFERENCES viaje(id_viaje)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
)
go

-------------------------------------------------------------------------------------------------------------------------


--Correr esquema por separado
go
CREATE SCHEMA usuarios AUTHORIZATION DBO
go
CREATE SCHEMA estacion AUTHORIZATION DBO
go 
CREATE SCHEMA empleados AUTHORIZATION DBO
go

--AGREGANDO CADA TABLA A SUS RESPECTIVOS ESQUEMAS
ALTER SCHEMA usuarios TRANSFER dbo.usuario;
ALTER SCHEMA usuarios TRANSFER dbo.tipo_membresia;
ALTER SCHEMA usuarios TRANSFER dbo.telefono;
ALTER SCHEMA usuarios TRANSFER dbo.metodo_pago;
ALTER SCHEMA usuarios TRANSFER dbo.incidente;
ALTER SCHEMA usuarios TRANSFER dbo.viaje;
ALTER SCHEMA usuarios TRANSFER dbo.plan_seguro;
ALTER SCHEMA usuarios TRANSFER dbo.membresia;
ALTER SCHEMA usuarios TRANSFER dbo.historial_viaje


ALTER SCHEMA estacion TRANSFER dbo.estacion;
ALTER SCHEMA estacion TRANSFER dbo.color;
ALTER SCHEMA estacion TRANSFER dbo.bicimantenimiento;
ALTER SCHEMA estacion TRANSFER dbo.bicicleta;
ALTER SCHEMA estacion TRANSFER dbo.terminal;
ALTER SCHEMA estacion TRANSFER dbo.modelo;


ALTER SCHEMA empleados TRANSFER dbo.administrador;
ALTER SCHEMA empleados TRANSFER dbo.empleado;
ALTER SCHEMA empleados TRANSFER dbo.empleado_idioma;
ALTER SCHEMA empleados TRANSFER dbo.historial_falta;
ALTER SCHEMA empleados TRANSFER dbo.mantenimiento;
ALTER SCHEMA empleados TRANSFER dbo.motivo;
ALTER SCHEMA empleados TRANSFER dbo.idioma;
ALTER SCHEMA empleados TRANSFER dbo.agente;

-----------------------------------------------------------------------------------------------------------
--ACTUALIZACIÓN 10 DE JUNIO DE 2023: ADICIÓN DE NUEVA TABLA
CREATE  TABLE tipo_incidente (
	idTipoInc int primary key,
	tipo varchar(30) unique,
	descripcion varchar(60)
)


ALTER TABLE usuarios.incidente
ADD idTipoInc int

