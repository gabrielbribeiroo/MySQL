-- Database: public_transport
CREATE DATABASE IF NOT EXISTS public_transport
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

USE public_transport;

CREATE TABLE lines (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    route_description TEXT,
    operation_hours VARCHAR(100)
);

CREATE TABLE stops (
    id SERIAL PRIMARY KEY,
    line_id INTEGER REFERENCES lines(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    latitude DECIMAL(10,6),
    longitude DECIMAL(10,6),
    order_in_route INTEGER NOT NULL
);

CREATE TABLE vehicles (
    id SERIAL PRIMARY KEY,
    line_id INTEGER REFERENCES lines(id) ON DELETE SET NULL,
    plate_number VARCHAR(20) UNIQUE NOT NULL,
    vehicle_type VARCHAR(50),
    capacity INTEGER,
    status VARCHAR(50) CHECK (status IN ('Active', 'Maintenance', 'Inactive'))
);

CREATE TABLE schedules (
    id SERIAL PRIMARY KEY,
    line_id INTEGER REFERENCES lines(id) ON DELETE CASCADE,
    stop_id INTEGER REFERENCES stops(id) ON DELETE CASCADE,
    departure_time TIME NOT NULL,
    arrival_time TIME
);