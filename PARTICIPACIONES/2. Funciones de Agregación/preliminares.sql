/*
=================================
Ejercicio de participación 2: Funciones de agregación 
Nombre: Ruben Núñez
Fecha: 12 - Nov - 22
=================================
*/
use pixup;

-- Ejercicio 1: Reporte de cuantos títulos fueron lanzados por año, ordenado por año descendentemente.
select count(titulo) from disco
group by fecha_lanzamiento
order by fecha_lanzamiento desc;

# Ruben
select count(titulo) as 'Discos Lanzados', year(fecha_lanzamiento) as 'Año' from disco
group by year(fecha_lanzamiento)
order by 2 desc;

# Sofia
select year(fecha_lanzamiento) as 'Año', count(titulo) as 'Discos Lanzados' from disco
group by year(fecha_lanzamiento) 
order by 1 desc;

-- Ejercicio 2: Reporte de cantidad de discos lanzados por año solo de los años con lanzamientos de más de 10 discos, ordenado por esa cantidad descendente.
select year(fecha_lanzamiento) as 'Año', count(titulo) as 'Discos Lanzados' from disco
group by 1
having count(titulo) > 10
order by 2 desc;

-- Ejercicio 3: Reporte por año y por mes indicando el nombre del mes, de la cantidad de discos disponibles, ordenado por año descendente y por mes ascendente.
select year(fecha_lanzamiento), monthname(fecha_lanzamiento), count(cantidad_disponible) from disco
group by monthname(fecha_lanzamiento);
order by 1 desc, month(fecha_lanzamiento) asc;


select year(fecha_lanzamiento), monthname(fecha_lanzamiento), count(cantidad_disponible) from disco
group by year(fecha_lanzamiento

select cantidad_disponible, year(fecha_lanzamiento) form disco;

select cantidad_disponible, year(fecha_lanzamiento), monthname(fecha_lanzamiento) from disco order by year(fecha_lanzamiento) desc, month(fecha_lanzamiento) asc;

select count(cantidad_disponible), year(fecha_lanzamiento), monthname(fecha_lanzamiento) from disco
group by month(fecha_lanzamiento);


select count(cantidad_disponible), month(fecha_lanzamiento), monthname(fecha_lanzamiento) from disco
group by month(fecha_lanzamiento);


select year(fecha_lanzamiento), month(fecha_lanzamiento), count(cantidad_disponible) from disco
group by 2,1
order by 1 desc, 2 asc;



select cantidad_disponible from disco
where month(fecha_lanzamiento) = 1 and year(fecha_lanzamiento) = 2022;


select sum(cantidad_disponible) from disco
where month(fecha_lanzamiento) = 1 and year(fecha_lanzamiento) = 2022;


select sum(cantidad_disponible), year(fecha_lanzamiento), month(fecha_lanzamiento) from disco
group by month(fecha_lanzamiento), year(fecha_lanzamiento)
order by 2 desc, 3 asc;


# Es el bueno
select year(fecha_lanzamiento) as 'Año', monthname(fecha_lanzamiento) as 'Mes', sum(cantidad_disponible) as 'Cantidad disponible' from disco
group by monthname(fecha_lanzamiento), year(fecha_lanzamiento), month(fecha_lanzamiento)
order by 1 desc, month(fecha_lanzamiento) asc;

/*
Grup by resume por los campos que especifiques
lo encapsula por los valores que pides en la clausula
puedes agregar 'capsulas' para agrupar los datos aunque no se encuentren en el select 

*/



-- Ejercicio 4: Reporte trimestral por año de la cantidad de discos disponibles, ordenado por año y por trimestre.


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



SELECT CONCAT_WS('--',titulo,precio,cantidad_disponible) FROM disco;





select year(fecha_lanzamiento) as 'Año', monthname(fecha_lanzamiento),
case
	when month(fecha_lanzamiento) in (1,2,3) then 'Q1'
	when month(fecha_lanzamiento) in (4,5,6) then 'Q2'
	when month(fecha_lanzamiento) in (7,8,9) then 'Q3'
	else 'Q4'
end as 'Trimerstre'
from disco 
order by 1 desc, month(fecha_lanzamiento) asc;	





# Ruben
select 
year(fecha_lanzamiento) as 'Año', 
monthname(fecha_lanzamiento),
case
	when month(fecha_lanzamiento) in (1,2,3) then 'Q1'
	when month(fecha_lanzamiento) in (4,5,6) then 'Q2'
	when month(fecha_lanzamiento) in (7,8,9) then 'Q3'
	else 'Q4'
end as 'Trimerstre',
sum(cantidad_disponible)
from disco 
group by 3,1
order by 1 desc, month(fecha_lanzamiento) asc;	


# Query que quieren:
select year(fecha_lanzamiento) as 'Año',
case
	when month(fecha_lanzamiento) in (1,2,3) then 'Trimestre 1'
	when month(fecha_lanzamiento) in (4,5,6) then 'Trimestre 2'
	when month(fecha_lanzamiento) in (7,8,9) then 'Trimestre 3'
	else 'Trimestre 4'
end as 'Trimestre',
sum(cantidad_disponible) as 'Cantidad disponible'
from disco
group by 2,1
order by 1 asc, 2 asc;	















