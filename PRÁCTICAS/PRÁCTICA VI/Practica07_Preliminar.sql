-- 0.
prompt \D [\d] -> 

-- 1. 
source /Users/rubennunezsanchez/Documents/ESCUELA/7. Séptimo Semestre/Bases Datos/Códigos/Bases de Datos/12. base_replicas_pr.sql

USE replicas_pr;

DROP FUNCTION IF EXISTS f_week;

DELIMITER //
CREATE FUNCTION IF NOT EXISTS f_week(f1 date, f2 date)
	RETURNS DOUBLE
	READS SQL DATA DETERMINISTIC
BEGIN
	DECLARE diff DOUBLE;
	DECLARE d_diff DOUBLE;

	# Fecha Inicial - Fecha Final
	SET d_diff = datediff(f1, f2);
	SET diff = d_diff / 7;

	# Manejo de errores:
	RETURN round(diff,2);
END;
//
DELIMITER ;

-- 2.
CREATE OR REPLACE VIEW v_date_analysis AS 
SELECT MIN(weeks) AS 'Mínimo de semanas', ROUND(AVG(weeks),2) AS 'Promedio de semanas', MAX(weeks) AS 'Número máximo de semanas' FROM 
(SELECT orderNumber, f_week(requiredDate, orderDate) AS weeks FROM orders WHERE status = 'Shipped') s;

SELECT * FROM v_date_analysis;

-- 3.

-- 4.
DROP DATABASE IF EXISTS base_p07;
CREATE DATABASE IF NOT EXISTS base_p07;

USE base_p07;

DROP FUNCTION IF EXISTS fibonacci;
DELIMITER //
CREATE FUNCTION fibonacci(n int)
RETURNS int DETERMINISTIC
BEGIN
DECLARE fib_1 int;
DECLARE fib_2 int;
DECLARE fib int;
DECLARE contador int;
-- SET contador = 0;

-- Manejo de errores: n < 0:
IF n < 0 THEN
SET fib = -1;
-- RETURN 'ERROR';

-- Primeros dos terminos de la sucesión
ELSEIF n = 0 THEN
SET fib = 0;
-- SET contador = 1;

ELSEIF n = 1 THEN 
SET fib = 1;
-- SET contador = 2;

ELSE
-- Para n > 1
SET contador = 3;
SET fib_1 = 0;
SET fib_2 = 1;

-- Calculos
WHILE contador - 1 <= n DO
SET fib = fib_1 + fib_2;
SET fib_1 = fib_2;
SET fib_2 = fib;

SET contador = contador + 1;
END WHILE;

END IF;

RETURN fib;
END //
DELIMITER ;

-- 5.
SELECT 'Numero Natural', 'Termino Fibonacci' UNION
SELECT 0, fibonacci(0) UNION
SELECT 1, fibonacci(1) UNION
SELECT 2, fibonacci(2) UNION
SELECT 15, fibonacci(15) UNION
SELECT 46, FORMAT(fibonacci(46),0);

-- 6.
USE information_schema;

SELECT routine_type AS 'Funciones & Procedimientos Existentes', routine_schema AS 'Base de Datos', routine_name AS 'Nombre Funciones/Procedimientos', data_type AS 'Tipo dato salida' 
FROM routines 
WHERE routine_schema = 'base_p07';
