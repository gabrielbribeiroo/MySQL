CREATE DATABASE music_festival
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE music_festival;

CREATE TABLE stages (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location TEXT
);

CREATE TABLE artists (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    genre VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE sponsors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    industry VARCHAR(100),
    contact_email VARCHAR(100)
);

CREATE TABLE performances (
    id SERIAL PRIMARY KEY,
    artist_id INTEGER REFERENCES artists(id),
    stage_id INTEGER REFERENCES stages(id),
    performance_time TIMESTAMP NOT NULL,
    duration_minutes INTEGER
);

CREATE TABLE attendees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    ticket_type VARCHAR(50) -- ex: VIP, Regular, Student
);

CREATE TABLE festival_sponsors (
    festival_year INTEGER NOT NULL,
    sponsor_id INTEGER REFERENCES sponsors(id),
    PRIMARY KEY(festival_year, sponsor_id)
);

CREATE TABLE ticket_sales (
    id SERIAL PRIMARY KEY,
    attendee_id INTEGER REFERENCES attendees(id),
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    price DECIMAL(10,2)
);