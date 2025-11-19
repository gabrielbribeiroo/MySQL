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

CREATE TABLE consultations (
    consultation_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    scheduled_at DATETIME NOT NULL,
    timezone VARCHAR(60) DEFAULT 'UTC',
    status ENUM('scheduled','in_progress','completed','canceled','no_show') DEFAULT 'scheduled',
    video_call_link VARCHAR(300),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE chat_messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    consultation_id INT NOT NULL,
    sender_id INT NOT NULL,
    message TEXT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id),
    FOREIGN KEY (sender_id) REFERENCES users(user_id)
);

CREATE TABLE attachments (
    attachment_id INT AUTO_INCREMENT PRIMARY KEY,
    consultation_id INT NOT NULL,
    uploaded_by INT NOT NULL,
    file_name VARCHAR(200),
    file_type VARCHAR(50),
    file_url VARCHAR(300),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id),
    FOREIGN KEY (uploaded_by) REFERENCES users(user_id)
);

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    consultation_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    method_id INT NOT NULL,
    status ENUM('pending','paid','failed','refunded') DEFAULT 'pending',
    paid_at DATETIME,
    FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id),
    FOREIGN KEY (method_id) REFERENCES payment_methods(method_id)
);

CREATE TABLE prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    consultation_id INT NOT NULL,
    doctor_id INT NOT NULL,
    patient_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE prescription_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    prescription_id INT NOT NULL,
    medication VARCHAR(150) NOT NULL,
    dosage VARCHAR(100),
    frequency VARCHAR(100),
    duration VARCHAR(100),
    notes TEXT,
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id)
);

CREATE TABLE medical_records (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    consultation_id INT,
    record_date DATE NOT NULL,
    diagnosis TEXT,
    treatment TEXT,
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id)
);