-- Database: water_quality_monitor
-- System to monitor water quality parameters across regions and generate environmental reports.

CREATE DATABASE water_quality_monitor
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

USE water_quality_monitor;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    role ENUM('field_agent','analyst','admin') NOT NULL,
    phone VARCHAR(40),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE regions (
    region_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    region_type ENUM('country','state','city','district','watershed','other') DEFAULT 'other',
    parent_region_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_region_id) REFERENCES regions(region_id)
);

CREATE TABLE monitoring_sites (
    site_id INT AUTO_INCREMENT PRIMARY KEY,
    region_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    site_type ENUM('river','lake','reservoir','coastal','groundwater','treatment_plant','other') DEFAULT 'other',
    latitude DECIMAL(10,7) NOT NULL,
    longitude DECIMAL(10,7) NOT NULL,
    address VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

CREATE TABLE parameters (
    parameter_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,          -- e.g., pH, Turbidity, Dissolved Oxygen
    unit VARCHAR(50) NOT NULL,                  -- e.g., NTU, mg/L, °C
    category ENUM('physical','chemical','biological','microbiological','other') DEFAULT 'other',
    description TEXT
);

CREATE TABLE parameters (
    parameter_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,          -- e.g., pH, Turbidity, Dissolved Oxygen
    unit VARCHAR(50) NOT NULL,                  -- e.g., NTU, mg/L, °C
    category ENUM('physical','chemical','biological','microbiological','other') DEFAULT 'other',
    description TEXT
);

-- Regulatory thresholds by region (optional)
CREATE TABLE parameter_thresholds (
    threshold_id INT AUTO_INCREMENT PRIMARY KEY,
    parameter_id INT NOT NULL,
    region_id INT,                               -- NULL = global
    min_value DECIMAL(12,4),
    max_value DECIMAL(12,4),
    standard_name VARCHAR(150),                  -- e.g., "Local Regulation 2026"
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parameter_id) REFERENCES parameters(parameter_id),
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);