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