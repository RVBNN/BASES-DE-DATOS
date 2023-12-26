-- tee AY_27sep.txt

## Ej1_27sep.sql

-- Cambiamos el prompt para mostrar base y fecha y mysql>
prompt (Ando en \d) mysql>

-- Borrar base 'ej_01'
drop DATABASE if EXISTS ej_01;

-- crear base 'ej_01'
CREATE DATABASE if not EXISTS ej_01;

-- crear tabla 'alumnos'
-- primero se habilita la tabla

use ej_01;

create table if not exists alumnos (
id int unsigned not null auto_increment primary key
);

-- mostramos la descripcion de la tabla alumnos
desc alumnos;

-- añadimos el campo nombre
alter table alumnos add (
nombre varchar(20) not null
);

-- se repite el mostrar la descripcion
desc alumnos;


-- añadir a la tabla 'alumnos' los campos de apellidos y fecha
alter table alumnos add (
apP varchar(20),
apM varchar(20),
feNac date default '1999-01-17'
);

-- se repite el mostrar la descripcion
desc alumnos; 

-- Renombramos la tabla alumnos a chicos
alter table alumnos rename to chicos;

-- Revisamos
show tables;

-- Borrar base 'ej_01'
-- drop DATABASE if EXISTS ej_01;

## Ej2_27sep.sql
-- EJERCICIO 2a

-- cambiar el prompt
prompt (\d: \\\D) mysql>

drop database if exists registro_coches;

create database if not exists registro_coches;

use registro_coches

drop table if exists accidente;

create table if not exists accidente(
id_accidente int NOT NULL primary key,
fecha_accidente date NOT NULL
);

drop table if exists informe_accidente;

create table if not exists informe_accidente(
id_informe int NOT NULL,
hora_accidente time,
direccion varchar(100),
primary key(id_informe),
constraint FK_accidente foreign key (id_informe) references accidente(id_accidente)
);

-- EJERCICIO 2b

use registro_coches

drop table if exists cliente;

create table if not exists cliente(
RFC char(12) NOT NULL unique,
CURP char(18) NOT NULL unique
);

ALTER TABLE cliente MODIFY column RFC char(12) NOT NULL unique primary key;

drop table if exists auto;

create table if not exists auto(
placa char(8) NOT NULL unique primary key,
num_serie char(18) NOT NULL unique,
RFC char(12) NOT NULL unique
);

ALTER TABLE auto ADD CONSTRAINT FK_cliente foreign key(RFC)
 references cliente(RFC) on delete cascade on update cascade;

desc cliente;
show create table cliente;

desc auto;
show create table auto;

-- EJERCICIO 2c

use registro_coches

desc auto;
desc accidente;

drop table if exists sufre_accidente;

create table if not exists sufre_accidente(
placa char(8) NOT NULL,
id_acc int NOT NULL,
primary key(placa, id_acc),
foreign key (placa) references auto(placa)
on delete restrict on update cascade ,
foreign key (id_acc) references accidente(id_accidente)
on delete cascade on update cascade
);

desc sufre_accidente;
show create table sufre_accidente;

-- ALTER CHANGE MODIFY

drop table if exists  mi_tabla;

use nombre_DB --o alguna
create table if not exists mi_tabla(
id int,
nombre char(5),
fac varchar(10)
);

desc mi_tabla;

ALTER table mi_tabla ALTER COLUMN nombre SET DEFAULT 'sofia';

desc mi_tabla;

ALTER table mi_tabla ALTER COLUMN nombre DROP DEFAULT;

ALTER table mi_tabla CHANGE COLUMN nombre nom VARCHAR(32) NOT NULL first;

desc mi_tabla;

ALTER table mi_tabla CHANGE COLUMN nom nom2 VARCHAR(32) NOT NULL AFTER fac;

desc mi_tabla;

ALTER TABLE mi_tabla MODIFY COLUMN fac text NOT NULL AFTER nom2;

drop table if exists mi_tabla;


-- notee





