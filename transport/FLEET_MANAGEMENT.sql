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