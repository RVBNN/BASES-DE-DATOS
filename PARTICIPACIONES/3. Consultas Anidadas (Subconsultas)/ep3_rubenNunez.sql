/*
=================================
Ejercicio de participación 3: Consultas anidadas (subconsultas)
Nombre: Ruben Núñez
Fecha: 13 - Nov - 22
=================================
*/
use pixup;


-- Ejercicio 1: Obtener el id, título y precio del disco más barato

select id_disco, titulo, precio from disco
where precio = (select min(precio) from disco);

-- Ejercicio 2: Obtener el id, título y cantidad disponible del disco con mayor cantidad disponible

select id_disco, titulo, cantidad_disponible from disco
where cantidad_disponible = (select max(cantidad_disponible) from disco);

-- Ejercicio 3: Obtener el id,título y fecha de lanzamiento del disco lanzado más reciente

select id_disco, titulo, fecha_lanzamiento from disco
where fecha_lanzamiento = (select max(fecha_lanzamiento) from disco);

-- Ejercicio 4: Obtener el id, título y precio de los discos con precios mayores que el precio promedio pero menores que $500, ordenados por precio.

select id_disco, titulo, precio from disco
where precio > (select avg(precio) from disco) and 
precio < 500
order by 3 asc;