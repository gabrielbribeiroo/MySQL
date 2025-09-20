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

CREATE TABLE assignments (
    id SERIAL PRIMARY KEY,
    vehicle_id INTEGER REFERENCES vehicles(id) ON DELETE CASCADE,
    driver_id INTEGER REFERENCES drivers(id) ON DELETE CASCADE,
    route_id INTEGER REFERENCES routes(id) ON DELETE CASCADE,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP,
    status VARCHAR(50) CHECK (status IN ('Planned', 'Ongoing', 'Completed', 'Cancelled')) DEFAULT 'Planned'
);

CREATE TABLE maintenance (
    id SERIAL PRIMARY KEY,
    vehicle_id INTEGER REFERENCES vehicles(id) ON DELETE CASCADE,
    description TEXT NOT NULL,
    maintenance_date DATE NOT NULL,
    cost DECIMAL(10,2) DEFAULT 0,
    provider VARCHAR(100)
);

CREATE TABLE costs (
    id SERIAL PRIMARY KEY,
    vehicle_id INTEGER REFERENCES vehicles(id) ON DELETE CASCADE,
    assignment_id INTEGER REFERENCES assignments(id) ON DELETE CASCADE,
    cost_type VARCHAR(50) CHECK (cost_type IN ('Fuel', 'Toll', 'Repair', 'Insurance', 'Other')),
    amount DECIMAL(10,2) NOT NULL,
    incurred_at DATE NOT NULL DEFAULT CURRENT_DATE
);