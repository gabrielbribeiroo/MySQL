-- Database: insurance_platform
CREATE DATABASE insurance_platform
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE insurance_platform;

CREATE TABLE policyholders (
    policyholder_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    cpf_cnpj VARCHAR(20) UNIQUE NOT NULL,
    birth_date DATE,
    email VARCHAR(120),
    phone VARCHAR(20),
    address VARCHAR(200),
    registration_date DATE DEFAULT (CURRENT_DATE)
);