-- Database: research_repository
-- Repository for academic publications, theses, and research data sharing among institutions

CREATE DATABASE research_repository
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_general_ci;

USE research_repository;

CREATE TABLE institutions (
    institution_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    acronym VARCHAR(20),
    country VARCHAR(100),
    city VARCHAR(100),
    website VARCHAR(150),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);