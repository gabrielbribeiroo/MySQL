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