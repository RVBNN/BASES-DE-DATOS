use bank
show tables;

-- Ejercicio 1
select * from branch;
select * from branch where state = 'MA';
create or replace view bancos_MA as select * from branch where state = 'MA';

-- Ejercicio 2
select * from bancos_MA;


-- Ejercicio 3
select * from product_type;

-- create table like, select *, AS select *
drop table if exists mi_tabla;

create table mi_tabla as select * from product_type;
select * from mi_tabla;

create or replace view mi_vista as select * from product_type;
select * from mi_vista;

insert into product_type values ('PAGO DE SERVICIOS', 'Agua, luz, gas y teléfono');
update product_type set name = 'Customer AND BUSINESS accounts' where product_type_cd = 'ACCOUNT';

select * from product_type;
select * from mi_tabla;
select * from mi_vista;

alter table product_type add column nuevo_campo int default 123;
select * from product_type;
select * from mi_tabla;
select * from mi_vista;

/* Las vistas no necesitan actualizarse por nosotros cuando los datos cambian pero 
podrán necesitar ser recreadas si la estructura de la tabla cambia */

-- Ejercicio 4
drop table if exists ejercicio4;
create table if not exists ejercicio4 (id int unsigned primary key auto_increment, nombre varchar(50) not null);
desc ejercicio4;
	
insert into ejercicio4 (nombre) values 
('Joshua'),
('Sofía'),
('Nina'),
('Venus');		

select * from ejercicio4;

select * from ejercicio4 where nombre like '%a%';

create or replace view v_ej4 as select * from ejercicio4 where nombre like '%a%';

select * from v_ej4;
select * from ejercicio4;

DELETE FROM v_ej4 WHERE  id = 2;

select * from v_ej4;
select * from ejercicio4;

insert into v_ej4 (nombre) values ('prueba?');

select * from v_ej4;
select * from ejercicio4;
		
-- Ejercicio 5

select * from business;

select * from account where cust_id in (10,11,12,13);

select name, count(account_id) cuentas
from business 
inner join account using (cust_id)
group by 1;

create or replace view numCuentas_x_empresa as 
select cust_id as Cliente, name as Empresa, count(account_id) 'Num_cuentas'
from business 
inner join account using (cust_id)
group by 1;

select * from numCuentas_x_empresa;

desc numCuentas_x_empresa;

select 'Cliente','Empresa', 'Num_cuentas' 
from numCuentas_x_empresa;

select Cliente, Empresa, Num_cuentas 
from numCuentas_x_empresa;

select * from account 
inner join branch on account.open_branch_id = branch.branch_id;

select account_id, city from account 
inner join branch on account.open_branch_id = branch.branch_id;

create or replace view cuenta_ciudad as 
select account_id, cust_id, city from account 
inner join branch on account.open_branch_id = branch.branch_id;

create or replace view cuenta_empleado as 
select account_id, concat_ws(' ',first_name,last_name) as nombre_emp from account 
inner join employee on account.open_emp_id = employee.emp_id;

desc cuenta_empleado;
desc numCuentas_x_empresa;
desc cuenta_ciudad;

select Cliente,Empresa, Num_cuentas, city, nombre_emp  
from numCuentas_x_empresa 
inner join cuenta_ciudad on Cliente=cust_id 
inner join cuenta_empleado using (account_id);


select Cliente,Empresa, Num_cuentas, city, nombre_emp  
from numCuentas_x_empresa 
inner join cuenta_ciudad on Cliente=cust_id 
inner join cuenta_empleado using (account_id) 
where Num_cuentas = (select min(Num_cuentas) from numCuentas_x_empresa);



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


