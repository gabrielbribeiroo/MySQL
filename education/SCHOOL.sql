-- 🏫 Language School - Language Learning Management System
-- This schema models a language school's operations, including courses, levels, classes, assessments, and student histories.

CREATE DATABASE IF NOT EXISTS language_school
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE language_school;

-- Languages taught at the school
CREATE TABLE IF NOT EXISTS languages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);