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

-- Table to store physical evaluations (weight, height, body fat, etc.)
CREATE TABLE IF NOT EXISTS physical_records (
  id INT NOT NULL AUTO_INCREMENT,
  client_id INT NOT NULL,
  record_date DATE NOT NULL,
  weight DECIMAL(5,2), -- in kg
  height DECIMAL(4,2), -- in meters
  body_fat_percent DECIMAL(4,2),
  muscle_mass DECIMAL(5,2),
  observations TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;

-- Table to store training plans (ex: "Hypertrophy", "Weight Loss")
CREATE TABLE IF NOT EXISTS training_plans (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  description TEXT,
  duration_weeks INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;

-- Table to associate a training plan with a client
CREATE TABLE IF NOT EXISTS client_training (
  id INT NOT NULL AUTO_INCREMENT,
  client_id INT NOT NULL,
  training_plan_id INT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE,
  active BOOLEAN DEFAULT TRUE,
  PRIMARY KEY (id),
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
  FOREIGN KEY (training_plan_id) REFERENCES training_plans(id)
) DEFAULT CHARSET = utf8mb4;

-- Table for training sessions/frequency tracking
CREATE TABLE IF NOT EXISTS attendance (
  id INT NOT NULL AUTO_INCREMENT,
  client_id INT NOT NULL,
  check_in DATETIME NOT NULL,
  check_out DATETIME,
  PRIMARY KEY (id),
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;

-- Table to store individual exercises per training plan
CREATE TABLE IF NOT EXISTS exercises (
  id INT NOT NULL AUTO_INCREMENT,
  training_plan_id INT NOT NULL,
  name VARCHAR(50) NOT NULL,
  muscle_group VARCHAR(30),
  series INT,
  repetitions INT,
  rest_time_seconds INT,
  instructions TEXT,
  PRIMARY KEY (id),
  FOREIGN KEY (training_plan_id) REFERENCES training_plans(id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;
