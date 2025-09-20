-- Database: fleet_management
CREATE DATABASE IF NOT EXISTS fleet_management
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

USE fleet_management;

CREATE TABLE vehicles (
    id SERIAL PRIMARY KEY,
    plate VARCHAR(20) UNIQUE NOT NULL,
    model VARCHAR(100) NOT NULL,
    year INT CHECK (year >= 1900),
    type VARCHAR(50), -- carro, caminhão, van, ônibus etc.
    status VARCHAR(50) CHECK (status IN ('Active', 'Inactive', 'In Maintenance')) DEFAULT 'Active'
);

CREATE TABLE drivers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    phone VARCHAR(20),
    hire_date DATE,
    status VARCHAR(50) CHECK (status IN ('Active', 'Inactive')) DEFAULT 'Active'
);

CREATE TABLE routes (
    id SERIAL PRIMARY KEY,
    origin VARCHAR(200) NOT NULL,
    destination VARCHAR(200) NOT NULL,
    distance_km DECIMAL(8,2),
    estimated_time INTERVAL
);