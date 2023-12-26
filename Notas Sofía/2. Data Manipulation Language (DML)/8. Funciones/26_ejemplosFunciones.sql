-- Ejemplos de funciones
use collectionhw;

-- =============================================================================
-- ejemplo 1: Enviar un saludo al usuario

DROP FUNCTION IF EXISTS saludo;
DELIMITER //
CREATE FUNCTION saludo()
RETURNS TEXT
-- LANGUAGE SQL
READS SQL DATA DETERMINISTIC
BEGIN
return 'Hola Mundo de BD';
END;
//
DELIMITER ;

-- Ejecutar la función: 
select saludo();

-- =============================================================================
-- ejemplo 2: Las funciones pueden recibir parámetros y declarar variables

DROP FUNCTION IF EXISTS saludo2;
DELIMITER $$
CREATE FUNCTION saludo2(entrada VARCHAR(20))
RETURNS TEXT
READS SQL DATA DETERMINISTIC
BEGIN
DECLARE salida VARCHAR(20);
SET salida = entrada;
RETURN concat('Hola ... ',salida);
END;
$$
DELIMITER ;

-- Ejecutar la función: 
select saludo2("Grupo de BD");

-- =============================================================================
-- ejemplo 3: Cálculo de valores: división sin usar el operador (÷)

DROP FUNCTION IF EXISTS divide;
DELIMITER //
create function divide(dividendo int,divisor int) returns int
READS SQL DATA DETERMINISTIC 
begin 
declare aux int;
declare contador int;
declare resto int;
set contador = 0;
set aux = 0;
while (aux + divisor) <= dividendo do
set aux = aux + divisor ;
set contador = contador + 1;
end while;
set resto = dividendo - aux ;
return contador;
end;
//
DELIMITER ;

-- Probar función:
select divide(10,2);


-- fin ejemplos --
-- =============================================================================


-- instrucciones para consultar funciones creadas

SELECT specific_name FROM information_schema.routines;

SELECT routine_definition FROM information_schema.routines WHERE specific_name = 'saludo';

SELECT routine_definition FROM information_schema.routines WHERE specific_name = 'saludo2';

-- =============================================================================
