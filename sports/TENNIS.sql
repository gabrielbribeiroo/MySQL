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