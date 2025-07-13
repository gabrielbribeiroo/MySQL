-- 🏛️ Museum Catalog - Art Collection Database
-- This database stores artworks, artists, exhibitions, types, and movement history.

CREATE DATABASE IF NOT EXISTS museum_catalog
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE museum_catalog;

-- Artists who created the artworks
CREATE TABLE IF NOT EXISTS artists (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  birth_year YEAR,
  death_year YEAR,
  nationality VARCHAR(50),
  biography TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Types or categories of artworks (e.g., Painting, Sculpture)
CREATE TABLE IF NOT EXISTS art_types (
  id INT AUTO_INCREMENT PRIMARY KEY,
  type_name VARCHAR(50) NOT NULL UNIQUE,
  description TEXT
);