CREATE DATABASE IF NOT EXISTS public_consultation
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE public_consultation;

CREATE TABLE consultation_topics (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    area VARCHAR(100), -- ex: Leis, Obras, Mobilidade, etc.
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    role VARCHAR(20) DEFAULT 'citizen' -- citizen, moderator, admin
);

CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    consultation_id INTEGER REFERENCES consultation_topics(id),
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);