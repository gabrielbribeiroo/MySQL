-- Database: restaurant_management
CREATE DATABASE restaurant_management
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE restaurant_management;

CREATE TABLE menu_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);