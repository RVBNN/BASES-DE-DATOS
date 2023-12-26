-- source F:\Pejcovich\BBDD\Semana 10\PR04_INSERT_SELECT\PR04_INSERT_SELECT.sql

/* ---------------------------------------------------------------- */
/* 							PARTE 1 - INSERT											*/
/* ---------------------------------------------------------------- */


/* 1. Cambiar el prompt  */
prompt \c [\R:\m]-[\d]->

/* 2. Crear una base de datos llamada pr04_eqNN */

drop database if exists pr04_eq00;
create database if not exists pr04_eq00;

/* 3. Crear todas las tablas del siguiente diagrama */

use pr04_eq00

-- Creamos las tablas padres primero 
-- Se crea la tabla vendedor
create table if not exists vendedor(
num_vendedor smallint unsigned not null auto_increment primary key,
nombre varchar(30) unique
);

-- Se crea la tabla tienda
create table if not exists tienda(
  num_tienda int unsigned not null auto_increment primary key,
  nombre varchar(50),
  direccion varchar(100)
);

-- Se crea la tabla producto
create table if not exists producto(
  cod_prod int unsigned not null auto_increment primary key,
  precio decimal(6,2),
  tipo varchar(30),
  marca varchar(20)
);


-- Se crean las tablas dependientes (hijas)
-- Se crea la tabla Ventas que depende de Cliente, tienda y vendedor
create table if not exists ventas(
  num_venta int unsigned not null auto_increment primary key,
  id_cliente int unsigned not null,
  id_vendedor smallint unsigned not null,
  id_tienda int unsigned not null,
  fecha_compra timestamp,
  total decimal(8,2),
  foreign key(id_tienda) references tienda(num_tienda),
  foreign key(id_vendedor) references vendedor(num_vendedor)
);

-- se crea la tabla detalle ventas que depende de producto y ventas
create table if not exists detalle_ventas(
  cod_prod int unsigned not null,
  id_venta int unsigned not null,
  cantidad smallint,
  unique(cod_prod,id_venta),
  foreign key(cod_prod) references producto(cod_prod),
  foreign key(id_venta) references ventas(num_venta)  
);

show tables;

/* 4. Insertar 5 registros en cada tabla creada  */

insert into vendedor values
(null,'Marisol'),
(null,'Sofia'),
(null,'Messi'),
(null,'Jonas'),
(null,'Vendedor fantasma');

insert into tienda(nombre,direccion) values
('tienda1','direccion1'),
('tienda2','direccion2'),
('tienda3','direccion3'),
('tienda4','direccion4'),
('tienda5','direccion5');

insert into producto(precio,tipo,marca) values
(1.5,'small','mi marca'),
(2000.01, null, null),
(5, null, null),
(333.2, 'big', 'not mi marca'),
(0, 'none', 'pendiente');

insert into ventas values
(5000,800,1,1,'2022-10-31',2001.51),
(5001,800,2,3,'1999-01-01 12:05',671.4),
(5002,800,2,2,'2022-10-31 14:05:26',null),
(5003,800,4,1,'2022-10-31 18:45:01',null),
(5004,800,4,4,'2022-10-30',null);

insert into detalle_ventas values
(1,5000,1),
(2,5000,1),
(3,5001,1),
(4,5001,2),
(5,5004,null);


/* 5. Mostrar contenido de las tablas ordenando por su llave primaria */

select * from vendedor order by num_vendedor;
select * from tienda order by num_tienda;
select * from producto order by cod_prod;
select * from ventas order by num_venta;
select * from detalle_ventas order by cod_prod, id_venta;


/* Ejercicios 6. y 7. corresponden a su DER  */

/* ---------------------------------------------------------------- */
/* 							PARTE 2 - SELECT											*/
/* ---------------------------------------------------------------- */

use mundo

/* 8. Mostrar campos de los primeros 4 registros  */
select * from paises limit 4;


/* 9. Listar el país de una sola palabra que contiene 
cada una de las vocales (a,e,i,o,u).  */
select pais from paises where pais like '%a%' 
and pais like '%e%'
and pais like '%i%'
and pais like '%o%'
and pais like '%u%'
and pais not like '% %';

/* 10. ¿Qué países del caribe tienen poblaciones 
mayores a 1M (un millón) o cumplen que su nombre 
está compuesto por, al menos, dos palabras?  */
select pais,poblacion from paises where continente = 'Caribbean' and 
(poblacion > 1000000 OR pais like '% %');

/* 11. ¿Qué capitales empiezan con la letra B 
y constan de únicamente 6 letras (sin espacios)? 
Mostrar su nombre y en qué país se encuentran.  */
select capital, pais from paises where capital like 'B_____';

/* 12. En listar los países cuya capital tenga el mismo
 número de letras que el nombre del país; y que tanto
la capital como el país empiecen con la misma letra.  */
select pais, capital, length(pais) as 'Caracteres pais',
length(capital) as 'Caracteres capital'
from paises
where length(pais) = length(capital)
and left(pais,1)=left(capital,1);

/* 13. Listar el país, capital y total de población (en millones)
de los top 3 países con más gente.  */
select concat(pais,' con capital ',capital,' tiene ', round(poblacion/1000000,2),'M de personas.') 
as 'Pais, capital, poblacion'
from paises order by poblacion desc limit 3;

/* 14. Enlistar el nombre de los países, su promedio de gpd
y su continente.

Sólo seleccionar los países que tengan una ‘a’ en la segunda 
y última posición de su nombre, y tales que su promedio esté 
por encima de los 750 millones. Ordenar el resultado 
alfabéticamente por continente y país (en ese orden).  */
select pais,continente,avg(gdp) as 'Promedio GDP' from paises 
where pais like '_a%a'
group by pais
having avg(gdp) > 750000000
order by continente, pais;

/* ---------------------------------------------------------------- */
/* 							EJERCICIO EXTRA											*/
/* ---------------------------------------------------------------- */


