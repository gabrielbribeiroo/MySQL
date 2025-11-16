-- Database: nutrition_center
-- Nutrition center management system with client dietary records, meal plans, and nutrition assessments.
CREATE DATABASE nutrition_center
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE nutrition_center;

CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL,
    birth_date DATE NOT NULL,
    gender ENUM('male', 'female', 'other') NOT NULL,
    email VARCHAR(120) UNIQUE,
    phone VARCHAR(30),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE nutritionists (
    nutritionist_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL,
    certification_number VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(120) UNIQUE,
    phone VARCHAR(30),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    nutritionist_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (nutritionist_id) REFERENCES nutritionists(nutritionist_id)
);

CREATE TABLE meal_plans (
    meal_plan_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    nutritionist_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    goal VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (nutritionist_id) REFERENCES nutritionists(nutritionist_id)
);

CREATE TABLE meal_plan_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    meal_plan_id INT NOT NULL,
    meal_time ENUM('breakfast', 'lunch', 'dinner', 'snack') NOT NULL,
    food_description VARCHAR(255) NOT NULL,
    calories INT,
    proteins DECIMAL(5,2),
    carbs DECIMAL(5,2),
    fats DECIMAL(5,2),
    FOREIGN KEY (meal_plan_id) REFERENCES meal_plans(meal_plan_id)
);

CREATE TABLE food_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    log_date DATE NOT NULL,
    meal_time ENUM('breakfast', 'lunch', 'dinner', 'snack') NOT NULL,
    food_description VARCHAR(255) NOT NULL,
    calories INT,
    proteins DECIMAL(5,2),
    carbs DECIMAL(5,2),
    fats DECIMAL(5,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE nutrition_goals (
    goal_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    description VARCHAR(255) NOT NULL,
    target_value DECIMAL(8,2),
    metric ENUM('weight', 'body_fat', 'calories', 'proteins', 'carbs', 'fats') NOT NULL,
    deadline DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);