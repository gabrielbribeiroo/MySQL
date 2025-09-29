-- Database: startup_incubator
CREATE DATABASE IF NOT EXISTS startup_incubator
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE startup_incubator;

CREATE TABLE startups (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    sector VARCHAR(100),
    founded_date DATE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);