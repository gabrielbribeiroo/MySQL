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

CREATE TABLE product_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    name VARCHAR(160) NOT NULL,
    sku VARCHAR(80) UNIQUE,
    description TEXT,
    unit_price DECIMAL(10,2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES product_categories(category_id)
);

CREATE TABLE subscription_plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(160) NOT NULL UNIQUE,    -- e.g., "Monthly Beauty Box"
    description TEXT,
    billing_cycle ENUM('weekly','monthly','quarterly','yearly') NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    shipping_fee DECIMAL(10,2) DEFAULT 0.00,
    trial_days INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE plan_products (
    plan_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT DEFAULT 1,
    PRIMARY KEY (plan_id, product_id),
    FOREIGN KEY (plan_id) REFERENCES subscription_plans(plan_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE subscriptions (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    plan_id INT NOT NULL,
    address_id INT NOT NULL,
    start_date DATE NOT NULL,
    next_billing_date DATE,
    status ENUM('trial','active','paused','canceled','expired') DEFAULT 'active',
    cancel_reason VARCHAR(200),
    canceled_at DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (plan_id) REFERENCES subscription_plans(plan_id),
    FOREIGN KEY (address_id) REFERENCES addresses(address_id)
);