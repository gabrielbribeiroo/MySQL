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
