# 1.
prompt [\w\O \r:\m] (\d) ~>

# 2.
CREATE DATABASE IF NOT EXISTS pr03_eq09;
USE pr03_eq09;

# 3.
CREATE TABLE trabajador(
    id int unsigned not null primary key,
    nombre_pila varchar(10),
    puesto varchar(15)
);

DESC trabajador;

# 4.
CREATE TABLE ingrediente( 
    codigo tinyint unsigned auto_increment not null primary key,
    nombre varchar(20),
    precio_kg decimal(3,1),
    disponibilidad enum('D','ND') default 'ND' 
);
DESC ingrediente;

# 5.
ALTER TABLE trabajador 
ADD fecha_inicio date DEFAULT  '2022-09-30' AFTER nombre_pila;

ALTER TABLE trabajador 
ADD ing_fav tinyint unsigned not null AFTER puesto;

ALTER TABLE trabajador 
ALTER puesto SET DEFAULT 'pasante';

ALTER TABLE trabajador 
ADD FOREIGN KEY(ing_fav) REFERENCES ingrediente(codigo);

DESC trabajador; 
# 6.
CREATE TABLE IF NOT EXISTS paciente(
    id_paciente int unsigned not null,
    id_dueño int unsigned not null,
    nombre varchar(30) not null,
    raza varchar(30) not null,
    color varchar(30) not null,
    edad smallint not null,
    padecimiento varchar(200) not null,
    alergia varchar(200) not null
);

CREATE TABLE IF NOT EXISTS dueño(
    id_dueño int unsigned not null,
    nombre varchar(30) not null, 
    telefono int unsigned not null,
    email varchar(50) not null unique,
    calle varchar(100) unique,
    codigo_postal int(5) unsigned
); 

CREATE TABLE IF NOT EXISTS consulta(
    id_consulta int unsigned not null,
    id_paciente int unsigned not null,
    fecha_consulta date not null,
    fecha_siguiente_consulta date not null,
    motivo varchar(200) not null
);

CREATE TABLE IF NOT EXISTS consulta_tratamiento(
    id_consulta int unsigned not null,
    id_tratamiento int unsigned not null
);

CREATE TABLE IF NOT EXISTS tratamiento(
    id_tratamiento int unsigned not null,
    nombre varchar(30) not null,
    precio decimal(6,2) not null
);

# Esta última tabla(6) es la que hace que esté completo nuestro DER
CREATE TABLE IF NOT EXISTS usuario(
    id_usuario int unsigned not null,
    nombre varchar(30) not null,
    contraseña varchar(50) not null
); 


# 7. RELACION 1:M, M:M & AJUSTE DE LLAVES
ALTER TABLE dueño
ADD PRIMARY KEY(id_dueño);

ALTER TABLE paciente
ADD PRIMARY KEY(id_paciente),
ADD CONSTRAINT FK_paciente_dueño FOREIGN KEY(id_dueño) REFERENCES dueño(id_dueño);

ALTER TABLE consulta
ADD PRIMARY KEY(id_consulta),
ADD CONSTRAINT FK_paciente_consulta FOREIGN KEY(id_paciente) REFERENCES paciente(id_paciente);

ALTER TABLE tratamiento
ADD PRIMARY KEY(id_tratamiento);

# 8. IMPLEMENTACIÓN RELACIÓN M:M
ALTER TABLE consulta_tratamiento
ADD PRIMARY KEY(id_consulta, id_tratamiento),
ADD FOREIGN KEY(id_consulta) REFERENCES consulta(id_consulta),
ADD FOREIGN KEY(id_tratamiento) REFERENCES tratamiento(id_tratamiento);
drop database pr03_eq09;
