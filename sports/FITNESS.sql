-- Database: fitness_app
-- Personal fitness tracking system with exercises, nutrition plans, goals, and progress monitoring

CREATE DATABASE fitness_app
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE fitness_app;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    gender ENUM('M', 'F', 'Other'),
    birth_date DATE,
    height_cm DECIMAL(5,2),
    weight_kg DECIMAL(5,2),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE exercises (
    exercise_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    category ENUM('Strength', 'Cardio', 'Flexibility', 'Balance', 'Other') DEFAULT 'Other',
    muscle_group VARCHAR(100),
    equipment_needed VARCHAR(150),
    description TEXT
);

CREATE TABLE workouts (
    workout_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    date DATE DEFAULT (CURRENT_DATE),
    duration_minutes INT,
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE workout_exercises (
    workout_exercise_id INT AUTO_INCREMENT PRIMARY KEY,
    workout_id INT NOT NULL,
    exercise_id INT NOT NULL,
    sets INT DEFAULT 3,
    reps INT DEFAULT 10,
    weight_kg DECIMAL(5,2),
    rest_seconds INT,
    FOREIGN KEY (workout_id) REFERENCES workouts(workout_id),
    FOREIGN KEY (exercise_id) REFERENCES exercises(exercise_id)
);

CREATE TABLE nutrition_plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(150),
    calories_target INT,
    protein_target_g DECIMAL(6,2),
    carbs_target_g DECIMAL(6,2),
    fat_target_g DECIMAL(6,2),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);