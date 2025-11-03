-- Database: fitness_app
-- Personal fitness tracking system with exercises, nutrition plans, goals, and progress monitoring

CREATE DATABASE fitness_app
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE fitness_app;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    gender ENUM('M', 'F', 'Other'),
    birth_date DATE,
    height_cm DECIMAL(5,2),
    weight_kg DECIMAL(5,2),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);