/* 
===============================================
Creación de las tablas y relaciones para la
base de datos PIXUP

===============================================
*/

-- elimino la base de datos por si ya existia, esto sólo en caso de que quiera volver a tener la estructura
DROP DATABASE IF EXISTS pixup;

-- crea la base de datos pixup indicando el conjunto de caracteres por default
CREATE DATABASE IF NOT EXISTS pixup;

-- habilito la base de datos pixup
USE pixup

/*
-----------------------------------------
Crear las tablas del modelo, iniciando con 
las tablas padre o independientes
-----------------------------------------
*/

-- se crea la tabla usuario
create table usuario(
id tinyint unsigned not null auto_increment primary key,
nombre varchar(30) not null unique, 
contrasena varchar(64)
);

create table idioma(
id_idioma tinyint unsigned not null auto_increment primary key, 
nombre varchar(50) not null unique
);

create table version(
id_version tinyint unsigned not null auto_increment primary key, 
nombre varchar(50) not null unique
);

create table genero(
id_genero tinyint unsigned not null auto_increment primary key, 
nombre varchar(50) not null unique
);

create table cancion(
id_cancion int unsigned not null auto_increment primary key,
nombre varchar(100) not null unique
);

create table artista(
id_artista mediumint unsigned not null auto_increment primary key,
nombre varchar(100) not null unique,
descripcion text
);

create table pais(
id_pais smallint unsigned not null auto_increment primary key, 
nombre varchar(100) not null unique
);

-- se crea la tabla estado
create table estado(
clave char(2) not null primary key, 
nombre varchar(40) not null unique
);

/*
--------------------------------------------
| Se crean las tablas hijas o dependientes |
--------------------------------------------
*/

create table disquera(
id_disquera smallint unsigned not null auto_increment primary key,
nombre varchar(100) not null,
id_pais smallint unsigned not null,
unique key (id_pais,nombre),
foreign key (id_pais) references pais(id_pais) on update cascade
);

create table municipio(
clave char(5) not null primary key,
nombre varchar(100) not null,
clave_estado char(2) not null,
constraint FK_mun_edo foreign key(clave_estado) references estado(clave)
);

create table colonia(
id_colonia int unsigned not null auto_increment primary key,
nombre varchar(150) not null,
cp char(5) not null,
clave_mun char(5) not null,
unique key (clave_mun,cp,nombre),
foreign key(clave_mun) references municipio(clave)
);

create table direccion (
id_direccion int unsigned not null auto_increment primary key,
calle varchar(150) not null,
num_ext varchar(10) not null,
num_int varchar(10),
id_colonia int unsigned not null,
unique key(id_colonia,calle,num_ext,num_int),
foreign key (id_colonia) references colonia(id_colonia)
);

create table cliente (
id_cliente int unsigned not null auto_increment primary key,
nombre varchar(30) not null,
apellido_paterno varchar(30) not null,
apellido_materno varchar(30),
fecha_nacimiento date not null,
correo varchar(100) not null unique,
contrasena char(40) not null,
sexo enum('H','M'),
telefono varchar(10),
id_direccion int unsigned not null,
unique key (nombre,apellido_paterno,apellido_materno),
foreign key(id_direccion) references direccion(id_direccion)
);

create table disco (
id_disco int unsigned not null auto_increment primary key,
titulo varchar(100) not null unique,
fecha_lanzamiento date not null,
precio decimal(6,2) not null,
cantidad_disponible int unsigned not null default 10,
portada varchar(100),
id_disquera smallint unsigned not null,
constraint FK_disco_disquera foreign key(id_disquera) references disquera(id_disquera) on update cascade
);

create table ticket(
id_ticket int unsigned not null auto_increment primary key,
fecha timestamp not null,
total decimal default 0,
id_cliente int unsigned not null,
unique key (id_ticket,id_cliente),
foreign key(id_cliente) references cliente(id_cliente)
);

/*
--------------------------------------------
|    Se crean las tablas muchos a muchos   |
--------------------------------------------
*/

-- el uso de constraint es opcional, es solo para darle un nombre a las llaves
create table disco_cancion (
id_disco int unsigned not null,
id_cancion int unsigned not null,
id_artista mediumint unsigned not null,
id_genero tinyint unsigned not null,
id_idioma tinyint unsigned not null,
id_version tinyint unsigned not null,
duracion time not null,
primary key(id_disco,id_cancion,id_artista,id_genero,id_idioma,id_version,duracion),
foreign key(id_disco) references disco(id_disco) on delete cascade on update cascade,
foreign key(id_cancion) references cancion(id_cancion) on delete restrict on update cascade,
foreign key(id_artista) references artista(id_artista) on delete restrict on update cascade,
foreign key(id_genero) references genero(id_genero) on delete restrict on update cascade,
foreign key(id_idioma) references idioma(id_idioma) on delete restrict on update cascade,
foreign key(id_version) references version(id_version) on delete restrict on update cascade
);

create table detalle_ticket(
id_ticket int unsigned not null,
id_disco int unsigned not null,
cantidad tinyint unsigned default 1,
subtotal decimal default 0,
unique key(id_ticket,id_disco),
foreign key (id_ticket) references ticket(id_ticket) on delete cascade on update cascade,
foreign key (id_disco) references disco(id_disco) on delete restrict on update cascade
);


