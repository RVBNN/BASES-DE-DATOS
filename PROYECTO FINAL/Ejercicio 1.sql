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




