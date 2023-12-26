

# 1.
prompt [\w\O \r:\m] (\d) ~>

# 2.
DROP DATABASE IF EXISTS pr03_eq09;

CREATE DATABASE IF NOT EXISTS pr03_eq09;

USE pr03_eq09;

# 3.
CREATE TABLE trabajador(
	id int unsigned auto_increment not null primary key,
nombre_pila varchar(10),
puesto varchar(15)
);

DESC trabajador;

# 4.
CREATE TABLE ingrediente( 
codigo tinyint unsigned auto_increment not null primary key,
nombre varchar(20),
precio_kg decimal(3,1),
disponibilidad enum('D','ND') default 'ND' 
);
DESC ingrediente;

# 5.
ALTER TABLE trabajador 
ADD fecha_inicio date DEFAULT  '2022-09-30' AFTER nombre_pila;

ALTER TABLE trabajador 
ADD ing_fav tinyint unsigned not null AFTER puesto;

ALTER TABLE trabajador 
ALTER puesto SET DEFAULT 'pasante';

ALTER TABLE trabajador 
ADD FOREIGN KEY(ing_fav) REFERENCES ingrediente(codigo) ON DELETE RESTRICT ON UPDATE CASCADE;

DESC trabajador; 
# 6.
CREATE TABLE IF NOT EXISTS paciente(
	id_paciente int unsigned not null,
	id_dueno int unsigned not null,
nombre varchar(30) not null,
	raza varchar(30) not null,
	color varchar(30) not null,
	edad smallint not null,
	padecimiento varchar(200) not null,
	alergia varchar(200) not null
);

CREATE TABLE IF NOT EXISTS dueno(
id_dueno int unsigned not null,
nombre varchar(30) not null, 
telefono int unsigned not null,
email varchar(50) not null unique,
calle varchar(100) unique,
	codigo_postal int(5) unsigned
); 

CREATE TABLE IF NOT EXISTS consulta(
	id_consulta int unsigned not null,
	id_paciente int unsigned not null,
	fecha_consulta date not null,
	fecha_siguiente_consulta date not null,
	motivo varchar(200) not null
);

CREATE TABLE IF NOT EXISTS consulta_tratamiento(
id_consulta int unsigned not null,
	id_tratamiento int unsigned not null
);

CREATE TABLE IF NOT EXISTS tratamiento(
	id_tratamiento int unsigned not null,
	nombre varchar(30) not null,
	precio decimal(6,2) not null
);

# Esta última tabla(6) es la que hace que esté completo nuestro DER
CREATE TABLE IF NOT EXISTS usuario(
id_usuario int unsigned not null,
nombre varchar(30) not null,
contrasena varchar(50) not null
); 


# 7. RELACION 1:M, M:M & AJUSTE DE LLAVES
ALTER TABLE dueno
ADD PRIMARY KEY(id_dueno);

ALTER TABLE paciente
ADD PRIMARY KEY(id_paciente),
ADD CONSTRAINT FK_paciente_dueno FOREIGN KEY(id_dueno) REFERENCES dueno(id_dueno) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE consulta
ADD PRIMARY KEY(id_consulta),
ADD CONSTRAINT FK_paciente_consulta FOREIGN KEY(id_paciente) REFERENCES paciente(id_paciente) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE tratamiento
ADD PRIMARY KEY(id_tratamiento);

# 8. IMPLEMENTACIÓN RELACIÓN M:M
ALTER TABLE consulta_tratamiento
ADD PRIMARY KEY(id_consulta, id_tratamiento),
ADD FOREIGN KEY(id_consulta) REFERENCES consulta(id_consulta) ON DELETE RESTRICT ON UPDATE CASCADE,
ADD FOREIGN KEY(id_tratamiento) REFERENCES tratamiento(id_tratamiento) ON DELETE RESTRICT ON UPDATE CASCADE;

drop database pr03_eq09;


/*  
EJERCICIOS EXTRA

1. Enuncien tres maneras para fijar un campo como llave primaria de una tabla. 

Forma 1: En la creación de la tabla:

CREATE TABLE nombre_tabla(
	atributo1 int not null PRIMARY KEY
	atributo2 tipo_dato,
	atributo3 tipo_dato,
	…
	atributoN tipo dato
);

Forma 2: En la creación de la tabla siendo específicos:

CREATE TABLE nombre_tabla(
	atributo1 tipo_dato
	atributo2 tipo_dato,
	atributo3 tipo_dato,
	…
	atributoN tipo dato,
	PRIMARY KEY(atributo1, atributoK)
);

Forma 3: Alterando la tabla en la que no exista una llave primaria previamente definida:

ALTER TABLE nombre_tabla
ADD atributoK tipo_dato PRIMARY KEY;

2. Identifiquen los 7 errores en el siguiente código: 
create table if exists ( 
atributo1 smallint unsigned, 
atributo4 not null auto increment primary key, 
atributo2 year default ‘1997-01-02’, 
atributo6 varchar(50) primary key;

Tabla corregida sin los 7 errores:
create table if not exists nombre_tabla(
	atributo1 smallint unsigned,
	atributo4 tipo_dato not null auto_increment,
	atributo2 date default '1997-01-02',
atributo6 varchar(50),
PRIMARY KEY(atributo4, atributo6)
);

*/
