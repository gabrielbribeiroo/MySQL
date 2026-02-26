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

CREATE TABLE sensors (
    sensor_id INT AUTO_INCREMENT PRIMARY KEY,
    site_id INT NOT NULL,
    model VARCHAR(120),
    serial_number VARCHAR(120) UNIQUE,
    sensor_type ENUM('fixed','portable','lab') DEFAULT 'fixed',
    installed_at DATETIME,
    status ENUM('active','maintenance','inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (site_id) REFERENCES monitoring_sites(site_id)
);

CREATE TABLE sensor_calibrations (
    calibration_id INT AUTO_INCREMENT PRIMARY KEY,
    sensor_id INT NOT NULL,
    calibrated_by INT,                           -- user_id
    calibration_date DATETIME NOT NULL,
    notes TEXT,
    next_due_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sensor_id) REFERENCES sensors(sensor_id),
    FOREIGN KEY (calibrated_by) REFERENCES users(user_id)
);

CREATE TABLE sampling_events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    site_id INT NOT NULL,
    collected_by INT,                            -- user_id
    event_type ENUM('manual','automatic','lab') DEFAULT 'manual',
    collected_at DATETIME NOT NULL,
    weather_conditions VARCHAR(200),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (site_id) REFERENCES monitoring_sites(site_id),
    FOREIGN KEY (collected_by) REFERENCES users(user_id)
);

CREATE TABLE measurements (
    measurement_id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    parameter_id INT NOT NULL,
    sensor_id INT,                               -- optional (for automated/IoT)
    value DECIMAL(12,4) NOT NULL,
    quality_flag ENUM('valid','suspect','invalid') DEFAULT 'valid',
    recorded_at DATETIME NOT NULL,
    FOREIGN KEY (event_id) REFERENCES sampling_events(event_id),
    FOREIGN KEY (parameter_id) REFERENCES parameters(parameter_id),
    FOREIGN KEY (sensor_id) REFERENCES sensors(sensor_id),
    UNIQUE (event_id, parameter_id, recorded_at)
);

CREATE TABLE alerts (
    alert_id INT AUTO_INCREMENT PRIMARY KEY,
    site_id INT NOT NULL,
    parameter_id INT NOT NULL,
    measurement_id INT NOT NULL,
    severity ENUM('low','medium','high','critical') DEFAULT 'medium',
    message VARCHAR(255),
    status ENUM('open','investigating','resolved','dismissed') DEFAULT 'open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at DATETIME,
    resolved_by INT,
    FOREIGN KEY (site_id) REFERENCES monitoring_sites(site_id),
    FOREIGN KEY (parameter_id) REFERENCES parameters(parameter_id),
    FOREIGN KEY (measurement_id) REFERENCES measurements(measurement_id),
    FOREIGN KEY (resolved_by) REFERENCES users(user_id)
);