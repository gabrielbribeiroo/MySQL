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

CREATE TABLE rides (
    id SERIAL PRIMARY KEY,
    driver_id INTEGER REFERENCES drivers(id) ON DELETE CASCADE,
    route_id INTEGER REFERENCES routes(id) ON DELETE CASCADE,
    departure_time TIMESTAMP NOT NULL,
    available_seats INTEGER NOT NULL,
    status VARCHAR(50) CHECK (status IN ('Scheduled', 'In Progress', 'Completed', 'Cancelled')) DEFAULT 'Scheduled'
);

CREATE TABLE ride_passengers (
    ride_id INTEGER REFERENCES rides(id) ON DELETE CASCADE,
    passenger_id INTEGER REFERENCES passengers(id) ON DELETE CASCADE,
    seat_number INTEGER,
    PRIMARY KEY (ride_id, passenger_id)
);