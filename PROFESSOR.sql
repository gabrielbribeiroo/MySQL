create database professor
default character set utf8mb4
default collate utf8mb4_general_ci;

use professor;

create table `finanças` (
id int not null auto_increment,
`data` date,
referência varchar(15) not null,
valor decimal(5,2) not null,
cliente varchar(20),
banco varchar(15),
beneficiário varchar(20),
banco_rec varchar(15),  
primary key(id)
) default charset = utf8mb4;

create table if not exists aulas_mes (
id int not null,
`data` date,
aluno varchar(30) not null,
série varchar(3),
matérias varchar(25) not null,
`conteúdo` varchar(60) not null,
`acréscimos` varchar(30),
primary key(`conteúdo`)
) default charset = utf8mb4;
