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

CREATE TABLE pool_lanes (
    lane_id INT AUTO_INCREMENT PRIMARY KEY,
    lane_number INT UNIQUE NOT NULL,
    length_meters INT DEFAULT 25,
    status ENUM('available', 'occupied', 'maintenance') DEFAULT 'available',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE training_sessions (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    coach_id INT,
    session_date DATE NOT NULL,
    start_time TIME,
    end_time TIME,
    focus ENUM('Endurance', 'Speed', 'Technique', 'Recovery') DEFAULT 'Endurance',
    notes TEXT,
    FOREIGN KEY (coach_id) REFERENCES coaches(coach_id)
);

CREATE TABLE training_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT NOT NULL,
    athlete_id INT NOT NULL,
    lane_id INT,
    distance_meters INT,
    time_seconds DECIMAL(6,2),
    stroke ENUM('Freestyle', 'Backstroke', 'Breaststroke', 'Butterfly', 'Medley'),
    comments TEXT,
    FOREIGN KEY (session_id) REFERENCES training_sessions(session_id),
    FOREIGN KEY (athlete_id) REFERENCES athletes(athlete_id),
    FOREIGN KEY (lane_id) REFERENCES pool_lanes(lane_id)
);

CREATE TABLE competitions (
    competition_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    location VARCHAR(150),
    start_date DATE,
    end_date DATE,
    level ENUM('Local', 'Regional', 'National', 'International') DEFAULT 'Local'
);

CREATE TABLE competition_events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    competition_id INT NOT NULL,
    event_name VARCHAR(150) NOT NULL,
    distance_meters INT,
    stroke ENUM('Freestyle', 'Backstroke', 'Breaststroke', 'Butterfly', 'Medley'),
    gender_category ENUM('M', 'F', 'Mixed'),
    FOREIGN KEY (competition_id) REFERENCES competitions(competition_id)
);

CREATE TABLE competition_results (
    result_id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    athlete_id INT NOT NULL,
    position INT,
    time_seconds DECIMAL(6,2),
    points INT,
    FOREIGN KEY (event_id) REFERENCES competition_events(event_id),
    FOREIGN KEY (athlete_id) REFERENCES athletes(athlete_id)
);

CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT NOT NULL,
    athlete_id INT NOT NULL,
    status ENUM('Present', 'Absent', 'Justified') DEFAULT 'Present',
    FOREIGN KEY (session_id) REFERENCES training_sessions(session_id),
    FOREIGN KEY (athlete_id) REFERENCES athletes(athlete_id)
);