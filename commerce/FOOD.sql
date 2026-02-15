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

CREATE TABLE menu_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    name VARCHAR(120) NOT NULL,
    description TEXT,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
    UNIQUE (restaurant_id, name)
);

CREATE TABLE menu_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    category_id INT,
    name VARCHAR(160) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
    FOREIGN KEY (category_id) REFERENCES menu_categories(category_id)
);

-- Item options / add-ons (e.g., extra cheese)
CREATE TABLE item_options (
    option_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT NOT NULL,
    name VARCHAR(120) NOT NULL,
    extra_price DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id)
);

CREATE TABLE couriers (
    courier_id INT PRIMARY KEY,  -- references users.user_id
    vehicle_type ENUM('bike','motorcycle','car','other') DEFAULT 'motorcycle',
    license_plate VARCHAR(20),
    is_available BOOLEAN DEFAULT TRUE,
    rating DECIMAL(3,2) DEFAULT 0.00,
    total_deliveries INT DEFAULT 0,
    FOREIGN KEY (courier_id) REFERENCES users(user_id)
);

-- Optional: courier location pings (for "real-time monitoring")
CREATE TABLE courier_locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    courier_id INT NOT NULL,
    latitude DECIMAL(10,7) NOT NULL,
    longitude DECIMAL(10,7) NOT NULL,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (courier_id) REFERENCES couriers(courier_id)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    delivery_address_id INT NOT NULL,
    status ENUM(
        'created','confirmed','preparing','ready',
        'picked_up','delivered','canceled','refunded'
    ) DEFAULT 'created',
    subtotal DECIMAL(12,2) DEFAULT 0.00,
    delivery_fee DECIMAL(12,2) DEFAULT 0.00,
    discount DECIMAL(12,2) DEFAULT 0.00,
    total DECIMAL(12,2) DEFAULT 0.00,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(user_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
    FOREIGN KEY (delivery_address_id) REFERENCES customer_addresses(address_id)
);

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,      -- locked at order time
    line_total DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id)
);

-- If customer chooses add-ons for a given order item
CREATE TABLE order_item_options (
    order_item_option_id INT AUTO_INCREMENT PRIMARY KEY,
    order_item_id INT NOT NULL,
    option_id INT NOT NULL,
    extra_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_item_id) REFERENCES order_items(order_item_id),
    FOREIGN KEY (option_id) REFERENCES item_options(option_id)
);

CREATE TABLE deliveries (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    courier_id INT,
    status ENUM('pending','assigned','picked_up','in_transit','delivered','failed') DEFAULT 'pending',
    assigned_at DATETIME,
    picked_up_at DATETIME,
    delivered_at DATETIME,
    proof_url VARCHAR(300),                 -- photo/proof of delivery
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (courier_id) REFERENCES couriers(courier_id),
    UNIQUE (order_id)
);

-- Delivery tracking events (timeline)
CREATE TABLE delivery_events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    delivery_id INT NOT NULL,
    event_type ENUM('assigned','picked_up','in_transit','arrived','delivered','issue') NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (delivery_id) REFERENCES deliveries(delivery_id)
);

CREATE TABLE payment_methods (
    method_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(80) NOT NULL UNIQUE        -- credit_card, pix, boleto, wallet, paypal
);

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    method_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    status ENUM('pending','authorized','paid','failed','refunded') DEFAULT 'pending',
    transaction_ref VARCHAR(120),
    paid_at DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (method_id) REFERENCES payment_methods(method_id)
);

CREATE TABLE restaurant_reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    customer_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
    FOREIGN KEY (customer_id) REFERENCES users(user_id),
    UNIQUE (order_id)
);

CREATE TABLE courier_reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    courier_id INT NOT NULL,
    customer_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (courier_id) REFERENCES couriers(courier_id),
    FOREIGN KEY (customer_id) REFERENCES users(user_id),
    UNIQUE (order_id)
);

CREATE TABLE audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    actor_user_id INT,
    action VARCHAR(200) NOT NULL,
    entity VARCHAR(120),
    entity_id INT,
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (actor_user_id) REFERENCES users(user_id)
);

DELIMITER $$

-- Update orders subtotal/total after inserting items
CREATE TRIGGER trg_order_item_after_insert
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders
    SET subtotal = (
        SELECT COALESCE(SUM(line_total), 0) FROM order_items WHERE order_id = NEW.order_id
    ),
    total = (
        SELECT COALESCE(SUM(line_total), 0) FROM order_items WHERE order_id = NEW.order_id
    ) + delivery_fee - discount
    WHERE order_id = NEW.order_id;
END$$

-- Update orders subtotal/total after updating items
CREATE TRIGGER trg_order_item_after_update
AFTER UPDATE ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders
    SET subtotal = (
        SELECT COALESCE(SUM(line_total), 0) FROM order_items WHERE order_id = NEW.order_id
    ),
    total = (
        SELECT COALESCE(SUM(line_total), 0) FROM order_items WHERE order_id = NEW.order_id
    ) + delivery_fee - discount
    WHERE order_id = NEW.order_id;
END$$