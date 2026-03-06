-- Database: renewable_energy
-- Renewable energy project management with generation data, maintenance logs, and investment tracking.

CREATE DATABASE renewable_energy
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

USE renewable_energy;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    role ENUM('operator','technician','analyst','investor','admin') NOT NULL,
    phone VARCHAR(40),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    energy_type ENUM('solar','wind','hydro','biomass','geothermal','other') DEFAULT 'solar',
    status ENUM('planning','construction','operational','paused','decommissioned') DEFAULT 'planning',
    country VARCHAR(80) DEFAULT 'Brazil',
    state VARCHAR(80),
    city VARCHAR(120),
    address VARCHAR(255),
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    start_date DATE,
    operation_start_date DATE,
    expected_lifetime_years INT DEFAULT 25,
    capacity_kw DECIMAL(12,2),                          -- installed capacity in kW
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);