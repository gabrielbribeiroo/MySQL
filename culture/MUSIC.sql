-- DATABASE: music_school
-- Music school management with instruments, teachers, classes, performances, and student evaluations.

CREATE DATABASE music_school
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE music_school;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    role ENUM('student','teacher','admin') NOT NULL,
    phone VARCHAR(40),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    birth_date DATE,
    guardian_name VARCHAR(150),
    address TEXT,
    FOREIGN KEY (student_id) REFERENCES users(user_id)
);

CREATE TABLE instruments (
    instrument_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    type VARCHAR(100),
    difficulty ENUM('beginner','intermediate','advanced') DEFAULT 'beginner'
);

CREATE TABLE teachers (
    teacher_id INT PRIMARY KEY,
    biography TEXT,
    years_experience INT DEFAULT 0,
    FOREIGN KEY (teacher_id) REFERENCES users(user_id)
);

-- Teacher specialization (many-to-many)
CREATE TABLE teacher_instruments (
    teacher_id INT NOT NULL,
    instrument_id INT NOT NULL,
    PRIMARY KEY(teacher_id, instrument_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),
    FOREIGN KEY (instrument_id) REFERENCES instruments(instrument_id)
);

CREATE TABLE classes (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    instrument_id INT NOT NULL,
    teacher_id INT NOT NULL,
    level ENUM('beginner','intermediate','advanced') DEFAULT 'beginner',
    schedule VARCHAR(100),   -- e.g., Mondays 18:00
    capacity INT DEFAULT 10,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (instrument_id) REFERENCES instruments(instrument_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

-- Students enrolled (many-to-many)
CREATE TABLE class_students (
    class_id INT NOT NULL,
    student_id INT NOT NULL,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(class_id, student_id),
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

CREATE TABLE evaluations (
    evaluation_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    class_id INT NOT NULL,
    teacher_id INT NOT NULL,
    evaluation_date DATE NOT NULL,
    score DECIMAL(4,2),      -- numeric score
    comments TEXT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

CREATE TABLE performances (
    performance_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    event_date DATE NOT NULL,
    location VARCHAR(200),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Students participating in performances
CREATE TABLE performance_participants (
    performance_id INT NOT NULL,
    student_id INT NOT NULL,
    role VARCHAR(150),     -- soloist, accompanist, etc.
    PRIMARY KEY(performance_id, student_id),
    FOREIGN KEY (performance_id) REFERENCES performances(performance_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);


CREATE TABLE lessons (
    lesson_id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_id INT NOT NULL,
    student_id INT NOT NULL,
    instrument_id INT NOT NULL,
    lesson_date DATETIME NOT NULL,
    duration_minutes INT DEFAULT 60,
    notes TEXT,
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (instrument_id) REFERENCES instruments(instrument_id)
);