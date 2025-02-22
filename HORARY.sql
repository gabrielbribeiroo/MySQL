create database timeline
default character set utf8mb4
default collate utf8mb4_general_ci;

use timeline;

-- table for time slots --
create table if not exists horary (
  id int not null auto_increment,
  start_time time NOT NULL,
  end_time time NOT NULL,
  created_at timestamp default current_timestamp,
  updated_at TIMESTAMP default current_timestamp on update current_timestamp,
  primary key (id)
) default charset = utf8mb4;
