create database futebol
default character set utf8mb4
default collate utf8mb4_general_ci;

create table if not exists jogadores (
id int not null auto_increment,
nome varchar(30) not null,
`time` varchar(30),
posição varchar(15) not null,
inicio date,
fim date,
valor numeric,
contrato varchar(15) default 'Compra',
nascimento date,
altura decimal(3,2),
nacionalidade varchar(20) default 'Brasil',
primary key(id)
) default charset = utf8mb4;

create table if not exists campeonato_ano (
id int not null auto_increment,
`data` date,
fase varchar(30) default 'Fase de Grupos',
`estádio` varchar(40) not null,
`time 1` varchar(25) not null,
gp1 int not null,
gp2 int not null,
`time 2` varchar(25) not null,
resultado enum('Vitória','Empate','Derrota'),
primary key(id)
) default charset = utf8mb4;

create table if not exists campeonato_ano (
id int not null auto_increment,
`data` date,
turno int,
`estádio` varchar(40) not null,
`time 1` varchar(25) not null,
gp1 int not null,
gp2 int not null,
`time 2` varchar(25) not null,
resultado enum('Vitória','Empate','Derrota'),
primary key(id)
) default charset = utf8mb4;

create table if not exists campeonato_ano (
id int not null auto_increment,
`data` date,
fase varchar(30),
`estádio` varchar(40) not null,
`time 1` varchar(25) not null,
gp1 int not null,
gp2 int not null,
`time 2` varchar(25) not null,
resultado enum('Vitória','Empate','Derrota'),
primary key(id)
) default charset = utf8mb4;