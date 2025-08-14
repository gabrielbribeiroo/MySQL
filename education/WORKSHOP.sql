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

CREATE TABLE workshop_instructors (
    workshop_id INTEGER REFERENCES workshop_topics(id) ON DELETE CASCADE,
    instructor_id INTEGER REFERENCES instructors(id) ON DELETE CASCADE,
    PRIMARY KEY(workshop_id, instructor_id)
);

CREATE TABLE participants (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL
);

CREATE TABLE registrations (
    id SERIAL PRIMARY KEY,
    participant_id INTEGER REFERENCES participants(id) ON DELETE CASCADE,
    workshop_id INTEGER REFERENCES workshop_topics(id) ON DELETE CASCADE,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(participant_id, workshop_id)
);

CREATE TABLE certificates (
    id SERIAL PRIMARY KEY,
    registration_id INTEGER REFERENCES registrations(id) ON DELETE CASCADE,
    issued_at DATE DEFAULT CURRENT_DATE,
    certificate_code VARCHAR(50) UNIQUE NOT NULL
);