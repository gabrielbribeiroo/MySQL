-- Database: food_delivery
-- Food delivery platform with restaurants, menus, delivery agents, orders, deliveries, and payment integration.

CREATE DATABASE food_delivery
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE food_delivery;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(40),
    role ENUM('customer','restaurant_owner','courier','admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE customer_addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    label VARCHAR(60) DEFAULT 'home',
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
    FOREIGN KEY (customer_id) REFERENCES users(user_id)
);

CREATE TABLE restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    phone VARCHAR(40),
    email VARCHAR(150),
    address VARCHAR(255),
    city VARCHAR(120),
    state VARCHAR(80),
    country VARCHAR(80) DEFAULT 'Brazil',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(user_id)
);

-- Restaurant operating hours (weekly)
CREATE TABLE restaurant_hours (
    hours_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    weekday ENUM('mon','tue','wed','thu','fri','sat','sun') NOT NULL,
    open_time TIME NOT NULL,
    close_time TIME NOT NULL,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
    UNIQUE (restaurant_id, weekday)
);