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

-- Table for Expense Categories (e.g., Food, Utilities, etc.)
CREATE TABLE IF NOT EXISTS categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table to define monthly limits per category and user
CREATE TABLE IF NOT EXISTS category_limits (
  id INT AUTO_INCREMENT PRIMARY KEY,
  category_id INT NOT NULL,
  user_id INT,
  month YEAR NOT NULL,
  month_number TINYINT NOT NULL CHECK (month_number BETWEEN 1 AND 12),
  limit_amount DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
  -- You might want to add a UNIQUE(category_id, user_id, month, month_number)
);

-- Table for planned budget (forecasted values)
CREATE TABLE IF NOT EXISTS forecasts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  category_id INT NOT NULL,
  user_id INT,
  month YEAR NOT NULL,
  month_number TINYINT NOT NULL CHECK (month_number BETWEEN 1 AND 12),
  forecast_amount DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
  -- Consider UNIQUE(category_id, user_id, month, month_number) for data consistency
);
