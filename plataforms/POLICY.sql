-- Database: policy_tracker
-- Tracker for monitoring implementation and results of public policies across regions

CREATE DATABASE policy_tracker
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE policy_tracker;

CREATE TABLE regions (
    region_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    type ENUM('Municipality', 'State', 'Region', 'Country') DEFAULT 'Municipality',
    parent_region_id INT,
    FOREIGN KEY (parent_region_id) REFERENCES regions(region_id)
);