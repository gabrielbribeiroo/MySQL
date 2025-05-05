-- 📦 Simplified ERP (Enterprise Resource Planning) - MySQL

-- Create database
CREATE DATABASE IF NOT EXISTS erp_system
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE erp_system;

-- Customers table
CREATE TABLE IF NOT EXISTS customers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE,
  phone VARCHAR(20),
  address TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
