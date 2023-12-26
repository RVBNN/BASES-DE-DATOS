-- comandos para crear base de datos (esta línea es un comentario que será ignorado por mysql, inicia con dos guiones juntos y espacio)
/* comentarios  */

-- línea para cambiar el prompt de mysql
prompt (BD:\d \\\D) mysql> 


show databases; -- muestra las bases de datos existentes en la máquina
create database if not exists ejemplo1; -- crea la base de datos si no existe
create database if not exists ejemplo2; 
create database if not exists ejemplo3;

USE ejemplo1; -- habilitar la base de datos

-- Borrar una base de datos si es que existe
DROP DATABASE if exists ejemplo2;

-- Mostrar las bases de datos:
show databases;

-- Habilitar la base de datos:
use ejemplo3;

-- Mostrar cómo fue creada una BD
SHOW CREATE DATABASE ejemplo1;

-- Mostrar listado de codificaciones
SHOW CHARACTER SET;

CREATE DATABASE ejemplo2 DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci; 

-- Mostrar cómo fue creada la BD 
SHOW CREATE DATABASE ejemplo2; 
SHOW CREATE DATABASE ejemplo1;

-- Mostrar las tablas de la base de datos: 
show tables;
-- Habilitar la base de datos a usar: 
use ejemplo1;

-- Crear la tabla usuarios
CREATE TABLE usuarios(
id int, nombre varchar(30), rfc char(13));

-- Mostrar las tablas de la BD: 
SHOW TABLES;

show create table usuarios; -- muestra la estructura de cómo fue creada la tabla usuarios
desc usuarios; -- muestra los atributos de la tabla usuarios
drop table usuarios; -- borra la tabla usuarios

-- Ejercicio en clase
-- crear la base de datos almacen
create database almacen;

-- mostrar las bases
show databases;

-- habilitar la base de datos almacen
use almacen

-- crear las tablas
create table fabricante(clave_fabricante char(10),
nombre varchar(30)
);

create table articulo(clave_articulo char(5),
nombre varchar(30),
precio decimal
);