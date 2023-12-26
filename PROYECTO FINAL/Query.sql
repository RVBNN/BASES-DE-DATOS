/*
1. Reporte de extranjeros que fallecieron, 
según el país de nacionalidad y un criterio de búsqueda que se pasan como parámetros. 

(Ver en el archivo de resultados, las columnas que se deben mostrar)

El nombre del país que se pasa como parámetro puede ser completo o sólo una parte del nombre.

Los criterios deben considerar sólo los siguientes caracteres: 

‘*’ Todos los extranjeros
‘=’ Los que vinieron del mismo país de nacionalidad
‘!’ Los que vinieron de un país diferente al suyo

En cualquier otro caso, se mostrará opción no válida, ejemplos:

*/

-- Reporte todos los extranjeros
SELECT extranjeros.id_paciente
	, pacientes.sexo
	, extranjeros.pais_nacionalidad
	, extranjeros.pais_origen
	, pacientes.fecha_sintomas
	, pacientes.fecha_ingreso
	, defunciones.fecha_defuncion
	, pacientes.intubado
	, pacientes.neumonia
	, tipos_paciente.clave_tipo
	, resultado.clave_resultado
FROM extranjeros
JOIN defunciones ON defunciones.id_paciente = extranjeros.id_paciente
JOIN pacientes ON pacientes.id_paciente = extranjeros.id_paciente
JOIN tipos_paciente ON tipos_paciente.clave_tipo = pacientes.tipo_paciente
JOIN resultado ON resultado.clave_resultado = pacientes.clave_resultado

WHERE extranjeros.pais_nacionalidad IN (

SELECT distinct extranjeros.pais_nacionalidad
	, pais.nom_pais
FROM extranjeros
JOIN pais ON extranjeros.pais_nacionalidad = pais.clave_pais
WHERE pais.nom_pais LIKE '%repu%'

);



SELECT distinct extranjeros.pais_nacionalidad
	, pais.nom_pais
FROM extranjeros
JOIN pais ON extranjeros.pais_nacionalidad = pais.clave_pais
WHERE pais.nom_pais LIKE '%repu%' 