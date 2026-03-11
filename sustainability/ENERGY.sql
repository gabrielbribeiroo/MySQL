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

CREATE TABLE assets (
    asset_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    asset_type ENUM('turbine','panel_array','inverter','meter','battery','transformer','other') DEFAULT 'other',
    name VARCHAR(200) NOT NULL,
    manufacturer VARCHAR(150),
    model VARCHAR(150),
    serial_number VARCHAR(150) UNIQUE,
    installed_at DATE,
    status ENUM('active','maintenance','inactive','retired') DEFAULT 'active',
    capacity_kw DECIMAL(12,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

CREATE TABLE generation_readings (
    reading_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    asset_id INT,                                        -- optional: asset-level reading
    reading_datetime DATETIME NOT NULL,
    energy_kwh DECIMAL(14,4) NOT NULL,                   -- generated energy in kWh for the interval
    power_kw DECIMAL(14,4),                              -- average/instantaneous power in kW (optional)
    irradiance_w_m2 DECIMAL(14,4),                       -- solar (optional)
    wind_speed_m_s DECIMAL(14,4),                        -- wind (optional)
    temperature_c DECIMAL(14,4),                         -- optional
    data_source ENUM('scada','meter','manual','api') DEFAULT 'scada',
    quality_flag ENUM('valid','suspect','invalid') DEFAULT 'valid',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id),
    UNIQUE (project_id, asset_id, reading_datetime)
);

CREATE TABLE daily_generation (
    daily_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    day_date DATE NOT NULL,
    total_kwh DECIMAL(16,4) NOT NULL,
    peak_kw DECIMAL(16,4),
    availability_pct DECIMAL(6,3),                       -- e.g., 99.500
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    UNIQUE (project_id, day_date)
);

CREATE TABLE maintenance_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    asset_id INT,
    opened_by INT,
    priority ENUM('low','medium','high','critical') DEFAULT 'medium',
    status ENUM('open','in_progress','resolved','canceled') DEFAULT 'open',
    issue_title VARCHAR(200) NOT NULL,
    issue_description TEXT,
    opened_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at DATETIME,
    resolved_by INT,
    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id),
    FOREIGN KEY (opened_by) REFERENCES users(user_id),
    FOREIGN KEY (resolved_by) REFERENCES users(user_id)
);

CREATE TABLE maintenance_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    technician_id INT NOT NULL,
    action_taken TEXT NOT NULL,
    downtime_minutes INT DEFAULT 0,
    labor_cost DECIMAL(12,2) DEFAULT 0.00,
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES maintenance_requests(request_id),
    FOREIGN KEY (technician_id) REFERENCES users(user_id)
);

CREATE TABLE parts (
    part_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    sku VARCHAR(80) UNIQUE,
    unit_cost DECIMAL(12,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE maintenance_parts (
    log_id INT NOT NULL,
    part_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_cost DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (log_id, part_id),
    FOREIGN KEY (log_id) REFERENCES maintenance_logs(log_id),
    FOREIGN KEY (part_id) REFERENCES parts(part_id)
);

CREATE TABLE funding_sources (
    funding_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    type ENUM('equity','debt','grant','internal','government','other') DEFAULT 'other',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Project financial transactions (CAPEX/OPEX/Revenue)
CREATE TABLE financial_transactions (
    transaction_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    transaction_date DATE NOT NULL,
    type ENUM('capex','opex','revenue','tax','other') DEFAULT 'other',
    category VARCHAR(120),                               -- e.g., equipment, labor, energy_sale
    description VARCHAR(255),
    amount DECIMAL(14,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'BRL',
    related_round_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    FOREIGN KEY (related_round_id) REFERENCES investment_rounds(round_id)
);

-- Optional: investor allocations per round
CREATE TABLE round_investors (
    round_id INT NOT NULL,
    investor_user_id INT NOT NULL,                       -- users with role=investor
    amount DECIMAL(14,2) NOT NULL,
    PRIMARY KEY (round_id, investor_user_id),
    FOREIGN KEY (round_id) REFERENCES investment_rounds(round_id),
    FOREIGN KEY (investor_user_id) REFERENCES users(user_id)
);