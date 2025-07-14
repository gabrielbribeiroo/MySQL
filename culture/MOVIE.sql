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

-- Customers registered in the system
CREATE TABLE IF NOT EXISTS customers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE,
  phone VARCHAR(20),
  registration_date DATE DEFAULT (CURRENT_DATE)
);

-- Rental transactions with expected and return dates
CREATE TABLE IF NOT EXISTS rentals (
  id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  movie_id INT NOT NULL,
  rental_date DATE DEFAULT (CURRENT_DATE),
  due_date DATE NOT NULL,
  return_date DATE,
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (movie_id) REFERENCES movies(id)
);

-- Late fees associated with overdue rentals
CREATE TABLE IF NOT EXISTS late_fees (
  id INT AUTO_INCREMENT PRIMARY KEY,
  rental_id INT NOT NULL,
  amount DECIMAL(6,2) NOT NULL,
  paid BOOLEAN DEFAULT FALSE,
  charged_on DATE DEFAULT (CURRENT_DATE),
  FOREIGN KEY (rental_id) REFERENCES rentals(id) ON DELETE CASCADE
);