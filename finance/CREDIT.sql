-- 📊 Credit Score Management Database
-- This database stores user credit records, including debts, payments, credit lines, and score history.

-- Create database
CREATE DATABASE IF NOT EXISTS credit_score
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE credit_score;

-- Users registered in the system
CREATE TABLE IF NOT EXISTS users (
  id INT NOT NULL AUTO_INCREMENT,
  full_name VARCHAR(100) NOT NULL,
  cpf VARCHAR(14) NOT NULL UNIQUE, -- Brazilian CPF format (XXX.XXX.XXX-XX)
  birth_date DATE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;

-- Credit institutions (banks, fintechs, cooperatives, etc.)
CREATE TABLE IF NOT EXISTS institutions (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL UNIQUE,
  cnpj VARCHAR(18), -- Brazilian company ID format
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;