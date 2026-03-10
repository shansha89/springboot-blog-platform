CREATE TABLE users(
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    created_at TIMESTAMP,
    modified_at TIMESTAMP,
    name VARCHAR(128) NOT NULL,
    email VARCHAR(128) UNIQUE,
    password VARCHAR(255),
    role VARCHAR(50),
);