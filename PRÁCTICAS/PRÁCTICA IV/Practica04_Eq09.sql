/* PARTE 1 */

/* Paso 1 */

prompt \c [\R:\m]-[\d] ->

/* Paso 2 */

DROP DATABASE IF EXISTS pr04_eq09;

CREATE DATABASE IF NOT EXISTS pr04_eq09;

USE pr04_eq09;

/* Paso 3 */ 

CREATE TABLE tienda(
num_tienda int unsigned not null auto_increment primary key,
nombre varchar(50) not null,
direccion varchar(100) not null);

CREATE TABLE vendedor(
num_vendedor smallint unsigned not null auto_increment primary key,
nombre varchar(30) not null);

CREATE TABLE producto(
cod_prod int unsigned not null auto_increment primary key,
precio decimal(6,2) not null,
tipo varchar(30) not null,
marca varchar(20) not null);

CREATE TABLE ventas( 
num_venta int unsigned not null auto_increment primary key,
id_cliente int unsigned not null,
id_vendedor smallint unsigned not null,
id_tienda int unsigned not null,
fecha_compra timestamp not null,
total decimal(8,2) not null,
FOREIGN KEY(id_vendedor) REFERENCES vendedor(num_vendedor) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (id_tienda) REFERENCES tienda(num_tienda) ON DELETE RESTRICT ON UPDATE CASCADE);

CREATE TABLE detalle_ventas(
cod_prod int unsigned not null,
id_venta int unsigned not null,
cantidad smallint unsigned not null,
FOREIGN KEY(cod_prod) REFERENCES producto(cod_prod) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY(id_venta) REFERENCES ventas(num_venta) ON DELETE RESTRICT ON UPDATE CASCADE);

/* Paso 4 */

/* Producto */

INSERT INTO producto(cod_prod,precio,tipo,marca) VALUES(null,99.50,'shampoo','Head&Shoulders');

INSERT INTO producto(cod_prod,precio,tipo,marca) VALUES(null,1399.99,'papel de bano','Petalo');

INSERT INTO producto(cod_prod,precio,tipo,marca) VALUES(null,3500.45,'paquete de salchichas','FUD');

INSERT INTO producto(cod_prod,precio,tipo,marca) VALUES(null,15.00,'cheetos flamin hot','Sabritas');

INSERT INTO producto(cod_prod,precio,tipo,marca) VALUES(null,76.99,'dalmata','Marinela');

   
/* Tienda */

INSERT INTO tienda(num_tienda,nombre,direccion) VALUES(null,'El Perrito Panzon','Calle Santa Catarina 45');

INSERT INTO tienda(num_tienda,nombre,direccion) VALUES(null,'Abarrotes La Chona','Av. Gustavo I. Madero 37');

INSERT INTO tienda(num_tienda,nombre,direccion) VALUES(null,'La Merkadona','Calle San Juan de Atoxpan 220');

INSERT INTO tienda(num_tienda,nombre,direccion) VALUES(null,'Abarrotes Kem-Monito','Av. Hidalgo 105');

INSERT INTO tienda(num_tienda,nombre,direccion) VALUES(null,'Cremeria La Numero 10','Calle Insurgentes Oeste 1543');

/* Vendedor */

INSERT INTO vendedor(num_vendedor,nombre) VALUES(null,'Juanito Perez');

INSERT INTO vendedor(num_vendedor,nombre) VALUES(null,'Valentina Mayorga');

INSERT INTO vendedor(num_vendedor,nombre) VALUES(null,'Alfredo Mazo');

INSERT INTO vendedor(num_vendedor,nombre) VALUES(null,'Omar Chaparro');

INSERT INTO vendedor(num_vendedor,nombre) VALUES(null,'Sofia Lara');


/* Ventas */

INSERT INTO ventas(num_venta,id_cliente,id_vendedor,id_tienda,fecha_compra,total) VALUES(null,3541,2,3,'2022-02-25',15.00);

INSERT INTO ventas(num_venta,id_cliente,id_vendedor,id_tienda,fecha_compra,total) VALUES(null,8132,5,4,'2022-09-7',76.99);

INSERT INTO ventas(num_venta,id_cliente,id_vendedor,id_tienda,fecha_compra,total) VALUES(null,6743,3,5,'2022-05-23',1399.99);

INSERT INTO ventas(num_venta,id_cliente,id_vendedor,id_tienda,fecha_compra,total) VALUES(null,3541,1,2,'2022-07-14',99.50);

INSERT INTO ventas(num_venta,id_cliente,id_vendedor,id_tienda,fecha_compra,total) VALUES(null,3541,4,1,'2022-03-08',3500.45);

/* Detalle_Ventas */

INSERT INTO detalle_ventas(cod_prod,id_venta,cantidad) VALUES(4,1,1);

INSERT INTO detalle_ventas(cod_prod,id_venta,cantidad) VALUES(5,2,1);

INSERT INTO detalle_ventas(cod_prod,id_venta,cantidad) VALUES(2,3,1);

INSERT INTO detalle_ventas(cod_prod,id_venta,cantidad) VALUES(1,4,1);

INSERT INTO detalle_ventas(cod_prod,id_venta,cantidad) VALUES(3,5,1);

/* Paso 5 */

SELECT * FROM producto order by cod_prod asc;

SELECT * FROM vendedor order by num_vendedor asc;

SELECT * FROM tienda order by num_tienda asc;

SELECT * FROM ventas order by num_venta asc;

SELECT * FROM detalle_ventas order by cod_prod asc;

SELECT * FROM detalle_ventas order by id_venta asc;

 /* Paso 6 Creación de las Tablas con el código ya existente de la práctica anterior */
/* Adjuntamos el Código de la Base de Datos de nuestro DER */

DROP DATABASE IF EXISTS pr03_eq09;

CREATE DATABASE IF NOT EXISTS pr03_eq09;

USE pr03_eq09;

CREATE TABLE trabajador(
	id int unsigned auto_increment not null primary key,
nombre_pila varchar(10),
puesto varchar(15)
);

DESC trabajador;

CREATE TABLE ingrediente( 
codigo tinyint unsigned auto_increment not null primary key,
nombre varchar(20),
precio_kg decimal(3,1),
disponibilidad enum('D','ND') default 'ND' 
);
DESC ingrediente;

ALTER TABLE trabajador 
ADD fecha_inicio date DEFAULT  '2022-09-30' AFTER nombre_pila;

ALTER TABLE trabajador 
ADD ing_fav tinyint unsigned not null AFTER puesto;

ALTER TABLE trabajador 
ALTER puesto SET DEFAULT 'pasante';

ALTER TABLE trabajador 
ADD FOREIGN KEY(ing_fav) REFERENCES ingrediente(codigo) ON DELETE RESTRICT ON UPDATE CASCADE;

DESC trabajador; 


CREATE TABLE IF NOT EXISTS paciente(
	id_paciente int unsigned not null,
	id_dueno int unsigned not null,
nombre varchar(30) not null,
	raza varchar(30) not null,
	color varchar(30) not null,
	edad smallint not null,
	padecimiento varchar(200) not null,
	alergia varchar(200) not null
);

CREATE TABLE IF NOT EXISTS dueno(
id_dueno int unsigned not null,
nombre varchar(30) not null, 
telefono int unsigned not null,
email varchar(50) not null unique,
calle varchar(100) unique,
	codigo_postal int(5) unsigned
); 

CREATE TABLE IF NOT EXISTS consulta(
	id_consulta int unsigned not null,
	id_paciente int unsigned not null,
	fecha_consulta date not null,
	fecha_siguiente_consulta date not null,
	motivo varchar(200) not null
);

CREATE TABLE IF NOT EXISTS consulta_tratamiento(
id_consulta int unsigned not null,
	id_tratamiento int unsigned not null
);

CREATE TABLE IF NOT EXISTS tratamiento(
	id_tratamiento int unsigned not null,
	nombre varchar(30) not null,
	precio decimal(6,2) not null
);


CREATE TABLE IF NOT EXISTS usuario(
id_usuario int unsigned not null,
nombre varchar(30) not null,
contrasena varchar(50) not null
); 


ALTER TABLE dueno
ADD PRIMARY KEY(id_dueno);

ALTER TABLE paciente
ADD PRIMARY KEY(id_paciente),
ADD CONSTRAINT FK_paciente_dueno FOREIGN KEY(id_dueno) REFERENCES dueno(id_dueno) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE consulta
ADD PRIMARY KEY(id_consulta),
ADD CONSTRAINT FK_paciente_consulta FOREIGN KEY(id_paciente) REFERENCES paciente(id_paciente) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE tratamiento
ADD PRIMARY KEY(id_tratamiento);

ALTER TABLE consulta_tratamiento
ADD PRIMARY KEY(id_consulta, id_tratamiento),
ADD FOREIGN KEY(id_consulta) REFERENCES consulta(id_consulta) ON DELETE RESTRICT ON UPDATE CASCADE,
ADD FOREIGN KEY(id_tratamiento) REFERENCES tratamiento(id_tratamiento) ON DELETE RESTRICT ON UPDATE CASCADE;


/*Paso 6 Mostrar la Descripción de las Tablas */

DESC consulta;

DESC dueno;

DESC paciente;

DESC tratamiento;

/* Paso 7 */ 
/* Insertar elemtos a cada tabla */

INSERT INTO dueno(id_dueno,nombre,telefono,email,calle,codigo_postal) VALUES(1111,'Juan Hernandez',2912536787,'juanhernan@hotmail.com','Calle Durango 30',24367);

INSERT INTO dueno(id_dueno,nombre,telefono,email,calle,codigo_postal) VALUES(1789,'Alfredo Adame',3745389032,'alfred87@hotmail.com','Calle Aldama Prieto 27',89056);

INSERT INTO dueno(id_dueno,nombre,telefono,email,calle,codigo_postal) VALUES(5467,'Andrea Martinez',3421789076,'andymar@outlook.com','Calle Gustavo Colon',67345);


INSERT INTO paciente(id_paciente,id_dueno,nombre,raza,color,edad,padecimiento,alergia) VALUES(1,1789,'Zoe','Pastor Aleman','Negro con Cafe',5,'Estrenimiento','Cacahuate');

INSERT INTO paciente(id_paciente,id_dueno,nombre,raza,color,edad,padecimiento,alergia) VALUES(2,5467,'Gambito','Pez Veta','Violeta',1,'Fatiga y Cansancio','Paracetamol');

INSERT INTO paciente(id_paciente,id_dueno,nombre,raza,color,edad,padecimiento,alergia) VALUES(3,1789,'Kira','Bulldog','Negro',8,'Falta de Apetito','Pollo y Salchicha de Pavo');


INSERT INTO consulta(id_consulta,id_paciente,fecha_consulta,fecha_siguiente_consulta,motivo) VALUES(1234,3,'2021-10-08','2022-10-08','Falta de apetito de varios dias asi como de agua');

INSERT INTO consulta(id_consulta,id_paciente,fecha_consulta,fecha_siguiente_consulta,motivo) VALUES(1345,1,'2022-03-05','2022-11-10','Estrenimiento causado por la injerta de un juguete de plastico');

INSERT INTO consulta(id_consulta,id_paciente,fecha_consulta,fecha_siguiente_consulta,motivo) VALUES(1456,2,'2022-05-23','2022-10-29','Poca movilidad causada por estres debido a la falta de espacio en la pecera');


INSERT INTO tratamiento(id_tratamiento,nombre,precio) VALUES(98765,'Cirugia',7000.00);

INSERT INTO tratamiento(id_tratamiento,nombre,precio) VALUES(97654,'Adquisicion de Pecera',3750.00);

INSERT INTO tratamiento(id_tratamiento,nombre,precio) VALUES(96543,'Medicamento',799.99);


/* Describir las tablas */

SELECT * FROM dueno;

SELECT * FROM paciente;

SELECT * FROM consulta;

SELECT * FROM tratamiento;

/* PARTE 2 */

/* Cargar la base de datos ‘mundo’ contenida en el archivo pr04_mundo.sql y verificar
el número de registros. No añadir en el script la línea para cargar esta base. */
USE mundo;

SELECT 'paises' AS 'tabla', COUNT(*) AS 'num_registros' FROM paises;

# 8. Mostrar todos los campos de los primeros 4 registros de la tabla paises
SELECT * FROM paises LIMIT 4;

# 9. Listar el país de una sola palabra que contiene cada una de las vocales (a,e,i,o,u). 
SELECT pais
FROM paises
WHERE pais NOT LIKE '% %' AND 
pais LIKE '%a%' AND 
pais LIKE '%e%' AND
pais LIKE '%i%' AND 
pais LIKE '%o%' AND
pais LIKE '%u%';

/* 
10. ¿Qué países del caribe tienen poblaciones mayores a 1M (un millón) o cumplen
que su nombre está compuesto por, al menos, dos palabras? 
*/

SELECT pais FROM paises
WHERE continente LIKE 'Caribbean' AND poblacion > 1000000 OR
pais LIKE '% %';

/*
11. ¿Qué capitales empiezan con la letra B y constan de únicamente 6 letras
(sin espacios) ? Mostrar su nombre y en qué país se encuentran. 
*/

SELECT REPLACE(capital, ' ', '') AS capital, pais
FROM paises 
WHERE capital LIKE 'B%'  AND LENGTH(capital) = 6;

/*
12. En listar los países cuya capital tenga el mismo número de letras que el nombre
del país; y que tanto la capital como el país empiecen con la misma letra. 
*/

SELECT pais FROM paises
WHERE LENGTH(capital) = LENGTH(pais) AND
LEFT(capital, 1) = LEFT(pais, 1);

/*
13. Listar el país, capital y total de población (en millones) de los top 3 países con
más gente. El resultado deberá visualizarse de la siguiente manera: 
*/

SELECT CONCAT(pais, ' con capital ', capital, ' tiene ', ROUND(poblacion/1000000, 2), 'M de personas.')
as 'Pais, capital, poblacion' FROM paises ORDER BY round(poblacion/1000000, 2) DESC LIMIT 3;

/*
14. Enlistar el nombre de los países, su promedio de gpd y su continente.
Sólo seleccionar los países que tengan una ‘a’ en la segunda y última posición de su
nombre, y tales que su promedio esté por encima de los 750 millones. Ordenar el
resultado alfabéticamente por continente y país (en ese orden). 
*/

SELECT pais, gdp, continente FROM paises
WHERE pais LIKE '_a%' AND right(pais, 1) LIKE 'a'
AND gdp > 750000000
ORDER BY continente, pais ASC;


/* EXTRA */

# Insertar valores 
USE pr03_eq09;

INSERT INTO dueno VALUES
(4,'Julio',5562456,'juliocs12@hotmail.com','La petrolera',02460),
(5,'Armando',938456,'arm22@outlook.com','las armas',05543),
(6,'Brenda',2093456,'brend89@outlook.com','Calle flores magon',88667);

INSERT INTO paciente VALUES
(4,4,'Jack','Corgi','Cafe',10,'Fatiga','leche'),
(5,5,'Bubba','Pastor aleman','negro',5,'Vomito','trigo'),
(6,6,'Ein','Corgi','Cafe',4,'Falta de sueño','hongos');

# ¿Cuales son los padecimientos de los perros corgi con más de 5 años de edad pero menos de 11?

SELECT  id_paciente,nombre,edad,padecimiento as 'padecimientos de perros corgi' from paciente where raza = 'Corgi' and edad between 5 and 11; 

# ¿Cual es el nombre, telefono y residencia de los duenos, de forma que la direccion este completamente en mayusculas y reemplazando la palabra calle por su abreviatura C.?

SELECT CONCAT('El dueno ',nombre,' cuyo telefono es ',telefono,' vive en ', REPLACE(calle, 'Calle','c.')) as 'informacion del dueno' FROM dueno;

# ¿Qué razas tienen en promedio mas de 7 años de edad?

SELECT raza, AVG(edad)FROM paciente GROUP BY raza HAVING AVG(edad)>6;  

#Borrar registros:

#alter table paciente drop foreign key FK_paciente_consulta;
#alter table consulta drop foreign key FK_paciente_consulta;

#delete from dueno; 
#delete from paciente; 

