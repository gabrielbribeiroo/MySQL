-- 💊 Pharmacy Management System
-- Database for tracking medicine inventory, prescriptions, batch numbers, expiration dates, and sales.

-- Create the database
CREATE DATABASE IF NOT EXISTS pharmacy
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE pharmacy;

-- Registered medicines in the pharmacy
CREATE TABLE IF NOT EXISTS medicines (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  manufacturer VARCHAR(100),
  unit_price DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) DEFAULT CHARSET = utf8mb4;

-- Batch and stock control for each medicine
CREATE TABLE IF NOT EXISTS batches (
  id INT AUTO_INCREMENT PRIMARY KEY,
  medicine_id INT NOT NULL,
  batch_number VARCHAR(50) NOT NULL,
  quantity INT NOT NULL,
  expiration_date DATE NOT NULL,
  arrival_date DATE NOT NULL,
  FOREIGN KEY (medicine_id) REFERENCES medicines(id)
) DEFAULT CHARSET = utf8mb4;

-- Clients who purchase or receive medication (can be used with or without prescriptions)
CREATE TABLE IF NOT EXISTS clients (
  id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  cpf VARCHAR(14) UNIQUE,
  birth_date DATE,
  email VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) DEFAULT CHARSET = utf8mb4;