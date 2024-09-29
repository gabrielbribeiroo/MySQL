create database teacher
default character set utf8mb4
default collate utf8mb4_general_ci;

create table `finance` (
id int not null auto_increment,
`date` date,
reference varchar(15) not null,
`value` decimal(5,2) not null,
client varchar(20),
bank_origin varchar(15),
beneficiary varchar(20),
bank_destination varchar(15),  
primary key(id)
) default charset = utf8mb4;

create table if not exists classes_month (
id int not null,
`date` date,
student varchar(30) not null,
series varchar(3),
subjects varchar(25) not null,
content varchar(60) not null,
additional varchar(30),
primary key(additional)
) default charset = utf8mb4;
