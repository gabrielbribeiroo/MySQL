-- 📘 Family Budget System (MySQL)

-- Create the main database
CREATE DATABASE IF NOT EXISTS family_budget
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE family_budget;

-- Table for Users (e.g., family members)
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE,
  role ENUM('Parent', 'Child', 'Other') DEFAULT 'Other',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  -- Consider adding authentication fields if login is needed
);
