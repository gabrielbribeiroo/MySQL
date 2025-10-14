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

CREATE TABLE audit_items (
    audit_item_id INT AUTO_INCREMENT PRIMARY KEY,
    audit_id INT NOT NULL,
    product_id INT NOT NULL,
    counted_quantity INT NOT NULL,
    expected_quantity INT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    discrepancy INT GENERATED ALWAYS AS (counted_quantity - expected_quantity) STORED,
    discrepancy_value DECIMAL(14,2) GENERATED ALWAYS AS (discrepancy * unit_price) STORED,
    FOREIGN KEY (audit_id) REFERENCES audits(audit_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE discrepancy_reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    audit_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_items INT,
    total_discrepancy_value DECIMAL(14,2),
    approved_by VARCHAR(120),
    notes TEXT,
    FOREIGN KEY (audit_id) REFERENCES audits(audit_id)
);

CREATE TABLE audit_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    audit_id INT NOT NULL,
    action VARCHAR(150),
    action_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    performed_by VARCHAR(120),
    FOREIGN KEY (audit_id) REFERENCES audits(audit_id)
);