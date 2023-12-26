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

-- 1.
use collectionhw;
drop table if exists carritosRNS;
create table if not exists carritosRNS as select * from carritos;

-- 2.
select distinct color from carritosRNS;

-- 3. Actualizar el color de los carritos que empiezan con la palabra "Mtflk." (126 rows), "satin" (16 rows) y "Spectraflame" (15 rows) 
-- para que se unifiquen los nombres quitándoles esa palabra, por ejemplo: 
-- el carrito con sku -> V5294 color-> Mtflk. Magenta, debe quedar con color -> Magenta. Para este ejercicio se requieren 3 instrucciones, una por cada palabra.

# Mtflk.
update carritosRNS
set color = right(color, length(color) - length('Mtflk. '))
where color like 'Mtflk.%';

# Satin
update carritosRNS
set color = right(color, length(color) - length('satin '))
where color like 'satin%';

# Spectraflame
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


-- 11. Obtener un reporte que muestre el nombre, el modelo, el precio, precio con descuento, la diferencia entre ambos precios 
--		y el porcentaje de descuento pero sólo de los carritos que tuvieron descuento, ordenado por modelo (81 rows) 
--		Ver imagen, atención en formato y columnas
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
select modelo, count(sku) as 'Total de carritos', 
format(sum(precio), 1) as 'Venta total',
format(sum(precioNuevo), 1) as ' Venta con descuento',
format(sum(CASE WHEN precioNuevo <> 0 THEN precio - precioNuevo ELSE 0 END), 1) as 'Cantidad descontada' from carritosRNS
group by 1
order by 1 asc;

-- 13. Mostrar el total de carritos[iniciales] (-- 346 rows)

select count(*) as 'Total carritos' from carritosRNS;
