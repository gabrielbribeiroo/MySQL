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

CREATE TABLE proposals (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id),
    freelancer_id INTEGER REFERENCES users(id),
    proposal_text TEXT NOT NULL,
    proposed_budget NUMERIC(12,2),
    delivery_time_days INTEGER,
    status VARCHAR(20) DEFAULT 'pending', -- pending, accepted, rejected
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(project_id, freelancer_id)
);

CREATE TABLE deliveries (
    id SERIAL PRIMARY KEY,
    proposal_id INTEGER REFERENCES proposals(id),
    delivery_link TEXT NOT NULL, -- link to files or repository
    delivered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved BOOLEAN DEFAULT FALSE
);

CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id),
    reviewer_id INTEGER REFERENCES users(id),
    reviewee_id INTEGER REFERENCES users(id),
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for quick search by category
CREATE INDEX idx_projects_category ON projects(category);