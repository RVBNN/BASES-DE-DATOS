/* =======================================================

Proyecto Final Bases de Datos
Fecha: 8 de Dciembre del 2022
Equipo 9
Integrante 1: Núñez Sánchez Ruben 
Integrante 2: Peña Romero Gerardo

========================================================*/

prompt [\d] mysql~>


USE covid; 

/* SECCIÓN 1 : CONSULTAS */

/*  EJERCICIO 1 */
/* 1. Id del paciente, edad, fecha de síntomas, fecha de ingreso, estado, 
municipio de residencia y resultado de la prueba covid, de las mujeres embarazadas 
que fueron hospitalizadas y cuyo municipio de residencia tiene alguna de las 
palabras: Cárdenas, Zapata y Atotonilco, ordenado por resultado de la prueba y edad. */

SELECT 'Ejercicio 1' AS '';

SELECT embarazos.id_paciente
	, pacientes.edad AS 'edad'
	, pacientes.fecha_sintomas
	, pacientes.fecha_ingreso
	, estados.nom_estado AS 'Estado'
	, municipios.nom_mun AS 'Municipio'
	, resultado.descripcion AS 'Prueba COVID'
FROM embarazos
JOIN pacientes ON pacientes.id_paciente = embarazos.id_paciente
JOIN tipos_paciente ON tipos_paciente.clave_tipo = pacientes.tipo_paciente 
JOIN resultado ON resultado.clave_resultado = pacientes.clave_resultado
JOIN mexicanos ON mexicanos.id_paciente = embarazos.id_paciente
JOIN municipios ON municipios.edo_mun = mexicanos.edomun_resi
JOIN estados ON estados.clave_edo = municipios.clave_edo
WHERE tipos_paciente.clave_tipo = 2
AND resultado.clave_resultado IN (1,2)
AND municipios.nom_mun IN (SELECT nom_mun from municipios where nom_mun like '%Cardenas%' or nom_mun like '%Zapata%' or nom_mun like '%Atotonilco%')
ORDER BY 7 DESC, 2 ASC;

/* EJERCICIO 2 */
/* 2. Estado de nacimiento, estado de residencia, municipio y edad de las mujeres embarazadas que murieron 
por covid y que no vivían en su estado de nacimiento. */

SELECT 'Ejercicio 2' AS '';

SELECT a.estado_de_nacimiento
	, b.Estado_de_residencia
	, c.Municipio_de_residencia
	, c.edad
FROM (SELECT estados.nom_estado as 'Estado_de_nacimiento'
	, abc.id_paciente
	, abc.edad
FROM estados
JOIN (SELECT defunciones.id_paciente
	, mexicanos.edo_nacim
	, mexicanos.edomun_resi
	, pacientes.edad
FROM defunciones
JOIN embarazos ON embarazos.id_paciente = defunciones.id_paciente
JOIN mexicanos ON mexicanos.id_paciente = defunciones.id_paciente
JOIN pacientes ON pacientes.id_paciente = mexicanos.id_paciente
JOIN resultado ON resultado.clave_resultado = pacientes.clave_resultado
JOIN estados ON pacientes.edo_um = estados.clave_edo
WHERE mexicanos.edo_nacim not like LEFT(mexicanos.edomun_resi, 2)
AND resultado.clave_resultado = 1
ORDER BY 1 ASC) abc
ON estados.clave_edo = abc.edo_nacim) a
JOIN(SELECT estados.nom_estado as 'Estado_de_residencia'
	, def.id_paciente
	, def.edad
FROM estados
JOIN (SELECT defunciones.id_paciente
	, mexicanos.edo_nacim
	, mexicanos.edomun_resi
	, pacientes.edad
FROM defunciones
JOIN embarazos ON embarazos.id_paciente = defunciones.id_paciente
JOIN mexicanos ON mexicanos.id_paciente = defunciones.id_paciente
JOIN pacientes ON pacientes.id_paciente = mexicanos.id_paciente
JOIN resultado ON resultado.clave_resultado = pacientes.clave_resultado
JOIN estados ON pacientes.edo_um = estados.clave_edo
WHERE mexicanos.edo_nacim not like LEFT(mexicanos.edomun_resi, 2)
AND resultado.clave_resultado = 1
ORDER BY 1 ASC) def
ON estados.clave_edo =  LEFT(def.edomun_resi, 2)) b ON a.id_paciente = b.id_paciente
JOIN (SELECT municipios.nom_mun as 'Municipio_de_residencia'
	, ghi.id_paciente
	, ghi.edad
FROM municipios
JOIN (SELECT defunciones.id_paciente
	, mexicanos.edo_nacim
	, mexicanos.edomun_resi
	, pacientes.edad
FROM defunciones
JOIN embarazos ON embarazos.id_paciente = defunciones.id_paciente
JOIN mexicanos ON mexicanos.id_paciente = defunciones.id_paciente
JOIN pacientes ON pacientes.id_paciente = mexicanos.id_paciente
JOIN resultado ON resultado.clave_resultado = pacientes.clave_resultado
JOIN estados ON pacientes.edo_um = estados.clave_edo
WHERE mexicanos.edo_nacim not like LEFT(mexicanos.edomun_resi, 2)
AND resultado.clave_resultado = 1
ORDER BY 1 ASC) ghi
ON municipios.edo_mun = ghi.edomun_resi) c
ON c.id_paciente = b.id_paciente
ORDER BY 1,2;


/* EJERCICIO 3 */
/* 3. Número de defunciones por estado de residencia que no tuvieron contacto con otro caso de covid y 
sin embargo se contagiaron. (mexicanos y extranjeros) */

SELECT 'Ejercicio 3' AS '';

SELECT estados.nom_estado as 'Entidad Federativa'
	, LPAD(FORMAT( COUNT(abc.id_paciente), 0), length('Total de defunciones'), ' ') AS 'Total de defunciones'
FROM estados
JOIN (SELECT LEFT(sq.edomun_resi,2) as edos
, defunciones.id_paciente
FROM defunciones
JOIN (
SELECT mexicanos.id_paciente
,mexicanos.edomun_resi
FROM mexicanos
UNION( SELECT extranjeros.id_paciente
, extranjeros.edomun_resi
FROM extranjeros)) sq
ON defunciones.id_paciente = sq.id_paciente
JOIN pacientes ON pacientes.id_paciente = sq.id_paciente
JOIN cat_sino ON cat_sino.clave = pacientes.otro_caso
JOIN resultado ON resultado.clave_resultado = pacientes.clave_resultado
JOIN estados ON estados.clave_edo = pacientes.edo_um
WHERE cat_sino.clave = 2
AND resultado.clave_resultado = 1) abc
ON estados.clave_edo = abc.edos
GROUP BY 1 ORDER BY 1 ASC, 2 ASC;


/* EJERCICIO 4 */
/* 4. Id del paciente, edad, entidad federativa de la unidad médica, país de nacionalidad, país de origen, 
condición de migración y resultado de la prueba de covid, de las extranjeras que están embarazadas, 
ordenado por estado y nacionalidad. */

SELECT 'Ejercicio 4' AS '';

-- Query OK
SELECT a.id_paciente
	, a.edad
	, estados.nom_estado AS 'Estado de la Unidad Medica'
	, a.nom_pais AS 'Nacionalidad' 
	, b.nom_pais AS 'Pais de Origen'
	, cat_sino.descripcion AS 'Es migrante'
	, b.descripcion AS 'Prueba COVID' 
FROM extranjeros
JOIN(
-- Pais de nacionalidad
SELECT abc.id_paciente
	, abc.edad
	, abc.edo_um
	, abc.cve_pais
	, pais.nom_pais
FROM pais
JOIN(
SELECT embarazos.id_paciente
	, pacientes.edad
	, pacientes.edo_um
	, extranjeros.pais_nacionalidad as cve_pais
FROM embarazos
JOIN extranjeros ON extranjeros.id_paciente = embarazos.id_paciente
JOIN pacientes ON pacientes.id_paciente = embarazos.id_paciente
JOIN resultado ON resultado.clave_resultado = pacientes.clave_resultado
JOIN estados ON estados.clave_edo = pacientes.edo_um
) abc
ON pais.clave_pais = abc.cve_pais) a
ON extranjeros.id_paciente = a.id_paciente
JOIN(
	-- Pais de origen
SELECT abcd.id_paciente
	, abcd.cve_pais_o
	, pais.nom_pais
	, abcd.migrante
	, abcd.descripcion
FROM pais
JOIN(
SELECT embarazos.id_paciente
	, extranjeros.pais_origen as cve_pais_o
	, extranjeros.migrante
	, resultado.descripcion
FROM embarazos
JOIN extranjeros ON extranjeros.id_paciente = embarazos.id_paciente
JOIN pacientes ON pacientes.id_paciente = embarazos.id_paciente
JOIN resultado ON resultado.clave_resultado = pacientes.clave_resultado
JOIN estados ON estados.clave_edo = pacientes.edo_um
) abcd
ON pais.clave_pais = abcd.cve_pais_o) b
ON extranjeros.id_paciente = b.id_paciente
JOIN pacientes ON pacientes.id_paciente = extranjeros.id_paciente
JOIN estados ON estados.clave_edo = pacientes.edo_um
JOIN cat_sino ON cat_sino.clave = b.migrante
ORDER BY 3 ASC,4 ASC;


/* EJERCICIO 5 */
/* 5. Clave, nombre y cantidad del sector que tiene el máximo de casos positivos. 
(No se puede usar limit, ni valores estáticos, ni order by, debe resolverse con funciones de agregación 
y consultas anidadas.) */

SELECT 'Ejercicio 5' AS '';

SELECT sub.clave_sector
	, sub.nom_sector as 'Sector'
	, FORMAT(sub.total, 0) as 'Total'
FROM (SELECT count(pacientes.id_paciente) as Total
	, resultado.descripcion
	, sector.clave_sector
	, sector.nom_sector
FROM pacientes
JOIN resultado ON resultado.clave_resultado = pacientes.clave_resultado
JOIN sector ON sector.clave_sector = pacientes.clave_sector
WHERE resultado.clave_resultado = 1
GROUP BY 3,4,2
ORDER BY 1 ASC) sub
WHERE TOTAL = (SELECT MAX(total)
FROM (SELECT count(pacientes.id_paciente) as Total
	, resultado.descripcion
	, sector.clave_sector
	, sector.nom_sector
FROM pacientes
JOIN resultado ON resultado.clave_resultado = pacientes.clave_resultado
JOIN sector ON sector.clave_sector = pacientes.clave_sector
WHERE resultado.clave_resultado = 1
GROUP BY 3,4,2
ORDER BY 1 ASC) subb);

/* EJERCICIO 6*/
/* 6. De los 5 estados con mayor número de habitantes 
¿Cuál es el que tiene la menor cantidad de infectados? */

SELECT 'Ejercicio 6' AS '';


SELECT 'Se permite usar LIMIT, si se usan las 2 tablas: mexicanos y extranjeros' AS 'Opcion 2';

-- Ejercicio 6.

SELECT q.nom_estado AS 'Estado'
	, LPAD(FORMAT(q.total, 0), length('Población total'), ' ') AS 'Población total'
	, LPAD(FORMAT(q.total_infectados, 0), length('Total de infectados'), ' ') AS 'Total de infectados'
FROM (
SELECT h.nom_estado
	, h.total
	, sq.total_infectados
FROM (
-- LUGARES MÁS HABITADOS
SELECT SUM(municipios.pob_total) as total
	,estados.nom_estado
	,estados.clave_edo
FROM estados
JOIN municipios USING(clave_edo)
GROUP BY 2
ORDER BY 1 DESC
) h
JOIN(
-- NÚMERO DE INFECTADOS 
SELECT LEFT(mundo.edomun_resi, 2) as clave_edo
	, COUNT(mundo.id_paciente) as total_infectados
FROM
(SELECT mexicanos.id_paciente
	,mexicanos.edomun_resi
FROM mexicanos
UNION( 
	SELECT extranjeros.id_paciente
	, extranjeros.edomun_resi
FROM extranjeros)
) mundo
JOIN pacientes ON mundo.id_paciente = pacientes.id_paciente
JOIN resultado ON resultado.clave_resultado = pacientes.clave_resultado
WHERE resultado.clave_resultado = 1
GROUP BY 1
ORDER BY 2 ASC
) sq
ON h.clave_edo = sq.clave_edo
-- TODA LA TABLA SE LLAMA q
)q
WHERE q.total_infectados = (
-- MÍNIMO NÚMERO DE INFECTADOS DEL TOP 5
SELECT MIN(x.total_infectados) as min_infectados
FROM (
SELECT h.nom_estado
	, h.total
	, sq.total_infectados
FROM (
SELECT SUM(municipios.pob_total) as total
	,estados.nom_estado
	,estados.clave_edo
FROM estados
JOIN municipios USING(clave_edo)
GROUP BY 2
ORDER BY 1 DESC
) h
JOIN(
SELECT LEFT(mundo.edomun_resi, 2) as clave_edo
	, COUNT(mundo.id_paciente) as total_infectados
FROM
(SELECT mexicanos.id_paciente
	,mexicanos.edomun_resi
FROM mexicanos
UNION( 
	SELECT extranjeros.id_paciente
	, extranjeros.edomun_resi
FROM extranjeros)
) mundo
JOIN pacientes ON mundo.id_paciente = pacientes.id_paciente
JOIN resultado ON resultado.clave_resultado = pacientes.clave_resultado
WHERE resultado.clave_resultado = 1
GROUP BY 1
ORDER BY 2 ASC
) sq
ON h.clave_edo = sq.clave_edo
LIMIT 5
) x
);


/* SECCION 2 : PROCEDIMIENTOS ALMACENADOS */

DROP PROCEDURE IF EXISTS defExtranjeros; 

DROP PROCEDURE IF EXISTS reporteTecnico;
 
DROP PROCEDURE IF EXISTS tardanza;
 
DROP PROCEDURE IF EXISTS intubados;

/* EJERCICIO 1 */
/*1. Reporte de extranjeros que fallecieron, según el país de nacionalidad y un criterio de búsqueda que se pasan 
como parámetros. (Ver en el archivo de resultados, las columnas que se deben mostrar)
El nombre del país que se pasa como parámetro puede ser completo o sólo una parte del nombre.
Los criterios deben considerar sólo los siguientes caracteres:
‘*’ Todos los extranjeros
‘=’ Los que vinieron del mismo país de nacionalidad
‘!’ Los que vinieron de un país diferente  al suyo
En cualquier otro caso, se mostrará opción no válida, ejemplos:
call defExtranjeros('colombia','*');
call defExtranjeros('repu','=');
call defExtranjeros('cia','!');
call defExtranjeros('repu','x'); */




SELECT "call defExtranjeros('repu','*')" AS 'Llamadas a procedimiento 1';


SELECT "call defExtranjeros('repu','=')" AS 'Llamadas a procedimiento 1';


SELECT "call defExtranjeros('repu','!')" AS 'Llamadas a procedimiento 1';


SELECT "call defExtranjeros('repu','x')" AS 'Llamadas a procedimiento 1';


SELECT "call defExtranjeros('cuba','*')" AS 'Llamadas a procedimiento 1';






/* EJERCICIO 2 */
/* 2. Número de casos registrados, casos positivos, casos negativos, casos sospechosos totales a la fecha 
de actualización, según el parámetro que aceptará cualquiera de las 3 opciones:
‘gral’ Para un reporte general de casos
‘sexo’ Para un reporte que desglosa los casos positivos por sexo
‘comor’ Para un reporte de número total de pacientes por comorbilidad
Cualquier otra palabra debe marcar opción no válida.
Ejemplos:
call reporteTecnico('gral');
call reporteTecnico('sexo');
call reporteTecnico('comor'); */




SELECT "call reporteTecnico('gral')" AS 'Llamadas a procedimiento 2';



SELECT "call reporteTecnico('sexo')" AS 'Llamadas a procedimiento 2';



SELECT "call reporteTecnico('comor')" AS 'Llamadas a procedimiento 2';



SELECT "call reporteTecnico('otro')" AS 'Llamadas a procedimiento 2';




/* EJERCICIO 3 */
/*3. Id del paciente, sexo, edad, fecha de síntomas, fecha de ingreso, días transcurridos, 
entidad de la unidad médica, tipo de paciente, si fue intubado, si tuvo neumonía y 
resultado de la prueba covid de los pacientes (positivo y negativo) que más tardaron 
en ingresar al hospital después de sentir síntomas 
Ejemplo: call tardanza(); */




SELECT 'call tardanza()' AS 'Llamada a procedimiento 3';



/* EJERCICIO 4 */
/* 4. Reporte de porcentaje de pacientes con covid que son intubados
Ejemplo: call intubados(); */




SELECT 'call intubados()' AS 'Llamada a procedimiento 4';