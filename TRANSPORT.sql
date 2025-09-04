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