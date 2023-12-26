/*
								PARTE 0: Preliminares
*/


# 1. Cambiar el prompt
#prompt [\r:\m \P]-[\d] ->

/*
							PARTE 1: Base de datos ‘mundo’
*/

/*
2. ¿Cuáles son los países de Europa tales que su gdp supera el promedio de gdp de
los países en América (Norte, Sur y Caribe) y su área cumple ser menor que tres veces
la de Cuba? Ordenar el resultado alfabéticamente.

Nota: se incluye el proceso creativo para llegar a la consulta deseada
*/

#use mundo;
/*
# Paises de America
select pais from paises 
where continente like '%america%' 
or continente like 'caribbean%';

# Promedio de gdp en America
select avg(gdp) from paises 
where continente like '%america%' 
or continente like 'caribbean%';

# Paises de Europa con area menor a tres veces la de Cuba
select pais from paises
where continente like '%europe%' and
area < 3 * (select area from paises where pais like '%cuba%');

# Consulta general
select pais from paises 
where continente = "Europe" and 
area < 3 * (select area from paises where pais = "Cuba") and
gdp > (select avg(gdp) from paises where continente in ("North America","South America","Caribbean")) 
order by 1;

*/
/*
3. Enlistar el nombre de los países y continente al que pertenecen; siempre y cuando
sean países que se encuentren en el mismo continente que Argentina o Australia; y
cuyo nombre tenga más de dos palabras. Ordenar el resultado alfabéticamente por
continente y país.

Nota: se incluye el proceso creativo para llegar a la consulta deseada
*/

/*
# Condicion chida
select pais, continente from paises where 
pais='Argentina' or pais='Australia' or 
continente like '%america%' or continente like '%caribbean%';

# Consulta general: Tomando a South America como continente
select pais, continente from paises 
where continente in (select continente from paises where pais="Argentina" or pais="Australia") 
and pais like "% % %" order by 2,1;
*/


/*
							PARTE 2: Base de datos ‘sakila’
*/


/*
4. Encontrar el id y el nombre de las categorías que tengan entre 65 y 75 películas
registradas en ellas.

Nota: se incluye el proceso creativo para llegar a la consulta deseada
*/
/*
use sakila;

# Cuantos registros hay por cada categoria
select category_id, count(category_id) from film_category 
group by category_id;


# Cuantas peliculas hay que tengan entre 65 y 75 peliculas registradas 
select category_id, count(category_id) from film_category 
group by 1 having count(category_id) between 65 and 75;


# Consulta general: Nombre y id de las categorias con la condición deseada
select name, category_id from category
where category_id in (select category_id from film_category 
group by 1 having count(category_id) between 65 and 75);

*/
/*
5. Listar el año y nombre de los meses en los que un pago realizado por una renta
superó el mínimo pago, pero quedó por debajo del pago promedio en ese año, para los
años 2005 y 2006.

Nota: se incluye el proceso creativo para llegar a la consulta deseada
*/

/*
# Seleccionamos pago mínimo realizado (que debe ser distinto de 0)
select min(amount) from payment where amount not like 0.00;

# Seleccionamos el promedio de los pagos por cada año
select year(payment_date) as 'anio', avg(amount) from payment where
year(payment_date) in (2005, 2006) group by 1;

# Seleccionamos el minimo de los pagos por cada año
select year(payment_date) as 'anio', min(amount) from payment where
amount not like 0.00 and year(payment_date) in (2005, 2006) group by 1;

# Consulta por separado para 2005
select distinct monthname(payment_date) from payment
where amount between
(select min(amount) from payment where amount not like 0.00 and year(payment_date)=2005) and
(select avg(amount) from payment where year(payment_date) = 2005)
and year(payment_date)=2005;

# Consulta por separado para 2006
select distinct monthname(payment_date)from payment
where amount between
(select min(amount) from payment where amount not like 0.00 and year(payment_date)=2006) and
(select avg(amount) from payment where year(payment_date) = 2006)
and year(payment_date)=2006;


# Consulta general:
select distinct year(payment_date) as 'anio', monthname(payment_date) as 'meses pago' from payment
where 
(year(payment_date) = 2005 and amount between
(select min(amount) from payment where amount not like 0.00 and year(payment_date)=2005) and
(select avg(amount) from payment where year(payment_date) = 2005))
or
(year(payment_date) = 2006 and amount between
(select min(amount) from payment where amount not like 0.00 and year(payment_date)=2006) and
(select avg(amount) from payment where year(payment_date) = 2006));

*/
/*
6. Seleccionar el código postal, distrito y id de ciudad de los códigos postales de
longitud 5 para los que haya registrados más de una dirección, y que cumplan que el
primer dígito del id de su ciudad sea par. Este es el resultado esperado:

Nota: se incluye el proceso creativo para llegar a la consulta deseada
*/
/*
# Códigos Postales de longitud 5
select postal_code from address
where length(postal_code) = 5;

# Contamos el número de veces que están registrados los  códigos postales
select postal_code, count(postal_code) from address 
group by 1 order by 2 asc;

# Qué códigos postales existen
select distinct postal_code from address order by 1 desc;

# Los C.P. con más de un registro
select postal_code, count(postal_code) from address 
group by 1 having count(postal_code) > 1 order by 2 asc;

# Primer dígito del id de su ciudad sea par
select city_id from address where
mod(left(city_id, 1), 2) = 0;

# Consulta general:
select postal_code, district, city_id from address 
where length(postal_code) = 5 and postal_code in
(select postal_code from address 
group by 1 having count(postal_code) > 1 order by 1 asc) and
mod(left(city_id, 1), 2) = 0;
*/

/*
7. Mostrar el nombre completo (nombre + apellido) y el correo de los clientes que han
rentado una película antes del 2006 y no la hayan regresado aún.
*/
/*
select concat(first_name," ",last_name) as nombre, email from customer 
where customer_id in (select count(customer_id) from rental
where year(rental_date)<2006 and return_date is null);
*/

/*
8. Hallar el id de los clientes tales que el máximo monto de renta 
que le han pagado a la tienda esté por encima de los 10 dólares 
y que su última renta se haya hecho el día de San Valentín del año 2006. 

Nota: se incluye el proceso creativo para llegar a la consulta deseada
*/
/*
# Clientes distintos que rentaron en San Valentín del 2006
select distinct customer_id from rental
where cast(rental_date as date) = '2006-02-14';

# Consulta general: 
select customer_id as cliente, round(amount,1) as 'max pago', 
concat(day('2006-02-14'),'-',monthname('2006-02-14'),'-',year('2006-02-14')) as 'ultima renta'
from payment where
amount > 10 and customer_id in (select distinct customer_id from rental
where cast(rental_date as date) = '2006-02-14');
*/



/*
						CONSULTAS GENERALES:
*/


# 1. 
prompt [\r:\m \P]-[\d] ->
# 2.
use mundo;
select pais from paises 
where continente = "Europe" and 
area < 3 * (select area from paises where pais = "Cuba") and
gdp > (select avg(gdp) from paises where continente in ("North America","South America","Caribbean")) 
order by 1;
# 3.
select pais, continente from paises 
where continente in (select continente from paises where pais="Argentina" or pais="Australia") 
and pais like "% % %" order by 2,1;
# 4.
use sakila;
select name, category_id from category
where category_id in (select category_id from film_category 
group by 1 having count(category_id) between 65 and 75);
# 5.
select distinct year(payment_date) as 'anio', monthname(payment_date) as 'meses pago' from payment
where 
(year(payment_date) = 2005 and amount between
(select min(amount) from payment where amount not like 0.00 and year(payment_date)=2005) and
(select avg(amount) from payment where year(payment_date) = 2005))
or
(year(payment_date) = 2006 and amount between
(select min(amount) from payment where amount not like 0.00 and year(payment_date)=2006) and
(select avg(amount) from payment where year(payment_date) = 2006));
# 6.
select postal_code, district, city_id from address 
where length(postal_code) = 5 and postal_code in
(select postal_code from address 
group by 1 having count(postal_code) > 1 order by 1 asc) and
mod(left(city_id, 1), 2) = 0;
# 7.
select concat(first_name," ",last_name) as nombre, email from customer 
where customer_id in (select count(customer_id) from rental
where year(rental_date)<2006 and return_date is null);
# 8.
select customer_id as cliente, round(amount,1) as 'max pago', 
concat(day('2006-02-14'),'-',monthname('2006-02-14'),'-',year('2006-02-14')) as 'ultima renta'
from payment where
amount > 10 and customer_id in (select distinct customer_id from rental
where cast(rental_date as date) = '2006-02-14');