-- Database for tracking legislative proposals, their authors, topics, stages, and votes
-- Create database
CREATE DATABASE IF NOT EXISTS law_proposals
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE law_proposals;

CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(100), -- e.g., Senator, Representative
    party VARCHAR(100),
    state VARCHAR(100)
);

CREATE TABLE topics (
    topic_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT
);

CREATE TABLE law_proposals (
    proposal_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    summary TEXT,
    date_submitted DATE NOT NULL,
    status VARCHAR(100) NOT NULL, -- e.g., In Progress, Approved, Rejected
    author_id INT REFERENCES authors(author_id),
    topic_id INT REFERENCES topics(topic_id)
);

CREATE TABLE proposal_stages (
    stage_id SERIAL PRIMARY KEY,
    proposal_id INT REFERENCES law_proposals(proposal_id),
    stage_name VARCHAR(255) NOT NULL, -- e.g., Committee Review, Plenary Vote
    description TEXT,
    stage_date DATE NOT NULL
);