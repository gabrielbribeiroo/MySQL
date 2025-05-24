-- Database: athlete_performance
CREATE DATABASE IF NOT EXISTS athlete_performance
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE athlete_performance;

-- Table: athletes
CREATE TABLE athletes (
    athlete_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    gender ENUM('M', 'F', 'Other') NOT NULL,
    nationality VARCHAR(50),
    sport VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: physical_tests
CREATE TABLE physical_tests (
    test_id INT AUTO_INCREMENT PRIMARY KEY,
    athlete_id INT NOT NULL,
    test_date DATE NOT NULL,
    test_type VARCHAR(50) NOT NULL,
    result_value DECIMAL(6,2),
    unit VARCHAR(20),
    notes TEXT,
    FOREIGN KEY (athlete_id) REFERENCES athletes(athlete_id)
);

-- Table: training_sessions
CREATE TABLE training_sessions (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    athlete_id INT NOT NULL,
    session_date DATE NOT NULL,
    duration_minutes INT,
    intensity_level ENUM('Low', 'Moderate', 'High') NOT NULL,
    focus_area VARCHAR(100),
    notes TEXT,
    FOREIGN KEY (athlete_id) REFERENCES athletes(athlete_id)
);