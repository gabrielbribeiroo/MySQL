CREATE DATABASE cultural_hub;
USE cultural_hub;

CREATE TABLE artists (
    artist_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_date DATE,
    nationality VARCHAR(100),
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE exhibitions (
    exhibition_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    location VARCHAR(150),
    start_date DATE,
    end_date DATE,
    theme TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);