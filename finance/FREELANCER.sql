-- Database: freelancer_marketplace

-- Create the main database
CREATE DATABASE IF NOT EXISTS freelancer_marketplace
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

use freelancer_marketplace;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role VARCHAR(20) DEFAULT 'freelancer', -- freelancer, client, admin
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    client_id INTEGER REFERENCES users(id),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(100),
    budget NUMERIC(12,2),
    status VARCHAR(20) DEFAULT 'open', -- open, in_progress, completed, cancelled
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);