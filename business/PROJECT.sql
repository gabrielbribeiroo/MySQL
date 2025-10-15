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