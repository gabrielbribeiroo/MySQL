-- Create database
CREATE DATABASE IF NOT EXISTS urban_projects
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE urban_projects;

CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE,
    total_budget DECIMAL(15,2),
    status ENUM('planned', 'in_progress', 'completed', 'canceled') DEFAULT 'planned',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE phases (
    phase_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    phase_budget DECIMAL(15,2),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);