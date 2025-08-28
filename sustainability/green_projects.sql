-- Database: green_projects

CREATE DATABASE IF NOT EXISTS green_projects
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

USE green_projects;

CREATE TABLE funders (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    organization_type VARCHAR(50) -- ONG, Governo, Empresa privada
);

CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE,
    budget DECIMAL(12,2),
    funder_id INTEGER REFERENCES funders(id)
);

CREATE TABLE impact_indicators (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    unit VARCHAR(50),
    description TEXT
);

CREATE TABLE project_indicators (
    project_id INTEGER REFERENCES projects(id),
    indicator_id INTEGER REFERENCES impact_indicators(id),
    target_value DECIMAL(12,2),
    achieved_value DECIMAL(12,2),
    PRIMARY KEY (project_id, indicator_id)
);

CREATE TABLE executions (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id),
    activity_name VARCHAR(150) NOT NULL,
    description TEXT,
    execution_date DATE NOT NULL,
    cost DECIMAL(12,2)
);