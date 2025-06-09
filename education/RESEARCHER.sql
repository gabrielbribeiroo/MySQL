-- 🎓 Research Projects - Academic Research Management
-- This schema handles research project tracking, advisors, scholarship students, schedules, and deliverables.

CREATE DATABASE IF NOT EXISTS research_projects
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE research_projects;

-- Advisors (professors or researchers)
CREATE TABLE IF NOT EXISTS advisors (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE,
  department VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Scholarship students involved in projects
CREATE TABLE IF NOT EXISTS scholars (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE,
  enrollment_number VARCHAR(20) UNIQUE,
  course VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Research projects
CREATE TABLE IF NOT EXISTS projects (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  summary TEXT,
  advisor_id INT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE,
  funding_source VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (advisor_id) REFERENCES advisors(id)
);

-- Relationship between projects and scholars
CREATE TABLE IF NOT EXISTS project_scholars (
  project_id INT NOT NULL,
  scholar_id INT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE,
  role ENUM('Researcher', 'Assistant', 'Collaborator') DEFAULT 'Researcher',
  PRIMARY KEY (project_id, scholar_id),
  FOREIGN KEY (project_id) REFERENCES projects(id),
  FOREIGN KEY (scholar_id) REFERENCES scholars(id)
);