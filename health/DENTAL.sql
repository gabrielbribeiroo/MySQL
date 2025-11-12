-- Database: dental_clinic
-- Dental clinic management system with patient dental records, procedures, and treatment plans.

CREATE DATABASE dental_clinic
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE dental_clinic;

CREATE TABLE dentists (
    dentist_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    specialty ENUM('General Dentistry', 'Orthodontics', 'Endodontics', 'Periodontics', 'Prosthodontics', 'Pediatric Dentistry', 'Oral Surgery') NOT NULL,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    phone VARCHAR(50),
    email VARCHAR(150),
    hire_date DATE
);