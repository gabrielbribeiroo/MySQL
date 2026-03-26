-- Database: waste_tracking
-- Waste tracking system from generation to disposal, including recycling rates and certifications.

CREATE DATABASE waste_tracking
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_unicode_ci;

USE waste_tracking;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    role ENUM('generator','collector','processor','auditor','admin') NOT NULL,
    phone VARCHAR(40),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE organizations (
    organization_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    organization_type ENUM(
        'industry',
        'commercial',
        'municipality',
        'collector',
        'recycling_center',
        'landfill',
        'incinerator',
        'other'
    ) DEFAULT 'other',
    tax_id VARCHAR(50) UNIQUE,
    email VARCHAR(150),
    phone VARCHAR(40),
    address VARCHAR(255),
    city VARCHAR(120),
    state VARCHAR(80),
    country VARCHAR(80) DEFAULT 'Brazil',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE organization_users (
    organization_id INT NOT NULL,
    user_id INT NOT NULL,
    role_in_organization VARCHAR(120),
    PRIMARY KEY (organization_id, user_id),
    FOREIGN KEY (organization_id) REFERENCES organizations(organization_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE waste_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE waste_types (
    waste_type_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    name VARCHAR(150) NOT NULL UNIQUE,
    hazardous BOOLEAN DEFAULT FALSE,
    recyclable BOOLEAN DEFAULT FALSE,
    unit VARCHAR(30) DEFAULT 'kg',
    description TEXT,
    FOREIGN KEY (category_id) REFERENCES waste_categories(category_id)
);

CREATE TABLE facilities (
    facility_id INT AUTO_INCREMENT PRIMARY KEY,
    organization_id INT NOT NULL,
    name VARCHAR(180) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(120),
    state VARCHAR(80),
    country VARCHAR(80) DEFAULT 'Brazil',
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (organization_id) REFERENCES organizations(organization_id)
);

CREATE TABLE waste_batches (
    batch_id INT AUTO_INCREMENT PRIMARY KEY,
    generator_org_id INT NOT NULL,
    facility_id INT,
    waste_type_id INT NOT NULL,
    batch_code VARCHAR(80) UNIQUE NOT NULL,
    generation_date DATE NOT NULL,
    quantity DECIMAL(14,3) NOT NULL,
    current_status ENUM(
        'generated',
        'stored',
        'in_transit',
        'received',
        'processing',
        'recycled',
        'disposed',
        'rejected'
    ) DEFAULT 'generated',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (generator_org_id) REFERENCES organizations(organization_id),
    FOREIGN KEY (facility_id) REFERENCES facilities(facility_id),
    FOREIGN KEY (waste_type_id) REFERENCES waste_types(waste_type_id)
);