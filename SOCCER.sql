create database soccer
default character set utf8mb4
default collate utf8mb4_general_ci;

use soccer;

-- table for teams --
create table if not exists team (
  id int not null auto_increment,
  name varchar(30) not null,
  stadium varchar(50),
  birth date check (birth <= CURDATE()),
  nationality varchar(20) default 'Brazil',
  title enum('World', 'National', 'Regional', 'Defeat'),
  created_at timestamp default current_timestamp,
  updated_at TIMESTAMP default current_timestamp on update current_timestamp,
  primary key(id)
) default charset = utf8mb4;

-- table for player positions --
create table if not exists position (
  id int not null auto_increment,
  name varchar(20) not null unique,
  primary key (id)
) default charset = utf8mb4;

-- table for contract types --
create table if not exists contract (
  id int not null auto_increment,
  type varchar(15) not null unique,
  primary key (id)
) default charset = utf8mb4;

-- table for players -- 
create table if not exists player (
  id int not null auto_increment,
  name varchar(50) not null,
  team_id int,
  position_id int not null,
  `start` date,
  `end` date,
  `value` decimal(10, 2),
  contract int default 1,
  birth date check (birth <= CURDATE()),
  height decimal(3,2),
  nationality varchar(20) default 'Brazil',
  created_at timestamp default current_timestamp,
  updated_at timestamp default current_timestamp on update current_timestamp,
  primary key(id),
  foreign key (team_id) references team(id) on delete set null on update cascade,
  foreign key (position_id) references position(id) on delete restrict on update cascade,
  foreign key (contract) references contract on delete restrict on update cascade
) default charset = utf8mb4;

-- table for match results --
create table if not exists match_result (
  id int not null auto_increment,
  result varchar(10) not null unique,
  primary key (id)
) default charset = utf8mb4;

-- table for championship --
create table if not exists championship_year (
  id int not null auto_increment,
  `date` date,
  fase varchar(30) default 'Group Stage',
  stadium varchar(50) not null,
  team1_id int not null,
  gp1 int not null default 0,
  gp2 int not null default 0,
  team2_id int not null,
  result_id int not null,
  created_at TIMESTAMP default current_timestamp,
  updated_at TIMESTAMP default current_timestamp on update current_timestamp,
  primary key(id),
  foreign key (team1_id) references team(id) on delete cascade on update cascade,
  FOREIGN KEY (team2_id) references team(id) on delete cascade on update cascade,
  FOREIGN KEY (result_id) references match_result(id) on delete restrict on update cascade
) default charset = utf8mb4;
