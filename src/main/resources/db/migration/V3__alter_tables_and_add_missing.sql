-- ─────────────────────────────────────────────
-- Alter users table
-- ─────────────────────────────────────────────
ALTER TABLE users
    MODIFY COLUMN name          VARCHAR(100)  NOT NULL,
    MODIFY COLUMN email         VARCHAR(150)  NOT NULL,
    MODIFY COLUMN password      VARCHAR(255)  NOT NULL,
    MODIFY COLUMN created_at    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    MODIFY COLUMN updated_at    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
                                              ON UPDATE CURRENT_TIMESTAMP,
    MODIFY COLUMN role          VARCHAR(50)   NOT NULL DEFAULT 'ROLE_READER',
    ADD COLUMN    is_active     BOOLEAN       NOT NULL DEFAULT TRUE,
    ADD COLUMN    created_by    VARCHAR(100),
    ADD COLUMN    updated_by    VARCHAR(100);

-- ─────────────────────────────────────────────
-- Alter posts table
-- ─────────────────────────────────────────────
ALTER TABLE posts
    MODIFY COLUMN title         VARCHAR(255)  NOT NULL,
    MODIFY COLUMN content       LONGTEXT      NOT NULL,
    MODIFY COLUMN created_at    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    MODIFY COLUMN updated_at    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
                                              ON UPDATE CURRENT_TIMESTAMP,
    ADD COLUMN    slug          VARCHAR(255)  NOT NULL UNIQUE AFTER title,
    ADD COLUMN    status        VARCHAR(20)   NOT NULL DEFAULT 'DRAFT' AFTER content,
    ADD COLUMN    thumbnail_url VARCHAR(500)  AFTER status,
    ADD COLUMN    view_count    INT           NOT NULL DEFAULT 0 AFTER thumbnail_url,
    ADD COLUMN    published_at  TIMESTAMP     NULL AFTER view_count,
    ADD COLUMN    category_id   BIGINT        AFTER author_id,
    ADD COLUMN    created_by    VARCHAR(100),
    ADD COLUMN    updated_by    VARCHAR(100);

-- ─────────────────────────────────────────────
-- Alter comments table
-- ─────────────────────────────────────────────
ALTER TABLE comments
    -- rename content → body to match entity field
    CHANGE COLUMN content       body          TEXT NOT NULL,
    MODIFY COLUMN created_at    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    MODIFY COLUMN updated_at    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
                                              ON UPDATE CURRENT_TIMESTAMP,
    ADD COLUMN    parent_id     BIGINT        NULL AFTER user_id,
    ADD COLUMN    is_approved   BOOLEAN       NOT NULL DEFAULT TRUE AFTER parent_id,
    ADD COLUMN    created_by    VARCHAR(100),
    ADD COLUMN    updated_by    VARCHAR(100);

-- ─────────────────────────────────────────────
-- Add missing foreign keys
-- ─────────────────────────────────────────────

-- posts → categories (add FK after category table is created below)
-- posts author FK — add ON DELETE CASCADE
ALTER TABLE posts
    DROP FOREIGN KEY  fk_author,
    ADD  CONSTRAINT   fk_post_author
         FOREIGN KEY  (author_id)   REFERENCES users(id)  ON DELETE CASCADE;

-- comments — add ON DELETE CASCADE + parent_id FK
ALTER TABLE comments
    DROP FOREIGN KEY  fk_post,
    DROP FOREIGN KEY  fk_user,
    ADD  CONSTRAINT   fk_comment_post
         FOREIGN KEY  (post_id)     REFERENCES posts(id)   ON DELETE CASCADE,
    ADD  CONSTRAINT   fk_comment_user
         FOREIGN KEY  (user_id)     REFERENCES users(id)   ON DELETE CASCADE,
    ADD  CONSTRAINT   fk_comment_parent
         FOREIGN KEY  (parent_id)   REFERENCES comments(id) ON DELETE CASCADE;

-- ─────────────────────────────────────────────
-- New tables
-- ─────────────────────────────────────────────

CREATE TABLE categories (
    id          BIGINT        AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100)  NOT NULL UNIQUE,
    slug        VARCHAR(100)  NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
                              ON UPDATE CURRENT_TIMESTAMP,
    created_by  VARCHAR(100),
    updated_by  VARCHAR(100)
);

CREATE TABLE tags (
    id         BIGINT       AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(50)  NOT NULL UNIQUE,
    slug       VARCHAR(50)  NOT NULL UNIQUE,
    created_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
                            ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    updated_by VARCHAR(100)
);

CREATE TABLE post_tags (
    post_id BIGINT NOT NULL,
    tag_id  BIGINT NOT NULL,
    PRIMARY KEY (post_id, tag_id),
    CONSTRAINT fk_pt_post FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    CONSTRAINT fk_pt_tag  FOREIGN KEY (tag_id)  REFERENCES tags(id)  ON DELETE CASCADE
);

-- ─────────────────────────────────────────────
-- Add posts → categories FK (now that table exists)
-- ─────────────────────────────────────────────
ALTER TABLE posts
    ADD CONSTRAINT fk_post_category
        FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL;

-- ─────────────────────────────────────────────
-- Performance indexes
-- ─────────────────────────────────────────────
CREATE INDEX idx_posts_status      ON posts(status);
CREATE INDEX idx_posts_slug        ON posts(slug);
CREATE INDEX idx_posts_author_id   ON posts(author_id);
CREATE INDEX idx_posts_category_id ON posts(category_id);
CREATE INDEX idx_comments_post_id  ON comments(post_id);