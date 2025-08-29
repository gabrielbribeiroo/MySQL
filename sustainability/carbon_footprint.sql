-- Database: carbon_footprint

CREATE DATABASE IF NOT EXISTS carbon_footprint
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

USE carbon_footprint;

CREATE TABLE entities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    country VARCHAR(100),
    sector VARCHAR(100)
);

CREATE TABLE emission_sources (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);