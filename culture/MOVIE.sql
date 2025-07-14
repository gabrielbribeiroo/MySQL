-- 📽️ Movie Rentals - Video Rental Store Database
-- This schema models a classic movie rental system, tracking customers, movies, rentals, and late fees.

CREATE DATABASE IF NOT EXISTS movie_rentals
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE movie_rentals;

-- Genres like Action, Comedy, Drama, etc.
CREATE TABLE IF NOT EXISTS genres (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE
);

-- Movies available for rental
CREATE TABLE IF NOT EXISTS movies (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  release_year YEAR,
  genre_id INT,
  rating VARCHAR(10),
  available_copies INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (genre_id) REFERENCES genres(id)
);