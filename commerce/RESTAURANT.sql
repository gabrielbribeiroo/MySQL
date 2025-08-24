-- Database: restaurant_management
CREATE DATABASE restaurant_management
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE restaurant_management;

CREATE TABLE menu_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE menu_items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES menu_categories(category_id)
);

CREATE TABLE tables (
    table_id INT PRIMARY KEY AUTO_INCREMENT,
    table_number INT NOT NULL UNIQUE,
    capacity INT NOT NULL,
    status ENUM('available','reserved','occupied') DEFAULT 'available'
);

CREATE TABLE waiters (
    waiter_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    shift ENUM('morning','afternoon','evening') NOT NULL
);

CREATE TABLE reservations (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    table_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_phone VARCHAR(20),
    reservation_time DATETIME NOT NULL,
    num_people INT NOT NULL,
    status ENUM('pending','confirmed','cancelled') DEFAULT 'pending',
    FOREIGN KEY (table_id) REFERENCES tables(table_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    table_id INT NOT NULL,
    waiter_id INT NOT NULL,
    order_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('open','served','paid','cancelled') DEFAULT 'open',
    FOREIGN KEY (table_id) REFERENCES tables(table_id),
    FOREIGN KEY (waiter_id) REFERENCES waiters(waiter_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('cash','credit_card','debit_card','pix') NOT NULL,
    payment_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);