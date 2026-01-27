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

CREATE TABLE bulk_price_tiers (
    tier_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    min_quantity INT NOT NULL,
    max_quantity INT,                         -- NULL = no upper bound
    unit_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE warehouses (
    warehouse_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_company_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(120),
    state VARCHAR(80),
    country VARCHAR(80) DEFAULT 'Brazil',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_company_id) REFERENCES companies(company_id)
);

CREATE TABLE inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    warehouse_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity_available INT DEFAULT 0,
    reorder_level INT DEFAULT 0,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (warehouse_id, product_id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE purchase_orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    retailer_company_id INT NOT NULL,
    supplier_company_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('draft','placed','confirmed','packed','shipped','delivered','canceled') DEFAULT 'placed',
    currency VARCHAR(10) DEFAULT 'BRL',
    subtotal DECIMAL(12,2) DEFAULT 0.00,
    shipping_cost DECIMAL(12,2) DEFAULT 0.00,
    total DECIMAL(12,2) DEFAULT 0.00,
    notes TEXT,
    FOREIGN KEY (retailer_company_id) REFERENCES companies(company_id),
    FOREIGN KEY (supplier_company_id) REFERENCES companies(company_id)
);

CREATE TABLE purchase_order_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,       -- price locked at purchase time (tier-applied)
    line_total DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES purchase_orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payment_methods (
    method_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(80) NOT NULL UNIQUE          -- credit_card, pix, boleto, bank_transfer
);

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    method_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    status ENUM('pending','paid','failed','refunded') DEFAULT 'pending',
    transaction_ref VARCHAR(120),
    paid_at DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES purchase_orders(order_id),
    FOREIGN KEY (method_id) REFERENCES payment_methods(method_id)
);

CREATE TABLE carriers (
    carrier_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,
    support_phone VARCHAR(40),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE shipments (
    shipment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    carrier_id INT,
    status ENUM('pending','packed','in_transit','delivered','returned','lost') DEFAULT 'pending',
    tracking_code VARCHAR(120),
    planned_ship_date DATE,
    shipped_at DATETIME,
    delivered_at DATETIME,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES purchase_orders(order_id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id),
    FOREIGN KEY (carrier_id) REFERENCES carriers(carrier_id)
);

-- Optional: shipment package breakdown
CREATE TABLE shipment_items (
    shipment_item_id INT AUTO_INCREMENT PRIMARY KEY,
    shipment_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (shipment_id) REFERENCES shipments(shipment_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);