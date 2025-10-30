-- Database: swimming_club
-- Swimming club management system with athletes, coaches, pool lanes, training logs, and competition results

CREATE DATABASE swimming_club
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE swimming_club;

CREATE TABLE coaches (
    coach_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20),
    certification_level ENUM('Level 1', 'Level 2', 'Level 3', 'Elite') DEFAULT 'Level 1',
    hire_date DATE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE athletes (
    athlete_id INT AUTO_INCREMENT PRIMARY KEY,
    coach_id INT,
    name VARCHAR(150) NOT NULL,
    gender ENUM('M', 'F', 'Other'),
    birth_date DATE,
    category ENUM('Junior', 'Senior', 'Master') DEFAULT 'Junior',
    registration_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (coach_id) REFERENCES coaches(coach_id)
);