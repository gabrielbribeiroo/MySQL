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

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    position_id INT REFERENCES positions(id),
    salary NUMERIC(12,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'Ativo'
);

CREATE TABLE payroll (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id),
    pay_date DATE NOT NULL,
    base_salary NUMERIC(12,2) NOT NULL,
    bonuses NUMERIC(12,2) DEFAULT 0,
    deductions NUMERIC(12,2) DEFAULT 0,
    net_salary NUMERIC(12,2) NOT NULL
);

CREATE TABLE benefits (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id),
    benefit_type VARCHAR(100) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE
);

CREATE TABLE vacations (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    approved_by VARCHAR(150),
    status VARCHAR(50) DEFAULT 'Pendent'
);

CREATE TABLE performance_reviews (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id),
    review_date DATE NOT NULL,
    reviewer VARCHAR(150) NOT NULL,
    score INT CHECK (score BETWEEN 1 AND 10),
    comments TEXT
);