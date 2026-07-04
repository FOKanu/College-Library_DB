-- ============================================================
-- Reporting Queries
-- Course style: SELECT-FROM-WHERE, joins, GROUP BY, ORDER BY
-- Prerequisite: run schema.sql and insert.sql first.
-- ============================================================

USE library_db;


-- ============================================================
-- Report 1: Overdue books
-- Books still out (return_date IS NULL) past the due date.
-- ============================================================
SELECT  u.name          AS borrower,
        u.email,
        b.title         AS book_title,
        c.copy_id,
        br.borrow_date,
        br.due_date,
        DATEDIFF(CURDATE(), br.due_date) AS days_overdue
FROM    users AS u, borrow_records AS br, copies AS c, books AS b
WHERE   u.user_id = br.user_id
  AND   br.copy_id = c.copy_id
  AND   c.book_id = b.book_id
  AND   br.return_date IS NULL
  AND   br.due_date < CURDATE()
ORDER BY days_overdue DESC;


-- ============================================================
-- Report 2: Unpaid fines per user
-- Total unpaid amount grouped by user (GROUP BY + SUM).
-- ============================================================
SELECT  u.user_id,
        u.name,
        u.email,
        COUNT(*)        AS unpaid_fine_count,
        SUM(f.amount)   AS total_unpaid
FROM    users AS u, borrow_records AS br, fines AS f
WHERE   u.user_id = br.user_id
  AND   br.borrow_id = f.borrow_id
  AND   f.paid_status = 'unpaid'
GROUP BY u.user_id, u.name, u.email
ORDER BY total_unpaid DESC;


-- ============================================================
-- Report 3: Most borrowed books
-- Count all borrow records per book (active and returned).
-- ============================================================
SELECT  b.book_id,
        b.title,
        b.primary_author,
        COUNT(*) AS borrow_count
FROM    books AS b, copies AS c, borrow_records AS br
WHERE   b.book_id = c.book_id
  AND   c.copy_id = br.copy_id
GROUP BY b.book_id, b.title, b.primary_author
ORDER BY borrow_count DESC, b.title ASC;


-- ============================================================
-- Report 4: Publications by author
-- Lists each publication with its authors in citation order.
-- ============================================================
SELECT  a.name          AS author_name,
        a.affiliation,
        p.title         AS publication_title,
        p.type,
        p.publication_date,
        pa.author_order
FROM    authors AS a, publication_authors AS pa, publications AS p
WHERE   a.author_id = pa.author_id
  AND   pa.publication_id = p.publication_id
ORDER BY a.name ASC, pa.author_order ASC;
