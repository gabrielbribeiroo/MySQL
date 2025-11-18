-- Database: telemedicine
-- Telemedicine system for virtual consultations, prescriptions, medical records, communication, and payments.
CREATE DATABASE telemedicine
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE telemedicine;

CREATE TABLE specialties (
    specialty_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE document_types (
    document_type_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE payment_methods (
    method_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('patient','doctor','admin') NOT NULL,
    phone VARCHAR(40),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    birth_date DATE,
    gender ENUM('male','female','other'),
    address TEXT,
    emergency_contact VARCHAR(150),
    FOREIGN KEY (patient_id) REFERENCES users(user_id)
);

CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    specialty_id INT NOT NULL,
    license_number VARCHAR(80) NOT NULL UNIQUE,
    years_experience INT DEFAULT 0,
    bio TEXT,
    FOREIGN KEY (doctor_id) REFERENCES users(user_id),
    FOREIGN KEY (specialty_id) REFERENCES specialties(specialty_id)
);

CREATE TABLE doctor_availability (
    availability_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    weekday ENUM('mon','tue','wed','thu','fri','sat','sun'),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);