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

CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    status ENUM('ongoing','paused','completed') DEFAULT 'ongoing',
    funding_source VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Many-to-Many (project participants)
CREATE TABLE project_members (
    project_id INT,
    academic_id INT,
    role VARCHAR(150),
    joined_at DATE,
    PRIMARY KEY(project_id, academic_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    FOREIGN KEY (academic_id) REFERENCES academics(academic_id)
);

CREATE TABLE collaboration_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    status ENUM('pending','accepted','declined') DEFAULT 'pending',
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES academics(academic_id),
    FOREIGN KEY (receiver_id) REFERENCES academics(academic_id)
);

CREATE TABLE messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    content TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES academics(academic_id),
    FOREIGN KEY (receiver_id) REFERENCES academics(academic_id)
);

CREATE TABLE academic_events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    event_date DATE,
    location VARCHAR(200)
);

CREATE TABLE event_participants (
    event_id INT,
    academic_id INT,
    PRIMARY KEY(event_id, academic_id),
    FOREIGN KEY (event_id) REFERENCES academic_events(event_id),
    FOREIGN KEY (academic_id) REFERENCES academics(academic_id)
);

CREATE TABLE audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    academic_id INT,
    action VARCHAR(200),
    entity VARCHAR(100),
    entity_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (academic_id) REFERENCES academics(academic_id)
);
