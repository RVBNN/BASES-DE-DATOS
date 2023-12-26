/* Cambiamos el prompt  */
prompt [\d]->

/* Ejercicio 1 - base super */
use super
show tables;

-- 1
drop table if exists compras_hoy;
create table if not exists compras_hoy like compras;

desc compras;
desc compras_hoy;

-- 2
insert compras_hoy select * from compras where unidad = 'kg';
select count(*) from compras_hoy;

-- 3
select format(count(*),0) as registros,round(avg(precio),2) as precio_prom from compras;
select format(count(*),0) as registros,round(avg(precio),2) as precio_prom from compras_hoy;

select format(count(*),0) as registros1,round(avg(precio),2) as precio_prom1,
(select format(count(*),0) from compras_hoy) as registros2,
(select round(avg(precio),2) from compras_hoy) as precio_prom2
from compras;

select 'compras' as tabla,format(count(*),0) as registros,round(avg(precio),2) as precio_prom from compras
UNION
select 'compras_hoy' as tabla, format(count(*),0) as registros,round(avg(precio),2) as precio_prom from compras_hoy;

-- 4
drop table if exists compras_copia;
create table if not exists compras_copia AS select * from compras_hoy;
show tables;

-- 5
update compras_copia set fecha = '2022-11-03';
select fecha from compras_copia limit 5;

-- 6
select distinct articulo from compras_copia where articulo like 'C%';
update compras_copia set cantidad = 1.5 where articulo like 'C%';

-- 7
alter table compras_copia add total_kg decimal(10,5) default 0 after articulo;

update compras_copia set total_kg = round(cantidad * precio,2);
select * from compras_copia limit 5;
select * from compras_copia where total_kg = 0;

-- 8
select distinct articulo from compras_copia where articulo like '% % %';
select * from compras_copia where total_kg < 15 limit 5;

delete from compras_copia where articulo like '% % %' or total_kg < 15;
select count(*) 'avance' from compras_copia;

-- 9
select * from compras_copia where articulo like '%mango%';
update compras_copia set precio =  (1-.18)*precio where articulo like '%mango%';
select * from compras_copia where articulo like '%mango%';

select *,round(cantidad*precio,2) as total_bien
from compras_copia 
where articulo like '%mango%';

-- 10
select * from compras_copia limit 5;
update compras_copia set 
	unidad = 'gr',
	precio = precio / 1000,
	cantidad = cantidad * 1000;
select * from compras_copia limit 5;

-- 11
alter table compras_copia change total_kg total decimal(10,2) default 0 after articulo;
desc compras_copia;
select * from compras_copia limit 5;


-- 12
alter table compras_copia add clase char(2) default '00';
desc compras_copia;
select * from compras_copia limit 4;

update compras_copia
set clase = case
when total <= 115 then '01'
when total > 115 then '02'
else 'NA'
end;

select * from compras_copia limit 5;
select * from compras_copia where clase = 'NA';

-- 13
select 
clase,
count(*) as registros,
count(distinct articulo) as art_distintos,
max(total) as max_total
from compras_copia group by clase;





