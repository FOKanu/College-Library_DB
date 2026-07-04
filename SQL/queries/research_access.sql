-- Prerequisite: run schema.sql and insert.sql first.
-- DML steps change data — re-run insert.sql to reset.
-- ============================================================
-- Workflow 4: Research Access Control
-- Course style: two-table join, WHERE filtering, INSERT
-- Example: Prof. Schmidt (user_id = 2) accesses publication_id = 1
-- ============================================================

USE library_db;


-- ------------------------------------------------------------
-- Step 1: Check if a user has access to a publication
-- Returns the access level: open, restricted, or subscription.
-- No rows = access denied.
-- ------------------------------------------------------------
SELECT  u.user_id,
        u.name,
        p.publication_id,
        p.title,
        ra.access_type
FROM    users AS u, publications AS p, research_access AS ra
WHERE   u.user_id = ra.user_id
  AND   p.publication_id = ra.publication_id
  AND   u.user_id = 2
  AND   p.publication_id = 1;


-- ------------------------------------------------------------
-- Step 2: List all publications a user can access
-- ------------------------------------------------------------
SELECT  u.name,
        p.title,
        p.type,
        ra.access_type
FROM    users AS u, publications AS p, research_access AS ra
WHERE   u.user_id = ra.user_id
  AND   p.publication_id = ra.publication_id
  AND   u.user_id = 2
ORDER BY p.title ASC;


-- ------------------------------------------------------------
-- Step 3: List users who have restricted access to a publication
-- ------------------------------------------------------------
SELECT  u.user_id,
        u.name,
        u.email,
        p.title,
        ra.access_type
FROM    users AS u, publications AS p, research_access AS ra
WHERE   u.user_id = ra.user_id
  AND   p.publication_id = ra.publication_id
  AND   p.publication_id = 2
  AND   ra.access_type = 'restricted';


-- ------------------------------------------------------------
-- Step 4: Log an access event (after access is granted)
-- action_type examples: view, download, cite
-- ------------------------------------------------------------
INSERT INTO research_access_log (access_id, user_id, access_timestamp, action_type, ip_address)
VALUES (1, 2, NOW(), 'view', '192.168.1.20');


-- ------------------------------------------------------------
-- Step 5: View access history for a user
-- ------------------------------------------------------------
SELECT  u.name,
        p.title,
        ral.access_timestamp,
        ral.action_type,
        ral.ip_address
FROM    users AS u, research_access_log AS ral, research_access AS ra, publications AS p
WHERE   u.user_id = ral.user_id
  AND   ral.access_id = ra.access_id
  AND   ra.publication_id = p.publication_id
  AND   u.user_id = 2
ORDER BY ral.access_timestamp DESC;


-- ------------------------------------------------------------
-- Step 6: Count access events per publication (GROUP BY)
-- ------------------------------------------------------------
SELECT  p.title,
        COUNT(*) AS access_count
FROM    publications AS p, research_access AS ra, research_access_log AS ral
WHERE   p.publication_id = ra.publication_id
  AND   ra.access_id = ral.access_id
GROUP BY p.publication_id, p.title
ORDER BY access_count DESC;
