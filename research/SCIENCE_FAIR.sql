CREATE DATABASE IF NOT EXISTS science_fair
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE science_fair;

CREATE TABLE science_areas (
    area_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE judges (
    judge_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    institution VARCHAR(100)
);

CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    area_id INT,
    school_name VARCHAR(100),
    student_names TEXT,
    submission_date DATE,
    FOREIGN KEY (area_id) REFERENCES science_areas(area_id)
);

CREATE TABLE evaluations (
    evaluation_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT,
    judge_id INT,
    score DECIMAL(4,2) CHECK (score >= 0 AND score <= 10),
    feedback TEXT,
    evaluation_date DATE,
    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    FOREIGN KEY (judge_id) REFERENCES judges(judge_id)
);