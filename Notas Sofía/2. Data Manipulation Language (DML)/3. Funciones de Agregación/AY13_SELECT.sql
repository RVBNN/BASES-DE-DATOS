/* Cambiamos el prompt  */
prompt [\R:\m \O\y]-[\d]->

/* Cargamos la base de datos super */
-- source base_super.sql

/* Creamos un tee */
-- tee ay13_select.txt

/* Ponemos al uso la base */
use super

/* Exploramos que hay... */
show tables;
desc compras;
select * from compras limit 5;


/* Ejercicios */

-- Mostrar el total de tickets, artículos y precio medio de los artículos de la tabla compras
select count(distinct id_ticket) as 'numero de tickets',
count(distinct articulo) as 'articulos distintos',
round(avg(precio),2) as 'precio medio por articulo'
from compras;

-- Replicar el ejercicio anterior pero ahora segmentando mes a mes
select month(fecha) as 'mes fecha',
count(distinct id_ticket) as 'numero de tickets',
count(distinct articulo) as 'articulos distintos',
round(avg(precio),2) as 'precio medio por articulo'
from compras
group by 1;

-- Ordenando por mes de manera descendente
select month(fecha) as 'mes fecha',
count(distinct id_ticket) as 'numero de tickets',
count(distinct articulo) as 'articulos distintos',
round(avg(precio),2) as 'precio medio por articulo'
from compras
group by 1
order by 1 desc;

-- Mostrar los meses impares con precios promedios mayores a 66.00
/* 
MOD(N, M)
or
N % M
or
N MOD M 
*/
/* select month(fecha) as 'mes fecha'
from compras
where mod(month(fecha),2) > 0
order by 1; */

select distinct month(fecha) as 'mes fecha'
from compras
where mod(month(fecha),2) > 0
order by 1;

select month(fecha), round(avg(precio),2) 'precio medio por articulo' 
from compras 
group by 1 
having avg(precio) > 66
order by 1;

select month(fecha) 'mes fecha',
round(avg(precio),2) 'precio medio por articulo' 
from compras
where mod(month(fecha),2) > 0
group by 1
having avg(precio) > 66
order by 1;

-- Repetir la consulta anterior, pero añadiendo el nombre del mes
select monthname(fecha) 'mes fecha',
round(avg(precio),2) 'precio medio por articulo' 
from compras
where mod(month(fecha),2) > 0
group by 1
having avg(precio) > 66
order by 1;

-- Ordenar por transcurso real de los meses
select monthname(fecha) 'mes fecha',
round(avg(precio),2) 'precio medio por articulo' 
from compras
where mod(month(fecha),2) > 0
group by 1
having avg(precio) > 66
order by month(fecha);

-- Listar el total de ventas (precio * cantidad) por día de la semana.
/*
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    WHEN conditionN THEN resultN
    ELSE result
END;
*/
select dayname(fecha) as 'Dia semana',
format(sum(precio*cantidad),2) as 'Total Ventas'
from compras
group by 1
order by weekday(fecha);


-- Listar el total de ventas por trimestre
select fecha,
case
	when month(fecha) in (1,2,3) then 'Q1'
	when month(fecha) in (4,5,6) then 'Q2'
	when month(fecha) in (7,8,9) then 'Q3'
	else 'Q4'
end as trimestre
from compras
limit 5;

select
concat_ws('-',
case
	when month(fecha) in (1,2,3) then 'Q1'
	when month(fecha) in (4,5,6) then 'Q2'
	when month(fecha) in (7,8,9) then 'Q3'
	else 'Q4'
end,
year(fecha)) as trimestre,
format(sum(precio*cantidad),2) as 'Total Ventas'
from compras
group by 1
order by month(fecha);

-- Mostrar la lista del super de los tickets impares, comprados el 12 de marzo de 2021.
-- ¿?


/* Cerramos el tee */
-- notee
 


