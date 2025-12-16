-- Database: photo_gallery
-- Digital photo gallery system with photographers, albums, licensing, and purchase options.

CREATE DATABASE photo_gallery
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE photo_gallery;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    role ENUM('photographer','customer','admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE photographers (
    photographer_id INT PRIMARY KEY,
    biography TEXT,
    website VARCHAR(200),
    FOREIGN KEY (photographer_id) REFERENCES users(user_id)
);

CREATE TABLE albums (
    album_id INT AUTO_INCREMENT PRIMARY KEY,
    photographer_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    is_public BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (photographer_id) REFERENCES photographers(photographer_id)
);


CREATE TABLE photos (
    photo_id INT AUTO_INCREMENT PRIMARY KEY,
    album_id INT NOT NULL,
    title VARCHAR(200),
    description TEXT,
    file_url VARCHAR(300) NOT NULL,
    thumbnail_url VARCHAR(300),
    width INT,
    height INT,
    camera_model VARCHAR(150),
    taken_date DATE,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (album_id) REFERENCES albums(album_id)
);

CREATE TABLE licenses (
    license_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    usage_type ENUM('personal','editorial','commercial') NOT NULL
);


CREATE TABLE photo_licenses (
    photo_id INT NOT NULL,
    license_id INT NOT NULL,
    PRIMARY KEY(photo_id, license_id),
    FOREIGN KEY (photo_id) REFERENCES photos(photo_id),
    FOREIGN KEY (license_id) REFERENCES licenses(license_id)
);


CREATE TABLE purchases (
    purchase_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(12,2),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE purchase_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    purchase_id INT NOT NULL,
    photo_id INT NOT NULL,
    license_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (purchase_id) REFERENCES purchases(purchase_id),
    FOREIGN KEY (photo_id) REFERENCES photos(photo_id),
    FOREIGN KEY (license_id) REFERENCES licenses(license_id)
);