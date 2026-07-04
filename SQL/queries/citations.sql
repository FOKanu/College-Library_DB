-- Prerequisite: run schema.sql and insert.sql first.
-- DML steps change data — re-run insert.sql to reset.
-- ============================================================
-- Workflow 5: Citation Lookup and Management
-- Course style: self-join, multi-table join, subqueries, INSERT
-- ============================================================

USE library_db;


-- ------------------------------------------------------------
-- Step 1: List all citations — which paper cites which
-- Self-join on publications (same table, two aliases).
-- ------------------------------------------------------------
SELECT  citing.title AS citing_paper,
        cited.title  AS cited_paper,
        c.citation_context
FROM    citations AS c,
        publications AS citing,
        publications AS cited
WHERE   c.citing_publication_id = citing.publication_id
  AND   c.cited_publication_id = cited.publication_id
ORDER BY citing.title ASC;


-- ------------------------------------------------------------
-- Step 2: Find all papers cited BY a given publication
-- Example: publication_id = 2 (Graph Neural Networks...)
-- ------------------------------------------------------------
SELECT  citing.title AS citing_paper,
        cited.title  AS cited_paper,
        c.citation_context
FROM    citations AS c,
        publications AS citing,
        publications AS cited
WHERE   c.citing_publication_id = citing.publication_id
  AND   c.cited_publication_id = cited.publication_id
  AND   citing.publication_id = 2;


-- ------------------------------------------------------------
-- Step 3: Find all papers that cite a given publication
-- Example: publication_id = 1 (Optimizing Relational Query Execution)
-- ------------------------------------------------------------
SELECT  citing.title AS citing_paper,
        cited.title  AS cited_paper
FROM    citations AS c,
        publications AS citing,
        publications AS cited
WHERE   c.citing_publication_id = citing.publication_id
  AND   c.cited_publication_id = cited.publication_id
  AND   cited.publication_id = 1;


-- ------------------------------------------------------------
-- Step 4: List publications with their authors (join)
-- author_order = 1 is the lead author.
-- ------------------------------------------------------------
SELECT  p.title,
        a.name AS author_name,
        pa.author_order
FROM    publications AS p, publication_authors AS pa, authors AS a
WHERE   p.publication_id = pa.publication_id
  AND   pa.author_id = a.author_id
ORDER BY p.title ASC, pa.author_order ASC;


-- ------------------------------------------------------------
-- Step 5: Count how many times each publication is cited (GROUP BY)
-- ------------------------------------------------------------
SELECT  p.title,
        COUNT(*) AS times_cited
FROM    publications AS p, citations AS c
WHERE   p.publication_id = c.cited_publication_id
GROUP BY p.publication_id, p.title
ORDER BY times_cited DESC;


-- ------------------------------------------------------------
-- Step 6: Find publications that are NOT cited by any other paper
-- Uses NOT IN subquery (as in Exercise 4.5c).
-- ------------------------------------------------------------
SELECT  p.publication_id,
        p.title
FROM    publications AS p
WHERE   p.publication_id NOT IN (
          SELECT c.cited_publication_id
          FROM   citations AS c
      );


-- ------------------------------------------------------------
-- Step 7: Add a new citation
-- publication 6 cites publication 3.
-- ------------------------------------------------------------
INSERT INTO citations (citing_publication_id, cited_publication_id, citation_context)
VALUES (6, 3, 'References schema normalisation discussion.');
