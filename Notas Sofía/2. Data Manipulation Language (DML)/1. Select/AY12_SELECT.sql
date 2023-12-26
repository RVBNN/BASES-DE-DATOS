/* Cargamos la base de datos mundo */
-- source base_mundo.sql

/* Creamos un tee */
-- tee ay12_select.txt

/* Ponemos al uso la base */
use mundo

/* Exploramos que hay... */
show tables;
desc paises;
select * from paises limit 5;

/* Ejercicios */

select capital 
from paises 
where capital like 'M%' 
order by capital desc limit 5;

select pais,gdp from paises order by gdp desc limit 3;

select pais,continente, poblacion from paises where continente 
like '%america%' and poblacion < 2000000;

select continente,sum(area) as area_total
from paises where continente='Europe';

select pais, round(gdp/area,2) as num
from paises order by num desc limit 1;

select pais from paises where pais like '%x%';

select pais from paises where pais like '%land';

select pais from paises where pais like 'C%ia';

select pais from paises where pais like '_n%';

select pais 
from paises
where pais like '% %' and pais not like '% % %' and pais not like 'C%';;

/* Cargamos la base de datos bank */
-- source base_bank.sql

/* Ponemos al uso la base */
use bank

select table_name as tabla, table_rows as num_registros
from INFORMATION_SCHEMA.TABLES
where TABLE_SCHEMA = 'bank'
order by num_registros desc;

/* Ejercicios */

select account_id,status,open_date, monthname(open_date)
from account limit 10;

select account_id,pending_balance,open_date, monthname(open_date)
from account where month(open_date) = 12;

select cust_id,avail_balance,pending_balance from account limit 10;
select cust_id,avail_balance,pending_balance 
from account where avail_balance-pending_balance > 0;

select *
from customer
where (city = 'Salem' or city = 'Newton') and cust_type_cd != 'B'; 

select distinct state from customer where left(fed_id,2)='04';

select year(txn_date),month(txn_date), amount
from acc_transaction
where year(txn_date) ='2002' and month(txn_date) in (10,11,12);

select 
concat('En el último trimestre del año ',year(txn_date),' los montos de todas las transacciones acumulan $',sum(amount),'.')
as resumen
from acc_transaction
where year(txn_date) ='2002' and month(txn_date) in (10,11,12);


select first_name as empleados,start_date as fecha_inicio, datediff(curdate(),start_date)/365 as tiempo_trabajando
from employee 
where (title='Teller' or title = 'Head Teller')
and datediff(curdate(),start_date)/365 >= 20;


select first_name as empleados
from employee 
where (title='Teller' or title = 'Head Teller')
and datediff(curdate(),start_date)/365 > 20
order by empleados;

select name 
from business 
where (cust_id % 2) > 0 and year(incorp_date) < 2001;

/* Cerramos el tee */
-- notee
 


