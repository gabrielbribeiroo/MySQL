-- 🏭 Database: wholesale_platform
-- Wholesale commerce system connecting suppliers and retailers with bulk pricing and logistics.

CREATE DATABASE wholesale_platform
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE wholesale_platform;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    role ENUM('supplier','retailer','admin') NOT NULL,
    phone VARCHAR(40),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE companies (
    company_id INT AUTO_INCREMENT PRIMARY KEY,
    company_type ENUM('supplier','retailer') NOT NULL,
    legal_name VARCHAR(200) NOT NULL,
    trade_name VARCHAR(200),
    tax_id VARCHAR(40) UNIQUE,               -- CNPJ/CPF or any tax identifier
    email VARCHAR(150),
    phone VARCHAR(40),
    country VARCHAR(80) DEFAULT 'Brazil',
    city VARCHAR(120),
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Link users to companies
CREATE TABLE company_users (
    company_id INT NOT NULL,
    user_id INT NOT NULL,
    role_in_company VARCHAR(120),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (company_id, user_id),
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE product_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_company_id INT NOT NULL,
    category_id INT,
    name VARCHAR(180) NOT NULL,
    sku VARCHAR(80) UNIQUE,
    description TEXT,
    unit VARCHAR(30) DEFAULT 'unit',         -- e.g., unit, kg, box, pack
    base_price DECIMAL(10,2) NOT NULL,       -- default unit price (can be overridden by bulk tiers)
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_company_id) REFERENCES companies(company_id),
    FOREIGN KEY (category_id) REFERENCES product_categories(category_id)
);