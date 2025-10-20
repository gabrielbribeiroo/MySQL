-- Database: team_planner
-- Team scheduling system to allocate resources, shifts, and workload balancing

CREATE DATABASE team_planner
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE team_planner;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(40),
    role ENUM('employee', 'manager', 'admin') DEFAULT 'employee',
    active BOOLEAN DEFAULT TRUE,
    hired_at DATE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES users(user_id)
);

CREATE TABLE teams (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE team_members (
    team_id INT NOT NULL,
    user_id INT NOT NULL,
    position VARCHAR(150),
    assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (team_id, user_id),
    FOREIGN KEY (team_id) REFERENCES teams(team_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE shifts (
    shift_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    shift_type ENUM('morning', 'afternoon', 'night', 'custom') DEFAULT 'custom'
);

CREATE TABLE work_schedule (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    shift_id INT NOT NULL,
    work_date DATE NOT NULL,
    workload_hours DECIMAL(4,2),
    status ENUM('scheduled', 'completed', 'absent', 'cancelled') DEFAULT 'scheduled',
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (shift_id) REFERENCES shifts(shift_id)
);

CREATE TABLE workload_balancing (
    balance_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    week_start DATE NOT NULL,
    total_hours DECIMAL(5,2) DEFAULT 0,
    ideal_hours DECIMAL(5,2) DEFAULT 40,
    balance_status ENUM('underloaded', 'balanced', 'overloaded') GENERATED ALWAYS AS (
        CASE
            WHEN total_hours < ideal_hours * 0.9 THEN 'underloaded'
            WHEN total_hours > ideal_hours * 1.1 THEN 'overloaded'
            ELSE 'balanced'
        END
    ) STORED,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    team_id INT,
    week_start DATE,
    total_hours DECIMAL(6,2),
    avg_workload DECIMAL(5,2),
    absences INT DEFAULT 0,
    generated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (team_id) REFERENCES teams(team_id)
);