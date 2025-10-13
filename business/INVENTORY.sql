-- Database: inventory_audit
-- Inventory auditing and valuation platform

CREATE DATABASE inventory_audit
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

USE inventory_audit;

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    sku VARCHAR(50) UNIQUE NOT NULL,
    category VARCHAR(100),
    unit_price DECIMAL(12,2) NOT NULL,
    quantity_expected INT DEFAULT 0,
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE warehouses (
    warehouse_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(200),
    manager VARCHAR(120),
    contact VARCHAR(50)
);

CREATE TABLE auditors (
    auditor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(120) UNIQUE,
    phone VARCHAR(30),
    role ENUM('internal', 'external') DEFAULT 'internal'
);

CREATE TABLE audits (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    warehouse_id INT NOT NULL,
    auditor_id INT NOT NULL,
    start_date DATE,
    end_date DATE,
    status ENUM('scheduled', 'in_progress', 'completed') DEFAULT 'scheduled',
    total_value DECIMAL(14,2),
    notes TEXT,
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id),
    FOREIGN KEY (auditor_id) REFERENCES auditors(auditor_id)
);