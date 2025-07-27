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

CREATE TABLE responsibles (
    responsible_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE project_responsibles (
    project_id INT,
    responsible_id INT,
    assigned_role VARCHAR(100),
    PRIMARY KEY (project_id, responsible_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    FOREIGN KEY (responsible_id) REFERENCES responsibles(responsible_id)
);

CREATE TABLE bids (
    bid_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT,
    company_name VARCHAR(100),
    bid_amount DECIMAL(15,2),
    bid_date DATE,
    status ENUM('submitted', 'approved', 'rejected') DEFAULT 'submitted',
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);