/* 
Un TRIGGER es un conjunto de acciones que se ejecutan automáticamente cuando 
se realiza una operación de cambio específica (sentencia SQL INSERT, UPDATE o DELETE) 
en una tabla específica. 

Los disparadores son útiles para tareas como la aplicación de reglas comerciales, 
la validación de datos de entrada y el mantenimiento de un registro de auditoría.
*/


/*
Buscamos crear una tabla para auditorias
En esta tabla se deben registrar todos los cambios
Estaria bien contar con quien hizo la modificación y la fecha.

Nuevos registros
Registros borrados
Actualización de datos
Todo sobre la tabla compras de la base super
*/

-- Paso 1. Crear tabla para registrar cambios
-- Paso 2. Crear tres TRIGGERS (
-- Paso 2.1 Para insertar
-- Paso 2.2 Para eliminaciones
-- Paso 2.3 Para actualizaciones

-- TRIGGER PARA INSERTAR NUEVOS VALORES
use super;

drop table if exists compras_auditoria;
create table if not exists compras_auditoria like compras;

desc compras;
select count(*) from compras;

desc compras_auditoria;
select count(*) from compras_auditoria;

alter table compras_auditoria add cambio varchar(50);
alter table compras_auditoria add usuario varchar(50);
alter table compras_auditoria add fecha_cambio date;

desc compras_auditoria;

-- TRIGGERS PARA INSERTAR
CREATE TRIGGER compras_AI_trigger AFTER INSERT ON compras 
FOR EACH ROW 
INSERT INTO compras_auditoria VALUES 
(new.id_ticket, new.fecha, new.articulo, new.precio 
, new.unidad, new.cantidad, 'nueva data', user(), curdate()); 


-- TRIGGER PARA ELIMINAR
CREATE TRIGGER compras_BD_trigger BEFORE DELETE ON compras 
FOR EACH ROW
INSERT INTO compras_auditoria VALUES 
(old.id_ticket, old.fecha, old.articulo, old.precio 
, old.unidad, old.cantidad, 'data eli', user(), curdate());


-- TRIGGER PARA ACTUALIZAR
CREATE TRIGGER compras_AU_trigger AFTER UPDATE ON compras
FOR EACH ROW
INSERT INTO compras_auditoria VALUES
(old.id_ticket, old.fecha, old.articulo, old.precio
, old.unidad, old.cantidad, 'data actu', user(), curdate());


-- MODIFICACIONES
Insert into compras
values (50000,'2022-11-24','comidita yummy',10,'pza',5);

select * from compras where articulo like '%yummy%';
select * from compras_auditoria;

select * from compras where fecha = '2021-12-18';
update compras set articulo = concat(articulo,' OK') where fecha = '2021-12-18';
select * from compras where fecha = '2021-12-18';
select * from compras_auditoria;

select * from compras where precio < 2;
delete from compras where precio < 2;

select * from compras_auditoria;


-- OTRO TRIGGER PARA INSERTAR
alter table compras add 
(created_date DATETIME default '2000-01-01',
created_by VARCHAR(30) default 'creador');

desc compras;

delimiter //
create trigger compras_BI_trigger before insert on compras 
for each row
begin 
DECLARE vUser varchar(50);

-- Find username of person performing INSERT into table
select USER() into vUser;

-- Update create_date field to current system date
SET NEW.created_date = SYSDATE();

-- Update created_by field to the username of the person performing the INSERT
SET NEW.created_by = vUser;
end; // 
delimiter ;

insert into compras values 
(50001,'2022-11-24','insert 1',3,'pza',7,'2020-08-05','xyz'),
(50002,'2022-11-24','insert 2',2,'pza',5,'2020-08-05','xyz'),
(50003,'2022-11-24','insert 3',1,'kg',1,'2020-08-05','xyz');

select * from compras where id_ticket >= 50000;

-- REVISAR ESTADO DE TRIGGERS

show triggers\G
show create trigger compras_BI_trigger\G

drop trigger if exists compras_BI_trigger;

/*
SELECT ROUTINE_TYPE, ROUTINE_NAME, ROUTINE_DEFINITION FROM
INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA='super'\G 
*/