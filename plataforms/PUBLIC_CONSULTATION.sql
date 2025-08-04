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