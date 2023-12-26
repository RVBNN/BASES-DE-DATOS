-- Practica08_Eq09

/* Practica  08*/

/* Parte 0 - Preliminares */

prompt \w.\O.\y \r:\m - \d - '\S' ->

/* Parte 1 - 'Base de datos 'mundo' */

USE mundo;

/*  1  */
/*  En mundo, crear un procedimiento almacenado f1 que:
Reciba una cadena de texto y una variable de salida.
Imprima cada uno de los caracteres en mayúscula, uno debajo del otro.
Guarde en la variable de salida el total de vocales que hay en el texto
ingresado. */

DROP PROCEDURE IF EXISTS f1;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS f1(IN n varchar(100),OUT a int)
BEGIN
DECLARE contador int;
DECLARE limite int;
SET contador = 1;
SET limite=length(n);
SET a=0;
DROP TABLE IF EXISTS tabla;
WHILE contador<=limite DO
CREATE TABLE IF NOT EXISTS tabla(RESULTADO char(5));
INSERT tabla SELECT LPAD(UCASE(SUBSTRING(n,contador,1)),5,' ') ;
IF SUBSTRING(n,contador,1) IN ('A','E','I','O','U') THEN SET a=a+1;
END IF;
SET contador=contador+1;
END WHILE;
SELECT * FROM tabla;
END $$ 
DELIMITER ;

/* 2 */
/* Correr las siguientes instrucciones:
call f1('s0f14, @vocales_ayudante);
call f1('Albericoque y queso',@num_vocales);
call f1('Las bases de datos son geniales.',@vocales); */

CALL f1('s0f14', @vocales_ayudante);

CALL f1('Albericoque y queso',@num_vocales);

CALL f1('Las bases de datos son geniales.',@vocales);

SELECT @vocales_ayudante,@num_vocales,@vocales;


/* 3 */
/* En mundo, crear una copia de la tabla paises que se llame pais02 y una tabla
cambios. Crear triggers para cuando el usuario inserte, modifique o elimine registros de
pais02:
El trigger para insertar deberá ingresar los valores insertados dentro de la tabla
cambios.
El trigger para modificar deberá ingresar los valores originales dentro de la
tabla cambios.
El trigger para eliminar deberá ingresar los valores eliminados dentro de la
tabla cambios.
Ojo al elegir cuáles son los valores adecuados para los campos:
° accionCambio (Insert, Update o Delete)
° cambioPor (el usuario que realizó la acción)
° cambiadoEn (la fecha y hora a la que se realizó la acción) */

SHOW TABLES;

DROP TABLE IF EXISTS pais02;

CREATE TABLE  IF NOT EXISTS pais02 AS SELECT * FROM paises;

DROP TABLE IF EXISTS cambios;

CREATE TABLE IF NOT EXISTS cambios(
id_pais int unsigned not null,
pais varchar(50) not null,
continente varchar(30) not null,
area int not null,
poblacion bigint not null,
gdp bigint,
capital varchar(50),
accionCambio varchar(50),
cambioPor varchar(50),
cambiadoEn datetime);

DESC cambios;

SHOW TABLES;

DROP TRIGGER IF EXISTS pais02_AI_trigger;

CREATE TRIGGER IF NOT EXISTS pais02_AI_trigger AFTER INSERT ON pais02 FOR EACH ROW
INSERT INTO cambios VALUES 
(new.id_pais, new.pais, new.continente, new.area, new.poblacion, new.gdp, new.capital,
'Nueva Data', user(), sysdate());


DROP TRIGGER IF EXISTS pais02_BU_trigger;

CREATE TRIGGER IF NOT EXISTS  pais02_BU_trigger BEFORE UPDATE ON pais02 FOR EACH ROW
INSERT INTO cambios VALUES 
(old.id_pais, old.pais, old.continente, old.area, old.poblacion, old.gdp, old.capital,
'Data Modificado', user(), sysdate()); 

DROP TRIGGER IF EXISTS pais02_BD_trigger;

CREATE TRIGGER IF NOT EXISTS pais02_BD_trigger BEFORE DELETE ON pais02 FOR EACH ROW
INSERT INTO cambios VALUES
(old.id_pais, old.pais, old.continente, old.area, old.poblacion, old.gdp, old.capital,
'Data Eliminada', user(), sysdate()); 

SHOW TRIGGERS \G

/* 4 */
/* Escribir las siguientes consultas:
insert into pais02 values
(196,’BBDD’,’Ciencias’,17125243,1365370001,16244600000001,
’Marisol Flores’);
En pais02, actualizar los registros cuya población sea mayor a mil millones y
cambiar el nombre a mayúsculas.
En pais02, eliminar los registros cuyo gdp per capita sea mayor a 110 mil.
select * from cambios; */

/*Insertar */

INSERT INTO pais02 VALUES (196,'BBDD','Ciencias',17125243,1365370001,16244600000001, 'Marisol Flores');

/* Actualizar */

SELECT id_pais,pais,poblacion FROM pais02 WHERE poblacion > 1000000000;

UPDATE pais02 SET pais = UCASE(pais) WHERE poblacion > 1000000000;

/* Eliminar */

SELECT id_pais,pais,gdp FROM pais02 WHERE gdp > 110000;

DELETE FROM pais02 WHERE gdp >110000;

/* Comprobamos los TrIiggers */

SELECT * FROM cambios;


/* Parte 2 - Base de Datos 'pixup' */

USE pixup;

/* 5 */
/* Antes de procesar una compra se quiere saber si los clientes cuentan con los fondos
suficientes para que ésta se complete con éxito.
Crear un procedimiento que reciba el balance actual de la cuenta de un cliente, el título
del disco que le interesa y cuántos desea adquirir.
Este procedimiento se mandará a llamar por cada disco distinto que el cliente busque
comprar, pero sólo se correrá una instrucción por título (sin importar la cantidad).
Cuando se haya ejecutado el proceso por cada uno de los discos de interés, se podrá
consultar cuánto es el saldo restante en la cuenta del potencial comprador y verificar si
éste es mayor a 0. */


DROP PROCEDURE IF EXISTS ej5;
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS ej5(INOUT balance_actual DECIMAL(6,2), IN titulo_disco VARCHAR(100), IN cantidad_adquirir INT)
	BEGIN

	DECLARE p decimal (6,2);

	SELECT precio into p FROM disco WHERE titulo LIKE titulo_disco;

	IF balance_actual > p THEN
	SET balance_actual = balance_actual - (p * cantidad_adquirir);
	ELSE
	SET balance_actual = balance_actual;
	END IF;

	END;
//
DELIMITER ;	




/* 6 */
/*  Un cliente tiene, antes de llegar a la pixup store, 4,100.5 pesos en su cuenta.
Desea adquirir los siguientes discos:
° Love Goes, 1
° AM, 5
° dont smile at me, 3
° Grandes exitos de los tigres del norte, 2
¿Cuánto dinero quedaría en su cuenta si comprara todos los discos anteriores?
¿Cuántas coca colas de 20 pesos cada una puede comprarse con lo que le resta? */

set @balance = 4100.5;

call ej5(@balance, 'Love Goes', 1);
call ej5(@balance, 'AM', 5);
call ej5(@balance, 'dont smile at me', 3);
call ej5(@balance, 'Grandes exitos de los tigres del norte', 2);

select @balance;


select round(@balance/20,0) as 'Cantidad de Coquitas Light pa\' las que le alcanza:'; 



















CREATE PROCEDURE





















