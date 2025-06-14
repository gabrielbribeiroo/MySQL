-- 📅 Meeting Scheduler - Database for organizing meetings
-- Supports room management, agendas, participants, scheduling, and feedback

CREATE DATABASE IF NOT EXISTS meeting_scheduler
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE meeting_scheduler;

-- People who can schedule or participate in meetings
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  role ENUM('Organizer', 'Participant') DEFAULT 'Participant',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);