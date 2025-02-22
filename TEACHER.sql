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

-- table for students
create table if not exists student (
  id not null auto_increment,
  name varchar(50) not null unique, -- student's full name
  primary key (id)
) default charset = utf8mb4;

-- table for school series (grades)
create table if not exists series (
  id int not null auto_increment,
  name varchar(5) not null unique, -- grade level (e.g., "1st", "2nd", "High School")
  primary key (id)
) default charset = utf8mb4;

-- table for subjects 
create table if not exists subject (
  id int not null auto_increment,
  name varchar(50) not null unique, -- subject name (e.g., "Mathematics", "History")
  primary key (id)
) default charset = utf8mb4;

-- table for class records per month and year
create table if not exists classes_month_year (
  id int not null auto_increment,
  `date` date not null, -- class date
  student_id int not null, -- linked to student table
  series_id int not null, -- linked to series table
  subject_id int not null, -- linked to subject table
  content varchar(255) not null, -- detailed class content
  additional_notes text, -- additional notes (changed to text for flexibility)
  created_at timestamp default current_timestamp,
  updated_at TIMESTAMP default current_timestamp on update current_timestamp,
  primary key (id),
  foreign key (student_id) references student(id) on delete cascade on update cascade,
  foreign key (series_id) references series(id) on delete set null on update cascade,
  foreign key (subject_id) references subject(id) on delete cascade on update cascade
) default charset = utf8mb4;
