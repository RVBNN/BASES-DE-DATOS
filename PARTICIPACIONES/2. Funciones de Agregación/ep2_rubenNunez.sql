/*
=================================
Ejercicio de participación 2: Funciones de agregación 
Nombre: Ruben Núñez
Fecha: 13 - Nov - 22
=================================
*/
use pixup;

-- Ejercicio 1: Reporte de cuantos títulos fueron lanzados por año, ordenado por año descendentemente.

select year(fecha_lanzamiento) as 'Año', count(titulo) as 'Discos lanzados' from disco
group by year(fecha_lanzamiento) 
order by 1 desc;

-- Ejercicio 2: Reporte de cantidad de discos lanzados por año solo de los años con lanzamientos de más de 10 discos, ordenado por esa cantidad descendente.

select year(fecha_lanzamiento) as 'Año', count(titulo) as 'Total de discos Lanzados' from disco
group by 1
having count(titulo) > 10
order by 2 desc;

-- Ejercicio 3: Reporte por año y por mes indicando el nombre del mes, de la cantidad de discos disponibles, ordenado por año descendente y por mes ascendente.

select year(fecha_lanzamiento) as 'Año', monthname(fecha_lanzamiento) as 'Mes', sum(cantidad_disponible) as 'Cantidad disponible' from disco
group by monthname(fecha_lanzamiento), year(fecha_lanzamiento), month(fecha_lanzamiento)
order by 1 desc, month(fecha_lanzamiento) asc;

-- Ejercicio 4: Reporte trimestral por año de la cantidad de discos disponibles, ordenado por año y por trimestre.

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