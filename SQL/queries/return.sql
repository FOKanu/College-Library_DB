-- Prerequisite: run schema.sql and insert.sql first.
-- DML steps change data — re-run insert.sql to reset.
-- ============================================================
-- Workflow 2: Return Process
-- Course style: SELECT-FROM-WHERE, date comparison, DML
-- Example: Bob Student (user_id = 5) returns copy_id = 15 (overdue)
-- ============================================================

USE library_db;


-- ------------------------------------------------------------
-- Step 1: Find active borrow records for a user
-- return_date IS NULL means the book is still out.
-- ------------------------------------------------------------
SELECT  br.borrow_id,
        u.name,
        b.title,
        c.copy_id,
        br.borrow_date,
        br.due_date,
        br.return_date
FROM    users AS u, borrow_records AS br, copies AS c, books AS b
WHERE   u.user_id = br.user_id
  AND   br.copy_id = c.copy_id
  AND   c.book_id = b.book_id
  AND   u.user_id = 5
  AND   br.return_date IS NULL;


-- ------------------------------------------------------------
-- Step 2: Check if the loan is overdue
-- due_date before today = overdue.
-- ------------------------------------------------------------
SELECT  br.borrow_id,
        u.name,
        b.title,
        br.due_date,
        CURDATE() AS today,
        DATEDIFF(CURDATE(), br.due_date) AS days_overdue
FROM    users AS u, borrow_records AS br, copies AS c, books AS b
WHERE   u.user_id = br.user_id
  AND   br.copy_id = c.copy_id
  AND   c.book_id = b.book_id
  AND   br.borrow_id = 5
  AND   br.return_date IS NULL
  AND   br.due_date < CURDATE();


-- ------------------------------------------------------------
-- Step 3: Calculate a fine for an overdue return
-- Simple rule: 2.50 per overdue day (for demonstration).
-- ------------------------------------------------------------
SELECT  br.borrow_id,
        u.name,
        DATEDIFF(CURDATE(), br.due_date) AS days_overdue,
        DATEDIFF(CURDATE(), br.due_date) * 2.50 AS fine_amount
FROM    users AS u, borrow_records AS br
WHERE   u.user_id = br.user_id
  AND   br.borrow_id = 5
  AND   br.return_date IS NULL
  AND   br.due_date < CURDATE();


-- ------------------------------------------------------------
-- Step 4: Process the return
-- a) Set return_date on the borrow record
-- b) Set copy status back to 'available'
-- c) Insert a fine if overdue (skip if fine already exists)
-- ------------------------------------------------------------

-- 4a) Record the return date
UPDATE borrow_records
SET    return_date = CURDATE()
WHERE  borrow_id = 5
  AND  return_date IS NULL;

-- 4b) Make the copy available again
UPDATE copies
SET    status = 'available'
WHERE  copy_id = 15;

-- 4c) Add fine only when overdue and no fine exists yet
INSERT INTO fines (borrow_id, amount, paid_status, payment_date)
SELECT  br.borrow_id,
        DATEDIFF(CURDATE(), br.due_date) * 2.50,
        'unpaid',
        NULL
FROM    borrow_records AS br
WHERE   br.borrow_id = 5
  AND   br.due_date < CURDATE()
  AND   br.borrow_id NOT IN (SELECT borrow_id FROM fines);


-- ------------------------------------------------------------
-- Step 5: Verify return and fine status
-- ------------------------------------------------------------
SELECT  u.name,
        b.title,
        br.borrow_date,
        br.due_date,
        br.return_date,
        f.amount,
        f.paid_status
FROM    users AS u, borrow_records AS br, copies AS c, books AS b, fines AS f
WHERE   u.user_id = br.user_id
  AND   br.copy_id = c.copy_id
  AND   c.book_id = b.book_id
  AND   br.borrow_id = f.borrow_id
  AND   br.borrow_id = 5;
