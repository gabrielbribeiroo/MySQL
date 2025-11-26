-- Database: academic_network
-- Academic collaboration network with profiles, institutions, publications, and joint projects.

CREATE DATABASE academic_network
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE academic_network;

CREATE TABLE academics (
    academic_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    institution_id INT,
    bio TEXT,
    research_interests TEXT,
    website VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE institutions (
    institution_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    country VARCHAR(100),
    city VARCHAR(100),
    type ENUM('University', 'Institute', 'Research Center', 'Laboratory', 'Other') DEFAULT 'University',
    founded_year INT
);

ALTER TABLE academics
    ADD FOREIGN KEY (institution_id) REFERENCES institutions(institution_id);