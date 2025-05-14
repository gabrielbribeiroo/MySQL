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
