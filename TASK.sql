-- Create database
CREATE DATABASE IF NOT EXISTS task_manager
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE task_manager;

-- Table of users responsible for tasks
CREATE TABLE IF NOT EXISTS users (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;

-- Table of projects that group tasks
CREATE TABLE IF NOT EXISTS projects (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  start_date DATE,
  end_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;

-- Enum table for task priority levels
CREATE TABLE IF NOT EXISTS priorities (
  id INT NOT NULL AUTO_INCREMENT,
  name ENUM('Low', 'Medium', 'High', 'Critical') NOT NULL,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;

-- Enum table for task status
CREATE TABLE IF NOT EXISTS statuses (
  id INT NOT NULL AUTO_INCREMENT,
  name ENUM('To Do', 'In Progress', 'Done', 'Blocked') NOT NULL,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;
