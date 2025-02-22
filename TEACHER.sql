create database teacher
default character set utf8mb4
default collate utf8mb4_general_ci;

use teacher;

-- table for financial records
create table if not exists finance_year (
  id int not null auto_increment,
  `date` date not null, -- transaction date
  reference varchar(15) not null, -- payment reference number or ID
  `value` decimal(10,2) not null, -- adjusted for realistic financial transactions
  client_id int, -- linked to the client (student, parent, etc.)
  bank_origin_id int, -- linked to the originating bank
  beneficiary_id int, -- linked to the beneficiary
  bank_destination_id int, -- linked to the receiving bank  
  created_at timestamp default current_timestamp,
  updated_at TIMESTAMP default current_timestamp on update current_timestamp,
  primary key(id)
) default charset = utf8mb4;

-- table for banks (avoids repetition of bank names in finance_year)
create table if not exists bank (
  id int not null auto_increment,
  name varchar(50) not null unique, -- bank name (e.g., "Bank of America") 
  primary key (id)
) default charset = utf8mb4;

create table if not exists classes_month_year (
  id int not null,
  `date` date,
  student varchar(30) not null,
  series varchar(3),
  subjects varchar(25) not null,
  content varchar(60) not null,
  additional varchar(30),
  primary key(additional)
) default charset = utf8mb4;
