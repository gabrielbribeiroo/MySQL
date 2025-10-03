-- Database: hr_management
CREATE DATABASE IF NOT EXISTS hr_management
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

USE hr_management;

CREATE TABLE positions (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    department VARCHAR(100),
    description TEXT
);