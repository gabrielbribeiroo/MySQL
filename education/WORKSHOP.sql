-- Database: workshop_platform

CREATE DATABASE IF NOT EXISTS workshop_plataform
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE workshop_plataform;

CREATE TABLE workshop_topics (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    category VARCHAR(100), -- ex: Tecnologia, Arte, Negócios, etc.
    mode VARCHAR(20) CHECK (mode IN ('online', 'presencial')),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

CREATE TABLE instructors (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    bio TEXT,
    expertise_area VARCHAR(100)
);