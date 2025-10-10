-- Database: insurance_platform
CREATE DATABASE insurance_platform
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE insurance_platform;

CREATE TABLE policyholders (
    policyholder_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    cpf_cnpj VARCHAR(20) UNIQUE NOT NULL,
    birth_date DATE,
    email VARCHAR(120),
    phone VARCHAR(20),
    address VARCHAR(200),
    registration_date DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE coverage_plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    coverage_type ENUM('life', 'health', 'vehicle', 'home', 'travel', 'other') DEFAULT 'other',
    monthly_premium DECIMAL(10,2) NOT NULL,
    coverage_limit DECIMAL(12,2),
    active BOOLEAN DEFAULT TRUE
);

CREATE TABLE policies (
    policy_id INT AUTO_INCREMENT PRIMARY KEY,
    policyholder_id INT NOT NULL,
    plan_id INT NOT NULL,
    policy_number VARCHAR(50) UNIQUE NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status ENUM('active', 'expired', 'cancelled', 'pending') DEFAULT 'active',
    total_premium DECIMAL(12,2),
    FOREIGN KEY (policyholder_id) REFERENCES policyholders(policyholder_id),
    FOREIGN KEY (plan_id) REFERENCES coverage_plans(plan_id)
);

CREATE TABLE premium_payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT NOT NULL,
    payment_date DATE,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('pix', 'boleto', 'card', 'transfer') DEFAULT 'pix',
    status ENUM('pending', 'paid', 'overdue') DEFAULT 'pending',
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);

CREATE TABLE claims (
    claim_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT NOT NULL,
    claim_date DATE NOT NULL,
    description TEXT,
    claim_amount DECIMAL(12,2),
    status ENUM('submitted', 'under_review', 'approved', 'rejected', 'paid') DEFAULT 'submitted',
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);