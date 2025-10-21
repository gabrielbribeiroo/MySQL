-- Database: time_tracking
-- Employee or freelancer time tracking system
-- with work sessions, breaks, and productivity metrics

CREATE DATABASE time_tracking
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE time_tracking;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    role ENUM('employee', 'freelancer', 'manager', 'admin') DEFAULT 'employee',
    hourly_rate DECIMAL(10,2),
    active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);