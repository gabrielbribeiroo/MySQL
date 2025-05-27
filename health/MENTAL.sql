-- Create the database and select it
CREATE DATABASE IF NOT EXISTS mental_health
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE mental_health;

-- Table to register therapists
CREATE TABLE therapists (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    specialization VARCHAR(100),
    license_number VARCHAR(50) UNIQUE,
    contact_email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table to register patients
CREATE TABLE patients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    birth_date DATE,
    gender ENUM('M', 'F', 'O'),
    contact_email VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table to define different types of therapies
CREATE TABLE therapies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,            -- e.g. CBT, psychoanalysis, etc.
    description TEXT
);

-- Table to track therapy goals for each patient
CREATE TABLE patient_goals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    description TEXT NOT NULL,
    is_achieved BOOLEAN DEFAULT FALSE,
    target_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id)
);

-- Table to register psychological sessions
CREATE TABLE sessions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    therapist_id INT NOT NULL,
    therapy_id INT,                        -- Optional: type of therapy used in the session
    session_date DATETIME NOT NULL,
    duration_minutes INT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id),
    FOREIGN KEY (therapist_id) REFERENCES therapists(id),
    FOREIGN KEY (therapy_id) REFERENCES therapies(id)
);

-- Table to log mood tracking over time
CREATE TABLE mood_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    log_date DATE NOT NULL,
    mood_level TINYINT NOT NULL CHECK (mood_level BETWEEN 1 AND 10), -- Scale from 1 (very bad) to 10 (excellent)
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id)
);