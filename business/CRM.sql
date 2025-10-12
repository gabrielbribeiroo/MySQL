-- Database: crm_system
-- Customer Relationship Management (CRM)
CREATE DATABASE crm_system
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

USE crm_system;

CREATE TABLE clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(120) UNIQUE,
    phone VARCHAR(20),
    company VARCHAR(120),
    industry VARCHAR(100),
    country VARCHAR(100),
    registration_date DATE DEFAULT (CURRENT_DATE),
    status ENUM('active', 'inactive', 'prospect') DEFAULT 'prospect'
);

CREATE TABLE leads (
    lead_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(120),
    phone VARCHAR(20),
    source ENUM('website', 'social_media', 'referral', 'event', 'cold_call', 'other') DEFAULT 'other',
    status ENUM('new', 'contacted', 'qualified', 'lost', 'converted') DEFAULT 'new',
    notes TEXT,
    creation_date DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE lead_conversions (
    conversion_id INT AUTO_INCREMENT PRIMARY KEY,
    lead_id INT NOT NULL,
    client_id INT NOT NULL,
    conversion_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (lead_id) REFERENCES leads(lead_id),
    FOREIGN KEY (client_id) REFERENCES clients(client_id)
);

CREATE TABLE communications (
    communication_id INT AUTO_INCREMENT PRIMARY KEY,
    related_type ENUM('client', 'lead') NOT NULL,
    related_id INT NOT NULL,
    date DATETIME DEFAULT CURRENT_TIMESTAMP,
    channel ENUM('email', 'phone', 'meeting', 'chat', 'social_media') DEFAULT 'email',
    subject VARCHAR(150),
    content TEXT,
    follow_up_needed BOOLEAN DEFAULT FALSE
);

CREATE TABLE sales_pipelines (
    pipeline_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE stages (
    stage_id INT AUTO_INCREMENT PRIMARY KEY,
    pipeline_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    position INT NOT NULL,
    probability DECIMAL(5,2) DEFAULT 0.0,
    FOREIGN KEY (pipeline_id) REFERENCES sales_pipelines(pipeline_id)
);