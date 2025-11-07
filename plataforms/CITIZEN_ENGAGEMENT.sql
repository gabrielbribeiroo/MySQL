-- 🗣️ Database: citizen_engagement
-- Platform for community engagement with discussions, polls, and collaborative decision-making

CREATE DATABASE citizen_engagement
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE citizen_engagement;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    state VARCHAR(50),
    country VARCHAR(100) DEFAULT 'Brazil',
    role ENUM('Citizen', 'Moderator', 'Administrator') DEFAULT 'Citizen',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE communities (
    community_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    location VARCHAR(150),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

CREATE TABLE discussions (
    discussion_id INT AUTO_INCREMENT PRIMARY KEY,
    community_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    created_by INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Open', 'Closed', 'Archived') DEFAULT 'Open',
    FOREIGN KEY (community_id) REFERENCES communities(community_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    discussion_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    posted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (discussion_id) REFERENCES discussions(discussion_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE polls (
    poll_id INT AUTO_INCREMENT PRIMARY KEY,
    community_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    created_by INT NOT NULL,
    start_date DATETIME,
    end_date DATETIME,
    status ENUM('Draft', 'Open', 'Closed') DEFAULT 'Draft',
    FOREIGN KEY (community_id) REFERENCES communities(community_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);