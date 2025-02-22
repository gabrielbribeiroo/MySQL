create database timeline
default character set utf8mb4
default collate utf8mb4_general_ci;

use timeline;

-- table for time slots
create table if not exists horary (
  id int not null auto_increment,
  start_time time NOT NULL,
  end_time time NOT NULL,
  created_at timestamp default current_timestamp,
  updated_at timestamp default current_timestamp on update current_timestamp,
  primary key (id)
) default charset = utf8mb4;

-- table for day of the week
create table if not exists day_week (
  id int not null auto_increment,
  name varchar(10) not null unique,
  primary key (id)
) default charset = utf8mb4;

-- table to link horary with specific schedules on different days
create table if not exists horary_schedule (
  id int not null auto_increment,
  horary_id int not null,
  day_id int not null,
  description text, 
  created_at timestamp default current_timestamp,
  updated_at timestamp default current_timestamp on update current_timestamp,
  primary key (id),
  foreign key (horary_id) references horary(id) on delete cascade on update cascade,
  foreign key (day_id) REFERENCES day_of_week(id) on delete cascade on update cascade
) default charset = utf8mb4;

-- insert default values for days of the week
insert into day_week (name) values 
('Monday'), 
('Tuesday'), 
('Wednesday'), 
('Thursday'), 
('Friday'), 
('Saturday'), 
('Sunday');
