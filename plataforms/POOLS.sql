-- Database: online_polls
CREATE DATABASE IF NOT EXISTS online_polls
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE online_polls;

-- Users who can participate in polls
CREATE TABLE IF NOT EXISTS users (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;

-- Polls (set of questions grouped under a single theme)
CREATE TABLE IF NOT EXISTS polls (
  id INT NOT NULL AUTO_INCREMENT,
  title VARCHAR(100) NOT NULL,
  description TEXT,
  is_public BOOLEAN DEFAULT TRUE, -- true = any user can vote
  start_date DATE,
  end_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;

-- Questions within a poll
CREATE TABLE IF NOT EXISTS questions (
  id INT NOT NULL AUTO_INCREMENT,
  poll_id INT NOT NULL,
  question_text TEXT NOT NULL,
  question_type ENUM('single', 'multiple') DEFAULT 'single', -- single/multiple choice
  PRIMARY KEY (id),
  FOREIGN KEY (poll_id) REFERENCES polls(id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;

-- Options available for each question
CREATE TABLE IF NOT EXISTS options (
  id INT NOT NULL AUTO_INCREMENT,
  question_id INT NOT NULL,
  option_text VARCHAR(100) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;

-- Votes cast by users
CREATE TABLE IF NOT EXISTS votes (
  id INT NOT NULL AUTO_INCREMENT,
  user_id INT, -- nullable for anonymous voting
  option_id INT NOT NULL,
  vote_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
  FOREIGN KEY (option_id) REFERENCES options(id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;