-- 📚 Database: knowledge_base
-- Internal documentation and knowledge-sharing system with articles, tags, and user contributions.

CREATE DATABASE knowledge_base
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE knowledge_base;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    role ENUM('writer','reviewer','admin') DEFAULT 'writer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);