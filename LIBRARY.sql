-- Create database for Library Management
CREATE DATABASE library
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

-- Table to store authors
CREATE TABLE IF NOT EXISTS authors (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  birth_date DATE,
  nationality VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;

-- Table to store books
CREATE TABLE IF NOT EXISTS books (
  id INT NOT NULL AUTO_INCREMENT,
  title VARCHAR(150) NOT NULL,
  author_id INT NOT NULL,
  publish_date DATE,
  genre VARCHAR(50),
  language VARCHAR(30) DEFAULT 'English',
  pages INT,
  stock INT DEFAULT 0, -- Number of available copies
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (author_id) REFERENCES authors(id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;
