select 'Las funciones son rutinas que reciben parametros, los procesan y regresan el resultado.' as 'DEFINICION';

select 'Funciones como SUM(),MAX(),DAY(),MONTH(),CONCAT() son ejemplos de FUNCIONES predefinidas en MYSQL' as 'FUNCIONES PREDEFINIDAS';

select 'Tambien se pueden crear nuevas funciones como para comparar numeros, cadenas de texto, entre otras cosas' as 'FUNCIONES DEFINIDAS POR EL USUARIO';

select 'Para poder crear un funcion y que MYSQL no ejecute la consulta en automatico, es necesario cambiar el delimitador o enter de MYSQL, ";"' as 'DELIMITADOR';

select 'Para cambiar el delimitador solo hay que escribir "DELIMITER [espacio] [CADENA NUEVA]' as 'CAMBIAR DELIMITADOR';

select 'Cambiemos el delimitador, ";", por "$" --> DELIMITER $ <-- y consultemos las bases de datos existentes --> SHOW DATABASES; <-- ' as Ejemplo01;

select 'Como cambiamos el delimitador el ";" ya no funciona y ahora todo debe terminar con "$"' as Ejemplo01;

-- Ejercicio 1
use bank
drop function if exists SUMA_2N;

DELIMITER $$
CREATE FUNCTION SUMA_2N(n1 INT, n2 INT)
RETURNS INT DETERMINISTIC
BEGIN
DECLARE res INT; 
SET res=n1+n2; 
RETURN res; 
END
$$ 
DELIMITER ;


SELECT SUMA_2N(1,2) as 'Mandamos llamar a la func --> SELECT SUMA_2N(1,2); <--';
SELECT SUMA_2N(-1,-2) as 'Mandamos llamar a la func --> SELECT SUMA_2N(-1,-2); <--';


-- Ejercicio 2
use bank
drop function if exists hola_pers;

DELIMITER $$
CREATE FUNCTION hola_pers(nom varchar(50))
RETURNS VARCHAR(100) DETERMINISTIC
RETURN concat('Hola ',nom);
$$
DELIMITER ;

select hola_pers('Sofía');
select hola_pers('tú');


-- Ejercicio 3
use world_x


drop function if exists pais_capi;
DELIMITER $$
CREATE FUNCTION pais_capi(p varchar(50), c varchar(50))
RETURNS VARCHAR(100) DETERMINISTIC
RETURN concat('La capital de ',p,' es ',c);
$$
DELIMITER ;

select pais_capi(country.name,city.name) 
from country inner join city on country.capital = city.ID  
limit 10;


-- Ejercicio 4
use bank

drop function if exists sem_fecha;
DELIMITER $$
CREATE FUNCTION sem_fecha(d datetime)
RETURNS INT DETERMINISTIC
BEGIN
IF month(d) < 7 THEN RETURN 1;
ELSE RETURN 2;
END IF;
END $$
DELIMITER ;

select open_date,sem_fecha(open_date) from account limit 10;

-- Ejercicio 5
use bank

drop function if exists tri_fecha;
DELIMITER $$
CREATE FUNCTION tri_fecha(d datetime)
RETURNS INT DETERMINISTIC
BEGIN
IF month(d) in (1,2,3) THEN RETURN 1;
ELSEIF  month(d) in (4,5,6) THEN RETURN 2;
ELSEIF  month(d) in (7,8,9) THEN RETURN 3;
ELSE RETURN 4;
END IF;
END $$
DELIMITER ;

select open_date,tri_fecha(open_date) from account limit 10;


-- Ejercicio 6
use pixup

drop function if exists factorial;
DELIMITER $$
CREATE FUNCTION factorial(n int)
RETURNS int DETERMINISTIC
BEGIN
DECLARE res INT;
DECLARE cont INT; 
IF n > 0 THEN
SET res = 1;
SET cont = 1;

WHILE cont <= n DO
SET res = res * cont;
SET cont = cont + 1;
END WHILE;

RETURN res;
ELSE return 0;
END IF;
END $$
DELIMITER ;

select factorial(-1);
select factorial(5);
select factorial(3);


-- Ejercicio 7
use pixup
drop function if exists voltea;
DELIMITER $$

CREATE FUNCTION voltea(texto varchar(100))
RETURNS varchar(100) DETERMINISTIC 
BEGIN
DECLARE res VARCHAR(100);
DECLARE len INT; 
SET len = length(texto);
SET res = '';
WHILE len > 0 DO
SET res = concat(res,substr(texto,len,1));
SET len = len-1;
END WHILE;
RETURN res;
END $$
DELIMITER ;

select voltea('Sofía');
select titulo, voltea(titulo) from disco limit 10;

-- Ejercicio 8
use pixup

drop function if exists mini_gauss;

DELIMITER //

CREATE FUNCTION mini_gauss ( num_x INT )
RETURNS INT DETERMINISTIC

BEGIN

   DECLARE suma INT;
   declare contador int;

   SET suma = 0;
   set contador = 1;

   mi_loop: REPEAT
     SET suma = suma + contador;
	 set contador = contador + 1;
   UNTIL contador > num_x 
   END REPEAT mi_loop;

   RETURN suma;

END; //

DELIMITER ;

select mini_gauss(50);
select (50*51)/2;