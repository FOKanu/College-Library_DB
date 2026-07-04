-- Prerequisite: run schema.sql and insert.sql first.
-- DML steps (INSERT/UPDATE) change data — re-run insert.sql to reset.
-- ============================================================
-- Workflow 1: Borrowing Process
-- Course style: SELECT-FROM-WHERE, joins, subqueries, DML
-- Example user: Clara Student (user_id = 6)
-- Example book: Introduction to Algorithms (book_id = 3)
-- ============================================================

USE library_db;


-- ------------------------------------------------------------
-- Step 1: Check if the book has an available copy
-- ------------------------------------------------------------
SELECT  b.book_id,
        b.title,
        c.copy_id,
        c.status
FROM    books AS b, copies AS c
WHERE   b.book_id = c.book_id
  AND   b.book_id = 3
  AND   c.status = 'available';


-- ------------------------------------------------------------
-- Step 2: Check the user's borrow limit
-- Count active loans (return_date IS NULL) and compare to limit.
-- ------------------------------------------------------------
SELECT  u.user_id,
        u.name,
        u.borrow_limit,
        (SELECT COUNT(*)
         FROM   borrow_records AS br
         WHERE  br.user_id = u.user_id
           AND  br.return_date IS NULL) AS active_borrows
FROM    users AS u
WHERE   u.user_id = 6;


-- ------------------------------------------------------------
-- Step 3: Check if the user has any unpaid fines
-- If this returns rows, borrowing should be blocked.
-- ------------------------------------------------------------
SELECT  u.user_id,
        u.name,
        f.fine_id,
        f.amount,
        f.paid_status
FROM    users AS u, borrow_records AS br, fines AS f
WHERE   u.user_id = br.user_id
  AND   br.borrow_id = f.borrow_id
  AND   u.user_id = 6
  AND   f.paid_status = 'unpaid';


-- ------------------------------------------------------------
-- Step 4: Borrow the book (only if steps 1–3 pass)
-- a) Insert a new borrow record
-- b) Update the copy status to 'borrowed'
-- Use copy_id = 6 from Step 1 for book_id = 3.
-- ------------------------------------------------------------

-- 4a) Create borrow record (14-day loan)
INSERT INTO borrow_records (user_id, copy_id, borrow_date, due_date, return_date)
VALUES (6, 6, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), NULL);

-- 4b) Mark the copy as borrowed
UPDATE copies
SET    status = 'borrowed'
WHERE  copy_id = 6;


-- ------------------------------------------------------------
-- Step 5: Verify the borrow was recorded
-- ------------------------------------------------------------
SELECT  u.name,
        b.title,
        c.copy_id,
        br.borrow_date,
        br.due_date,
        br.return_date
FROM    users AS u, borrow_records AS br, copies AS c, books AS b
WHERE   u.user_id = br.user_id
  AND   br.copy_id = c.copy_id
  AND   c.book_id = b.book_id
  AND   u.user_id = 6
  AND   br.return_date IS NULL
ORDER BY br.borrow_date DESC;
