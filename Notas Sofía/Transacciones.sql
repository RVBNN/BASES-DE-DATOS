use bank;

/*
														TRANSACCIONES
                                                        
                                                        
                                                        
                                                        
Sólo afectan a DML: SELECT, UPDATE, DELETE

Si nos metmos con DDL no hay vuelta atrás                                                       
*/




-- Validación antes de ejecutar una instruccion en la base
SET autocommit = OFF;
SET autocommit = 0;

-- Iniciamos con las transacciones. Para acabar con la transacción lo ponemos en ON (que es equivalente a un commit)
START transaction;

SELECT * FROM employee;
SELECT * from bank.customer;

-- EJ: Quiero eliminar los que tengan NH
UPDATE customer
SET address = 'No existe el estado'
WHERE state = 'NH';

-- ES UN CTRL Z. Funciona cuando el autocommit está apagado y estamos en una transacción
ROLLBACK;

-- Para prender el commit
SET autocommit = ON;
