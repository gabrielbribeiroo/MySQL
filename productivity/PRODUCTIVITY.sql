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