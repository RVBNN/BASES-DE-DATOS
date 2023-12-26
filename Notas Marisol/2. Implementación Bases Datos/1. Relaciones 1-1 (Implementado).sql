-- línea para cambiar el prompt de mysql
prompt (BD:\d \\\D) mysql> 

DROP DATABASE IF EXISTS tienda; -- elimina la base de datos si ya existe.

-- comandos para crear los tipos de relaciones

create database IF not exists tienda; -- crea la base de datos tienda

use tienda -- habilita la base de datos tienda para trabajar en ella

-- los siguientes comandos son para crear tablas en la base de datos
-- crea la tabla producto (tabla padre) con 3 atributos
create table producto (
id int unsigned not null auto_increment primary key,
nombre varchar(30) not null unique,
precio decimal(6,2) not null default 9.99
);

desc producto; -- muestra la descripción de la tabla productos
show create table producto; -- muestra la estructura de la creación de la tabla productos

-- crea la tabla empleados con 4 atributos y con llaves únicas
create table empleado(
id smallint unsigned not null auto_increment,
nombre varchar(30) not null,
apellido1 varchar(30) not null,
apellido2 varchar(30),
primary key(id),
unique key(nombre,apellido1,apellido2)
);

/* =======================================================
---- Ejemplos relación uno a uno ----- 
==========================================================
*/
-- se crea la tabla productos_detalles (tabla hija) que será la relación uno a uno con la tabla producto
CREATE TABLE producto_detalles (
id_producto INT UNSIGNED NOT NULL,
descripcion VARCHAR(100) NOT NULL,
fecha_registro DATE NOT NULL,
cantidad smallint unsigned not null,
PRIMARY KEY (id_producto),
FOREIGN KEY (id_producto) REFERENCES producto (id)
);


/* ---- relación uno a uno (entre la tabla empleado y sucursal) ----- */
create table sucursal(
id_gerente smallint unsigned not null,
nombre varchar(30) not null unique,
fecha_apertura date not null,
primary key(id_gerente),
FOREIGN KEY (id_gerente) REFERENCES empleado(id)
);
