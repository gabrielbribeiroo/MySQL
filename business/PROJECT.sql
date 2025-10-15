-- Database: project_portfolio
-- Corporate project portfolio manager

CREATE DATABASE project_portfolio
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE project_portfolio;

CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    manager VARCHAR(120),
    email VARCHAR(150),
    phone VARCHAR(40)
);

CREATE TABLE teams (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    department_id INT,
    leader VARCHAR(120),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(150) UNIQUE,
    role VARCHAR(100),
    team_id INT,
    FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    status ENUM('planned', 'in_progress', 'completed', 'on_hold', 'cancelled') DEFAULT 'planned',
    budget DECIMAL(15,2),
    department_id INT,
    project_manager VARCHAR(120),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);