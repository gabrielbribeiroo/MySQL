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