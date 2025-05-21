
-- 🏙️ City Feedback System
-- Database for collecting suggestions and complaints from citizens by neighborhood and urban topic.

-- Create database
CREATE DATABASE IF NOT EXISTS city_feedback
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE city_feedback;

-- Citizens registered in the system
CREATE TABLE IF NOT EXISTS citizens (
  id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  cpf VARCHAR(14) UNIQUE, -- Brazilian personal ID (can be optional or removed for general use)
  email VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) DEFAULT CHARSET = utf8mb4;

-- City neighborhoods or regions
CREATE TABLE IF NOT EXISTS neighborhoods (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  zone ENUM('North', 'South', 'East', 'West', 'Central') NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) DEFAULT CHARSET = utf8mb4;