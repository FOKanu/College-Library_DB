-- ============================================================
-- University Library & Research Management System
-- Database Schema (DDL)
-- Course: Database Systems (BIT3.1) | SS 2026
-- Group 3: Francis Okorie Iyeke-Kanu, Dhrumil Khandla
-- ============================================================
-- Requires MySQL 8.0+ (CHECK constraints are enforced from 8.0)
-- ============================================================

CREATE DATABASE IF NOT EXISTS library_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE library_db;


-- ============================================================
-- MODULE 1: LIBRARY MANAGEMENT
-- Tables: departments, categories, users, books, copies,
--         borrow_records, reservations, fines
-- ============================================================

-- ------------------------------------------------------------
-- DEPARTMENTS
-- No dependencies.
-- ------------------------------------------------------------
CREATE TABLE departments (
    department_id   INT          NOT NULL AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    building        VARCHAR(100) NOT NULL,
    PRIMARY KEY (department_id)
) ENGINE=InnoDB;


-- ------------------------------------------------------------
-- CATEGORIES
-- No dependencies.
-- ------------------------------------------------------------
CREATE TABLE categories (
    category_id   INT          NOT NULL AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description   TEXT,
    PRIMARY KEY (category_id)
) ENGINE=InnoDB;


-- ------------------------------------------------------------
-- USERS
-- Depends on: departments
-- borrow_limit defaults to 5; adjust per role in application logic.
-- ------------------------------------------------------------
CREATE TABLE users (
    user_id       INT                                          NOT NULL AUTO_INCREMENT,
    name          VARCHAR(100)                                 NOT NULL,
    email         VARCHAR(100)                                 NOT NULL,
    role          ENUM('student','faculty','staff','admin')    NOT NULL,
    contact       VARCHAR(100),
    borrow_limit  INT                                          NOT NULL DEFAULT 5,
    department_id INT,
    PRIMARY KEY (user_id),
    UNIQUE KEY uq_users_email (email),
    CONSTRAINT fk_users_department
        FOREIGN KEY (department_id) REFERENCES departments (department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    CONSTRAINT chk_borrow_limit CHECK (borrow_limit > 0)
) ENGINE=InnoDB;


-- ------------------------------------------------------------
-- BOOKS
-- Depends on: categories
-- primary_author stores a single author string (Option A).
-- category_id is nullable: a book can be uncategorised.
-- ------------------------------------------------------------
CREATE TABLE books (
    book_id          INT          NOT NULL AUTO_INCREMENT,
    title            VARCHAR(200) NOT NULL,
    isbn             VARCHAR(20),
    primary_author   VARCHAR(150),
    publisher        VARCHAR(150),
    publication_year INT,
    pages            INT,
    is_textbook      BOOLEAN      NOT NULL DEFAULT FALSE,
    category_id      INT,
    PRIMARY KEY (book_id),
    UNIQUE KEY uq_books_isbn (isbn),
    CONSTRAINT fk_books_category
        FOREIGN KEY (category_id) REFERENCES categories (category_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    CONSTRAINT chk_publication_year CHECK (publication_year > 1000 AND publication_year <= 2100),
    CONSTRAINT chk_pages CHECK (pages > 0)
) ENGINE=InnoDB;


-- ------------------------------------------------------------
-- COPIES
-- Depends on: books
-- Each row is one physical copy of a book.
-- ON DELETE RESTRICT: cannot delete a book while copies exist.
-- ------------------------------------------------------------
CREATE TABLE copies (
    copy_id INT                                                              NOT NULL AUTO_INCREMENT,
    book_id INT                                                              NOT NULL,
    status  ENUM('available','borrowed','reserved','damaged','lost')         NOT NULL DEFAULT 'available',
    PRIMARY KEY (copy_id),
    CONSTRAINT fk_copies_book
        FOREIGN KEY (book_id) REFERENCES books (book_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;


-- ------------------------------------------------------------
-- BORROW_RECORDS
-- Depends on: users, copies
-- return_date is NULL while the book is still out.
-- ON DELETE RESTRICT: preserves history; records cannot be deleted
-- while referenced by fines.
-- ------------------------------------------------------------
CREATE TABLE borrow_records (
    borrow_id   INT  NOT NULL AUTO_INCREMENT,
    user_id     INT  NOT NULL,
    copy_id     INT  NOT NULL,
    borrow_date DATE NOT NULL,
    due_date    DATE NOT NULL,
    return_date DATE,
    PRIMARY KEY (borrow_id),
    CONSTRAINT fk_borrow_user
        FOREIGN KEY (user_id) REFERENCES users (user_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_borrow_copy
        FOREIGN KEY (copy_id) REFERENCES copies (copy_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_due_after_borrow
        CHECK (due_date >= borrow_date),
    CONSTRAINT chk_return_after_borrow
        CHECK (return_date IS NULL OR return_date >= borrow_date)
) ENGINE=InnoDB;


-- ------------------------------------------------------------
-- RESERVATIONS
-- Depends on: books, users
-- queue_position orders waiting users per book (1 = next in line).
-- ------------------------------------------------------------
CREATE TABLE reservations (
    reservation_id   INT                                              NOT NULL AUTO_INCREMENT,
    book_id          INT                                              NOT NULL,
    user_id          INT                                              NOT NULL,
    reservation_date DATE                                             NOT NULL,
    status           ENUM('active','fulfilled','cancelled','expired') NOT NULL DEFAULT 'active',
    expiry_date      DATE                                             NOT NULL,
    queue_position   INT                                              NOT NULL,
    PRIMARY KEY (reservation_id),
    CONSTRAINT fk_reservation_book
        FOREIGN KEY (book_id) REFERENCES books (book_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_reservation_user
        FOREIGN KEY (user_id) REFERENCES users (user_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_expiry_after_reservation
        CHECK (expiry_date >= reservation_date),
    CONSTRAINT chk_queue_position
        CHECK (queue_position > 0)
) ENGINE=InnoDB;


-- ------------------------------------------------------------
-- FINES
-- Depends on: borrow_records
-- payment_date must be set when status is 'paid' or 'waived'.
-- ------------------------------------------------------------
CREATE TABLE fines (
    fine_id      INT           NOT NULL AUTO_INCREMENT,
    borrow_id    INT           NOT NULL,
    amount       DECIMAL(10,2) NOT NULL,
    paid_status  ENUM('unpaid','paid','waived') NOT NULL DEFAULT 'unpaid',
    payment_date DATE,
    PRIMARY KEY (fine_id),
    CONSTRAINT fk_fines_borrow
        FOREIGN KEY (borrow_id) REFERENCES borrow_records (borrow_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_fine_amount
        CHECK (amount > 0),
    CONSTRAINT chk_payment_date
        CHECK (paid_status = 'unpaid' OR payment_date IS NOT NULL)
) ENGINE=InnoDB;


-- ============================================================
-- MODULE 2: ACADEMIC INTEGRATION
-- Tables: courses, textbook_courses
-- ============================================================

-- ------------------------------------------------------------
-- COURSES
-- Depends on: departments
-- ------------------------------------------------------------
CREATE TABLE courses (
    course_id     INT          NOT NULL AUTO_INCREMENT,
    course_code   VARCHAR(20)  NOT NULL,
    course_name   VARCHAR(100) NOT NULL,
    department_id INT,
    PRIMARY KEY (course_id),
    UNIQUE KEY uq_courses_code (course_code),
    CONSTRAINT fk_courses_department
        FOREIGN KEY (department_id) REFERENCES departments (department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;


-- ------------------------------------------------------------
-- TEXTBOOK_COURSES
-- Depends on: books, courses, users (professor)
-- semester format: 'SS2026' or 'WS2526'.
-- Unique constraint prevents the same book being listed twice
-- for the same course in the same semester.
-- ------------------------------------------------------------
CREATE TABLE textbook_courses (
    tc_id        INT         NOT NULL AUTO_INCREMENT,
    book_id      INT         NOT NULL,
    course_id    INT         NOT NULL,
    semester     VARCHAR(10) NOT NULL,
    professor_id INT         NOT NULL,
    is_required  BOOLEAN     NOT NULL DEFAULT TRUE,
    PRIMARY KEY (tc_id),
    UNIQUE KEY uq_tc_book_course_semester (book_id, course_id, semester),
    CONSTRAINT fk_tc_book
        FOREIGN KEY (book_id) REFERENCES books (book_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_tc_course
        FOREIGN KEY (course_id) REFERENCES courses (course_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_tc_professor
        FOREIGN KEY (professor_id) REFERENCES users (user_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;


-- ============================================================
-- MODULE 3: RESEARCH MANAGEMENT
-- Tables: authors, publications, publication_authors,
--         citations, research_access, research_access_log
-- ============================================================

-- ------------------------------------------------------------
-- AUTHORS
-- No dependencies.
-- ------------------------------------------------------------
CREATE TABLE authors (
    author_id   INT          NOT NULL AUTO_INCREMENT,
    name        VARCHAR(100) NOT NULL,
    affiliation VARCHAR(150),
    email       VARCHAR(100),
    PRIMARY KEY (author_id)
) ENGINE=InnoDB;


-- ------------------------------------------------------------
-- PUBLICATIONS
-- No dependencies.
-- doi is unique: each publication has one DOI.
-- ------------------------------------------------------------
CREATE TABLE publications (
    publication_id   INT                                                    NOT NULL AUTO_INCREMENT,
    title            VARCHAR(200)                                           NOT NULL,
    type             ENUM('journal','conference','book_chapter','thesis')   NOT NULL,
    publication_date DATE,
    abstract         TEXT,
    doi              VARCHAR(100),
    PRIMARY KEY (publication_id),
    UNIQUE KEY uq_publications_doi (doi)
) ENGINE=InnoDB;


-- ------------------------------------------------------------
-- PUBLICATION_AUTHORS
-- Depends on: publications, authors
-- Composite PK ensures each author appears once per publication.
-- author_order (1 = first/lead author) preserves citation order.
-- ON DELETE CASCADE: removing a publication cleans up its author links.
-- ------------------------------------------------------------
CREATE TABLE publication_authors (
    publication_id INT NOT NULL,
    author_id      INT NOT NULL,
    author_order   INT NOT NULL,
    PRIMARY KEY (publication_id, author_id),
    CONSTRAINT fk_pa_publication
        FOREIGN KEY (publication_id) REFERENCES publications (publication_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_pa_author
        FOREIGN KEY (author_id) REFERENCES authors (author_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_author_order CHECK (author_order > 0)
) ENGINE=InnoDB;


-- ------------------------------------------------------------
-- CITATIONS
-- Depends on: publications (twice, self-referential)
-- citing_publication cites cited_publication.
-- ON DELETE CASCADE on citing side: if the citing paper is deleted,
-- its citation records go with it.
-- ON DELETE RESTRICT on cited side: cannot delete a publication
-- that others are citing.
-- ------------------------------------------------------------
CREATE TABLE citations (
    citation_id           INT  NOT NULL AUTO_INCREMENT,
    citing_publication_id INT  NOT NULL,
    cited_publication_id  INT  NOT NULL,
    citation_context      TEXT,
    PRIMARY KEY (citation_id),
    UNIQUE KEY uq_citation_pair (citing_publication_id, cited_publication_id),
    CONSTRAINT fk_citations_citing
        FOREIGN KEY (citing_publication_id) REFERENCES publications (publication_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_citations_cited
        FOREIGN KEY (cited_publication_id) REFERENCES publications (publication_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Self-citation CHECK omitted: MySQL rejects CHECK on FK columns used in
-- referential actions. Enforced via trigger instead (see below).


-- ------------------------------------------------------------
-- RESEARCH_ACCESS
-- Depends on: publications, users
-- Stores the access level granted to a specific user
-- for a specific publication.
-- Unique constraint: one access rule per user-publication pair.
-- ------------------------------------------------------------
CREATE TABLE research_access (
    access_id      INT                                        NOT NULL AUTO_INCREMENT,
    publication_id INT                                        NOT NULL,
    user_id        INT                                        NOT NULL,
    access_type    ENUM('open','restricted','subscription')   NOT NULL,
    PRIMARY KEY (access_id),
    UNIQUE KEY uq_research_access (publication_id, user_id),
    CONSTRAINT fk_ra_publication
        FOREIGN KEY (publication_id) REFERENCES publications (publication_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_ra_user
        FOREIGN KEY (user_id) REFERENCES users (user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;


-- ------------------------------------------------------------
-- RESEARCH_ACCESS_LOG
-- Depends on: research_access, users
-- Audit log of every access attempt: who, when, what action,
-- from which IP.
-- access_timestamp defaults to current time on insert.
-- ------------------------------------------------------------
CREATE TABLE research_access_log (
    log_id           INT          NOT NULL AUTO_INCREMENT,
    access_id        INT          NOT NULL,
    user_id          INT          NOT NULL,
    access_timestamp TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    action_type      VARCHAR(50),
    ip_address       VARCHAR(45),
    PRIMARY KEY (log_id),
    CONSTRAINT fk_ral_access
        FOREIGN KEY (access_id) REFERENCES research_access (access_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_ral_user
        FOREIGN KEY (user_id) REFERENCES users (user_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;


-- ============================================================
-- INDEXES
-- Added on columns used in frequent lookups and joins.
-- Primary key indexes are created automatically above.
-- ============================================================

-- Book searches and filtering
CREATE INDEX idx_books_title    ON books (title);
CREATE INDEX idx_books_category ON books (category_id);
CREATE INDEX idx_books_author   ON books (primary_author);

-- Copy availability checks
CREATE INDEX idx_copies_book   ON copies (book_id);
CREATE INDEX idx_copies_status ON copies (status);

-- Borrow record lookups
CREATE INDEX idx_borrow_user ON borrow_records (user_id);
CREATE INDEX idx_borrow_copy ON borrow_records (copy_id);

-- Reservation queue lookups (most critical: book + status + position)
CREATE INDEX idx_reservations_user  ON reservations (user_id);
CREATE INDEX idx_reservations_queue ON reservations (book_id, status, queue_position);

-- Fine lookups
CREATE INDEX idx_fines_borrow ON fines (borrow_id);
CREATE INDEX idx_fines_status ON fines (paid_status);

-- Publication searches
CREATE INDEX idx_publications_type ON publications (type);
CREATE INDEX idx_publications_date ON publications (publication_date);

-- Access log queries (by user and by time)
CREATE INDEX idx_ral_user      ON research_access_log (user_id);
CREATE INDEX idx_ral_timestamp ON research_access_log (access_timestamp);


-- ============================================================
-- TRIGGERS
-- Business rules that cannot be expressed as CHECK constraints
-- when columns participate in FK referential actions.
-- ============================================================

DELIMITER //

CREATE TRIGGER trg_citations_no_self_insert
BEFORE INSERT ON citations
FOR EACH ROW
BEGIN
    IF NEW.citing_publication_id = NEW.cited_publication_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'A publication cannot cite itself';
    END IF;
END//

CREATE TRIGGER trg_citations_no_self_update
BEFORE UPDATE ON citations
FOR EACH ROW
BEGIN
    IF NEW.citing_publication_id = NEW.cited_publication_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'A publication cannot cite itself';
    END IF;
END//

DELIMITER ;
