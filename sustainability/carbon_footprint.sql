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

CREATE TABLE emission_records (
    id SERIAL PRIMARY KEY,
    entity_id INTEGER REFERENCES entities(id),
    source_id INTEGER REFERENCES emission_sources(id),
    record_date DATE NOT NULL,
    activity_description TEXT,
    amount DECIMAL(12,2) NOT NULL,
    emission_factor DECIMAL(12,4) NOT NULL,
    total_emission DECIMAL(12,2) GENERATED ALWAYS AS (amount * emission_factor) STORED
);

CREATE TABLE reduction_actions (
    id SERIAL PRIMARY KEY,
    entity_id INTEGER REFERENCES entities(id),
    action_name VARCHAR(150) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    estimated_reduction DECIMAL(12,2), -- redução prevista em kg CO2e
    actual_reduction DECIMAL(12,2) -- redução efetiva
);

CREATE TABLE reports (
    id SERIAL PRIMARY KEY,
    entity_id INTEGER REFERENCES entities(id),
    report_date DATE NOT NULL,
    total_emissions DECIMAL(12,2),
    total_reductions DECIMAL(12,2),
    net_emissions DECIMAL(12,2)
);