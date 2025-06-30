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

-- Coaches who conduct training sessions
CREATE TABLE IF NOT EXISTS coaches (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  specialty VARCHAR(100),
  phone VARCHAR(20),
  email VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Archery sessions with date, time, and responsible coach
CREATE TABLE IF NOT EXISTS training_sessions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  session_date DATE NOT NULL,
  session_time TIME,
  location VARCHAR(100),
  coach_id INT,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (coach_id) REFERENCES coaches(id)
);

-- Association of athletes to training sessions (attendance)
CREATE TABLE IF NOT EXISTS session_attendance (
  id INT AUTO_INCREMENT PRIMARY KEY,
  session_id INT,
  athlete_id INT,
  attended BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (session_id) REFERENCES training_sessions(id),
  FOREIGN KEY (athlete_id) REFERENCES athletes(id)
);

-- Equipment available for training use
CREATE TABLE IF NOT EXISTS equipment (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  type VARCHAR(50),
  serial_number VARCHAR(50) UNIQUE,
  condition ENUM('New', 'Good', 'Used', 'Needs Repair') DEFAULT 'Good',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Log of equipment usage during training
CREATE TABLE IF NOT EXISTS equipment_usage (
  id INT AUTO_INCREMENT PRIMARY KEY,
  session_id INT,
  athlete_id INT,
  equipment_id INT,
  usage_notes TEXT,
  FOREIGN KEY (session_id) REFERENCES training_sessions(id),
  FOREIGN KEY (athlete_id) REFERENCES athletes(id),
  FOREIGN KEY (equipment_id) REFERENCES equipment(id)
);

-- Performance scores for each athlete in a session
CREATE TABLE IF NOT EXISTS performance_log (
  id INT AUTO_INCREMENT PRIMARY KEY,
  athlete_id INT,
  session_id INT,
  score INT NOT NULL,
  remarks TEXT,
  FOREIGN KEY (athlete_id) REFERENCES athletes(id),
  FOREIGN KEY (session_id) REFERENCES training_sessions(id)
);