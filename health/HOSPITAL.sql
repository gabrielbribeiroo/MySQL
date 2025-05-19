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