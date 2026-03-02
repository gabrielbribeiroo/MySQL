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

CREATE TABLE reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    region_id INT,
    site_id INT,
    title VARCHAR(250) NOT NULL,
    report_type ENUM('monthly','quarterly','annual','incident','custom') DEFAULT 'monthly',
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    generated_by INT,
    summary TEXT,
    file_url VARCHAR(300),                       -- exported PDF/CSV report
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (region_id) REFERENCES regions(region_id),
    FOREIGN KEY (site_id) REFERENCES monitoring_sites(site_id),
    FOREIGN KEY (generated_by) REFERENCES users(user_id)
);

CREATE TABLE report_metrics (
    metric_id INT AUTO_INCREMENT PRIMARY KEY,
    report_id INT NOT NULL,
    parameter_id INT NOT NULL,
    metric_type ENUM('avg','min','max','median','stddev','count','exceedances') NOT NULL,
    metric_value DECIMAL(18,6) NOT NULL,
    FOREIGN KEY (report_id) REFERENCES reports(report_id),
    FOREIGN KEY (parameter_id) REFERENCES parameters(parameter_id)
);

CREATE TABLE attachments (
    attachment_id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT,
    report_id INT,
    uploaded_by INT,
    file_name VARCHAR(200),
    file_type VARCHAR(80),
    file_url VARCHAR(300),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES sampling_events(event_id),
    FOREIGN KEY (report_id) REFERENCES reports(report_id),
    FOREIGN KEY (uploaded_by) REFERENCES users(user_id)
);

CREATE TABLE audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    actor_user_id INT,
    action VARCHAR(200) NOT NULL,
    entity VARCHAR(120),
    entity_id INT,
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (actor_user_id) REFERENCES users(user_id)
);

DELIMITER $$

CREATE TRIGGER trg_measurement_threshold_alert
AFTER INSERT ON measurements
FOR EACH ROW
BEGIN
    DECLARE v_site_id INT;
    DECLARE v_region_id INT;
    DECLARE v_min DECIMAL(12,4);
    DECLARE v_max DECIMAL(12,4);
    DECLARE v_severity ENUM('low','medium','high','critical');

    -- Site and region for this measurement
    SELECT se.site_id INTO v_site_id
    FROM sampling_events se
    WHERE se.event_id = NEW.event_id;

    SELECT ms.region_id INTO v_region_id
    FROM monitoring_sites ms
    WHERE ms.site_id = v_site_id;

    -- Prefer region-specific threshold; fallback to global (region_id IS NULL)
    SELECT pt.min_value, pt.max_value
    INTO v_min, v_max
    FROM parameter_thresholds pt
    WHERE pt.parameter_id = NEW.parameter_id
      AND (pt.region_id = v_region_id OR pt.region_id IS NULL)
    ORDER BY (pt.region_id = v_region_id) DESC
    LIMIT 1;

    -- If threshold exists and measurement violates it, create alert
    IF (v_min IS NOT NULL AND NEW.value < v_min) OR (v_max IS NOT NULL AND NEW.value > v_max) THEN

        -- Simple severity rule (you can adjust later)
        SET v_severity = 'high';
        IF (v_min IS NOT NULL AND NEW.value < v_min) OR (v_max IS NOT NULL AND NEW.value > v_max) THEN
            SET v_severity = 'high';
        END IF;

        INSERT INTO alerts (site_id, parameter_id, measurement_id, severity, message)
        VALUES (
            v_site_id,
            NEW.parameter_id,
            NEW.measurement_id,
            v_severity,
            CONCAT('Threshold exceeded for parameter_id=', NEW.parameter_id, ' value=', NEW.value)
        );
    END IF;
END$$

DELIMITER ;