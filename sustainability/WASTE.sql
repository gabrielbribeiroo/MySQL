-- Database: waste_tracking
-- Waste tracking system from generation to disposal, including recycling rates and certifications.

CREATE DATABASE waste_tracking
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_unicode_ci;

USE waste_tracking;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    role ENUM('generator','collector','processor','auditor','admin') NOT NULL,
    phone VARCHAR(40),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);