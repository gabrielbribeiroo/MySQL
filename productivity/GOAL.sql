-- 📈 Goal Tracking System
-- This database is designed to help users define, track, and evaluate personal or professional goals.

CREATE DATABASE IF NOT EXISTS goal_tracking
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE goal_tracking;

-- Users of the system
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Main goals set by the user
CREATE TABLE IF NOT EXISTS goals (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  title VARCHAR(150) NOT NULL,
  description TEXT,
  category ENUM('Personal', 'Professional', 'Health', 'Education', 'Financial') DEFAULT 'Personal',
  start_date DATE,
  end_date DATE,
  status ENUM('Planned', 'In Progress', 'Completed', 'Canceled') DEFAULT 'Planned',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);