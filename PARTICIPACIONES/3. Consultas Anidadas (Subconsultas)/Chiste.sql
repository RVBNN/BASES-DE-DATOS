# ep3_nombreApellido.sql
# ep3_RubenNunez.sql

/*
=================================
Ejercicio de participación 2: Funciones de agregación 
Nombre: Ruben Núñez
Fecha: 13 - Nov - 22
=================================
*/


-- Ejercicio 1: Obtener el id, título y precio del disco más barato
use pixup;

# Ejercicio 1:
select id_disco, titulo, precio from disco
where titulo = 'La vecindad del chavo';

# Ejercicio 2:
select id_disco, titulo, cantidad_disponible from disco
where titulo = 'Tributo a José José';

# Ejercicio 3:
select id_disco, titulo, fecha_lanzamiento from disco
where fecha_lanzamiento = '2022-07-01';

# Ejercicio 4: