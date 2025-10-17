-- Database: appointment_booking
-- Appointment scheduling system for consultants, salons, and professionals

CREATE DATABASE appointment_booking
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE appointment_booking;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(40),
    password_hash VARCHAR(255),
    user_type ENUM('client', 'professional', 'admin') DEFAULT 'client',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);