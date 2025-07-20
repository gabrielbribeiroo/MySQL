
CREATE DATABASE IF NOT EXISTS theater_management
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE theater_management;

CREATE TABLE theater (
  theater_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  location VARCHAR(150) NOT NULL,
  capacity INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE play (
  play_id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  genre VARCHAR(50),
  duration_minutes INT,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE actor (
  actor_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  bio TEXT,
  birth_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cast (
  cast_id INT AUTO_INCREMENT PRIMARY KEY,
  play_id INT NOT NULL,
  actor_id INT NOT NULL,
  role_name VARCHAR(100),
  FOREIGN KEY (play_id) REFERENCES play(play_id),
  FOREIGN KEY (actor_id) REFERENCES actor(actor_id)
);