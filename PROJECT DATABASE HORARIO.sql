create database cronograma
default character set utf8mb4
default collate utf8mb4_general_ci;

use cronograma;

create table horario (
id int not null auto_increment,
inicio varchar(5) NOT NULL,
fim varchar(5) NOT NULL,
segunda text,
terça text,
quarta text,
quinta text,
sexta text,
primary key (id)
) default charset = utf8mb4;

select * from horario;