/* Cambiamos el prompt  */
prompt [\d]->

/* Ejercicio 1 - base bank */
use bank
show tables;

-- 1
select * from product limit 5;
desc product;
desc product_type;
select * from product_type limit 5;

select product_cd as codigo,
 name as producto, 
 product_type_cd as tipo_producto
 from product;
 
select * from product inner join product_type on product.product_type_cd = product_type.product_type_cd;

select count(column_name) as num_columnas, table_name as tabla
 from information_schema.columns 
 where table_name in ('product', 'product_type')
 and table_schema=database()
 group by table_name with rollup;
 
 
select * from product inner join product_type using (product_type_cd);
 
 select product_cd as codigo,
 name as producto, 
 product_type_cd as tipo_producto
 from product;
 
select product_cd as codigo,
 product.name as producto, 
 product_type.name as tipo_producto
 from product inner join product_type using (product_type_cd);

-- 2
select product_cd as codigo,
 product.name as producto, 
 product_type.name as tipo_producto
 from product inner join product_type using (product_type_cd)
 where product_cd like 'M%';


-- 3
select txn_date,city,format(avail_balance,2)
from acc_transaction
inner join account using (account_id)
inner join customer using (cust_id)
where city = 'Salem'
or avail_balance > 5000;

-- 4 
select txn_date,city,format(avail_balance,2)
from acc_transaction
natural join account
natural join customer
where city = 'Salem'
or avail_balance > 5000;

-- 5
select max(txn_date) from acc_transaction;

select txn_date,city,format(avail_balance,2),
(select max(txn_date) from acc_transaction)
from acc_transaction
natural join account
natural join customer
where city = 'Salem'
or avail_balance > 5000;

select txn_date 'fecha',city 'ciudad',
format(avail_balance,2) 'saldo',
(select max(txn_date) from acc_transaction) 'max fecha',
datediff((select max(txn_date) from acc_transaction),txn_date) as 'dias'
from acc_transaction
natural join account
natural join customer
where city = 'Salem'
or avail_balance > 5000;

select date(txn_date) 'fecha',city 'ciudad',
format(avail_balance,2) 'saldo',
(select date(max(txn_date)) from acc_transaction) 'max fecha',
datediff((select max(txn_date) from acc_transaction),txn_date) as 'dias'
from acc_transaction
natural join account
natural join customer
where city = 'Salem'
or avail_balance > 5000
order by 5 asc;

select date(txn_date) 'fecha',city 'ciudad',
format(avail_balance,2) 'saldo',
datediff((select max(txn_date) from acc_transaction),txn_date) as 'dias'
from acc_transaction
natural join account
natural join customer
where city = 'Salem'
or avail_balance > 5000
order by 4 asc;

-- 6
select * from business;

select * from account where cust_id in (10,11,12,13);

select name, count(account_id) cuentas
from business 
inner join account using (cust_id)
group by 1;


select b.name as 'Empresa', count(account_id) 'Num cuentas', city 'Ciudad apertura', 
concat_ws(' ',e.first_name,e.last_name) 'Empleado encargado' 
from business b 
inner join account a using (cust_id) 
inner join employee e on a.open_emp_id = e.emp_id 
inner join branch br on a.open_branch_id = br.branch_id 
group by 1,3,4
having count(account_id) = (select min(cuentas)
FROM 
(
select name, count(account_id) cuentas
from business 
inner join account using (cust_id)
group by 1
) sub);

