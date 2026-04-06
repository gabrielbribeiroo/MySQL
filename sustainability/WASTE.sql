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

CREATE TABLE collections (
    collection_id INT AUTO_INCREMENT PRIMARY KEY,
    batch_id INT NOT NULL,
    collector_org_id INT NOT NULL,
    collected_by INT,
    collection_date DATETIME NOT NULL,
    collected_quantity DECIMAL(14,3) NOT NULL,
    vehicle_info VARCHAR(150),
    manifest_number VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (batch_id) REFERENCES waste_batches(batch_id),
    FOREIGN KEY (collector_org_id) REFERENCES organizations(organization_id),
    FOREIGN KEY (collected_by) REFERENCES users(user_id)
);

CREATE TABLE transport_events (
    transport_id INT AUTO_INCREMENT PRIMARY KEY,
    batch_id INT NOT NULL,
    from_org_id INT,
    to_org_id INT,
    event_date DATETIME NOT NULL,
    transport_status ENUM('departed','arrived','delayed','cancelled') DEFAULT 'departed',
    carrier_name VARCHAR(150),
    tracking_reference VARCHAR(120),
    notes TEXT,
    FOREIGN KEY (batch_id) REFERENCES waste_batches(batch_id),
    FOREIGN KEY (from_org_id) REFERENCES organizations(organization_id),
    FOREIGN KEY (to_org_id) REFERENCES organizations(organization_id)
);

CREATE TABLE processing_methods (
    method_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,
    method_type ENUM('recycling','reuse','composting','incineration','landfill','treatment','other') DEFAULT 'other',
    description TEXT
);

CREATE TABLE processing_records (
    processing_id INT AUTO_INCREMENT PRIMARY KEY,
    batch_id INT NOT NULL,
    processor_org_id INT NOT NULL,
    method_id INT NOT NULL,
    processing_date DATE NOT NULL,
    input_quantity DECIMAL(14,3) NOT NULL,
    output_quantity DECIMAL(14,3),
    residue_quantity DECIMAL(14,3),
    status ENUM('pending','completed','failed') DEFAULT 'completed',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (batch_id) REFERENCES waste_batches(batch_id),
    FOREIGN KEY (processor_org_id) REFERENCES organizations(organization_id),
    FOREIGN KEY (method_id) REFERENCES processing_methods(method_id)
);

CREATE TABLE certification_types (
    certification_type_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE certifications (
    certification_id INT AUTO_INCREMENT PRIMARY KEY,
    organization_id INT NOT NULL,
    certification_type_id INT NOT NULL,
    certificate_number VARCHAR(120) UNIQUE,
    issue_date DATE,
    expiry_date DATE,
    issuing_authority VARCHAR(180),
    status ENUM('valid','expired','revoked','pending') DEFAULT 'valid',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (organization_id) REFERENCES organizations(organization_id),
    FOREIGN KEY (certification_type_id) REFERENCES certification_types(certification_type_id)
);

CREATE TABLE recycling_reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    organization_id INT NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    total_generated DECIMAL(14,3) DEFAULT 0,
    total_recycled DECIMAL(14,3) DEFAULT 0,
    total_disposed DECIMAL(14,3) DEFAULT 0,
    recycling_rate DECIMAL(8,4) DEFAULT 0, -- e.g. 0.8532
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (organization_id) REFERENCES organizations(organization_id)
);

CREATE TABLE attachments (
    attachment_id INT AUTO_INCREMENT PRIMARY KEY,
    batch_id INT,
    collection_id INT,
    processing_id INT,
    certification_id INT,
    uploaded_by INT,
    file_name VARCHAR(200),
    file_type VARCHAR(80),
    file_url VARCHAR(300),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (batch_id) REFERENCES waste_batches(batch_id),
    FOREIGN KEY (collection_id) REFERENCES collections(collection_id),
    FOREIGN KEY (processing_id) REFERENCES processing_records(processing_id),
    FOREIGN KEY (certification_id) REFERENCES certifications(certification_id),
    FOREIGN KEY (uploaded_by) REFERENCES users(user_id)
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