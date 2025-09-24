-- Database: podcast_platform
CREATE DATABASE podcast_platform
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE podcast_platform;

CREATE TABLE hosts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    bio TEXT,
    joined_at DATE DEFAULT CURRENT_DATE
);

CREATE TABLE podcasts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    host_id INTEGER REFERENCES hosts(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE episodes (
    id SERIAL PRIMARY KEY,
    podcast_id INTEGER REFERENCES podcasts(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    duration INTERVAL, -- duração do episódio
    published_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    audio_url TEXT NOT NULL
);

CREATE TABLE listeners (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE episode_stats (
    id SERIAL PRIMARY KEY,
    episode_id INTEGER REFERENCES episodes(id) ON DELETE CASCADE,
    listener_id INTEGER REFERENCES listeners(id) ON DELETE CASCADE,
    listened_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    progress DECIMAL(5,2) CHECK (progress >= 0 AND progress <= 100) -- % do episódio ouvido
);