/* Abrimos un tee \! cls*/
-- tee F:\Pejcovich\BBDD\Semana 10\AY11_INSERT\AY11_Insert.txt

\! cls
/* Cambiamos el prompt */
prompt [\w\O \R:\m] (\d) ~>

/* ---------------------------------------------------------------------------------------------------- */
/* 												EJERCICIO 1 											*/
/* ---------------------------------------------------------------------------------------------------- */

/* Cargamos el esquema de la pixup store */
-- source F:\Pejcovich\BBDD\Semana 10\AY11_INSERT\15_mapeoDER_pixupSchema.sql
use pixup

/* Revisamos la tabla idioma */
desc idioma;
show create table idioma;

/* Verificamos que no haya registros en la tabla */
select count(*) as num_registros from idioma;

/* Insertar el idioma ALEMAN con id_idioma = -1 */
insert into idioma values(-1,'ALEMAN');

/* Insertar el idioma ALEMAN con id_idioma = 2 */
insert into idioma values(2,'ALEMAN'); 
select * from idioma;

 /* Insertar el idioma ALEMAN con id_idioma = 3 */
insert into idioma(id_idioma,nombre) values (3,'ALEMAN'); 
insert into idioma(id_idioma,nombre) values (3,'aleman'); 
insert into idioma(id_idioma,nombre) values (3,'Aleman'); 

/* Insertar ITALIANO con id = 2, sin especificar columnas */
insert into idioma values (2, 'ITALIANO');

/* Insertar ITALIANO con id = 10, sin especificar columnas */
insert into idioma values (10, 'ITALIANO'); 
/* todas las columnas y mismo orden */

select * from idioma;

/* Insertar los idiomas INGLES y SUECO con id_idioma = 0 y nulo. */
insert into idioma values (0,'INGLES'),(null,'SUECO');

/* Insertar el idioma CHINO sin id. */
insert into idioma values ('CHINO');


/* Insertar el idioma CHINO sin id, pero que funcione. */
insert into idioma(nombre) values ('CHINO'); 
/* El numero de columnas de la tabla y el numero de valores a insertar
no coincide. Para resolverlo hay de dos: modificamos la insercion para 
que respete el numero de columnas de la tabla o especificamos solo las
columnas para las que tenemos datos.*/

/* Insertar el idioma CHINO sin id. */
insert into idioma(nombre) values ('CHINO');

/* Insertar los idiomas ARABE y PORTUGES en una misma sentencia
sin ingresar valores (ni siquiera nulo) para id_idioma.  */
insert into idioma(nombre) values ('ARABE'),('PORTUGUES');

select * from idioma order by id_idioma asc;

/* Insertar el idioma ALEMAN sin id_idioma */
insert into idioma values(0,'ALEMAN');


/* Insertar el idioma JAPONES sin id */
insert into idioma(nombre,id_idioma) values('JAPONES',null);

/* Mostrar todos los registros de la tabla idioma */
select * from idioma order by id_idioma asc;

/* Cuando ya existe una fila en la tabla y una consulta de insercion falla,
la columna de clave principal aun se incrementara.
Los valores de incremento automatico no necesitan ser consecutivos, solo deben ser unicos.*/


/* ---------------------------------------------------------------------------------------------------- */
/* 												EJERCICIO 2 											*/
/* ---------------------------------------------------------------------------------------------------- */

/* Maneras de insertar datos en tablas
1. Poniendo las columnas y valores explicitamente
insert into nom_tbl(camp1,camp2,...) values(val1,val2,...)
 
2. Solo indicando los valores
	NOTA: tenemos que respetar el orden de las columnas
insert into nom_tbl values(val1,val2,...)

3. Podemos ingresar varios renglones a la vez. Separando por comas los parentesiss
insert into nom_tbl values (ren1),(ren2),....,(renN)
*/


/* Cargamos el esquema de la pixup store */
-- source F:\Pejcovich\BBDD\Semana 10\AY11_INSERT\15_mapeoDER_pixupSchema.sql

/* Revisamos la tabla estado */
desc estado;
show create table estado;

/* Verificar numero de registros en 'estado' */
select count(*) as num_registros from estado;

/* Insertar el estado CDMX con clave DF en la tabla estado con la sintaxis completa */
insert into estado values('DF','CDMX');

/* Insertar JALISCO con clave JAL en la tabla estado */
insert into estado values('JAL','JALISCO');

/* Insertar cdmx (en minusculas) con la clave MX */
insert into estado values('MX','cdmx');

/* Insertar DURANGO sin clave */
insert into estado values('DURANGO');
insert into estado(nombre) values('DURANGO');

/* Insertar ZACATECAS con clave Z (en ese orden) */
insert into estado(nombre,clave) values('ZACATECAS','Z');

/* ¿Por que funciona?
Cuando usamos CHAR decimos que la memoria sera reservada para la cantidad de bytes especificada. 
E.g., si declaramos un CHAR de longitud 2, y guardamos 'Z' sólo se ocupara 1 byte y el que resta se llenara con un espacio.
Siempre se ocupara la longitud que definimos, llenemos de caracteres de datos o no.
-> La ventaja es que CHAR es mas rapido que VARCHAR en cuanto a rendimiento ya que
el motor sabe de antemano cual es la longitud de los datos a procesar. 
En conclusion, si vamos a almacenar datos cuyo tamanio sabemos de antemano, 
lo mejor es optar por CHAR, pues acelera el rendimiento.*/

/* ¿Que hago si quiero restringir que todas las claves sean de longitud 2 y no menores? */
delete from estado where clave = 'Z';
select * from estado;

alter table estado add constraint MINIMO check (CHAR_LENGTH(clave) >= 2);
insert into estado(nombre,clave) values('ZACATECAS','Z');

alter table estado drop constraint MINIMO;
insert into estado(nombre,clave) values('ZACATECAS','Z');
select * from estado;

/* Insertar DURANGO con clave null */
insert into estado values(null,'DURANGO');

/* Insertar DURANGO con clave vacia */
insert into estado values('','DURANGO');

/* Mostrar todos los registros de la tabla estado */
select * from estado;

/* Insertar 3 estados en la tabla estado, todo en una misma sentencia sin errores */
insert into estado(nombre,clave) values ('VERACRUZ','VE'),('GUADALAJARA','GA'),('QUINTANA ROO','QR');

/* Mostrar todos los registros de la tabla estado */
select * from estado;

/* Vaciar la tabla estado */
delete from estado;
select * from estado;

-- notee