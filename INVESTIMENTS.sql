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

-- Insert default investment types
INSERT INTO investment_types (name, description) VALUES
('Stocks', 'Equity investments in companies'),
('Bonds', 'Fixed income securities'),
('Real Estate Investment Trusts (REITs)', 'Investments in real estate funds'),
('Cryptocurrency', 'Digital assets such as Bitcoin and Ethereum'),
('Mutual Funds', 'Pooled investment funds managed by professionals');

-- Register a new user
INSERT INTO users (name, email, password_hash)
VALUES ('Gabriel Ribeiro', 'gabriel@email.com', 'hashed_password');

-- Create a new investment account
INSERT INTO accounts (user_id, name, balance)
VALUES (1, 'XP Investimentos - Conta Corretora', 10000.00);

-- Register a new investment
INSERT INTO investments (user_id, investment_type_id, account_id, asset_name, quantity, purchase_price, purchase_date)
VALUES (1, 
        (SELECT id FROM investment_types WHERE name = 'Stocks'),
        (SELECT id FROM accounts WHERE name = 'XP Investimentos - Conta Corretora'),
        'AAPL', 10, 150.00, '2025-02-20');

-- Dividend receipt recorder
INSERT INTO dividends (user_id, investment_id, amount, payment_date)
VALUES (1, 
        (SELECT id FROM investments WHERE asset_name = 'AAPL'),
        50.00, '2025-03-15');

-- Create an investment goal
INSERT INTO goals (user_id, goal_name, target_amount, deadline)
VALUES (1, 'Retirement Fund', 500000.00, '2045-12-31');

-- Get all investments of a user
SELECT i.asset_name, i.quantity, i.purchase_price, i.purchase_date, t.name AS investment_type
FROM investments i
JOIN investment_types t ON i.investment_type_id = t.id
WHERE i.user_id = 1
ORDER BY i.purchase_date DESC;

-- Total invested by investment type
SELECT t.name AS investment_type, SUM(i.quantity * i.purchase_price) AS total_invested
FROM investments i
JOIN investment_types t ON i.investment_type_id = t.id
WHERE i.user_id = 1
GROUP BY t.name
ORDER BY total_invested DESC;

