create database timeline
default character set utf8mb4
default collate utf8mb4_general_ci;

create table if not exists horary (
id int not null auto_increment,
`start` varchar(5) NOT NULL,
`end` varchar(5) NOT NULL,
monday text,
tuesday text,
wednesdsay text,
thursday text,
friday text,
primary key (id)
) default charset = utf8mb4;
