-- Database: retail_inventory
CREATE DATABASE retail_inventory
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE retail_inventory;

CREATE TABLE suppliers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INTEGER DEFAULT 0,
    supplier_id INTEGER REFERENCES suppliers(id)
);

CREATE TABLE purchases (
    id SERIAL PRIMARY KEY,
    supplier_id INTEGER REFERENCES suppliers(id),
    purchase_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL
);

CREATE TABLE purchase_items (
    purchase_id INTEGER REFERENCES purchases(id),
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER NOT NULL,
    cost_price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (purchase_id, product_id)
);