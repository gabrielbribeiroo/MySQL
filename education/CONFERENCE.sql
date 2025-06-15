-- 🎓 Conference System - Academic Conference Management
-- This database models the management of academic conferences with submissions, reviews, and presentations.

CREATE DATABASE IF NOT EXISTS conference_system
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE conference_system;

-- Conferences with title, location and date
CREATE TABLE IF NOT EXISTS conferences (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  location VARCHAR(150),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);