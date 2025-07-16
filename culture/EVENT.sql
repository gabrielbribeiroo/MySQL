-- 🎤 Event Management System
-- This schema supports the organization and management of events,
-- including venues, artists, schedules, tickets, and participants.

CREATE DATABASE IF NOT EXISTS event_management
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE event_management;

-- Table for event venues (locations)
CREATE TABLE IF NOT EXISTS venues (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  address TEXT,
  capacity INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for artists or performers
CREATE TABLE IF NOT EXISTS artists (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  genre VARCHAR(50),
  country VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
