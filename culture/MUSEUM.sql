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

-- Exhibitions where artworks are displayed
CREATE TABLE IF NOT EXISTS exhibitions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Linking artworks to exhibitions (many-to-many)
CREATE TABLE IF NOT EXISTS exhibition_artworks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  exhibition_id INT NOT NULL,
  artwork_id INT NOT NULL,
  FOREIGN KEY (exhibition_id) REFERENCES exhibitions(id) ON DELETE CASCADE,
  FOREIGN KEY (artwork_id) REFERENCES artworks(id) ON DELETE CASCADE
);