-- Database: student_portal
-- Comprehensive student information system with profiles, attendance, grades, and communication

CREATE DATABASE student_portal
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE student_portal;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('student', 'teacher', 'admin') DEFAULT 'student',
    phone VARCHAR(20),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    active BOOLEAN DEFAULT TRUE
);