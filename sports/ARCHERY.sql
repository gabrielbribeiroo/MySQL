-- 🎯 Archery Club Management Database
-- This schema is designed to manage an archery training club with athlete registrations, sessions, performance logs, and equipment usage.

CREATE DATABASE IF NOT EXISTS archery_club
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

USE archery_club;

-- Athletes registered in the club
CREATE TABLE IF NOT EXISTS athletes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  birth_date DATE,
  gender ENUM('Male', 'Female', 'Other'),
  contact_email VARCHAR(100),
  registration_date DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
