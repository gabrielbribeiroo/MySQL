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

CREATE TABLE instruments (
    instrument_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    type VARCHAR(100),
    difficulty ENUM('beginner','intermediate','advanced') DEFAULT 'beginner'
);

CREATE TABLE teachers (
    teacher_id INT PRIMARY KEY,
    biography TEXT,
    years_experience INT DEFAULT 0,
    FOREIGN KEY (teacher_id) REFERENCES users(user_id)
);

-- Teacher specialization (many-to-many)
CREATE TABLE teacher_instruments (
    teacher_id INT NOT NULL,
    instrument_id INT NOT NULL,
    PRIMARY KEY(teacher_id, instrument_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),
    FOREIGN KEY (instrument_id) REFERENCES instruments(instrument_id)
);