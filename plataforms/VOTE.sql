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

-- Table for storing votes
CREATE TABLE IF NOT EXISTS votes (
  id INT NOT NULL AUTO_INCREMENT,
  voter_id INT NOT NULL,
  session_id INT NOT NULL,
  candidate_id INT NOT NULL,
  vote_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (voter_id) REFERENCES voters(id) ON DELETE CASCADE,
  FOREIGN KEY (session_id) REFERENCES voting_sessions(id) ON DELETE CASCADE,
  FOREIGN KEY (candidate_id) REFERENCES candidates(id) ON DELETE CASCADE,
  UNIQUE (voter_id, session_id) -- Prevents multiple votes in the same session
) DEFAULT CHARSET = utf8mb4;

-- Optional view for election results
CREATE VIEW voting_results AS
SELECT 
  s.id AS session_id,
  s.title AS session_title,
  c.id AS candidate_id,
  c.name AS candidate_name,
  COUNT(v.id) AS total_votes
FROM voting_sessions s
JOIN session_candidates sc ON sc.session_id = s.id
JOIN candidates c ON c.id = sc.candidate_id
LEFT JOIN votes v ON v.candidate_id = c.id AND v.session_id = s.id
GROUP BY s.id, c.id
ORDER BY s.id, total_votes DESC;
