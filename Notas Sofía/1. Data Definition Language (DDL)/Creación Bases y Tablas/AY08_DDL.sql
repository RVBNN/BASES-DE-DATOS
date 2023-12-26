-- PARTE 00

-- 2. Cambiar el prompt para que muestre la fecha y mysql>
-- tee C:\...\Ej_DDL_01.txt

-- 3. Cambiar el prompt para mostrar fecha y mysql>
prompt \\\D mysql>

-- 4. Cambiar el prompt para mostrar base y mysql>
prompt \d mysql>

-- 5. Crear la base 'Base_Datos_01' 
create DATABASE if not exists Base_Datos_01;

-- PARTE 01

-- 1. Mostrar las bases disponibles
show DATABASES;

-- 2. Borrar la base de datos ‘Base_Datos_01’ 
-- sin importar si existe o no.
drop DATABASE if exists Base_Datos_01;

-- 3. Crear la base de datos ‘Base_Datos_01’ sin importar si existe o no.
create DATABASE if not exists Base_Datos_01;

-- 4. Repetir el paso 3
create DATABASE if not exists Base_Datos_01;

-- 5. Repetir el paso 1.
show DATABASES;

-- 6. Repetir el paso 2.
drop DATABASE if exists Base_Datos_01;

-- 7. Repetir el paso 1.
show DATABASES;

-- PARTE 02

-- 1. Mostrar las bases disponibles
show DATABASES;

-- 2. Crear la base ‘Base_Datos_01’ sin importar si existe o no.
create DATABASE if not exists Base_Datos_01;

-- 3. Dentro de la base ‘Base_Datos_01’ la tabla Alumnos
-- y mostrar su descripción.
USE Base_Datos_01

create table if not exists Alumnos(
ID tinyint,
ApellidoP varchar(15) NOT NULL,
ApellidoM varchar(15),
FechaNac date,
Facultad VARCHAR(30) default 'Facultad de Ciencias'
);

DESC Alumnos;

-- 4. Mostrar el código con el que se creó la tabla Alumnos.
show create table Alumnos;

-- 5. Imprimir todas las tablas disponibles en ‘Base_Datos_01’.
show TABLES;

-- PARTE 03

-- 1. Borrar la base ‘Base_Datos_02’ sin importar si existe o no.
drop DATABASE if exists Base_Datos_02;

-- 2. Crear la base ‘Base_Datos_02’ sin importar si existe o no.
create DATABASE if not exists Base_Datos_02;

-- 3. Habilitar la base ‘Base_Datos_02’ crear la tabla Profesores.
use Base_Datos_02

create table if not exists Profesores(
ID int NOT NULL,
nombre VARCHAR(20),
ApellidoP varchar(20),
ApellidoM varchar(15)
);

desc Profesores;

-- PARTE 04

-- 1. Mostrar las bases de datos disponibles.
show DATABASES;

-- 2. Borrar la base ‘EJ_04’ sin importar si existe o no.
drop DATABASE if exists EJ_04;

-- 3. Crear la base ‘EJ_04’ sin importar si existe o no.
create DATABASE if not exists EJ_04;
 
-- 4. Crear la tabla ‘Estudiantes’ dentro de la base ‘EJ_04’.
create table if not exists Estudiantes(
ID int unsigned NOT NULL auto_increment primary key,
nombre varchar(20) NOT NULL,
apP VARCHAR(20),
apM VARCHAR(15),
feNac DATE default '1999-01-01'
);

-- 5. notee