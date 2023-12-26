/* Cambiamos el prompt  */
prompt [\d]->

/* Ejercicio 1 - base mundo */

-- Paises con pob mayor a la de canada pero menor a la de mexico
use mundo

select pais, format(poblacion,0) 
from paises
where pais in ('Canada','Mexico')
order by 2;

select pais, format(poblacion,0), continente
from paises
where poblacion > 35427524 
and poblacion < 119713203;


select pais, format(poblacion,0), continente
from paises
where poblacion > 35427524 
and poblacion < 119713203
and (continente like '%america%'
or continente like '%caribbean%')
order by 2;

select pais, format(poblacion,0) as poblacion
from paises
where poblacion > (select poblacion from paises where pais like 'Canada')
and poblacion < (select poblacion from paises where pais like 'Mexico')
and (continente like '%america%'
or continente like '%caribbean%')
order by 2;

-- Porcentaje de pob total por continente
select distinct continente from paises;

select distinct
case
	when pais like '%armenia%' then 'Europe'
	when pais like '%russia%' then 'Asia'
	when continente like '%america%'
	or continente like '%caribbean%' then 'America'
	else continente
end as nuevos_continentes
from paises
order by 1;


select distinct
case
	when pais like '%armenia%' then 'Europe'
	when pais like '%russia%' then 'Asia'
	when continente like '%america%'
	or continente like '%caribbean%' then 'America'
	else continente
end as nuevos_continentes,
sum(poblacion)
from paises
group by 1
order by 1;

select sum(poblacion) from paises;

select distinct
case
	when pais like '%armenia%' then 'Europe'
	when pais like '%russia%' then 'Asia'
	when continente like '%america%'
	or continente like '%caribbean%' then 'America'
	else continente
end as nuevos_continentes,
sum(poblacion) as pob_continente,
(select sum(poblacion) from paises) as pob_total
from paises
group by 1
order by 1;


select distinct
case
	when pais like '%armenia%' then 'Europe'
	when pais like '%russia%' then 'Asia'
	when continente like '%america%'
	or continente like '%caribbean%' then 'America'
	else continente
end as nuevos_continentes,
sum(poblacion) as pob_continente,
(select sum(poblacion) from paises) as pob_total,
sum(poblacion)/(select sum(poblacion) from paises) as proporcion
from paises
group by 1
order by 1;

select distinct
case
	when pais like '%armenia%' then 'Europe'
	when pais like '%russia%' then 'Asia'
	when continente like '%america%'
	or continente like '%caribbean%' then 'America'
	else continente
end as nuevos_continentes,
format(sum(poblacion),0) as pob_continente,
format((select sum(poblacion) from paises),0) as pob_total,
concat(round(100*sum(poblacion)/(select sum(poblacion) from paises),2),' %') as proporcion
from paises
group by 1
order by sum(poblacion) desc;

-- Si quisieramos ahora filtrar por los 
-- continentes con poblacion mayor a mil millones (1x10^9)
select distinct
case
	when pais like '%armenia%' then 'Europe'
	when pais like '%russia%' then 'Asia'
	when continente like '%america%'
	or continente like '%caribbean%' then 'America'
	else continente
end as nuevos_continentes,
format(sum(poblacion),0) as pob_continente,
format((select sum(poblacion) from paises),0) as pob_total,
concat(round(100*sum(poblacion)/(select sum(poblacion) from paises),2),' %') as proporcion
from paises
group by 1
having sum(poblacion) > 1000000000
order by sum(poblacion) desc;

/* Ejercicio 2 - base sakila */


/* Fecha estreno seguido del título de las peliculas
que sean de tipo accion y que lleven una u en la segunda letra de su título*/

use sakila
desc category;
desc film;
desc film_category;

select * from category where name like '%action%';
select count(*) 'pelis de accion' from film_category where category_id = 1;

select * from film_category 
where category_id in 
(select category_id from category where name like '%action%');

select film_id from film_category 
where category_id in 
(select category_id from category where name like '%action%');

select release_year,title from
(select * from film where film_id in
(select film_id from film_category 
where category_id in 
(select category_id from category where name like '%action%')))
as base
where title like '_u%';

select concat_ws('-',release_year,title) as 'mis pelis'
from
(select * from film where film_id in
(select film_id from film_category 
where category_id in 
(select category_id from category where name like '%action%')))
as consulta
where title like '_u%';


/* Cerramos el tee */
-- notee
 


