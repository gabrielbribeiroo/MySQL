-- Database: exam_system
-- Online exam platform with question banks, automatic grading, and student performance analytics

CREATE DATABASE exam_system
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;
    
USE exam_system;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('student', 'teacher', 'admin') DEFAULT 'student',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    active BOOLEAN DEFAULT TRUE
);

CREATE TABLE subjects (
    subject_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE questions (
    question_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id INT NOT NULL,
    question_text TEXT NOT NULL,
    question_type ENUM('multiple_choice', 'true_false', 'short_answer', 'essay') DEFAULT 'multiple_choice',
    difficulty ENUM('easy', 'medium', 'hard') DEFAULT 'medium',
    points DECIMAL(5,2) DEFAULT 1.00,
    created_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

CREATE TABLE options (
    option_id INT AUTO_INCREMENT PRIMARY KEY,
    question_id INT NOT NULL,
    option_text TEXT NOT NULL,
    is_correct BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (question_id) REFERENCES questions(question_id)
);

CREATE TABLE exams (
    exam_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    total_points DECIMAL(6,2),
    duration_minutes INT NOT NULL,
    start_time DATETIME,
    end_time DATETIME,
    created_by INT,
    status ENUM('draft', 'published', 'closed') DEFAULT 'draft',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

CREATE TABLE exam_questions (
    exam_question_id INT AUTO_INCREMENT PRIMARY KEY,
    exam_id INT NOT NULL,
    question_id INT NOT NULL,
    order_number INT,
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id),
    FOREIGN KEY (question_id) REFERENCES questions(question_id)
);

CREATE TABLE exam_attempts (
    attempt_id INT AUTO_INCREMENT PRIMARY KEY,
    exam_id INT NOT NULL,
    student_id INT NOT NULL,
    start_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    end_time DATETIME,
    total_score DECIMAL(6,2) DEFAULT 0,
    status ENUM('in_progress', 'submitted', 'graded', 'cancelled') DEFAULT 'in_progress',
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id),
    FOREIGN KEY (student_id) REFERENCES users(user_id)
);