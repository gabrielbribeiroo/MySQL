-- Database: film_festival
-- Film festival management with submissions, screenings, juries, and awards

CREATE DATABASE film_festival
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE film_festival;

CREATE TABLE festivals (
    festival_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    edition_year YEAR NOT NULL,
    start_date DATE,
    end_date DATE,
    city VARCHAR(120),
    country VARCHAR(120) DEFAULT 'Brazil',
    status ENUM('upcoming','open_submissions','in_progress','completed') DEFAULT 'upcoming',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (name, edition_year)
);

CREATE TABLE venues (
    venue_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(120),
    capacity INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE screens (
    screen_id INT AUTO_INCREMENT PRIMARY KEY,
    venue_id INT NOT NULL,
    name VARCHAR(120) NOT NULL,           -- e.g., "Room 1", "Main Hall"
    seat_count INT,
    FOREIGN KEY (venue_id) REFERENCES venues(venue_id),
    UNIQUE (venue_id, name)
);

CREATE TABLE people (
    person_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    email VARCHAR(150) UNIQUE,
    nationality VARCHAR(120),
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE films (
    film_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(250) NOT NULL,
    synopsis TEXT,
    duration_minutes INT,
    release_year YEAR,
    country VARCHAR(120),
    language VARCHAR(120),
    premiere_status ENUM('world','international','national','none') DEFAULT 'none',
    film_url VARCHAR(300),                -- private screener link (if used)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Film credits (many-to-many)
CREATE TABLE film_credits (
    film_id INT NOT NULL,
    person_id INT NOT NULL,
    role ENUM('director','producer','writer','cinematographer','editor','composer','cast','other') DEFAULT 'other',
    PRIMARY KEY (film_id, person_id, role),
    FOREIGN KEY (film_id) REFERENCES films(film_id),
    FOREIGN KEY (person_id) REFERENCES people(person_id)
);

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    festival_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,           -- e.g., "Short Films", "Feature Films", "Documentary"
    description TEXT,
    competition_type ENUM('competition','non_competition') DEFAULT 'competition',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (festival_id) REFERENCES festivals(festival_id),
    UNIQUE (festival_id, name)
);

CREATE TABLE submissions (
    submission_id INT AUTO_INCREMENT PRIMARY KEY,
    festival_id INT NOT NULL,
    category_id INT NOT NULL,
    film_id INT NOT NULL,
    submitted_by INT,                     -- person (usually producer/director)
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('submitted','in_review','selected','rejected','withdrawn') DEFAULT 'submitted',
    notes TEXT,
    FOREIGN KEY (festival_id) REFERENCES festivals(festival_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (film_id) REFERENCES films(film_id),
    FOREIGN KEY (submitted_by) REFERENCES people(person_id),
    UNIQUE (festival_id, category_id, film_id)
);