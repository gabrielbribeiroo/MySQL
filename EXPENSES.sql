-- Create a database for expense control
CREATE DATABASE IF NOT EXISTS expenses
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL, -- Store encrypted password
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;

-- Expense category table
CREATE TABLE IF NOT EXISTS categories (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;

-- Payment methods table
CREATE TABLE IF NOT EXISTS payment_methods (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;

-- Table of financial accounts
CREATE TABLE IF NOT EXISTS accounts (
  id INT NOT NULL AUTO_INCREMENT,
  user_id INT NOT NULL,
  name VARCHAR(50) NOT NULL, 
  balance DECIMAL(12,2) DEFAULT 0.00,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;

-- Main table for expenses
CREATE TABLE IF NOT EXISTS expenses (
  id INT NOT NULL AUTO_INCREMENT,
  user_id INT NOT NULL, -- User who registered the expense
  category_id INT NOT NULL, -- Expense category
  payment_method_id INT NOT NULL, -- Payment method used
  account_id INT NOT NULL, -- Financial account used for the expense
  amount DECIMAL(12,2) NOT NULL, -- Expense amount
  description TEXT, -- Additional details about the expense
  expense_date DATE NOT NULL, -- Date when the expense occurred
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Timestamp when the record was created
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, -- Ensures that when a user is deleted, their expenses are also removed
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE, -- Links the expense to a specific category
  FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id) ON DELETE CASCADE, -- Links the expense to a payment method
  FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE -- Links the expense to a financial account
) DEFAULT CHARSET = utf8mb4;
