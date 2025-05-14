-- Create the database
CREATE DATABASE IF NOT EXISTS medical_clinic
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE medical_clinic;

-- Table for patients
CREATE TABLE IF NOT EXISTS patients (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  birth_date DATE,
  gender ENUM('Male', 'Female', 'Other'),
  phone VARCHAR(20),
  email VARCHAR(100),
  address TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;

-- Table for doctors
CREATE TABLE IF NOT EXISTS doctors (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  specialty_id INT,
  phone VARCHAR(20),
  email VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (specialty_id) REFERENCES specialties(id) ON DELETE SET NULL
) DEFAULT CHARSET = utf8mb4;
