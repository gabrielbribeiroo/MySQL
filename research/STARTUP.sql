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

CREATE TABLE mentors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    expertise VARCHAR(100),
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(20)
);

CREATE TABLE mentor_startup (
    mentor_id INT REFERENCES mentors(id),
    startup_id INT REFERENCES startups(id),
    start_date DATE,
    role VARCHAR(100),
    PRIMARY KEY (mentor_id, startup_id)
);