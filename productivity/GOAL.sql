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

-- Milestones associated with a goal
CREATE TABLE IF NOT EXISTS milestones (
  id INT AUTO_INCREMENT PRIMARY KEY,
  goal_id INT NOT NULL,
  title VARCHAR(150) NOT NULL,
  due_date DATE,
  completed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (goal_id) REFERENCES goals(id) ON DELETE CASCADE
);

-- Notes or reflections logged by the user during the goal progress
CREATE TABLE IF NOT EXISTS reflections (
  id INT AUTO_INCREMENT PRIMARY KEY,
  goal_id INT NOT NULL,
  entry_date DATE DEFAULT CURRENT_DATE,
  content TEXT NOT NULL,
  mood ENUM('Very Bad', 'Bad', 'Neutral', 'Good', 'Excellent') DEFAULT 'Neutral',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (goal_id) REFERENCES goals(id) ON DELETE CASCADE
);

-- Daily progress tracking linked to specific goals
CREATE TABLE IF NOT EXISTS daily_progress (
  id INT AUTO_INCREMENT PRIMARY KEY,
  goal_id INT NOT NULL,
  progress_date DATE DEFAULT CURRENT_DATE,
  progress_percentage DECIMAL(5,2) CHECK (progress_percentage >= 0 AND progress_percentage <= 100),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (goal_id) REFERENCES goals(id) ON DELETE CASCADE
);