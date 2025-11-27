-- Database: academic_network
-- Academic collaboration network with profiles, institutions, publications, and joint projects.

CREATE DATABASE academic_network
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE academic_network;

CREATE TABLE academics (
    academic_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    institution_id INT,
    bio TEXT,
    research_interests TEXT,
    website VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE institutions (
    institution_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    country VARCHAR(100),
    city VARCHAR(100),
    type ENUM('University', 'Institute', 'Research Center', 'Laboratory', 'Other') DEFAULT 'University',
    founded_year INT
);

ALTER TABLE academics
    ADD FOREIGN KEY (institution_id) REFERENCES institutions(institution_id);

CREATE TABLE research_areas (
    area_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) UNIQUE NOT NULL
);

-- Many-to-Many between academics and research areas
CREATE TABLE academic_research_areas (
    academic_id INT,
    area_id INT,
    PRIMARY KEY(academic_id, area_id),
    FOREIGN KEY (academic_id) REFERENCES academics(academic_id),
    FOREIGN KEY (area_id) REFERENCES research_areas(area_id)
);

CREATE TABLE publications (
    publication_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(300) NOT NULL,
    abstract TEXT,
    publication_year INT,
    publication_type ENUM('Article','Conference Paper','Book','Thesis','Report'),
    doi VARCHAR(200),
    url VARCHAR(300),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Many-to-Many (authors of each publication)
CREATE TABLE publication_authors (
    publication_id INT,
    academic_id INT,
    author_order INT,
    PRIMARY KEY(publication_id, academic_id),
    FOREIGN KEY (publication_id) REFERENCES publications(publication_id),
    FOREIGN KEY (academic_id) REFERENCES academics(academic_id)
);