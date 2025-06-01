-- Create database
CREATE DATABASE IF NOT EXISTS sports_club
default character set utf8mb4
default collate utf8mb4_general_ci;

USE sports_club;

-- Table to register different sports modalities (e.g., swimming, judo, volleyball)
CREATE TABLE modalities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    active BOOLEAN DEFAULT TRUE
);