-- Database: tax_filing
CREATE DATABASE IF NOT EXISTS tax_filing
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE tax_filing;

CREATE TABLE taxpayers (
    taxpayer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    type ENUM('individual', 'business') NOT NULL,
    cpf_cnpj VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(120),
    phone VARCHAR(20),
    address VARCHAR(200),
    registration_date DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE tax_years (
    tax_year_id INT AUTO_INCREMENT PRIMARY KEY,
    year INT NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

CREATE TABLE income_records (
    income_id INT AUTO_INCREMENT PRIMARY KEY,
    taxpayer_id INT NOT NULL,
    tax_year_id INT NOT NULL,
    source VARCHAR(150) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    type ENUM('salary', 'rental', 'investment', 'business', 'other') DEFAULT 'other',
    FOREIGN KEY (taxpayer_id) REFERENCES taxpayers(taxpayer_id),
    FOREIGN KEY (tax_year_id) REFERENCES tax_years(tax_year_id)
);

CREATE TABLE deductions (
    deduction_id INT AUTO_INCREMENT PRIMARY KEY,
    taxpayer_id INT NOT NULL,
    tax_year_id INT NOT NULL,
    category ENUM('education', 'health', 'dependents', 'donations', 'retirement', 'other') DEFAULT 'other',
    description VARCHAR(150),
    amount DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (taxpayer_id) REFERENCES taxpayers(taxpayer_id),
    FOREIGN KEY (tax_year_id) REFERENCES tax_years(tax_year_id)
);

CREATE TABLE tax_filings (
    filing_id INT AUTO_INCREMENT PRIMARY KEY,
    taxpayer_id INT NOT NULL,
    tax_year_id INT NOT NULL,
    total_income DECIMAL(12,2) NOT NULL,
    total_deductions DECIMAL(12,2) DEFAULT 0.00,
    tax_due DECIMAL(12,2) DEFAULT 0.00,
    submission_date DATE,
    status ENUM('pending', 'submitted', 'approved', 'rejected') DEFAULT 'pending',
    FOREIGN KEY (taxpayer_id) REFERENCES taxpayers(taxpayer_id),
    FOREIGN KEY (tax_year_id) REFERENCES tax_years(tax_year_id)
);

CREATE TABLE submission_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    filing_id INT NOT NULL,
    submission_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    method ENUM('online', 'manual', 'api') DEFAULT 'online',
    message TEXT,
    FOREIGN KEY (filing_id) REFERENCES tax_filings(filing_id)
);

CREATE TABLE tax_payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    filing_id INT NOT NULL,
    payment_date DATE,
    amount_paid DECIMAL(12,2),
    payment_method ENUM('pix', 'boleto', 'transfer', 'card') DEFAULT 'pix',
    confirmed BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (filing_id) REFERENCES tax_filings(filing_id)
);