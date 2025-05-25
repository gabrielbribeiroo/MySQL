CREATE DATABASE IF NOT EXISTS vaccination_center
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE vaccination_center;

-- Table to store vaccine manufacturers
CREATE TABLE manufacturers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table to store available vaccines
CREATE TABLE vaccines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    manufacturer_id INT,
    doses_required INT DEFAULT 1,           -- Number of doses needed for full immunization
    effective_days INT,                     -- Days after which the vaccine becomes effective
    approved BOOLEAN DEFAULT TRUE,          -- Indicates if the vaccine is approved for use
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id)
);

-- Table to define age groups for campaigns
CREATE TABLE age_groups (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(100) NOT NULL,      -- e.g. "Children 5-11", "Adults 60+"
    min_age INT,
    max_age INT
);

-- Table to register citizens
CREATE TABLE citizens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    birth_date DATE NOT NULL,
    gender ENUM('M', 'F', 'O'),
    cpf CHAR(11) UNIQUE,                    -- National ID (example: Brazil)
    address TEXT,
    neighborhood VARCHAR(100),
    city VARCHAR(100),
    state CHAR(2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);