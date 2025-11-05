-- Database: transparency_portal
-- Public transparency system showing government budgets, expenditures, and contracts

CREATE DATABASE transparency_portal
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE transparency_portal;

CREATE TABLE government_entities (
    entity_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    abbreviation VARCHAR(50),
    type ENUM('Federal', 'State', 'Municipal', 'Other') DEFAULT 'Other',
    manager_name VARCHAR(150),
    contact_email VARCHAR(150),
    website VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);