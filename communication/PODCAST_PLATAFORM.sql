-- Database: podcast_platform
CREATE DATABASE podcast_platform
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE podcast_platform;

CREATE TABLE hosts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    bio TEXT,
    joined_at DATE DEFAULT CURRENT_DATE
);

CREATE TABLE podcasts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    host_id INTEGER REFERENCES hosts(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);