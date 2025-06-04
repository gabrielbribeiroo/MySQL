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

-- Petitions created by users
CREATE TABLE IF NOT EXISTS petitions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  description TEXT NOT NULL,
  goal INT NOT NULL,
  created_by INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE
);

-- Signatures from users supporting petitions
CREATE TABLE IF NOT EXISTS signatures (
  id INT AUTO_INCREMENT PRIMARY KEY,
  petition_id INT NOT NULL,
  user_id INT NOT NULL,
  signed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (petition_id) REFERENCES petitions(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Comments on petitions
CREATE TABLE IF NOT EXISTS comments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  petition_id INT NOT NULL,
  user_id INT NOT NULL,
  content TEXT NOT NULL,
  commented_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (petition_id) REFERENCES petitions(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);