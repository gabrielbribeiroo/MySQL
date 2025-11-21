-- 🧪 Database: innovation_lab
-- Platform for innovation labs with projects, prototypes, teams, and funding sources

CREATE DATABASE innovation_lab
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE innovation_lab;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    role ENUM('researcher','manager','director','partner','guest') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE teams (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE team_members (
    team_id INT NOT NULL,
    user_id INT NOT NULL,
    role_in_team VARCHAR(100),
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(team_id, user_id),
    FOREIGN KEY (team_id) REFERENCES teams(team_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE funding_sources (
    funding_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    type ENUM('grant','internal','corporate','government','angel','other') DEFAULT 'other',
    amount DECIMAL(12,2),
    description TEXT
);

CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    team_id INT,
    funding_id INT,
    start_date DATE,
    end_date DATE,
    status ENUM('planning','in_progress','prototype','testing','completed','canceled') DEFAULT 'planning',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (team_id) REFERENCES teams(team_id),
    FOREIGN KEY (funding_id) REFERENCES funding_sources(funding_id)
);

CREATE TABLE prototypes (
    prototype_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    version VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

CREATE TABLE prototype_tests (
    test_id INT AUTO_INCREMENT PRIMARY KEY,
    prototype_id INT NOT NULL,
    tested_by INT NOT NULL,
    result ENUM('success','partial','failure') NOT NULL,
    observations TEXT,
    tested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (prototype_id) REFERENCES prototypes(prototype_id),
    FOREIGN KEY (tested_by) REFERENCES users(user_id)
);

CREATE TABLE lab_meetings (
    meeting_id INT AUTO_INCREMENT PRIMARY KEY,
    team_id INT NOT NULL,
    topic VARCHAR(200) NOT NULL,
    meeting_date DATETIME NOT NULL,
    location VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

CREATE TABLE meeting_minutes (
    minute_id INT AUTO_INCREMENT PRIMARY KEY,
    meeting_id INT NOT NULL,
    author_id INT NOT NULL,
    notes TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (meeting_id) REFERENCES lab_meetings(meeting_id),
    FOREIGN KEY (author_id) REFERENCES users(user_id)
);