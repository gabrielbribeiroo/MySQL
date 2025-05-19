-- Hospital Management System

-- Table for departments
CREATE TABLE IF NOT EXISTS department (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;


-- Table for hospital staff (doctors, nurses, admin)
CREATE TABLE IF NOT EXISTS staff (
  id INT NOT NULL AUTO_INCREMENT,
  full_name VARCHAR(100) NOT NULL,
  role ENUM('Doctor', 'Nurse', 'Technician', 'Admin') NOT NULL,
  department_id INT,
  hire_date DATE NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(100),
  PRIMARY KEY (id),
  FOREIGN KEY (department_id) REFERENCES department(id)
) DEFAULT CHARSET = utf8mb4;

-- Table for patients
CREATE TABLE IF NOT EXISTS patient (
  id INT NOT NULL AUTO_INCREMENT,
  full_name VARCHAR(100) NOT NULL,
  birth_date DATE NOT NULL,
  gender ENUM('Male', 'Female', 'Other') NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(100),
  address TEXT,
  emergency_contact VARCHAR(100),
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;

-- Table for rooms
CREATE TABLE IF NOT EXISTS room (
  id INT NOT NULL AUTO_INCREMENT,
  room_number VARCHAR(10) NOT NULL UNIQUE,
  room_type ENUM('General', 'Private', 'ICU') NOT NULL,
  is_occupied BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;

-- Table for admissions
CREATE TABLE IF NOT EXISTS admission (
  id INT NOT NULL AUTO_INCREMENT,
  patient_id INT NOT NULL,
  room_id INT NOT NULL,
  staff_id INT, -- admitting doctor
  admission_date DATETIME NOT NULL,
  discharge_date DATETIME,
  diagnosis TEXT,
  PRIMARY KEY (id),
  FOREIGN KEY (patient_id) REFERENCES patient(id),
  FOREIGN KEY (room_id) REFERENCES room(id),
  FOREIGN KEY (staff_id) REFERENCES staff(id)
) DEFAULT CHARSET = utf8mb4;

-- Table for medical procedures
CREATE TABLE IF NOT EXISTS procedure (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  cost DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4;

-- Table for patient procedures
CREATE TABLE IF NOT EXISTS patient_procedure (
  id INT NOT NULL AUTO_INCREMENT,
  admission_id INT NOT NULL,
  procedure_id INT NOT NULL,
  performed_by INT, -- staff id
  performed_on DATETIME NOT NULL,
  notes TEXT,
  PRIMARY KEY (id),
  FOREIGN KEY (admission_id) REFERENCES admission(id),
  FOREIGN KEY (procedure_id) REFERENCES procedure(id),
  FOREIGN KEY (performed_by) REFERENCES staff(id)
) DEFAULT CHARSET = utf8mb4;