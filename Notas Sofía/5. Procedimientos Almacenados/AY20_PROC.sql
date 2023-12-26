-- PROCEDIMIENTOS ALMACENADOS

prompt \d mysql>

select 'Los procedimientos almacenados son un bloque de instrucciones que se van a ejecutar en un futuro.' as 'DEFINICION';

select 'Los procedimientos no devuelven un valor siempre.' as 'CARACTERISTICA';

select 'Se les invoca o llama por medio de --> CALL nombreProcedimiento([param]) <--  y suelen ser utilizados para tareas cotidianas.' as 'USO';

select 'Para poder crear un procedimiento almacenado y que MYSQL no ejecute la consulta en automatico, es necesario cambiar el delimitador o enter de MYSQL, ";"' as 'DELIMITADOR';

select 'Para cambiar el delimitador solo hay que escribir "DELIMITER [espacio] [CADENA NUEVA]' as 'CAMBIAR DELIMITADOR';

select 'Siempre regresar el delimitador a ";" para no tener problemas con consultas futuras --> DELIMITER ; <--' as 'NOTA IMPORTANTE';

select 'DELIMITER $$ CREATE PROCEDURE nombreProcedimiento(param) BEGIN [INSTRUCCIONES] END $$ DELIMITER ;' as 'ESTRUCTURA CONSULTA';

select 'Los procedimientos pueden o no recibir parametros. Si reciben pueden ser de tres tipos: IN, OUT, INOUT; dependiendo del objetivo a realizar.' as 'TIPOS PARAMETROS';

select 'Un parámetro IN pasa un valor a un procedimiento.' as 'PARÁMETRO IN'
UNION 
select 'El procedimiento puede modificar el valor, pero la modificación no es visible para el usuario cuando el procedimiento termina.' as 'PARÁMETRO IN';

select 'Un parámetro OUT devuelve un valor del procedimiento a la persona que llama.' as 'PARÁMETRO OUT' 
UNION 
select 'Su valor inicial es NULL dentro del procedimiento y su valor es visible para el usuario cuando el procedimiento termina.' as 'PARÁMETRO OUT';

select 'Un parámetro INOUT debe ser inicializado por el usuario.' as 'PARÁMETRO INOUT'
UNION 
select 'Luego, el procedimiento puede modificarlo y cualquier cambio realizado por el procedimiento es visible para el usuario cuando el procedimiento termina y se llama a la variable.' as 'PARÁMETRO INOUT';

-- EJERICIOS

drop database if exists ej_proc;
create database ej_proc;
use ej_proc
create table ej_proc (
	id int unsigned not null auto_increment primary key,
	ejercicio varchar(500),
	consulta varchar(1000)
);

insert into ej_proc (ejercicio,consulta) values
('Crear un proc en la base MUNDO para imprimir los primeros N registros de la tabla paises.','DELIMITER $$
CREATE PROCEDURE N_REGISTROS(IN n INT)
BEGIN
SELECT * FROM PAISES LIMIT n;
END $$ 
DELIMITER ;
'),
('Crear un proc en la base MUNDO para guardar en una variable el max de poblacion de la tabla paises.','DELIMITER $$
CREATE PROCEDURE max_pob(OUT max_pob int)
BEGIN
SELECT max(poblacion) INTO max_pob FROM paises;
END $$
DELIMITER ;'),
('Crear un proc para incrementar valores.','DELIMITER $$
CREATE PROCEDURE inc_valor(INOUT contador INT,IN aum INT)
BEGIN
SET contador = contador + aum;
END $$
DELIMITER ;
'),
('Crear un proc en la base MUNDO para saber si un pais es grande o no; (GRANDE si tiene mas de 100 M de habitantes',"DELIMITER $$
CREATE PROCEDURE pais_g(IN n VARCHAR(50))
BEGIN
DECLARE pob INT;
SELECT poblacion into pob from paises where pais = n;
IF pob > 100000000 THEN SELECT concat(n,' es GRANDE') as RESPUESTA;
ELSE SELECT concat(n,' es PEQUE');
END IF;
END $$
DELIMITER ;"),
('Crear un proc en la base MUNDO que nos devuelva el costo por envio dado un pais que ingresemos.',"DELIMITER $$
CREATE PROCEDURE envio(IN n VARCHAR(50),OUT e VARCHAR(50))
BEGIN
CASE
	WHEN n = 'Mexico' THEN SET e = 'Gratis';
	WHEN n = 'EEUU' THEN SET e = '$200.00 MXN';
	ELSE SET e = 'No lo puedes pagar';
END CASE;
END $$
DELIMITER ;"),
('Crear un proc que imprima los numeros pares hasta el indicado por el usuario.',"DELIMITER $$
CREATE PROCEDURE pares_hasta(IN n INT)
BEGIN
DECLARE res VARCHAR(500);
DECLARE contador INT;
SET res = '';
SET contador = 1;
nombre_loop: LOOP
	IF contador >= n THEN LEAVE nombre_loop;
	END IF;
	SET contador = contador + 1;
	IF (contador mod 2) THEN ITERATE nombre_loop;
	ELSE SET res = concat(res,contador,',');
	END IF;
END LOOP;
SELECT res as RESULTADO;
END $$
DELIMITER ;"),
('Crear un procedimiento que inserte n numeros en la tabla prueba.','CREATE TABLE prueba(id INT);
DROP PROCEDURE IF EXISTS llena_hasta;
DELIMITER $$
CREATE PROCEDURE llena_hasta(IN n INT)
BEGIN
DECLARE contador INT;
SET contador = 1;
REPEAT
INSERT INTO prueba VALUES(contador);
SET contador = contador + 1;
UNTIL contador > n
END REPEAT;
END $$
DELIMITER ;')
;



-- Ejercicio 01
select * from ej_proc where id = 1;

use mundo
drop procedure if exists n_registros;
delimiter $$
create procedure n_registros(in n int)
begin
select * from paises limit n;
end $$ 
delimiter ;

select 'Mandamos llamar a nuestro proceso --> CALL N_REGISTROS(2); <--' as 'CONSULTA';
call  N_REGISTROS(2);

select 'Mandamos llamar a nuestro proceso --> CALL N_REGISTROS(10); <--' as 'CONSULTA';
call  N_REGISTROS(10);

-- Ejercicio 02
use ej_proc
select * from ej_proc where id = 2;
use mundo
drop procedure if exists max_pob;
delimiter $$
create procedure max_pob(out max_pob int)
begin
select max(poblacion) into max_pob from paises;
end $$
delimiter ;

select 'Madamos llamar a nuestro proceso --> CALL max_pob(@max_pob); <--' as CONSULTA;
call max_pob(@max_pob);
select 'Imprimimos el valor de @max_pob --> SELECT @max_pob; <--' as CONSULTA;
select @max_pob;
select 'Validamos el proceso --> SELECT max(poblacion) FROM paises; <--' as CONSULTA;
select max(poblacion) from paises;



-- Ejercicio 03
use ej_proc
select * from ej_proc where id = 3;
drop procedure if exists inc_valor;
delimiter $$
create procedure inc_valor(inout contador int,in aum int)
begin
set contador = contador + aum;
end $$
delimiter ;

set @A = null;

select 'Llamamos al procedimiento --> CALL inc_valor(@A,1); <-- e imprimimos valor de @A --> SELECT @A;<--' as CONSULTA;
call inc_valor(@A,1);
select @A;

select 'Como @A no tiene valor, debemos primero asignar uno para despues poder incrementar su valor.
--> SET @A = 0; 
CALL inc_valor(@A,1); -- @A ahora vale 0+1 = 1
CALL inc_valor(@A,4); -- @A ahora vale 1+4 = 5
CALL inc_valor(@A,9); -- @A ahora vale 5+9 = 14
SELECT @A; <--' as CONSULTA;

set @A = 0; 
call inc_valor(@A,1);
call inc_valor(@A,4);
call inc_valor(@A,9);
select @A;

set @A = 5; 
call inc_valor(@A,1);
call inc_valor(@A,4);
call inc_valor(@A,9);
select @A;

-- Consulta las variables creadas
select 'Para consultar las variables creadas: 
--> select * from performance_schema.user_variables_by_thread; <--' as CONSULTA;

select * from performance_schema.user_variables_by_thread;


-- Ejercicio 04
use ej_proc
select * from ej_proc where id = 4;
use mundo
drop procedure if exists pais_g;
delimiter $$
create procedure pais_g(in n varchar(50))
begin
declare pob int;
select poblacion into pob from paises where pais = n;
if pob > 100000000 then select concat(n,' es GRANDE') as RESPUESTA;
else select concat(n,' es peque');
end if;
end $$
delimiter ;

select "Provamos el procedimiento...
--> CALL pais_g('Mexico');
CALL pais_g('France'); <--" as CONSULTA;

CALL pais_g('Mexico');
CALL pais_g('France');



-- Ejercicio 05
use ej_proc
select * from ej_proc where id = 5;
use mundo
drop procedure if exists envio;
delimiter $$
create procedure envio(in n varchar(50),out e varchar(50))
begin
case
	when n = 'Mexico' then set e = 'Gratis';
	when n = 'EEUU' then set e = '$200.00 MXN';
	else set e = 'No está disponible';
end case;
end $$
delimiter ;

select "Proveemos...
--> CALL envio('Mexico',@envio);
SELECT @envio;
CALL envio('EEUU',@envio);
SELECT @envio;
CALL envio('Mi casa',@envio);
SELECT @envio; <--" as CONSULTA;

call envio('Mexico',@envio);
select @envio;
call envio('EEUU',@envio);
select @envio;
call envio('Mi casa',@envio);
select @envio; 




-- Ejercicio 06
use ej_proc
select * from ej_proc where id = 6;
drop procedure if exists pares_hasta;
delimiter $$
create procedure pares_hasta(in n int)
begin
declare res varchar(500);
declare contador int;
set res = '';
set contador = 1;
nombre_loop: loop
	if contador >= n then leave nombre_loop;
	end if;
	set contador = contador + 1;
	if (contador mod 2) then iterate nombre_loop;
	else set res = concat(res,contador,',');
	end if;
end loop;
select res as resultado;
end $$
DELIMITER ;

select 'Proveemos...
--> CALL pares_hasta(10);
CALL pares_hasta(21); <--' as CONSULTA;

call pares_hasta(10);
call pares_hasta(21);


-- Ejercicio 07
use ej_proc
select * from ej_proc where id = 7;
drop table if exists prueba;
create table prueba(id int);
drop procedure if exists llena_hasta;
delimiter $$
create procedure llena_hasta(in n int)
begin
declare contador int;
set contador = 1;
repeat
insert into prueba values(contador);
set contador = contador + 1;
until contador > n
end repeat;
end $$
delimiter ;

select 'Proveemos...
--> CALL llena_hasta(5);
CALL llena_hasta(7); 
SELECT * FROM prueba;<--' as CONSULTA;

call llena_hasta(5);
call llena_hasta(7);
select * from prueba;