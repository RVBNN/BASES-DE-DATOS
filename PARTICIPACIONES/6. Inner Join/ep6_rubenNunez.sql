/*
=================================
Ejercicio de participación 6: Delete
Nombre: Ruben Núñez
Fecha: 14 - Nov - 22
=================================
*/


/*

tee /Users/rubennunezsanchez/Documents/ESCUELA/7. Séptimo Semestre/Bases Datos/Tareas/PARTICIPACIONES/6. Inner Join/ep6_rubenNunez.txt

source /Users/rubennunezsanchez/Documents/ESCUELA/7. Séptimo Semestre/Bases Datos/Tareas/PARTICIPACIONES/6. Inner Join/ep6_rubenNunez.sql


*/

use pixup;
-- 1. Generar un reporte con el total de discos por disquera de cada país, pero solo de las disqueras que tienen 5 o más discos.
select pais.nombre as 'Pais', disquera.nombre as 'Disquera', count(id_disco) as 'total_discos' from disco 
join disquera using(id_disquera)
join pais using(id_pais)
group by 2,1
having count(id_disco) >= 5
order by 3 desc;


-- 2. Generar un reporte que muestre la cantidad total de canciones por género musical.
select genero.id_genero, genero.nombre as 'género musical', count(id_cancion) as 'Total de canciones por género' from disco_cancion
join genero using(id_genero)
join cancion using(id_cancion)
group by 1,2
order by 3 desc;

-- 3. Generar un reporte que muestre cada canción con su género musical, pero sólo de los géneros que tienen menos de 5 canciones.

# Tabla intermedia para sacar los generos que tienen menos de 5 canciones
select genero.id_genero, genero.nombre as 'género musical', count(id_cancion) as 'Total de canciones por género' from disco_cancion
join genero using(id_genero)
join cancion using(id_cancion)
group by 1,2
having count(id_cancion) < 5
order by 3 desc;


select id_cancion, cancion.nombre, genero.nombre from disco_cancion
join cancion using(id_cancion)
join genero using(id_genero)
# Pegamos la tabla intermedia que lleva el alias 's' usando el id_genero
join (select genero.id_genero, genero.nombre as 'género musical', count(id_cancion) as 'Total de canciones por género' from disco_cancion
join genero using(id_genero)
join cancion using(id_cancion)
group by 1,2
having count(id_cancion) < 5
order by 3 desc) s using (id_genero);


-- 4. Generar un reporte que muestre las canciones en español cuyo género musical empiece con F o con R.
select cancion.nombre as 'Cancion', idioma.nombre as 'Idioma', genero.nombre as 'Género musical' from disco_cancion
join cancion using(id_cancion)
join genero using(id_genero)
join idioma using(id_idioma)
where idioma.nombre = 'Español' and genero.nombre like 'F%' or 
idioma.nombre = 'Español' and genero.nombre like'R%';



select id_cancion, cancion.nombre as 'canción', genero.nombre as 'género musical', idioma.nombre as 'idioma' from disco_cancion
join cancion using(id_cancion)
join genero using(id_genero)
join idioma using(id_idioma)
where idioma.nombre = 'Español' and genero.nombre like 'F%' or 
idioma.nombre = 'Español' and genero.nombre like'R%';


-- 5. Generar un reporte que muestre el nombre de la canción, el disco al que pertenece, artista que la canta, género musical, idioma y versión, ordenado por disco, artista y canción.
select cancion.nombre as 'canción', disco.titulo as 'disco', artista.nombre as 'artista', genero.nombre as 'género musical', idioma.nombre as 'idioma', version.nombre as 'version' from disco_cancion
join cancion using(id_cancion)
join disco using(id_disco)
join artista using(id_artista)
join genero using(id_genero)
join idioma using(id_idioma)
join version using(id_version)
order by 2,3,1;

-- 6. Mostrar el nombre del cliente y los discos vendidos en cada ticket separando los títulos por doble dos puntos
select cliente.nombre, ticket.id_ticket, group_concat(disco.titulo SEPARATOR ' :: ') from cliente
join ticket using(id_cliente)
join detalle_ticket using(id_ticket)
join disco using(id_disco)
group by 2,1
order by 2 asc;

/*
    GROUP_CONCAT()
    https://www.geeksforgeeks.org/mysql-group_concat-function/#:~:text=The%20GROUP_CONCAT()%20function%20in,Otherwise%2C%20it%20returns%20NULL.
*/

-- 7. Mostrar los discos vendidos en cada ticket como un arreglo.
select detalle_ticket.id_ticket, JSON_ARRAYAGG(disco.titulo) from detalle_ticket
join disco using(id_disco);

select id_ticket, disco.titulo from detalle_ticket
join disco using(id_disco) order by 1 asc;

select cliente.nombre as 'Cliente', ticket.id_ticket, JSON_ARRAYAGG( disco.titulo ) AS 'Discos vendidos por ticket' from cliente
join ticket using(id_cliente)
join detalle_ticket using(id_ticket)
join disco using(id_disco)
group by 2,1
order by 2;


/*
    JSON_ARRAYAGG()

    https://www.bennadel.com/blog/4217-goodbye-group-concat-hello-json-arrayagg-and-json-objectagg-in-mysql-5-7-32.htm

SELECT
    e.id,
    e.name,

    -- Pull back all the tag names a single array. Each tag will be an item
    -- within the array.
    JSON_ARRAYAGG( t.name ) AS tagNames,

    -- Create an object with the schema { tag.id : tag.name }. Each tag ID will
    -- be a key within the object.
    JSON_OBJECTAGG( t.id, t.name ) AS tagIndex
FROM
    blog_entry e
INNER JOIN
    blog_entry_tag_jn jn -- Our many-to-many join table.
ON
    jn.blog_entry_id = e.id
INNER JOIN
    tag t
ON
    t.id = jn.tag_id

-- Since we're GROUPING on the blog entry records, all of the `INNER JOIN` tag
-- information is going to be collapsed. However, we can extract aggregation
-- information about the tags using our JSON functions above!
GROUP BY
    e.id
HAVING
    COUNT( * ) > 1 -- To make the grouping more exciting!
ORDER BY
    e.id DESC
LIMIT
    10
*/




-- 8. Mostrar los discos comprados por cliente en cada ticket, indicando el título del disco y cantidad vendida, y total por ticket

/* 
    PRELIMINARES

select concat(cliente.nombre, ' ', cliente.apellido_paterno) as 'nombre', ticket.id_ticket, disco.titulo, detalle_ticket.cantidad, disco.precio from cliente
join ticket using(id_cliente)
join detalle_ticket using(id_ticket)
join disco using(id_disco)
group by id_disco,2,1
order by 2 asc;


select concat(cliente.nombre, ' ', cliente.apellido_paterno) as 'nombre', ticket.id_ticket, disco.titulo, detalle_ticket.cantidad, disco.precio, (detalle_ticket.cantidad * disco.precio) from cliente
join ticket using(id_cliente)
join detalle_ticket using(id_ticket)
join disco using(id_disco)
group by id_disco,2,1
order by 2 asc;


select concat(cliente.nombre, ' ', cliente.apellido_paterno) as 'nombre', ticket.id_ticket, disco.titulo, detalle_ticket.cantidad, disco.precio, (detalle_ticket.cantidad * disco.precio) from cliente
join ticket using(id_cliente)
join detalle_ticket using(id_ticket)
join disco using(id_disco)
group by id_disco,2,1
order by 2 asc;


# Preliminar al query deseado
select concat(cliente.nombre, ' ', cliente.apellido_paterno) as 'nombre', ticket.id_ticket, sum(detalle_ticket.cantidad * disco.precio) as 'total'
from cliente
join ticket using(id_cliente)
join detalle_ticket using(id_ticket)
join disco using(id_disco)
group by id_cliente, 2
order by 2 asc;


# Mi propuesta:
select concat(cliente.nombre, ' ', cliente.apellido_paterno) as 'nombre', ticket.id_ticket, group_concat(disco.titulo, ': ',detalle_ticket.cantidad SEPARATOR', ') as 'Discos vendidos por ticket', sum(detalle_ticket.cantidad * disco.precio) as 'total' from cliente
join ticket using(id_cliente)
join detalle_ticket using(id_ticket)
join disco using(id_disco)
group by 2,1
order by 2;

*/

# Query deseado: No supe cómo ponerlas llaves {}
select concat(cliente.nombre, ' ', cliente.apellido_paterno) as 'nombre', ticket.id_ticket, group_concat('"',disco.titulo, '": ',detalle_ticket.cantidad SEPARATOR', ') as 'Discos vendidos por ticket', round(sum(detalle_ticket.cantidad * disco.precio), 0) as 'total' from cliente
join ticket using(id_cliente)
join detalle_ticket using(id_ticket)
join disco using(id_disco)
group by 2,1
order by 2;


-- 9. Generar un reporte que muestre el nombre del cliente, el id del ticket, fecha de venta, disco, cantidad, precio y subtotal, de los clientes que compraron más de una vez.

/*
    PRELIMINARES

SELECT 
CONCAT(cliente.nombre, ' ', cliente.apellido_paterno) as 'Cliente', ticket.id_ticket, cast(ticket.fecha as date) as 'Fecha de venta', 
disco.titulo as 'Disco', detalle_ticket.cantidad as 'Cantidad', disco.precio as 'Precio' FROM cliente
join ticket using(id_cliente)
join detalle_ticket using(id_ticket)
join disco using(id_disco);


# Condición útil para cumplir con la condicion de tener a los clientes que compraron más de una vez
select id_cliente, count(id_cliente) from ticket
group by 1
having count(ticket.id_cliente) > 1;

*/

# Query deseado:
alter table detalle_ticket
modify subtotal decimal(10,2);


SELECT 
CONCAT(cliente.nombre, ' ', cliente.apellido_paterno) as 'Cliente', ticket.id_ticket, cast(ticket.fecha as date) as 'Fecha de venta', 
disco.titulo as 'Disco', detalle_ticket.cantidad as 'Cantidad', Concat('$', round(disco.precio, 1)) as 'Precio', Concat('$', round(detalle_ticket.subtotal, 1)) as 'Subtotal' FROM cliente
join ticket using(id_cliente)
join detalle_ticket using(id_ticket)
join disco using(id_disco)
join (select id_cliente, count(id_cliente) from ticket group by 1 having count(ticket.id_cliente) > 1) s using(id_cliente)
order by 1;

-- 10. Generar un reporte que muestre el nombre del cliente, el id del ticket, fecha de venta, discos vendidos por ticket con cantidad y total pagado, de los clientes que tienen sólo 1 ticket.
SELECT 
CONCAT(cliente.nombre, ' ', cliente.apellido_paterno) as 'Cliente', ticket.id_ticket, cast(ticket.fecha as date) as 'Fecha de venta', 
group_concat('"',disco.titulo, '": ',detalle_ticket.cantidad SEPARATOR', ') as 'Discos vendidos por ticket', concat('$',format(round(sum(detalle_ticket.subtotal),1),1)) as 'Total pagado' FROM cliente
join ticket using(id_cliente)
join detalle_ticket using(id_ticket)
join disco using(id_disco)
join (select id_cliente, count(id_cliente) from ticket group by 1 having count(ticket.id_cliente) = 1) s using(id_cliente)
group by 2
order by 1;



select * from ticket where; id_ticket = 4; 

select fecha from ticket;



SELECT 
CONCAT(cliente.nombre, ' ', cliente.apellido_paterno) as 'Cliente', ticket.id_ticket, ticket.fecha as 'Fecha de venta',
group_concat('"',disco.titulo, '": ',detalle_ticket.cantidad SEPARATOR', ') as 'Discos vendidos por ticket' FROM cliente
join ticket using(id_cliente)
join detalle_ticket using(id_ticket)
join disco using(id_disco)
group by id_ticket
order by 1;


join detalle_ticket using(id_ticket)
join (select id_cliente, count(id_cliente) from ticket group by 1 having count(ticket.id_cliente) = 1) s using(id_cliente)



select id_ticket, id_cliente, count(id_cliente) from ticket
group by 2;

select * from ticket;




select id_cliente, count(id_cliente) from ticket
group by 1
having count(id_cliente) = 1;




















