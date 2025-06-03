-- 🏘️ Community Budget - Participatory Budgeting System
-- This schema supports the voting and allocation of local government budgets through community participation in neighborhoods or municipalities.

CREATE DATABASE IF NOT EXISTS community_budget
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE community_budget;

-- Neighborhoods or districts involved in the budgeting process
CREATE TABLE IF NOT EXISTS districts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Budget cycles or annual participatory planning rounds
CREATE TABLE IF NOT EXISTS budget_cycles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  year YEAR NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Community members allowed to vote or submit proposals
CREATE TABLE IF NOT EXISTS citizens (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  cpf VARCHAR(14) UNIQUE,
  birth_date DATE,
  district_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (district_id) REFERENCES districts(id)
);