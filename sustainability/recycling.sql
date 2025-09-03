-- Database: recycling_center

CREATE DATABASE IF NOT EXISTS recycling_center
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

USE recycling_center;

CREATE TABLE collection_points (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(100),
    state VARCHAR(50),
    zip_code VARCHAR(20),
    opening_hours VARCHAR(100),
    contact_info VARCHAR(100)
);

CREATE TABLE waste_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    recycling_process TEXT
);

CREATE TABLE collections (
    id SERIAL PRIMARY KEY,
    point_id INTEGER REFERENCES collection_points(id),
    waste_type_id INTEGER REFERENCES waste_types(id),
    collection_date DATE NOT NULL,
    volume_kg DECIMAL(12,2) NOT NULL
);

CREATE TABLE reverse_logistics (
    id SERIAL PRIMARY KEY,
    collection_id INTEGER REFERENCES collections(id),
    destination VARCHAR(150) NOT NULL,
    transport_company VARCHAR(100),
    shipped_date DATE,
    received_date DATE,
    status VARCHAR(50) CHECK (status IN ('Shipped', 'Received', 'In Process'))
);

CREATE TABLE partners (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    partner_type VARCHAR(50),
    contact_info VARCHAR(100)
);
