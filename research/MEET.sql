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

-- Rooms or virtual spaces available for meetings
CREATE TABLE IF NOT EXISTS meeting_rooms (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  location VARCHAR(255),
  capacity INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Main meeting schedule including room, organizer, and time details
CREATE TABLE IF NOT EXISTS meetings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  agenda TEXT,
  room_id INT,
  organizer_id INT,
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (room_id) REFERENCES meeting_rooms(id),
  FOREIGN KEY (organizer_id) REFERENCES users(id)
);

-- Participants linked to meetings (many-to-many)
CREATE TABLE IF NOT EXISTS meeting_participants (
  id INT AUTO_INCREMENT PRIMARY KEY,
  meeting_id INT NOT NULL,
  user_id INT NOT NULL,
  status ENUM('Confirmed', 'Declined', 'Pending') DEFAULT 'Pending',
  FOREIGN KEY (meeting_id) REFERENCES meetings(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Optional feedback from participants after a meeting
CREATE TABLE IF NOT EXISTS meeting_feedback (
  id INT AUTO_INCREMENT PRIMARY KEY,
  meeting_id INT NOT NULL,
  user_id INT NOT NULL,
  rating INT CHECK (rating BETWEEN 1 AND 5),
  comments TEXT,
  submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (meeting_id) REFERENCES meetings(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);