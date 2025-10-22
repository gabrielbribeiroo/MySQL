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

CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    client_name VARCHAR(150),
    description TEXT,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(12,2),
    status ENUM('active', 'paused', 'completed', 'cancelled') DEFAULT 'active',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    project_id INT NOT NULL,
    role VARCHAR(100),
    assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

CREATE TABLE work_sessions (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    project_id INT,
    start_time DATETIME NOT NULL,
    end_time DATETIME,
    total_duration DECIMAL(6,2) GENERATED ALWAYS AS (
        TIMESTAMPDIFF(MINUTE, start_time, end_time) / 60
    ) STORED,
    session_type ENUM('work', 'meeting', 'focus', 'review') DEFAULT 'work',
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

CREATE TABLE breaks (
    break_id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME,
    duration_minutes INT GENERATED ALWAYS AS (
        TIMESTAMPDIFF(MINUTE, start_time, end_time)
    ) STORED,
    break_type ENUM('coffee', 'lunch', 'personal', 'technical') DEFAULT 'personal',
    FOREIGN KEY (session_id) REFERENCES work_sessions(session_id)
);

CREATE TABLE productivity_metrics (
    metric_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    work_date DATE NOT NULL,
    total_hours DECIMAL(5,2) DEFAULT 0,
    break_minutes INT DEFAULT 0,
    efficiency_score DECIMAL(5,2) GENERATED ALWAYS AS (
        CASE
            WHEN total_hours = 0 THEN 0
            ELSE ROUND((total_hours * 60) / (total_hours * 60 + break_minutes) * 100, 2)
        END
    ) STORED,
    status ENUM('low', 'medium', 'high') GENERATED ALWAYS AS (
        CASE
            WHEN efficiency_score < 70 THEN 'low'
            WHEN efficiency_score BETWEEN 70 AND 90 THEN 'medium'
            ELSE 'high'
        END
    ) STORED,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE billing_reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    project_id INT,
    period_start DATE,
    period_end DATE,
    total_hours DECIMAL(6,2),
    total_amount DECIMAL(10,2) GENERATED ALWAYS AS (total_hours * (SELECT hourly_rate FROM users WHERE users.user_id = billing_reports.user_id)) STORED,
    generated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);