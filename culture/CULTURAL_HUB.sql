CREATE DATABASE cultural_hub;
USE cultural_hub;

CREATE TABLE artists (
    artist_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_date DATE,
    nationality VARCHAR(100),
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE exhibitions (
    exhibition_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    location VARCHAR(150),
    start_date DATE,
    end_date DATE,
    theme TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE exhibition_artworks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    exhibition_id INT,
    artwork_id INT,
    display_order INT,
    FOREIGN KEY (exhibition_id) REFERENCES exhibitions(exhibition_id),
    FOREIGN KEY (artwork_id) REFERENCES artworks(artwork_id)
);

CREATE TABLE cultural_events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    category VARCHAR(100), -- festival, oficina, sarau, etc.
    description TEXT,
    location VARCHAR(150),
    event_date DATE,
    organizer VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE media_productions (
    media_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    type VARCHAR(50), -- filme, podcast, etc.
    release_year INT,
    synopsis TEXT,
    link VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cultural_spaces (
    space_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    address VARCHAR(255),
    type VARCHAR(100), -- museu, centro cultural, teatro
    capacity INT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE traditions (
    tradition_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    region VARCHAR(100),
    description TEXT,
    recognition_status VARCHAR(100), -- ex: patrimônio imaterial
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE community_feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT,
    author_name VARCHAR(100),
    feedback_text TEXT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES cultural_events(event_id)
);