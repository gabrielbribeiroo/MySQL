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

-- Artworks registered in the museum
CREATE TABLE IF NOT EXISTS artworks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  artist_id INT,
  type_id INT,
  year_created YEAR,
  description TEXT,
  dimensions VARCHAR(100), -- e.g., "60x90cm"
  location VARCHAR(100), -- current location or room
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (artist_id) REFERENCES artists(id),
  FOREIGN KEY (type_id) REFERENCES art_types(id)
);