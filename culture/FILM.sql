-- Database: film_festival
-- Film festival management with submissions, screenings, juries, and awards

CREATE DATABASE film_festival
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE film_festival;

CREATE TABLE festivals (
    festival_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    edition_year YEAR NOT NULL,
    start_date DATE,
    end_date DATE,
    city VARCHAR(120),
    country VARCHAR(120) DEFAULT 'Brazil',
    status ENUM('upcoming','open_submissions','in_progress','completed') DEFAULT 'upcoming',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (name, edition_year)
);

CREATE TABLE venues (
    venue_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(120),
    capacity INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE screens (
    screen_id INT AUTO_INCREMENT PRIMARY KEY,
    venue_id INT NOT NULL,
    name VARCHAR(120) NOT NULL,           -- e.g., "Room 1", "Main Hall"
    seat_count INT,
    FOREIGN KEY (venue_id) REFERENCES venues(venue_id),
    UNIQUE (venue_id, name)
);