-- Database: nutrition_center
-- Nutrition center management system with client dietary records, meal plans, and nutrition assessments.
CREATE DATABASE nutrition_center
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE nutrition_center;

CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL,
    birth_date DATE NOT NULL,
    gender ENUM('male', 'female', 'other') NOT NULL,
    email VARCHAR(120) UNIQUE,
    phone VARCHAR(30),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE nutritionists (
    nutritionist_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL,
    certification_number VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(120) UNIQUE,
    phone VARCHAR(30),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);