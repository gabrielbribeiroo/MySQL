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

CREATE TABLE installments (
    installment_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    installment_number INT NOT NULL,
    due_date DATE NOT NULL,
    amount_due DECIMAL(12,2) NOT NULL,
    amount_paid DECIMAL(12,2),
    payment_date DATE,
    status ENUM('pending', 'paid', 'late') DEFAULT 'pending',
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    installment_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount_paid DECIMAL(12,2) NOT NULL,
    payment_method ENUM('pix', 'boleto', 'transfer', 'card') DEFAULT 'pix',
    FOREIGN KEY (installment_id) REFERENCES installments(installment_id)
);

CREATE TABLE overdue_accounts (
    overdue_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    days_overdue INT NOT NULL,
    penalty_fee DECIMAL(10,2) DEFAULT 0.00,
    last_update DATE DEFAULT (CURRENT_DATE),
    resolved BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

CREATE TABLE interest_rate_history (
    rate_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    old_rate DECIMAL(5,2),
    new_rate DECIMAL(5,2),
    change_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);