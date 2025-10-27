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

CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    duration_semesters INT DEFAULT 8,
    coordinator_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (coordinator_id) REFERENCES users(user_id)
);

CREATE TABLE subjects (
    subject_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    semester INT NOT NULL,
    teacher_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (teacher_id) REFERENCES users(user_id)
);

CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    status ENUM('enrolled', 'completed', 'dropped') DEFAULT 'enrolled',
    UNIQUE(student_id, subject_id),
    FOREIGN KEY (student_id) REFERENCES users(user_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    class_date DATE NOT NULL,
    status ENUM('present', 'absent', 'late', 'justified') DEFAULT 'present',
    notes VARCHAR(255),
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
);

CREATE TABLE grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    evaluation_name VARCHAR(100),
    score DECIMAL(5,2) CHECK (score >= 0 AND score <= 100),
    weight DECIMAL(3,2) DEFAULT 1.0,
    recorded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
);

CREATE TABLE grade_summary (
    summary_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    average_score DECIMAL(5,2),
    final_status ENUM('approved', 'failed', 'incomplete') DEFAULT 'incomplete',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
);

CREATE TABLE messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    subject VARCHAR(150),
    body TEXT,
    sent_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (sender_id) REFERENCES users(user_id),
    FOREIGN KEY (receiver_id) REFERENCES users(user_id)
);

CREATE TABLE announcements (
    announcement_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id INT,
    title VARCHAR(150) NOT NULL,
    message TEXT NOT NULL,
    posted_by INT,
    posted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    visible_until DATE,
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id),
    FOREIGN KEY (posted_by) REFERENCES users(user_id)
);

CREATE TABLE performance_reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    total_subjects INT DEFAULT 0,
    average_score DECIMAL(5,2) DEFAULT 0,
    attendance_rate DECIMAL(5,2) DEFAULT 0,
    performance_level ENUM('low', 'medium', 'high') GENERATED ALWAYS AS (
        CASE
            WHEN average_score < 50 THEN 'low'
            WHEN average_score BETWEEN 50 AND 80 THEN 'medium'
            ELSE 'high'
        END
    ) STORED,
    FOREIGN KEY (student_id) REFERENCES users(user_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);