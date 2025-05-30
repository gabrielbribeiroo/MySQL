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

-- Table for club members
CREATE TABLE members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_date DATE,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    registration_date DATE DEFAULT CURRENT_DATE
);

-- Class schedule for each modality
CREATE TABLE classes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    modality_id INT,
    monitor_id INT,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
    start_time TIME,
    end_time TIME,
    location VARCHAR(100),
    FOREIGN KEY (modality_id) REFERENCES modalities(id),
    FOREIGN KEY (monitor_id) REFERENCES monitors(id)
);

-- Many-to-many relationship between members and classes
CREATE TABLE enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT,
    class_id INT,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (member_id) REFERENCES members(id),
    FOREIGN KEY (class_id) REFERENCES classes(id)
);