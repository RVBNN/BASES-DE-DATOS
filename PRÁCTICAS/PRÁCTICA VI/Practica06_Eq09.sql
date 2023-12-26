/*
2. En una sola instrucción, copiar la estructura y registros de la tabla resumen a una
nueva llamada nuevo_res. En esta nueva tabla se harán las modificaciones. 
*/


# Solo COPIA LA ESTRUCTURA (llaves), no copia los datos.

create table if not exists nuevo_res like base_p06

# CREAR TABLA CON TODO Y REGISTROS
# No guarda la estructura (i.e. las llaves) ********
create table if not exists nuevo_res as select * from resumen;

create table nuevo_res like base_p06;
insert nuevo_res select * from resumen;


# COPIAR ESTRUCTURA Y VALORES DE UNA TABLA

# Copiar estructura: Considera llaves
create table if not exists pba1 like resumen;

# Copia los registros:
insert pba1 select * from resumen;