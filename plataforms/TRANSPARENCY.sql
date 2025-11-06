-- Database: transparency_portal
-- Public transparency system showing government budgets, expenditures, and contracts

CREATE DATABASE transparency_portal
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE transparency_portal;

CREATE TABLE government_entities (
    entity_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    abbreviation VARCHAR(50),
    type ENUM('Federal', 'State', 'Municipal', 'Other') DEFAULT 'Other',
    manager_name VARCHAR(150),
    contact_email VARCHAR(150),
    website VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE budgets (
    budget_id INT AUTO_INCREMENT PRIMARY KEY,
    entity_id INT NOT NULL,
    fiscal_year YEAR NOT NULL,
    total_budget DECIMAL(15,2) NOT NULL,
    approved_date DATE,
    FOREIGN KEY (entity_id) REFERENCES government_entities(entity_id)
);

CREATE TABLE budget_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT
);

CREATE TABLE expenditures (
    expenditure_id INT AUTO_INCREMENT PRIMARY KEY,
    entity_id INT NOT NULL,
    category_id INT NOT NULL,
    budget_id INT NOT NULL,
    description TEXT,
    supplier_name VARCHAR(255),
    amount DECIMAL(15,2) NOT NULL,
    payment_date DATE,
    document_number VARCHAR(100),
    FOREIGN KEY (entity_id) REFERENCES government_entities(entity_id),
    FOREIGN KEY (category_id) REFERENCES budget_categories(category_id),
    FOREIGN KEY (budget_id) REFERENCES budgets(budget_id)
);

CREATE TABLE contracts (
    contract_id INT AUTO_INCREMENT PRIMARY KEY,
    entity_id INT NOT NULL,
    contract_number VARCHAR(100) UNIQUE NOT NULL,
    supplier_name VARCHAR(255) NOT NULL,
    contract_value DECIMAL(15,2) NOT NULL,
    start_date DATE,
    end_date DATE,
    status ENUM('Active', 'Completed', 'Cancelled', 'Suspended') DEFAULT 'Active',
    description TEXT,
    FOREIGN KEY (entity_id) REFERENCES government_entities(entity_id)
);

CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    tax_id VARCHAR(50) UNIQUE,
    contact_email VARCHAR(150),
    phone_number VARCHAR(50),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    country VARCHAR(100) DEFAULT 'Brazil'
);

CREATE TABLE contract_suppliers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    contract_id INT NOT NULL,
    supplier_id INT NOT NULL,
    FOREIGN KEY (contract_id) REFERENCES contracts(contract_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE revenues (
    revenue_id INT AUTO_INCREMENT PRIMARY KEY,
    entity_id INT NOT NULL,
    source ENUM('Taxes', 'Transfers', 'Donations', 'Other') DEFAULT 'Other',
    description TEXT,
    amount DECIMAL(15,2) NOT NULL,
    received_date DATE,
    FOREIGN KEY (entity_id) REFERENCES government_entities(entity_id)
);

CREATE TABLE transparency_reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    entity_id INT NOT NULL,
    period_start DATE,
    period_end DATE,
    total_revenue DECIMAL(15,2),
    total_expenditure DECIMAL(15,2),
    balance DECIMAL(15,2),
    publication_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (entity_id) REFERENCES government_entities(entity_id)
);