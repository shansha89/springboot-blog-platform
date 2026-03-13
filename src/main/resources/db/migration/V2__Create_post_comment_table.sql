CREATE TABLE posts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    title VARCHAR(255),
    content TEXT,
    author_id BIGINT,
    CONSTRAINT fk_author FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE comments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    content TEXT,
    post_id BIGINT,
    user_id BIGINT,
    CONSTRAINT fk_post FOREIGN KEY (post_id) REFERENCES posts(id),
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id)
);