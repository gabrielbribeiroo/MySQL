-- 🕹️ E-Sports Competition Database
-- This schema manages electronic sports tournaments, teams, matches, games, players, and prize distributions.

CREATE DATABASE IF NOT EXISTS e_sports
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE e_sports;

-- Games available in the tournament system
CREATE TABLE IF NOT EXISTS games (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  genre VARCHAR(50),
  developer VARCHAR(100),
  release_year YEAR,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Teams participating in competitions
CREATE TABLE IF NOT EXISTS teams (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  country VARCHAR(50),
  founded_year YEAR,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);