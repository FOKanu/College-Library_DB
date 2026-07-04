-- Prerequisite: run schema.sql and insert.sql first.
-- DML steps change data — re-run insert.sql to reset.
-- ============================================================
-- Workflow 3: Reservation Queue Management
-- Course style: SELECT-FROM-WHERE, ORDER BY, aggregates, DML
-- Example book: Linear Algebra (book_id = 2) — all copies borrowed
-- ============================================================

USE library_db;


-- ------------------------------------------------------------
-- Step 1: Check if all copies of a book are currently out
-- If available_copies = 0, a reservation is needed.
-- ------------------------------------------------------------
SELECT  b.book_id,
        b.title,
        COUNT(*) AS total_copies,
        SUM(CASE WHEN c.status = 'available' THEN 1 ELSE 0 END) AS available_copies
FROM    books AS b, copies AS c
WHERE   b.book_id = c.book_id
  AND   b.book_id = 2
GROUP BY b.book_id, b.title;


-- ------------------------------------------------------------
-- Step 2: View the active reservation queue for a book
-- queue_position = 1 is next in line. Sorted ascending.
-- ------------------------------------------------------------
SELECT  r.reservation_id,
        b.title,
        u.name,
        r.reservation_date,
        r.expiry_date,
        r.queue_position,
        r.status
FROM    reservations AS r, books AS b, users AS u
WHERE   r.book_id = b.book_id
  AND   r.user_id = u.user_id
  AND   r.book_id = 2
  AND   r.status = 'active'
ORDER BY r.queue_position ASC;


-- ------------------------------------------------------------
-- Step 3: Add a new reservation (enqueue)
-- queue_position = current max + 1 for that book.
-- Example: Greta (user_id = 10) reserves book_id = 2.
-- ------------------------------------------------------------
INSERT INTO reservations (book_id, user_id, reservation_date, status, expiry_date, queue_position)
VALUES (
    2,
    10,
    CURDATE(),
    'active',
    DATE_ADD(CURDATE(), INTERVAL 30 DAY),
    (SELECT COALESCE(MAX(r.queue_position), 0) + 1
     FROM   reservations AS r
     WHERE  r.book_id = 2
       AND  r.status = 'active')
);


-- ------------------------------------------------------------
-- Step 4: Find the next user in line when a copy becomes free
-- ------------------------------------------------------------
SELECT  r.reservation_id,
        u.name,
        u.email,
        b.title,
        r.queue_position
FROM    reservations AS r, users AS u, books AS b
WHERE   r.user_id = u.user_id
  AND   r.book_id = b.book_id
  AND   r.book_id = 2
  AND   r.status = 'active'
  AND   r.queue_position = (
          SELECT MIN(r2.queue_position)
          FROM   reservations AS r2
          WHERE  r2.book_id = 2
            AND  r2.status = 'active'
      );


-- ------------------------------------------------------------
-- Step 5: Fulfil a reservation (user collected the book)
-- Mark reservation as fulfilled.
-- ------------------------------------------------------------
UPDATE reservations
SET    status = 'fulfilled'
WHERE  reservation_id = 1
  AND  status = 'active';


-- ------------------------------------------------------------
-- Step 6: Cancel a reservation
-- Example: user_id = 6 cancels their active reservation on book 2.
-- ------------------------------------------------------------
UPDATE reservations
SET    status = 'cancelled'
WHERE  book_id = 2
  AND  user_id = 6
  AND  status = 'active';


-- ------------------------------------------------------------
-- Step 7: Verify queue after changes
-- ------------------------------------------------------------
SELECT  r.reservation_id,
        u.name,
        r.status,
        r.queue_position
FROM    reservations AS r, users AS u
WHERE   r.user_id = u.user_id
  AND   r.book_id = 2
ORDER BY r.queue_position ASC;
