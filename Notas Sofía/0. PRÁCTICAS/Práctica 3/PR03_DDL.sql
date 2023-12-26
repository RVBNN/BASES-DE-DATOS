## Parte 1 - Ejercicios DDL

-- 1.	Cambiar el prompt al siguiente formato:
prompt [\w\O \R:\m] (\d) ~>

-- 2.	Crear una base de datos llamada ‘pr03_eqN’
drop database if exists pr03_solucion;

create database if not exists pr03_solucion;

-- 3.	Crear la tabla ‘trabajador’
use pr03_solucion

drop table if exists trabajador;

create table if not exists trabajador(
id int unsigned not null primary key,
nombre_pila varchar(10),
puesto varchar(15)
);

desc trabajador;

-- 4.	Crear tabla ‘ingrediente’
drop table if exists ingrediente;

create table if not exists ingrediente(
codigo tinyint unsigned not null auto_increment primary key,
nombre varchar(20) not null,
precio_kg decimal(3,1),
disponibilidad enum('D','ND') NOT NULL default 'ND'
);

desc ingrediente;


/* 5.	De cada trabajador nos interesa conocer cuál es su ingrediente favorito. 
Los trabajadores sólo pueden optar por un ingrediente, pero varios pueden elegir el 
mismo. Es obligatorio que los trabajadores informen qué ingrediente prefieren.

A través del comando alter, relacionar la tabla ‘trabajador’ con la tabla ‘ingrediente’
respetando lo anterior y agregar los nuevos campos */
alter table trabajador alter column puesto set default 'pasante';

alter table trabajador add fecha_inicio date default '2022-09-30' after nombre_pila;

alter table trabajador add ing_fav tinyint unsigned not null;

alter table trabajador add foreign key (ing_fav) references ingrediente(codigo);

desc trabajador;


## Ejercicios extra

-- 1.	Enuncien tres maneras para fijar un campo como llave primaria de una tabla.

CREATE TABLE T1 (id_1 int PRIMARY KEY);

CREATE TABLE T2 (id_2 int, PRIMARY KEY(id_2)); 

CREATE TABLE T3 (id_3 int);
ALTER TABLE T3 MODIFY id_3 tinyint PRIMARY KEY;

CREATE TABLE T4 (id_4 int);
ALTER TABLE T4 ADD PRIMARY KEY (id_4);

-- 2.	Los 7 errores ya corregidos:
create table if not exists ej_extra (
	atributo1 smallint unsigned,
	atributo4 int not null auto_increment,
	atributo2 year default 1997,
	atributo6 varchar(50),
primary key(atributo4,atributo6)
);

/* Los errores enlistados:
1. Para crear tablas necesitamos ‘if NOT exists’
2. Falta indicar el nombre de la tabla
3. Para el campo atributo4 no se especificó un tipo de dato
4. auto_increment, i.e., lleva un guión bajo entre las dos palabras
5. Valor a fijar por default para atributo2 es inválido. Sólo acepta formato YYYY o YY.
6. No es posible definir una llave primaria compuesta así. Hay que agregar 
primary key(atributo1, atributo 6)
7. Falta el paréntesis de cierre.
*/

-- drop database if exists pr03_solucion;

