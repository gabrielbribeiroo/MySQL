-- DATABASE: music_school
-- Music school management with instruments, teachers, classes, performances, and student evaluations.

CREATE DATABASE music_school
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE music_school;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    role ENUM('student','teacher','admin') NOT NULL,
    phone VARCHAR(40),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    birth_date DATE,
    guardian_name VARCHAR(150),
    address TEXT,
    FOREIGN KEY (student_id) REFERENCES users(user_id)
);