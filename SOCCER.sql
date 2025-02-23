create database soccer
default character set utf8mb4
default collate utf8mb4_general_ci;

use soccer;

-- table for teams --
create table if not exists team (
  id int not null auto_increment,
  name varchar(30) not null, -- unique team name
  stadium varchar(50), -- name of the stadium
  birth date check (birth <= CURDATE()), -- ensures no future foundation dates
  nationality varchar(20) default 'Brazil', -- default nationality
  title enum('World', 'National', 'Regional', 'Defeat'), -- club recognition level
  created_at timestamp default current_timestamp,
  updated_at TIMESTAMP default current_timestamp on update current_timestamp,
  primary key(id)
) default charset = utf8mb4;

-- table for player positions --
create table if not exists position (
  id int not null auto_increment,
  name varchar(20) not null unique, -- unique position name (e.g., Goalkeeper, Defender)
  primary key (id)
) default charset = utf8mb4;

-- table for contract types --
create table if not exists contract (
  id int not null auto_increment,
  type varchar(15) not null unique, -- contract types (Buy, Loan, Free Transfer)
  primary key (id)
) default charset = utf8mb4;

-- table for players -- 
create table if not exists player (
  id int not null auto_increment,
  name varchar(50) not null, -- player's full name
  team_id int, -- reference to the team
  position_id int not null, -- reference to the position
  `start` date, -- start of the contract
  `end` date, -- end of the contract
  `value` decimal(10, 2), -- player's market value
  contract int default 1, -- default contract type is 'Buy'
  birth date check (birth <= CURDATE()), -- ensures no future birth dates
  height decimal(3,2), -- player's height (in meters)
  nationality varchar(20) default 'Brazil', -- default nationality
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
  result varchar(10) not null unique, -- possible results: Victory, Draw, Defeat
  primary key (id)
) default charset = utf8mb4;

-- table for championship --
create table if not exists championship_year (
  id int not null auto_increment,
  `date` date, -- match date
  stage varchar(30) default 'Group Stage', -- match phase
  stadium varchar(50) not null, -- match stadium
  team1_id int not null, -- reference to first team
  gp1 int not null default 0, -- goals scored by team 1
  gp2 int not null default 0, -- goals scored by team 2
  team2_id int not null, -- reference to second team
  result_id int not null, -- match result (Victory, Draw, Defeat)
  created_at TIMESTAMP default current_timestamp,
  updated_at TIMESTAMP default current_timestamp on update current_timestamp,
  primary key(id),
  foreign key (team1_id) references team(id) on delete cascade on update cascade,
  FOREIGN KEY (team2_id) references team(id) on delete cascade on update cascade,
  FOREIGN KEY (result_id) references match_result(id) on delete restrict on update cascade
) default charset = utf8mb4;
