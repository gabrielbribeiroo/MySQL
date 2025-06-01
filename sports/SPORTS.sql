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

-- Table to register monitors (coaches/trainers)
CREATE TABLE monitors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    specialization VARCHAR(100),
    hire_date DATE
);