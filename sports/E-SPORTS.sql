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

-- Players registered in the system
CREATE TABLE IF NOT EXISTS players (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  nickname VARCHAR(50) NOT NULL,
  birth_date DATE,
  team_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE SET NULL
);

-- E-sports tournaments or events
CREATE TABLE IF NOT EXISTS tournaments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  game_id INT,
  location VARCHAR(100),
  start_date DATE,
  end_date DATE,
  total_prize DECIMAL(12,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (game_id) REFERENCES games(id)
);

-- Individual matches within tournaments
CREATE TABLE IF NOT EXISTS matches (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tournament_id INT NOT NULL,
  match_date DATETIME NOT NULL,
  team1_id INT NOT NULL,
  team2_id INT NOT NULL,
  score_team1 INT DEFAULT 0,
  score_team2 INT DEFAULT 0,
  winner_team_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (tournament_id) REFERENCES tournaments(id),
  FOREIGN KEY (team1_id) REFERENCES teams(id),
  FOREIGN KEY (team2_id) REFERENCES teams(id),
  FOREIGN KEY (winner_team_id) REFERENCES teams(id)
);