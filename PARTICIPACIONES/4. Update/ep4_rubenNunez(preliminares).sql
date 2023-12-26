/*
=================================
Ejercicio de participación 4: Update
Nombre: Ruben Núñez
Fecha: 13 - Nov - 22
=================================
*/


# Vamos a realizar modificaciones a la tabla, por lo que haremos un respaldo de la base
use collectionhw;

/*
	Copia de la tabla datos de collectionhw

Este es un comando para COPIAR REGISTROS de una tabla	 
No considera la estructura de la tabla, es decir no guarda las llaves
*/

-- 1. Copia de la tabla datos de collectionhw
create table if not exists carritos as select * from datos;

-- 2. Cambiar el modelo del auto V5315 a 2012
UPDATE carritos SET modelo = 2012 WHERE sku = "V5315";

-- 3. Agregar una columna a la tabla autos llamada: ubicacion con valor por default NULL
alter table carritos add ubicacion varchar(50) default NULL;

-- 4. Listar las columnas nombre, color, modelo, notas, ubicación
select nombre, color, modelo,notas,ubicacion from carritos limit 10;

-- 5. Actualizar el valor de la columna ubicacion
update carritos set ubicacion = 'Coyoacán';

-- 6. Volver a listar las columnas nombre, color, modelo,notas,ubicación
select nombre, color, modelo,notas,ubicacion from carritos limit 10;

-- 7. Actualizar el valor a NULL de la columna ubicacion para todos los carritos excepto para aquellos que tienen notas distintas de null
update carritos set ubicacion = NULL where notas is null;

-- 8. Volver a listar las columnas nombre, color, modelo, notas, ubicacion
select nombre, color, notas, modelo, ubicacion from carritos limit 10;
select nombre, color, notas, modelo, ubicacion from carritos where notas is not null;

-- 9. Actualizar las notas de todos los Datsun para que diga agotado:
update carritos set notas = 'agotado' where nombre like 'Datsun%';

-- 10. Listar datos de carritos que inicien con Datsun:
select sku,nombre, notas,series,color,precio,modelo from carritos where nombre like
'Datsun%';

-- 11. Mostrar sku, nombre, precio, modelo y series de los carritos que contengan la
palabra “bird” en su nombre
select sku,nombre,precio,modelo,series from carritos where nombre like '%bird%';

-- 12. Actualizar el precio del carrito "Minion Pig" con un descuento del 15%
Update carritos set precio = precio * .85 where sku = "V5323";

-- 13. Listar los modelos únicos ordenado por modelo
select DISTINCT modelo from carritos order by modelo;

-- 14. Listar la cantidad de unidades por modelo
select modelo, count(*) from carritos group by modelo order by 1;











# Ruben: UPDATE
-- 2. Cambiar el modelo del auto V5315 a 2012
update carritos set modelo = 2012
where sku = "V5315";

-- 3. Agregar una columna a la tabla autos llamada: ubicacion con valor por default NULL
alter table carritos add ubicacion varchar(50) default null;

-- 4. Listar las columnas nombre, color, modelo, notas, ubicación
select nombre, color, modelo, notas, ubicación from carritos;

-- 5. Actualizar el valor de la columna ubicacion a Coyoacán para todos los carrios
update carritos set ubicacion = 'Coyoacán';

-- 6. Volver a listar las columnas nombre, color, modelo,notas,ubicación
select nombre, color, modelo, notas, ubicacion from carritos;

-- 7. Actualizar el valor a NULL de la columna ubicacion para todos los carritos excepto para aquellos que tienen notas distintas de null
update carritos set ubicacion = null where notas is null;

-- 8. Volver a listar las columnas nombre, color, modelo, notas, ubicacion
select nombre, color, modelo, notas, ubicacion from carritos;

-- 9. Actualizar las notas de todos los Datsun para que diga agotado:
update carritos set notas = 'agotado' where
nombre like '%datsun%';

-- 10. Listar datos de carritos que inicien con Datsun:
select sku, nombre, notas, series, color, precio, modelo from carritos where nombre like 'Datsun%';

-- 11. Mostrar sku, nombre, precio, modelo y series de los carritos que contengan la palabra “bird” en su nombre
select sku, nombre, precio, modelo, series from carritos
where nombre like '%bird%';

select sku, nombre, precio, modelo, series from carritos
where nombre like '%Minion Pig%';

-- 12. Actualizar el precio del carrito "Minion Pig" con un descuento del 15%
update carritos set precio = precio * (1 - .15)
where nombre like '%Minion Pig%';

-- 13. Listar los modelos únicos ordenado por modelo
select distinct modelo from carritos 
order by 1 asc;

-- 14. Listar la cantidad de unidades por modelo
select modelo, count(sku) from carritos
group by 1
order by 1 asc;



/*

Marisol: DELETE

Syntax:
DELETE FROM nombre_tabla WHERE condicion;

*/

-- 0. Elimina el registro del carro con sku V5289
DELETE from carritos WHERE sku = "V5289";

-- 1. Borrar los carritos del modelo 2020
DELETE from carritos WHERE modelo = 2020;

-- 2. Listar las columnas: sku, nombre, color, notas, modelo 1999, 2005 y 2011
select sku,nombre,color,notas,modelo from carritos 
where modelo in (1999,2005,2011);

-- 3. Borrar los carritos modelo 2005 y 2011 que sean de las series "Muscle Mania"
delete from carritos where modelo in (2005,2011) and series like "%mania%";

-- 4. Listar las columnas nombre, color, notas, modelo de carritos 2015
select nombre,color,notas,modelo from carritos where modelo =2015;

-- 5. Borrar los carritos modelo 2015 que en notas tengan NULL
delete from carritos where modelo=2015 AND notas is null;

-- 6. Borrar los Camaro rojos con notas nulas
delete from carritos where nombre like '%camaro%' and 
color like "%red%" and notas is null;

-- 7. Ver la cantidad de autos restante
select count(*) as total from carritos;

-- 8. Listar la cantidad de unidades por modelo
select modelo, count(*) from carritos group by modelo order by 1;



/*
												PRELIMINARES DE LA PRÁCTICA
*/


/*
=================================
Ejercicio de participación 4: Update
Nombre: Ruben Núñez
Fecha: 14 - Nov - 22
=================================
*/

/*
INSTRUCCIONES:

1) Generar un archivo script sql que contenga las instrucciones que solucionen lo que solicita cada ejercicio y comentarios que indiquen el número de ejercicio (no poner las instrucciones de tee o prompt en este archivo), nombrarlo como ep4_nombreApellido.sql

2) Generar un archivo txt con el comando tee, ejemplo: tee ep4_nombreApellido.txt

3) Poner en el prompt su nombre, apellido y la fecha y hora del sistema, ejemplo: prompt (MarisolFlores en: \d \\\D) mysql>
*/

-- 1. Hacer una copia de la tabla carritos y que se llame carritos[iniciales] ejemplo: carritosMFC (hacer los ejercicios sobre esta tabla generada, ejemplo: update carritosMFC set ...)
use collectionhw;
drop table if exists carritosRNS;
create table if not exists carritosRNS as select * from carritos;

-- 2. Listar los colores únicos de todos los carritos ordenado por color (98 rows)
select distinct color from carritosRNS;

-- 3. Actualizar el color de los carritos que empiezan con la palabra "Mtflk." (126 rows), "satin" (16 rows) y "Spectraflame" (15 rows) 
-- para que se unifiquen los nombres quitándoles esa palabra, por ejemplo: 
-- el carrito con sku -> V5294 color-> Mtflk. Magenta, debe quedar con color -> Magenta. Para este ejercicio se requieren 3 instrucciones, una por cada palabra.

# Mtflk.
select color from carritosRNS where
color like 'Mtflk.%';

update carritosRNS
set color = right(color, length(color) - length('Mtflk. '))
where color like 'Mtflk.%';

# Satin
select color from carritosRNS where
color like 'satin%';

update carritosRNS
set color = right(color, length(color) - length('satin '))
where color like 'satin%';

# Spectraflame
select color from carritosRNS where
color like 'Spectraflame%';

update carritosRNS
set color = right(color, length(color) - length('Spectraflame '))
where color like 'Spectraflame%';

-- 4. Volver a mostrar la lista de colores únicos (70 rows) (este punto será válido si el 3 se realizó correctamente)
select distinct color from carritosRNS;

-- 5. Asignar el valor de "Perisur" en la ubicación NULL de los carritos rojos (puros) y cuya serie contemple "stars", "racers" o "muscle" (14 rows)

update carritosRNS
set ubicacion = 'Perisur' where
ubicacion is null and color like 'Red' and series like '%stars%' or
ubicacion is null and color like 'Red' and series like '%racers%' or
ubicacion is null and color like 'Red' and series like '%muscle%';

-- 6. Actualizar las notas y el modelo (en una sola instrucción) de los carritos que su nombre comienza con un año por ejemplo "2012 Volkswagen Beetle" (12 rows) Ver imágenes



/*

															FAILS

select nombre, nombre REGEXP '^[0-9]+$', modelo, left(nombre, 4),left(nombre, 4) REGEXP '^[0-9]+$' as t1,  substr(nombre,1,4) , substr(nombre,1,4) REGEXP '^[0-9]+$' as t2 from carritosRNS
where left(nombre, 4) between 1886 and 3000 and left(nombre,4) <> modelo;

select nombre, modelo, left(nombre, 4) from carritosRNS
where left(nombre, 4) between 1886 and 3000;

update carritosRNS
set modelo = left(nombre, 4),
notas = concat(modelo, ' modelo corregido')
where left(nombre, 4) between 1886 and 3000 and left(nombre,4) <> modelo;



select nombre, modelo from carritosRNS
where cast(left(nombre, 4) as integer) between 1886 and 3000 and cast(left(nombre,4) as integer) <> modelo;
*/



select nombre, modelo,color, notas from carritosRNS 
where nombre LIKE '19%' or nombre LIKE '20%' 
order by nombre;

update carritosRNS 
set notas= concat(modelo,' modelo corregido'), 
modelo=SUBSTRING(nombre,1,4)  
where nombre LIKE '19%' or nombre LIKE '20%';


select nombre, modelo,color, notas from carritosRNS 
where nombre LIKE '19%' or nombre LIKE '20%' 
order by nombre;




-- 7. Agregar una columna llamada precioNuevo después de la columna precio con tipo de datos decimal(10,2) que tenga por default el valor 0.0

alter table carritosRNS
add precioNuevo decimal(10,2) default 0.0 after precio;

-- 8. Listar nombre,precio,precioNuevo,modelo limitado a 10 registros, debe mostrar el valor 0.0 para el atributo precioNuevo. 

select nombre, precio, precioNuevo, modelo from carritosRNS limit 10;

-- 9. Actualizar el precioNuevo de los carritos de acuerdo con la tabla proporcionada.
update carritosRNS
set precioNuevo = precio * (1 - .25) where modelo = 2012;

update carritosRNS
set precioNuevo = precio * (1 - .20) where modelo = 2019;

update carritosRNS
set precioNuevo = precio * (1 - .10) where modelo in (2010, 2013, 2020);

-- 10. Listar la cantidad de carritos que hay por modelo ordenado por la cantidad de mayor a menor (23 rows)
select modelo, count(modelo) as 'Total de carritos' from carritosRNS
group by modelo
order by 2 desc;


/* 
¿Hay alguna forma de hacer esto?

update carritosRNS
case
when modelo = 2012 then set precioNuevo = precio * (1-.25)
when modelo = 2019 then set precioNuevo = precio * (1 - .20)
when modelo in (2010, 2013, 2020) then set precioNuevo = precio * (1 - .10);
end;

*/

/*
11. Obtener un reporte que muestre el nombre, el modelo, el precio, precio con descuento, la diferencia entre ambos precios 
y el porcentaje de descuento pero sólo de los carritos que tuvieron descuento, ordenado por modelo (81 rows) 

Ver imagen, atención en formato y columnas
*/



/*
select nombre, modelo, precio, precioNuevo, (precio - precioNuevo), (precioNuevo * 100 / precio) from carritosRNS
where modelo in (2010, 2012, 2013, 2019, 2020)
order by modelo;
*/



select nombre, modelo, precio, 
round(precioNuevo, 1) as 'precio con descuento', 
round((precio - precioNuevo), 1) as 'cantidad descontada', 
round((100 - (precioNuevo * 100 / precio)), 0) as '% de descuento' from carritosRNS
where (precioNuevo * 100 / precio) <> 0
order by modelo asc;


/*
12. Suponiendo que se desea vender toda la colección de carritos. 

Mostrar un reporte de carritos por modelo, con la cantidad total de carritos, 
la cantidad total de venta para el precio original, 
para el precio con descuento 
y la diferencia de ambos precios, ordenado por modelo y 
con formato para las cantidades (23 rows) 

Ver imagen, atención con formato y columnas.
*/

/*
			FAIL
select modelo, count(sku) as 'Total de carritos',
round((count(sku) * precio), 1) as 'Venta total',
round((count(sku) * precioNuevo), 1) as 'Venta con descuento',
round((precio - precioNuevo), 1) as 'Cantidad descontada'
from carritosRNS
group by 1
order by modelo asc;
*/

select modelo, count(sku) as 'Total de carritos', 
format(sum(precio), 1) as 'Venta total',
format(sum(precioNuevo), 1) as ' Venta con descuento',
format(sum(CASE WHEN precioNuevo <> 0 THEN precio - precioNuevo ELSE 0 END), 1) as 'Cantidad descontada' from carritosRNS
group by 1
order by 1 asc;

-- 13. Mostrar el total de carritos[iniciales] (-- 346 rows)

select count(*) as 'Total carritos' from carritosRNS;



















