/*
=================================
Ejercicio de participación 5: Delete
Nombre: Ruben Núñez
Fecha: 14 - Nov - 22
=================================
*/

/*

source /Users/rubennunezsanchez/Documents/ESCUELA/7. Séptimo Semestre/Bases Datos/Tareas/PARTICIPACIONES/4. Update/ep4_rubenNunez.sql


tee /Users/rubennunezsanchez/Documents/ESCUELA/7. Séptimo Semestre/Bases Datos/Tareas/PARTICIPACIONES/5. Delete/ep5_rubenNunez.txt
source /Users/rubennunezsanchez/Documents/ESCUELA/7. Séptimo Semestre/Bases Datos/Tareas/PARTICIPACIONES/5. Delete/ep5_rubenNunez.sql

*/

/*
		INSTRUCCIONES
Para los siguientes ejercicios, habilitar la base de datos collectionhw y utilizar la tabla carritos[iniciales] dando continuidad a los ejercicios de Update (si no se entregó el ejercicio de participación 4, deberán realizar los ejercicios previos para que las cantidades coincidan).
*/
use collectionhw;

-- 1. Borrar los carritos de color negro o naranja (cualquier tono) cuyo modelo sea 2002, 2012 o 2019 (16 rows) 
select distinct color from carritosRNS order by 1 asc;

select sku,nombre,color,notas,modelo from carritosRNS
where modelo in (2002, 2012, 2019) and color = 'Black' or
modelo in (2002, 2012, 2019) and color like '%orange%'; 


delete from carritosRNS
where modelo in (2002, 2012, 2019) and color = 'Black' or
modelo in (2002, 2012, 2019) and color like '%orange%'; 


-- 2. Borrar los carritos que cuesten más de 100 pero menos de 250 (26 rows)
select sku,nombre,color,precio,modelo from carritosRNS
where precio > 100 and precio < 250;


delete from carritosRNS
where precio > 100 and precio < 250;

-- 3. Borrar los carritos de color "Pearl White" que no tengan observaciones en notas ni ubicación (20 rows)
select sku,nombre,color,precio,modelo, notas, ubicacion from carritosRNS
where color = 'Pearl White' and notas is null and ubicacion is null;

delete from carritosRNS
where color = 'Pearl White' and notas is null and ubicacion is null;

-- 4. Borrar los carritos con rayas blancas y no tienen ubicación (28 rows)
select nombre, descripcion, ubicacion from carritosRNS
where descripcion like '%white stripes%' and ubicacion is null;

delete from carritosRNS
where descripcion like '%white stripes%' and ubicacion is null;

-- 5. Borrar el carrito más caro. Usar consultas anidadas no valores estáticos como: sku = "V5654" o precio = 1994 
select max(precio) from carritosRNS;

select nombre, modelo, precio from carritosRNS
where precio = (select max(precio) from carritosRNS);




/*
Sofía
Hola! Les había prometido escribirles acerca de cómo actualizar en MySQL cuando hay condiciones extrañas sobre la misma tabla. 
 
En principio, no es posible condicionar la actualización de una tabla a un cálculo o conjunto selecto de condiciones aplicadas sobre ella misma. 
Por esta razón, hay que auxiliarse de una tabla temporal generada:
 
-> A través de una doble subconsulta en el where del update  
 
UPDATE mytable t1 SET t1.atributo = 'inserte aquí nuevo valor' 
WHERE t1.atributo IN  
(SELECT t2.atributo from (SELECT * FROM mytable t2 WHERE atributo > 5) f ); 
 
-> O uniendo la tabla a sí misma con un join y haciendo uso de los alias para referenciar valores temporales 
 
UPDATE 
    mytable t1 
LEFT JOIN  
    mytable t2 
ON  
    t1.id = t2.id 
SET 
    t1.atributo1 = 30 
WHERE  
    t2.atributo2 = 2
*/

# Así no se puede borrar/actualizar:
delete from carritosRNS
where precio = (select max(precio) from carritosRNS);

# Esta es la forma correcta de hacerlo:
DELETE FROM carritosRNS
WHERE precio IN
(SELECT precio from (SELECT * from carritosRNS WHERE precio = (select max(precio) from carritosRNS)) f);

# Corroboramos: 
select nombre, modelo, precio from carritosRNS
where precio = (select max(precio) from carritosRNS);

-- 6. Hacer un conteo de los carritos restantes (total de carritos 255)
select count(*) from carritosRNS;



