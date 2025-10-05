-- Database: loan_management
CREATE DATABASE loan_management
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE loan_management;

CREATE TABLE borrowers (
    borrower_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    cpf CHAR(11) UNIQUE NOT NULL,
    email VARCHAR(120),
    phone VARCHAR(20),
    address VARCHAR(200),
    registration_date DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    borrower_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    start_date DATE NOT NULL,
    due_date DATE NOT NULL,
    total_installments INT NOT NULL,
    status ENUM('active', 'paid', 'late', 'canceled') DEFAULT 'active',
    FOREIGN KEY (borrower_id) REFERENCES borrowers(borrower_id)
);