-- 🗣️ Database: citizen_engagement
-- Platform for community engagement with discussions, polls, and collaborative decision-making

CREATE DATABASE citizen_engagement
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE citizen_engagement;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    state VARCHAR(50),
    country VARCHAR(100) DEFAULT 'Brazil',
    role ENUM('Citizen', 'Moderator', 'Administrator') DEFAULT 'Citizen',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);