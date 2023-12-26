-- Practica07_Eq09.sql

prompt \D [\d] -> 

-- 1. 
source /Users/rubennunezsanchez/Documents/ESCUELA/7. Séptimo Semestre/Bases Datos/Códigos/Bases de Datos/12. base_replicas_pr.sql
use replicas_pr;

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

/* NOTAS Ejercicio 1: 

¿Qué es 2022/11,15?
¿Cómo realizamos el manejo del -1? */

select f_week('2022/11/24', '2022/11/15');
select f_week('2022/11/24', NULL);

-- 2.

/* NOTAS Ejercicio 2: 
¿A qué se refiere con resolved? */

CREATE OR REPLACE VIEW v_date_analysis AS 
SELECT MIN(weeks) AS 'Mínimo de semanas', ROUND(AVG(weeks),2) AS 'Promedio de semanas', MAX(weeks) AS 'Número máximo de semanas' FROM 
(SELECT orderNumber, f_week(requiredDate, orderDate) AS weeks FROM orders WHERE status = 'Shipped') s;

SELECT * FROM v_date_analysis;

-- 3. -----------------------------------------------------------

# offices & employees; JOIN
select e.employeenumber,e.firstname, e.lastname, e.officecode, offices.city, offices.state, offices.country from employees as e
join offices using(officecode);

select e.employeenumber, offices.city
from employees as e
join offices using(officecode);



# customers & employees; LEFT JOIN (employees, customers)
select e.employeenumber, e.firstname, e.lastname, e.officecode, cus.customernumber,cus.customername, cus.salesrepemployeenumber from employees as e
left join customers as cus on e.employeenumber = cus.salesrepemployeenumber
order by 4,6;

# customers & orders; JOIN
SELECT 
	cus.customername, cus.salesrepemployeenumber,cus.customernumber, o.customernumber, o.ordernumber, o.orderDate,o.requiredDate, o.status
FROM customers as cus join orders as o using(customernumber)
WHERE o.status = 'Shipped';

/*
empleados por oficina por una cosa

usar vistas y unir por o que me convenga

1. tabla: ciudades y numero de empleados por ciudad
2. tiempo promedio por ciudad y la ciudad

crear tablitas convenientes y unirlas por atributo comun
*/


select 
	of.city, count(e.employeenumber), f_week(o.requiredDate, o.orderDate) 
from employees as e
join offices as of using(of.officecode)
left join customers as cus on e.employeenumber = cus.salesrepemployeenumber
join orders as o using(cus.customernumber);






SELECT
	offices.city, COUNT(employees.employeeNumber), f_week(orders.requiredDate, orders.orderDate)
FROM offices 
JOIN employees using(officeCode)
LEFT JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber
JOIN orders USING(customerNumber)
WHERE orders.status = 'Shipped'
GROUP BY 1, 3
ORDER BY 1,2;



SELECT
	offices.city, employees.employeeNumber, customers.customerNumber, f_week(orders.requiredDate, orders.orderDate)
FROM offices 
JOIN employees using(officeCode)
LEFT JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber
JOIN orders USING(customerNumber)
WHERE orders.status = 'Shipped'
ORDER BY 1,2;







select distinct city from offices;

desc customers;
desc employees;
desc offices;
desc orderdetails;
desc orders;
desc payments;
desc productlines;
desc products;

select offices.city, count(employees.employeenumber), count(customers.customernumber), avg(f_week(requiredDate,orderDate)) 
from offices
join employees using(officecode)
join customers on employees.employeenumber = customers.salesrepemployeenumber
join orders using(customernumber)
group by 1;

count(distinct employees.employeenumber) as '# empleados', count(distinct customers.customernumber), avg(f_week(requiredDate,orderDate)) 

select distinct employees.employeenumber, offices.city
from offices
join employees using(officecode)
join customers on employees.employeenumber = customers.salesrepemployeenumber
join orders using(customernumber);



-- -----------------------------------------------------------

-- PARTE 2.

-- 4.
DROP DATABASE IF EXISTS base_p07;
CREATE DATABASE IF NOT EXISTS base_p07;


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
CREATE TABLE IF NOT EXISTS E5(
nat_number int not null,
fibo int not null
);

INSERT INTO E5
VALUES(0,fibonacci(0)), (1, fibonacci(1)), (2, fibonacci(2)), (15, fibonacci(15)), (46, fibonacci(46));
SELECT rpad(nat_number, length('Número Natural')/2, ' ') as 'Número Natural', lpad(format(fibo,0), length('Número Natural'), ' ')  as 'Término Fibonacci'
FROM E5;


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




/*
select routine_schema as database_name,
       routine_name,
       routine_type as type,
       data_type as return_type,
       -- routine_definition as definition
from information_schema.routines
where routine_schema not in ('sys', 'information_schema',
                             'mysql', 'performance_schema')
    and routine_schema = 'base_p07' -- put your database name here
order by routine_schema,
         routine_name;
*/






/*
6. Realizar una consulta a information_schema que 
muestre las funciones existentes en la base de datos base_p07 y los campos 
‘Base de datos’, ‘Nombre función’ y ‘Tipo de dato salida’.
*/


/*

routines

Todo es un query que sale de una
*/





























