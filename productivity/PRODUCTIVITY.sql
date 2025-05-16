-- 📌 Productivity Tracker Database
-- This schema is designed to monitor individual or team productivity
-- through activities, goals, time tracking, and evaluations.

CREATE DATABASE IF NOT EXISTS productivity_tracker
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE productivity_tracker;

-- Users table (individuals using the tracker)
CREATE TABLE IF NOT EXISTS users (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  role VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(id)
) DEFAULT CHARSET = utf8mb4;

-- Projects the users are involved in
CREATE TABLE IF NOT EXISTS projects (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  start_date DATE,
  end_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(id)
) DEFAULT CHARSET = utf8mb4;

-- Tasks under each project
CREATE TABLE IF NOT EXISTS tasks (
  id INT NOT NULL AUTO_INCREMENT,
  project_id INT NOT NULL,
  assigned_to INT NOT NULL,
  title VARCHAR(100) NOT NULL,
  description TEXT,
  status ENUM('Pending', 'In Progress', 'Completed', 'Blocked') DEFAULT 'Pending',
  priority ENUM('Low', 'Medium', 'High') DEFAULT 'Medium',
  deadline DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY(id),
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY (assigned_to) REFERENCES users(id) ON DELETE SET NULL
) DEFAULT CHARSET = utf8mb4;

-- Daily logs of time spent on tasks
CREATE TABLE IF NOT EXISTS time_logs (
  id INT NOT NULL AUTO_INCREMENT,
  task_id INT NOT NULL,
  user_id INT NOT NULL,
  date DATE NOT NULL,
  hours_spent DECIMAL(4,2) NOT NULL,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(id),
  FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;