-- Create database for investment management
CREATE DATABASE IF NOT EXISTS investments_db
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE investments_db;

-- Users table (for multi-user systems)
CREATE TABLE IF NOT EXISTS users (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL, -- Stores encrypted passwords
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;

-- Investment types table (e.g., Stocks, Bonds, REITs)
CREATE TABLE IF NOT EXISTS investment_types (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;

-- Accounts table (e.g., Brokerage Accounts, Bank Accounts)
CREATE TABLE IF NOT EXISTS accounts (
  id INT NOT NULL AUTO_INCREMENT,
  user_id INT NOT NULL,
  name VARCHAR(50) NOT NULL, -- Account name (e.g., "Interactive Brokers - Brokerage Account")
  balance DECIMAL(12,2) DEFAULT 0.00, -- Account balance
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;

-- Investments table (tracks individual investments)
CREATE TABLE IF NOT EXISTS investments (
  id INT NOT NULL AUTO_INCREMENT,
  user_id INT NOT NULL, -- Investor
  investment_type_id INT NOT NULL, -- Type of investment (e.g., Stocks, REITs)
  account_id INT NOT NULL, -- Account used for the investment
  asset_name VARCHAR(100) NOT NULL, -- Asset name (e.g., AAPL, TSLA, BTC)
  quantity DECIMAL(10,4) NOT NULL, -- Number of shares/units
  purchase_price DECIMAL(12,2) NOT NULL, -- Price per unit
  purchase_date DATE NOT NULL, -- Date of purchase
  current_value DECIMAL(12,2) DEFAULT NULL, -- Current market value
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (investment_type_id) REFERENCES investment_types(id) ON DELETE CASCADE,
  FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;

-- Transactions table (tracks deposits, withdrawals, and purchases)
CREATE TABLE IF NOT EXISTS transactions (
  id INT NOT NULL AUTO_INCREMENT,
  user_id INT NOT NULL,
  account_id INT NOT NULL,
  transaction_type ENUM('Deposit', 'Withdrawal', 'Investment Purchase', 'Investment Sale') NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  transaction_date DATE NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;

-- Dividends table (records received dividends)
CREATE TABLE IF NOT EXISTS dividends (
  id INT NOT NULL AUTO_INCREMENT,
  user_id INT NOT NULL,
  investment_id INT NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  payment_date DATE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (investment_id) REFERENCES investments(id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;

-- Investment goals table (tracks financial objectives)
CREATE TABLE IF NOT EXISTS goals (
  id INT NOT NULL AUTO_INCREMENT,
  user_id INT NOT NULL,
  goal_name VARCHAR(100) NOT NULL, -- Name of the goal (e.g., "Retirement Fund")
  target_amount DECIMAL(12,2) NOT NULL, -- Target amount to reach
  current_savings DECIMAL(12,2) DEFAULT 0.00, -- Current saved amount
  deadline DATE NOT NULL, -- Target completion date
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;
