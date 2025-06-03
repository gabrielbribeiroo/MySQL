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