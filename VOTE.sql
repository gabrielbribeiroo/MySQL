-- Create the database
CREATE DATABASE IF NOT EXISTS online_voting
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE online_voting;

-- Table for registered voters
CREATE TABLE IF NOT EXISTS voters (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  cpf VARCHAR(14) NOT NULL UNIQUE, -- Brazilian ID format (XXX.XXX.XXX-XX)
  email VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;

-- Table for election candidates
CREATE TABLE IF NOT EXISTS candidates (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  party VARCHAR(50),
  biography TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;

-- Table for voting sessions (e.g., "Presidential 2025", "School Council 2024")
CREATE TABLE IF NOT EXISTS voting_sessions (
  id INT NOT NULL AUTO_INCREMENT,
  title VARCHAR(100) NOT NULL,
  description TEXT,
  start_date DATETIME NOT NULL,
  end_date DATETIME NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;

-- Table to link candidates to specific voting sessions
CREATE TABLE IF NOT EXISTS session_candidates (
  id INT NOT NULL AUTO_INCREMENT,
  session_id INT NOT NULL,
  candidate_id INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (session_id) REFERENCES voting_sessions(id) ON DELETE CASCADE,
  FOREIGN KEY (candidate_id) REFERENCES candidates(id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;
