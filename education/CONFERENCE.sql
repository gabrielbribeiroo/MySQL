-- 🎓 Conference System - Academic Conference Management
-- This database models the management of academic conferences with submissions, reviews, and presentations.

CREATE DATABASE IF NOT EXISTS conference_system
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE conference_system;

-- Conferences with title, location and date
CREATE TABLE IF NOT EXISTS conferences (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  location VARCHAR(150),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Users of the system: authors, reviewers, and organizers
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  role ENUM('Author', 'Reviewer', 'Organizer') NOT NULL,
  institution VARCHAR(150),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Papers submitted to conferences
CREATE TABLE IF NOT EXISTS papers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  abstract TEXT NOT NULL,
  submission_date DATE NOT NULL,
  conference_id INT,
  author_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (conference_id) REFERENCES conferences(id),
  FOREIGN KEY (author_id) REFERENCES users(id)
);

-- Reviews by assigned reviewers
CREATE TABLE IF NOT EXISTS reviews (
  id INT AUTO_INCREMENT PRIMARY KEY,
  paper_id INT NOT NULL,
  reviewer_id INT NOT NULL,
  score INT CHECK (score BETWEEN 1 AND 10),
  comments TEXT,
  review_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (paper_id) REFERENCES papers(id),
  FOREIGN KEY (reviewer_id) REFERENCES users(id)
);

-- Accepted papers scheduled for presentations
CREATE TABLE IF NOT EXISTS presentations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  paper_id INT NOT NULL,
  scheduled_date DATETIME NOT NULL,
  room VARCHAR(50),
  FOREIGN KEY (paper_id) REFERENCES papers(id)
);