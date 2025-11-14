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

CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other'),
    phone VARCHAR(50),
    email VARCHAR(150),
    address VARCHAR(255),
    emergency_contact VARCHAR(150),
    registration_date DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE dental_records (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    dentist_id INT NOT NULL,
    visit_date DATE NOT NULL,
    notes TEXT,
    diagnosis TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (dentist_id) REFERENCES dentists(dentist_id)
);

CREATE TABLE procedures (
    procedure_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    cost DECIMAL(10,2),
    duration_minutes INT
);

CREATE TABLE record_procedures (
    id INT AUTO_INCREMENT PRIMARY KEY,
    record_id INT NOT NULL,
    procedure_id INT NOT NULL,
    quantity INT DEFAULT 1,
    total_cost DECIMAL(10,2),
    FOREIGN KEY (record_id) REFERENCES dental_records(record_id),
    FOREIGN KEY (procedure_id) REFERENCES procedures(procedure_id)
);

CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    dentist_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled', 'No-show') DEFAULT 'Scheduled',
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (dentist_id) REFERENCES dentists(dentist_id)
);