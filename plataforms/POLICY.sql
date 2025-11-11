-- Database: policy_tracker
-- Tracker for monitoring implementation and results of public policies across regions

CREATE DATABASE policy_tracker
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE policy_tracker;

CREATE TABLE regions (
    region_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    type ENUM('Municipality', 'State', 'Region', 'Country') DEFAULT 'Municipality',
    parent_region_id INT,
    FOREIGN KEY (parent_region_id) REFERENCES regions(region_id)
);

CREATE TABLE policies (
    policy_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    category ENUM('Education', 'Health', 'Infrastructure', 'Environment', 'Security', 'Social', 'Economic') NOT NULL,
    start_date DATE,
    end_date DATE,
    responsible_agency VARCHAR(150),
    budget DECIMAL(15,2),
    status ENUM('Planning', 'Implementation', 'Completed', 'Paused', 'Cancelled') DEFAULT 'Planning'
);

CREATE TABLE policy_region (
    id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT NOT NULL,
    region_id INT NOT NULL,
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id),
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

CREATE TABLE stakeholders (
    stakeholder_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    type ENUM('Government', 'NGO', 'Private Sector', 'Community', 'International Organization') NOT NULL,
    contact_email VARCHAR(150),
    phone VARCHAR(50)
);

CREATE TABLE policy_stakeholder (
    id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT NOT NULL,
    stakeholder_id INT NOT NULL,
    role ENUM('Coordinator', 'Partner', 'Funder', 'Evaluator', 'Participant') DEFAULT 'Partner',
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id),
    FOREIGN KEY (stakeholder_id) REFERENCES stakeholders(stakeholder_id)
);

CREATE TABLE indicators (
    indicator_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    unit VARCHAR(50),
    baseline_value DECIMAL(15,2),
    target_value DECIMAL(15,2),
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);

CREATE TABLE indicator_results (
    result_id INT AUTO_INCREMENT PRIMARY KEY,
    indicator_id INT NOT NULL,
    region_id INT,
    measurement_date DATE NOT NULL,
    measured_value DECIMAL(15,2),
    FOREIGN KEY (indicator_id) REFERENCES indicators(indicator_id),
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

CREATE TABLE reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT NOT NULL,
    report_title VARCHAR(200) NOT NULL,
    summary TEXT,
    progress_percentage DECIMAL(5,2),
    report_date DATE NOT NULL,
    prepared_by VARCHAR(150),
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);

CREATE TABLE documents (
    document_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_url VARCHAR(500),
    uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    uploaded_by VARCHAR(150),
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);