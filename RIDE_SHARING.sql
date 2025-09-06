-- Database: ride_sharing
CREATE DATABASE IF NOT EXISTS ride_sharing
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

USE ride_sharing;

CREATE TABLE drivers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    car_model VARCHAR(100),
    car_plate VARCHAR(20) UNIQUE NOT NULL,
    rating DECIMAL(3,2) DEFAULT 5.0 CHECK (rating >= 0 AND rating <= 5),
    phone VARCHAR(20)
);

CREATE TABLE passengers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    document VARCHAR(50) UNIQUE,
    phone VARCHAR(20),
    rating DECIMAL(3,2) DEFAULT 5.0 CHECK (rating >= 0 AND rating <= 5)
);

CREATE TABLE routes (
    id SERIAL PRIMARY KEY,
    origin VARCHAR(200) NOT NULL,
    destination VARCHAR(200) NOT NULL,
    distance_km DECIMAL(6,2),
    estimated_time INTERVAL
);