-- 📦 DATABASE: subscription_box
-- Subscription-based commerce platform with recurring deliveries, plans, and customer retention analytics.

CREATE DATABASE IF NOT EXISTS subscription_box
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE subscription_box;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(40),
    birth_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    label VARCHAR(60) DEFAULT 'home',     -- e.g., home, work
    street VARCHAR(200) NOT NULL,
    number VARCHAR(30),
    complement VARCHAR(100),
    neighborhood VARCHAR(120),
    city VARCHAR(120) NOT NULL,
    state VARCHAR(80),
    postal_code VARCHAR(30),
    country VARCHAR(80) DEFAULT 'Brazil',
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);