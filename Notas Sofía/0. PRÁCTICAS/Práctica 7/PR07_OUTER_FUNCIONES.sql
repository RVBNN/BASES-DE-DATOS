/* PARTE 1 */
use replicas_pr;

/* Ejercicio 1 */
DROP function if exists semanas_pedido;
DELIMITER $$
CREATE FUNCTION semanas_pedido(fecha_orden date, fecha_despacho date) RETURNS double(10,2)
READS SQL DATA DETERMINISTIC 
BEGIN
    DECLARE diferencia double(10,2);

    IF fecha_despacho is null THEN
		SET diferencia = -1;
    ELSE set diferencia = round(DATEDIFF(fecha_despacho, fecha_orden)/7,1);
    END IF; 

RETURN diferencia; 
END $$
DELIMITER ;

-- select semanas_pedido('2022/10/15','2022/10/23');
-- select semanas_pedido('2022/10/15',NULL);

/* Ejercicio 2 */
drop view if exists valores;

create or replace view valores as 
select round(avg(semanas_pedido(orderdate,shippeddate)),2) as 'promedio', 
round(max(semanas_pedido(orderdate,shippeddate)),2) as 'maximo', 
round(min(semanas_pedido(orderdate,shippeddate)),2) as 'minimo' from orders 
where shippeddate is not null;

select * from valores;

/* Ejercicio 3 */

/* select sub1.Ciudad, 
sub1.empleados as '# empleados' , sub2.clientes as '# clientes',
lpad(concat('->',format(tiem_prom,2),'<-'),11,' ') as 'TP por ciudad',
case when tiem_prom > valores.promedio then 'ALERTA' 
when tiem_prom < valores.promedio then 'OK' end as 'Aviso' 
from 
(select ucase(o1.city) as Ciudad, 
count(e1.employeenumber) as empleados 
from offices o1 inner join employees e1 using (officecode) group by 1) sub1 
inner join 
(select ucase(o2.city) as Ciudad, 
count(c.customernumber) as clientes
from offices o2 inner join employees e2 using (officecode) 
inner join customers c on c.salesRepEmployeeNumber = e2.employeeNumber group by 1) sub2 using(ciudad) 
inner join 
(select offices.city as Ciudad, avg(semanas_pedido(orderdate,shippeddate)) as tiem_prom from orders 
inner join customers using (customernumber) 
inner join employees on SalesRepEmployeeNumber = employeeNumber 
inner join offices using (officecode) group by 1) sub3 using(ciudad) 
join valores group by 1 order by 4 desc; */

select sub1.Ciudad, 
sub1.empleados as '# empleados' ,
lpad(concat('->',format(tiem_prom,2),'<-'),11,' ') as 'TP por ciudad',
case when tiem_prom > valores.promedio then 'ALERTA' 
when tiem_prom < valores.promedio then 'OK' end as 'Aviso' 
from 
(select ucase(o1.city) as Ciudad, 
count(e1.employeenumber) as empleados 
from offices o1 inner join employees e1 using (officecode) group by 1) sub1 
inner join 
(select offices.city as Ciudad, avg(semanas_pedido(orderdate,shippeddate)) as tiem_prom from orders 
left join customers using (customernumber) 
left join employees on SalesRepEmployeeNumber = employeeNumber 
left join offices using (officecode) group by 1) sub2 using(ciudad) 
join valores group by 1 order by 3 desc;

/* select offices.city as Ciudad, avg(semanas_pedido(orderdate,shippeddate)) as tiem_prom from orders 
inner join customers using (customernumber) 
inner join employees on SalesRepEmployeeNumber = employeeNumber 
inner join offices using (officecode) group by 1 order by 1;

En este ejercicio estaban forzados a utilizar la función semanas_pedido ya que al 
hacerlo ésta reducía los tiempos promedio por cada orden que aún no fuera despachada porque le daba un -1.
Los tiempos promedio correctos pueden verse así:

select offices.city as Ciudad, avg(semanas_pedido(orderdate,shippeddate)) as tiem_prom from orders 
inner join customers using (customernumber) 
inner join employees on SalesRepEmployeeNumber = employeeNumber 
inner join offices using (officecode) where shippeddate is not null group by 1 order by 1; */


/* PARTE 2 */
drop database if exists base_p07;
create database if not exists base_p07;

/* Ejercicio 4 */
use base_p07;
DROP FUNCTION IF EXISTS fibonacci;
DELIMITER //
create function fibonacci(num_natural int unsigned) returns bigint
READS SQL DATA DETERMINISTIC 
begin 

declare contador int; 
declare atras_1 bigint; 
declare atras_2 bigint; 
declare valor bigint; 

set contador = 2; 
set atras_1 = 1; 
set atras_2 = 1; 

if num_natural > 2 then 
while contador < num_natural do 
set valor = atras_1 + atras_2; 
set atras_1 = atras_2; 
set atras_2 = valor; 
set contador = contador + 1; 
end while; 
elseif num_natural = 0 then 
set valor = 0; 
else set valor = 1; 
end if;  
return valor;  
end;  
// 
DELIMITER ; 

/* Ejercicio 5 */
select lpad('0',round(length('Número natural')/2,0),' ') as 'Número natural', 
lpad(format(fibonacci(0),0),length('Término Fibonacci'),' ') as 'Término Fibonacci' 
UNION 
select lpad('1',round(length('Número natural')/2,0),' ') as 'Número natural', 
lpad(format(fibonacci(1),0),length('Término Fibonacci'),' ') as 'Término Fibonacci' 
UNION 
select lpad('2',round(length('Número natural')/2,0),' ') as 'Número natural', 
lpad(format(fibonacci(2),0),length('Término Fibonacci'),' ') as 'Término Fibonacci' 
UNION 
select lpad('15',round(length('Número natural')/2,0),' ') as 'Número natural', 
lpad(format(fibonacci(15),0),length('Término Fibonacci'),' ') as 'Término Fibonacci' 
UNION
select lpad('46',round(length('Número natural')/2,0),' ') as 'Número natural', 
lpad(format(fibonacci(46),0),length('Término Fibonacci'),' ') as 'Término Fibonacci';

/* Ejercicio 6 */
show function status where db = 'base_p07';

select routine_schema as 'Base de datos',
 SPECIFIC_NAME as 'Nombre', data_type as 'Tipo de dato salida' from information_schema.ROUTINES where routine_type = 'FUNCTION'
        AND routine_schema = 'base_p07';


/* EJERCICIO EXTRA */
use base_p07;

/*DROP FUNCTION IF EXISTS fibonacci_lim;
DELIMITER //
create function fibonacci_lim(objetivo int unsigned) returns text
READS SQL DATA DETERMINISTIC 
begin 
declare aureo decimal(11,10);
declare cociente decimal(11,10);
declare num_natural int unsigned;

set aureo = (1+sqrt(5))/2;
set cociente = cast(1 as decimal(11,10));
set num_natural = 1;

if objetivo > 0 then 
while abs(aureo-cociente) >= power(10,-objetivo)/objetivo do
set cociente = cast(fibonacci(num_natural+1)/fibonacci(num_natural) as decimal(11,10));
set num_natural = num_natural + 1; 
end while; 
end if;

return concat_ws(' ','Para n =',num_natural-1,'la sucesión an+1 ÷ an =',
cast(cociente as decimal(11,10)),'aproxima al \n límite φ =',aureo,'con una precisión de',
objetivo,case when objetivo = 1 then 'dígito decimal.' when objetivo != 1 then 
'dígitos decimales.' end,'\n');

end; 
// 
DELIMITER ;*/ 



DROP FUNCTION IF EXISTS fibonacci_lim;
DELIMITER //
create function fibonacci_lim(objetivo int unsigned) returns text
READS SQL DATA DETERMINISTIC 
begin 
declare aureo decimal(11,10);
declare cociente decimal(11,10);
declare num_natural int unsigned;

set aureo = (1+sqrt(5))/2;
set cociente = cast(1 as decimal(11,10));
set num_natural = 1;

if objetivo > 0 then 
while truncate(power(10,objetivo)*abs(aureo),0) - truncate(power(10,objetivo)*cociente,0) != 0 do
set cociente = fibonacci(num_natural+1)/fibonacci(num_natural);
set num_natural = num_natural + 1; 
end while; 
else set num_natural=2;
end if;


return concat_ws(' ','Para n =',num_natural-1,'la sucesión an+1 ÷ an =',
cast(cociente as decimal(11,10)),'aproxima al \n límite φ =',aureo,'con una precisión de',
objetivo,case when objetivo = 1 then 'dígito decimal.' when objetivo != 1 then 
'dígitos decimales.' end,'\n');

end; 
// 
DELIMITER ; 

/* Probando la función */
select 
fibonacci_lim(0),
fibonacci_lim(1),
fibonacci_lim(2),
fibonacci_lim(3),
fibonacci_lim(8)\G
