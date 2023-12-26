-- 1. 

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

-- 2. 

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

-- 3.

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

-- 4.

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



-- 5. 

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



