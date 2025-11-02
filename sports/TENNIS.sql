-- Database: tennis_league
-- Tennis league organizer with players, matches, rankings, and seasonal statistics

CREATE DATABASE tennis_league
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE tennis_league;

CREATE TABLE players (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    gender ENUM('M', 'F', 'Other'),
    birth_date DATE,
    nationality VARCHAR(100),
    dominant_hand ENUM('Right', 'Left') DEFAULT 'Right',
    ranking_points INT DEFAULT 0,
    registration_date DATE DEFAULT (CURRENT_DATE),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE seasons (
    season_id INT AUTO_INCREMENT PRIMARY KEY,
    year INT NOT NULL,
    start_date DATE,
    end_date DATE,
    status ENUM('Upcoming', 'Ongoing', 'Completed') DEFAULT 'Upcoming'
);

CREATE TABLE tournaments (
    tournament_id INT AUTO_INCREMENT PRIMARY KEY,
    season_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    location VARCHAR(150),
    surface ENUM('Clay', 'Grass', 'Hard', 'Carpet') DEFAULT 'Hard',
    start_date DATE,
    end_date DATE,
    level ENUM('Local', 'Regional', 'National', 'International') DEFAULT 'Local',
    FOREIGN KEY (season_id) REFERENCES seasons(season_id)
);

CREATE TABLE matches (
    match_id INT AUTO_INCREMENT PRIMARY KEY,
    tournament_id INT NOT NULL,
    round ENUM('Round of 32', 'Round of 16', 'Quarterfinal', 'Semifinal', 'Final'),
    match_date DATE,
    player1_id INT NOT NULL,
    player2_id INT NOT NULL,
    winner_id INT,
    score VARCHAR(50),  -- Exemplo: "6-4, 3-6, 7-6"
    duration_minutes INT,
    FOREIGN KEY (tournament_id) REFERENCES tournaments(tournament_id),
    FOREIGN KEY (player1_id) REFERENCES players(player_id),
    FOREIGN KEY (player2_id) REFERENCES players(player_id),
    FOREIGN KEY (winner_id) REFERENCES players(player_id)
);

CREATE TABLE match_stats (
    stats_id INT AUTO_INCREMENT PRIMARY KEY,
    match_id INT NOT NULL,
    player_id INT NOT NULL,
    aces INT DEFAULT 0,
    double_faults INT DEFAULT 0,
    first_serve_percent DECIMAL(5,2),
    winners INT DEFAULT 0,
    unforced_errors INT DEFAULT 0,
    break_points_converted DECIMAL(5,2),
    FOREIGN KEY (match_id) REFERENCES matches(match_id),
    FOREIGN KEY (player_id) REFERENCES players(player_id)
);

CREATE TABLE rankings (
    ranking_id INT AUTO_INCREMENT PRIMARY KEY,
    season_id INT NOT NULL,
    player_id INT NOT NULL,
    position INT,
    points INT DEFAULT 0,
    last_update DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (season_id) REFERENCES seasons(season_id),
    FOREIGN KEY (player_id) REFERENCES players(player_id)
);

CREATE TABLE seasonal_statistics (
    stats_id INT AUTO_INCREMENT PRIMARY KEY,
    season_id INT NOT NULL,
    player_id INT NOT NULL,
    matches_played INT DEFAULT 0,
    wins INT DEFAULT 0,
    losses INT DEFAULT 0,
    aces_total INT DEFAULT 0,
    double_faults_total INT DEFAULT 0,
    total_points_won INT DEFAULT 0,
    win_rate DECIMAL(5,2),
    FOREIGN KEY (season_id) REFERENCES seasons(season_id),
    FOREIGN KEY (player_id) REFERENCES players(player_id)
);