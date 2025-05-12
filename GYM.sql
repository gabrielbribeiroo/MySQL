-- Database: gym (fitness management system)
CREATE DATABASE IF NOT EXISTS gym
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE gym;

-- Table to store clients
CREATE TABLE IF NOT EXISTS clients (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  birth_date DATE,
  gender ENUM('Male', 'Female', 'Other'),
  email VARCHAR(100),
  phone VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;
