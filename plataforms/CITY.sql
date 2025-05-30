
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

-- Urban topic categories (e.g., sanitation, public safety, transportation)
CREATE TABLE IF NOT EXISTS categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT
) DEFAULT CHARSET = utf8mb4;

-- Main table for citizen feedback entries
CREATE TABLE IF NOT EXISTS feedback (
  id INT AUTO_INCREMENT PRIMARY KEY,
  citizen_id INT,
  neighborhood_id INT,
  category_id INT NOT NULL,
  type ENUM('complaint', 'suggestion') NOT NULL,
  title VARCHAR(150) NOT NULL,
  description TEXT NOT NULL,
  status ENUM('pending', 'under review', 'resolved', 'ignored') DEFAULT 'pending',
  submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (citizen_id) REFERENCES citizens(id),
  FOREIGN KEY (neighborhood_id) REFERENCES neighborhoods(id),
  FOREIGN KEY (category_id) REFERENCES categories(id)
) DEFAULT CHARSET = utf8mb4;

-- Table for municipal responses or follow-ups
CREATE TABLE IF NOT EXISTS responses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  feedback_id INT NOT NULL,
  responder_name VARCHAR(100) NOT NULL,
  message TEXT NOT NULL,
  responded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (feedback_id) REFERENCES feedback(id)
) DEFAULT CHARSET = utf8mb4;