-- 📝 Petition Platform - Online Petitions with Signature Goals and Comments
-- This schema supports online petitions authored by users with signature targets and community engagement via comments.

CREATE DATABASE IF NOT EXISTS petition_platform
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE petition_platform;

-- Users who can create or sign petitions
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);