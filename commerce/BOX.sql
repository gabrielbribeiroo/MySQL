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

CREATE TABLE payment_methods (
    method_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(80) NOT NULL UNIQUE      -- e.g., credit_card, pix, boleto, paypal
);

CREATE TABLE invoices (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    subscription_id INT NOT NULL,
    invoice_date DATE NOT NULL,
    period_start DATE,
    period_end DATE,
    subtotal DECIMAL(10,2) NOT NULL,
    shipping_fee DECIMAL(10,2) DEFAULT 0.00,
    discount DECIMAL(10,2) DEFAULT 0.00,
    total DECIMAL(10,2) NOT NULL,
    status ENUM('pending','paid','failed','refunded') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id)
);

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT NOT NULL,
    method_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status ENUM('pending','paid','failed','refunded') DEFAULT 'pending',
    transaction_ref VARCHAR(120),
    paid_at DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id),
    FOREIGN KEY (method_id) REFERENCES payment_methods(method_id)
);

CREATE TABLE boxes (
    box_id INT AUTO_INCREMENT PRIMARY KEY,
    subscription_id INT NOT NULL,
    cycle_reference VARCHAR(40) NOT NULL,         -- e.g., "2026-01" or "week-05-2026"
    planned_ship_date DATE,
    shipped_at DATETIME,
    delivered_at DATETIME,
    status ENUM('planned','packed','shipped','delivered','returned','lost') DEFAULT 'planned',
    tracking_code VARCHAR(120),
    carrier VARCHAR(120),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id),
    UNIQUE (subscription_id, cycle_reference)
);

CREATE TABLE box_items (
    box_item_id INT AUTO_INCREMENT PRIMARY KEY,
    box_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (box_id) REFERENCES boxes(box_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    subscription_id INT,
    box_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id),
    FOREIGN KEY (box_id) REFERENCES boxes(box_id)
);

CREATE TABLE retention_events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    subscription_id INT,
    event_type ENUM(
        'signup','trial_start','trial_end','payment_success','payment_failed',
        'box_shipped','box_delivered','pause','resume','cancel','reactivate',
        'refund','support_ticket'
    ) NOT NULL,
    event_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    metadata JSON,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id)
);

CREATE TABLE cohort_snapshots (
    snapshot_id INT AUTO_INCREMENT PRIMARY KEY,
    cohort_month CHAR(7) NOT NULL,               -- format: YYYY-MM
    active_subscriptions INT DEFAULT 0,
    canceled_subscriptions INT DEFAULT 0,
    churn_rate DECIMAL(6,3) DEFAULT 0.000,       -- e.g., 0.125 = 12.5%
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (cohort_month)
);

CREATE TABLE audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    actor_email VARCHAR(150),
    action VARCHAR(200) NOT NULL,
    entity VARCHAR(120),
    entity_id INT,
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TRIGGERS (analytics: auto-log key events)

DELIMITER $$

-- Log subscription status changes (pause/cancel/reactivate)
CREATE TRIGGER trg_subscription_status_log
AFTER UPDATE ON subscriptions
FOR EACH ROW
BEGIN
    IF NEW.status <> OLD.status THEN
        INSERT INTO retention_events (customer_id, subscription_id, event_type, metadata)
        VALUES (
            NEW.customer_id,
            NEW.subscription_id,
            CASE
                WHEN NEW.status = 'paused' THEN 'pause'
                WHEN NEW.status = 'active' AND OLD.status IN ('paused','canceled','expired') THEN 'reactivate'
                WHEN NEW.status = 'canceled' THEN 'cancel'
                ELSE 'support_ticket'
            END,
            JSON_OBJECT('old_status', OLD.status, 'new_status', NEW.status, 'reason', NEW.cancel_reason)
        );
    END IF;
END$$