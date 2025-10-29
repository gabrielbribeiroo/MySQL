-- Database: research_repository
-- Repository for academic publications, theses, and research data sharing among institutions

CREATE DATABASE research_repository
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_general_ci;

USE research_repository;

CREATE TABLE institutions (
    institution_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    acronym VARCHAR(20),
    country VARCHAR(100),
    city VARCHAR(100),
    website VARCHAR(150),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE researchers (
    researcher_id INT AUTO_INCREMENT PRIMARY KEY,
    institution_id INT,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE,
    orcid VARCHAR(30),
    research_area VARCHAR(150),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (institution_id) REFERENCES institutions(institution_id)
);

CREATE TABLE publications (
    publication_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    abstract TEXT,
    publication_type ENUM('article', 'thesis', 'dissertation', 'report', 'dataset') DEFAULT 'article',
    publication_date DATE,
    doi VARCHAR(100) UNIQUE,
    repository_link VARCHAR(255),
    institution_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (institution_id) REFERENCES institutions(institution_id)
);

CREATE TABLE publication_authors (
    publication_id INT NOT NULL,
    researcher_id INT NOT NULL,
    author_order INT DEFAULT 1,
    PRIMARY KEY (publication_id, researcher_id),
    FOREIGN KEY (publication_id) REFERENCES publications(publication_id),
    FOREIGN KEY (researcher_id) REFERENCES researchers(researcher_id)
);

CREATE TABLE keywords (
    keyword_id INT AUTO_INCREMENT PRIMARY KEY,
    keyword VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE publication_keywords (
    publication_id INT NOT NULL,
    keyword_id INT NOT NULL,
    PRIMARY KEY (publication_id, keyword_id),
    FOREIGN KEY (publication_id) REFERENCES publications(publication_id),
    FOREIGN KEY (keyword_id) REFERENCES keywords(keyword_id)
);