create database soccer
default character set utf8mb4
default collate utf8mb4_general_ci;

create table if not exists player (
id int not null auto_increment,
name varchar(30) not null,
team varchar(30),
position varchar(15) not null,
`start` date,
`end` date,
`value` numeric,
contract varchar(15) default 'Buy',
birth date,
height decimal(3,2),
nationality varchar(20) default 'Brazil',
primary key(id)
) default charset = utf8mb4;

create table if not exists championship_year (
id int not null auto_increment,
`date` date,
fase varchar(30) default 'Group Stage',
stadium varchar(40) not null,
team1 varchar(25) not null,
gp1 int not null,
gp2 int not null,
team2 varchar(25) not null,
result enum('Victory', 'Draw', 'Defeat'),
primary key(id)
) default charset = utf8mb4;
