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

-- Credit lines a user may have (e.g., credit card, loan, financing)
CREATE TABLE IF NOT EXISTS credit_lines (
  id INT NOT NULL AUTO_INCREMENT,
  user_id INT NOT NULL,
  institution_id INT NOT NULL,
  type ENUM('credit_card', 'personal_loan', 'financing', 'overdraft', 'other') NOT NULL,
  credit_limit DECIMAL(12,2),
  interest_rate DECIMAL(5,2), -- annual percentage
  start_date DATE NOT NULL,
  end_date DATE,
  status ENUM('active', 'closed', 'defaulted') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (institution_id) REFERENCES institutions(id)
) DEFAULT CHARSET = utf8mb4;