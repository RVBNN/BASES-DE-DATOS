use replicas
show tables;

-- Ejercicio 1
desc customers;
select count(distinct customernumber) from customers;

desc orders;
select count(distinct customernumber) from orders;


-- Ejercicio 2
select 
    customers.customernumber, 
    customername, 
    ordernumber, 
from
    customers
left join orders on 
    orders.customernumber = customers.customernumber;
	
-- Ejercicio 2
select 
    customers.customernumber, 
    customername, 
    count(ordernumber)
from
    customers
left join orders on 
    orders.customernumber = customers.customernumber
group by 1,2
order by 3 desc;

-- Ejercicio 3
select 
    customers.customernumber, 
    customername, 
    count(ordernumber)
from
    customers
inner join orders on 
    orders.customernumber = customers.customernumber
group by 1,2
order by 3 desc;

-- Ejercicio 4
select 
    c.customernumber, 
    customername, 
	status,
    count(ordernumber)
from
    orders
right join customers c on 
    orders.customernumber = c.customernumber
group by 1,2,3
having count(ordernumber) > 4
order by 4 desc;

select 
    c.customernumber, 
    customername, 
	status,
    count(ordernumber)
from
    orders
right join customers c on 
    orders.customernumber = c.customernumber
where c.customernumber = 124
group by 1,2,3
order by 4 desc;

-- Ejercicio 5
select customernumber id, 
concat(contactfirstname,' ',contactlastname) nombre,
city ciudad
from customers
left join orders using (customernumber)
where ordernumber is null;


create or replace view clientes_obj as 
select customernumber id, 
concat(contactfirstname,' ',contactlastname) nombre,
city ciudad
from customers
left join orders using (customernumber)
where ordernumber is null
;

show tables;
show create view clientes_obj;

-- Ejercicio 6
select distinct ciudad from clientes_obj order by 1;

select distinct ciudad,officecode,addressline1 from clientes_obj
left join offices o on clientes_obj.ciudad = o.city;

-- Ejercicio 7
drop view clientes_obj;
show tables;
