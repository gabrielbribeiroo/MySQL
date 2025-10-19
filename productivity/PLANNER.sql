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