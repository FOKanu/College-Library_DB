-- ============================================================
-- University Library & Research Management System
-- Sample / Mock Data (DML) — 3x expanded dataset
-- Course: Database Systems (BIT3.1) | SS 2026
-- Group 3: Francis Okorie Iyeke-Kanu, Dhrumil Khandla
-- ============================================================
-- Prerequisite: run schema.sql first.
-- Original rows (IDs 1–12 users/books, etc.) are unchanged so
-- workflow queries in SQL/queries/ still work as documented.
-- ============================================================

USE library_db;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE research_access_log;
TRUNCATE TABLE research_access;
TRUNCATE TABLE citations;
TRUNCATE TABLE publication_authors;
TRUNCATE TABLE fines;
TRUNCATE TABLE reservations;
TRUNCATE TABLE borrow_records;
TRUNCATE TABLE textbook_courses;
TRUNCATE TABLE copies;
TRUNCATE TABLE books;
TRUNCATE TABLE courses;
TRUNCATE TABLE users;
TRUNCATE TABLE publications;
TRUNCATE TABLE authors;
TRUNCATE TABLE categories;
TRUNCATE TABLE departments;

SET FOREIGN_KEY_CHECKS = 1;


-- ============================================================
-- MODULE 1: LIBRARY MANAGEMENT
-- ============================================================

-- ------------------------------------------------------------
-- DEPARTMENTS (9)
-- ------------------------------------------------------------
INSERT INTO departments (department_id, department_name, building) VALUES
(1, 'Computer Science',        'Building A - North Wing'),
(2, 'Mathematics',             'Building B - East Wing'),
(3, 'Business Administration', 'Building C - Main Hall'),
(4, 'Engineering',             'Building D - South Wing'),
(5, 'Physics',                 'Building E - West Wing'),
(6, 'Chemistry',               'Building F - Lab Block'),
(7, 'Law',                     'Building G - Justice Hall'),
(8, 'Medicine',                'Building H - Clinical Wing'),
(9, 'Arts and Humanities',     'Building I - Central Hall');


-- ------------------------------------------------------------
-- CATEGORIES (12)
-- ------------------------------------------------------------
INSERT INTO categories (category_id, category_name, description) VALUES
(1,  'Computer Science', 'Programming, databases, algorithms, and systems'),
(2,  'Mathematics',      'Pure and applied mathematics'),
(3,  'Business',         'Management, finance, and economics'),
(4,  'Fiction',          'Literary and genre fiction'),
(5,  'Engineering',      'Mechanical, electrical, and civil engineering'),
(6,  'Physics',          'Classical and modern physics'),
(7,  'Chemistry',        'Organic and inorganic chemistry'),
(8,  'Law',              'Legal studies and jurisprudence'),
(9,  'Medicine',         'Clinical and biomedical sciences'),
(10, 'History',          'World and regional history'),
(11, 'Arts',             'Fine arts, music, and theatre'),
(12, 'Biography',        'Biographical and memoir works');


-- ------------------------------------------------------------
-- USERS (36)
-- IDs 1–12 unchanged (workflow query examples).
-- Anna (12) = borrow limit test; Bob (5) = overdue / unpaid fine.
-- ------------------------------------------------------------
INSERT INTO users (user_id, name, email, role, contact, borrow_limit, department_id) VALUES
(1,  'Maria Admin',    'maria.admin@university.edu',    'admin',   '+49 171 1000001', 20, 1),
(2,  'Prof. Schmidt',  'schmidt@university.edu',        'faculty', '+49 171 2000001', 10, 1),
(3,  'Prof. Weber',    'weber@university.edu',          'faculty', '+49 171 2000002', 10, 2),
(4,  'Prof. Braun',    'braun@university.edu',          'faculty', '+49 171 2000003', 10, 3),
(5,  'Bob Student',    'bob.student@university.edu',    'student', '+49 171 3000001',  5, 1),
(6,  'Clara Student',  'clara.student@university.edu',  'student', '+49 171 3000002',  5, 1),
(7,  'David Student',  'david.student@university.edu',  'student', '+49 171 3000003',  5, 2),
(8,  'Eva Student',    'eva.student@university.edu',    'student', '+49 171 3000004',  5, 2),
(9,  'Felix Student',  'felix.student@university.edu',  'student', '+49 171 3000005',  5, 3),
(10, 'Greta Student',  'greta.student@university.edu',  'student', '+49 171 3000006',  5, 1),
(11, 'Hans Staff',     'hans.staff@university.edu',     'staff',   '+49 171 4000001',  7, 1),
(12, 'Anna Limit',     'anna.limit@university.edu',     'student', '+49 171 3000007',  5, 1),
(13, 'Tom Admin',      'tom.admin@university.edu',      'admin',   '+49 171 1000002', 20, 4),
(14, 'Lisa Admin',     'lisa.admin@university.edu',     'admin',   '+49 171 1000003', 20, 5),
(15, 'Prof. Hoffmann', 'hoffmann@university.edu',       'faculty', '+49 171 2000004', 10, 4),
(16, 'Prof. Richter',  'richter@university.edu',        'faculty', '+49 171 2000005', 10, 5),
(17, 'Prof. Fischer',  'fischer@university.edu',        'faculty', '+49 171 2000006', 10, 6),
(18, 'Prof. Wagner',   'wagner@university.edu',         'faculty', '+49 171 2000007', 10, 7),
(19, 'Prof. Becker',   'becker@university.edu',         'faculty', '+49 171 2000008', 10, 8),
(20, 'Prof. Schulz',   'schulz@university.edu',         'faculty', '+49 171 2000009', 10, 9),
(21, 'Ian Student',    'ian.student@university.edu',    'student', '+49 171 3000008',  5, 4),
(22, 'Julia Student',  'julia.student@university.edu',  'student', '+49 171 3000009',  5, 4),
(23, 'Karl Student',   'karl.student@university.edu',   'student', '+49 171 3000010',  5, 5),
(24, 'Laura Student',  'laura.student@university.edu',  'student', '+49 171 3000011',  5, 5),
(25, 'Max Student',    'max.student@university.edu',    'student', '+49 171 3000012',  5, 6),
(26, 'Nina Student',   'nina.student@university.edu',   'student', '+49 171 3000013',  5, 6),
(27, 'Otto Student',   'otto.student@university.edu',   'student', '+49 171 3000014',  5, 7),
(28, 'Paula Student',  'paula.student@university.edu',  'student', '+49 171 3000015',  5, 7),
(29, 'Quinn Student',  'quinn.student@university.edu',  'student', '+49 171 3000016',  5, 8),
(30, 'Rita Student',   'rita.student@university.edu',   'student', '+49 171 3000017',  5, 8),
(31, 'Sam Student',    'sam.student@university.edu',    'student', '+49 171 3000018',  5, 9),
(32, 'Tina Student',   'tina.student@university.edu',   'student', '+49 171 3000019',  5, 9),
(33, 'Uwe Student',    'uwe.student@university.edu',    'student', '+49 171 3000020',  5, 1),
(34, 'Vera Student',   'vera.student@university.edu',   'student', '+49 171 3000021',  5, 2),
(35, 'Wendy Staff',    'wendy.staff@university.edu',    'staff',   '+49 171 4000002',  7, 3),
(36, 'Xavier Staff',   'xavier.staff@university.edu',   'staff',   '+49 171 4000003',  7, 4);


-- ------------------------------------------------------------
-- BOOKS (36)
-- book 12 and 36 are uncategorised (category_id NULL).
-- ------------------------------------------------------------
INSERT INTO books (book_id, title, isbn, primary_author, publisher, publication_year, pages, is_textbook, category_id) VALUES
(1,  'Database System Concepts',              '978-0078022159', 'Silberschatz',     'McGraw-Hill',    2019, 1376, TRUE,  1),
(2,  'Linear Algebra and Its Applications',   '978-0321982384', 'Lay',              'Pearson',        2015,  576, TRUE,  2),
(3,  'Introduction to Algorithms',            '978-0262046305', 'Cormen',           'MIT Press',      2022, 1312, TRUE,  1),
(4,  'Principles of Corporate Finance',       '978-1260013908', 'Brealey',          'McGraw-Hill',    2020,  992, TRUE,  3),
(5,  'The Great Gatsby',                      '978-0743273565', 'Fitzgerald',       'Scribner',       2004,  180, FALSE, 4),
(6,  'Clean Code',                            '978-0132350884', 'Martin',           'Prentice Hall',  2008,  464, FALSE, 1),
(7,  'Calculus: Early Transcendentals',       '978-1285741550', 'Stewart',          'Cengage',        2015, 1368, TRUE,  2),
(8,  'Operating System Concepts',             '978-1119800361', 'Silberschatz',     'Wiley',          2021, 1040, TRUE,  1),
(9,  'Financial Accounting',                  '978-1260247930', 'Wild',             'McGraw-Hill',    2021,  864, TRUE,  3),
(10, '1984',                                  '978-0451524935', 'Orwell',           'Signet',         1950,  328, FALSE, 4),
(11, 'Design Patterns',                       '978-0201633610', 'Gamma',            'Addison-Wesley', 1994,  416, FALSE, 1),
(12, 'University Handbook',                   NULL,             'University Press', 'Uni Press',      2024,  120, FALSE, NULL),
(13, 'Computer Networks',                     '978-0136681557', 'Tanenbaum',        'Pearson',        2021,  960, TRUE,  1),
(14, 'Discrete Mathematics',                  '978-0134678327', 'Rosen',            'Pearson',        2018, 1120, TRUE,  2),
(15, 'Microeconomics',                        '978-0135164774', 'Hubbard',          'Pearson',        2020,  848, TRUE,  3),
(16, 'Pride and Prejudice',                   '978-0141439518', 'Austen',           'Penguin',        2003,  480, FALSE, 4),
(17, 'The C Programming Language',            '978-0131103627', 'Kernighan',        'Prentice Hall',  1988,  272, TRUE,  1),
(18, 'Probability and Statistics',            '978-0134995390', 'Walpole',          'Pearson',        2017,  816, TRUE,  2),
(19, 'Marketing Management',                  '978-0135226196', 'Kotler',           'Pearson',        2021,  736, TRUE,  3),
(20, 'To Kill a Mockingbird',                 '978-0061120084', 'Lee',              'Harper',         2006,  336, FALSE, 4),
(21, 'Mechanical Engineering Design',         '978-0073398204', 'Shigley',          'McGraw-Hill',    2019, 1088, TRUE,  5),
(22, 'University Physics',                    '978-0134988559', 'Young',            'Pearson',        2019, 1600, TRUE,  6),
(23, 'Organic Chemistry',                     '978-0134161600', 'Wade',             'Pearson',        2017, 1392, TRUE,  7),
(24, 'Constitutional Law',                    '978-1454897613', 'Chemerinsky',      'Wolters Kluwer', 2019, 1664, TRUE,  8),
(25, 'Gray''s Anatomy',                       '978-0702076116', 'Standring',        'Elsevier',       2020, 1568, TRUE,  9),
(26, 'A Brief History of Time',               '978-0553380163', 'Hawking',          'Bantam',         1998,  256, FALSE, 10),
(27, 'The Story of Art',                      '978-0714832470', 'Gombrich',         'Phaidon',        1995, 1064, FALSE, 11),
(28, 'Steve Jobs',                            '978-1451648539', 'Isaacson',         'Simon & Schuster',2011, 656, FALSE, 12),
(29, 'Electric Circuits',                     '978-0134746968', 'Nilsson',          'Pearson',        2018,  816, TRUE,  5),
(30, 'Modern Physics',                        '978-0133913965', 'Krane',            'Wiley',          2019,  560, TRUE,  6),
(31, 'Inorganic Chemistry',                   '978-0321811059', 'Housecroft',       'Pearson',        2018,  848, TRUE,  7),
(32, 'Criminal Law',                          '978-1454894025', 'Dressler',         'Wolters Kluwer', 2018,  864, TRUE,  8),
(33, 'Clinical Medicine',                     '978-0702070282', 'Kumar',            'Elsevier',       2021, 1456, TRUE,  9),
(34, 'The World Wars',                        '978-0143035739', 'Keegan',           'Penguin',        1990,  480, FALSE, 10),
(35, 'Art History',                           '978-0134475883', 'Stokstad',         'Pearson',        2017,  624, FALSE, 11),
(36, 'Campus Regulations',                    NULL,             'University Press', 'Uni Press',      2025,   96, FALSE, NULL);


-- ------------------------------------------------------------
-- COPIES (54)
-- IDs 1–18 unchanged. Additional copies on books 1–36.
-- ------------------------------------------------------------
INSERT INTO copies (copy_id, book_id, status) VALUES
(1,  1,  'available'),
(2,  1,  'borrowed'),
(3,  1,  'borrowed'),
(4,  2,  'borrowed'),
(5,  2,  'borrowed'),
(6,  3,  'available'),
(7,  4,  'damaged'),
(8,  5,  'lost'),
(9,  6,  'reserved'),
(10, 7,  'borrowed'),
(11, 8,  'borrowed'),
(12, 9,  'borrowed'),
(13, 10, 'borrowed'),
(14, 11, 'borrowed'),
(15, 12, 'borrowed'),
(16, 1,  'available'),
(17, 3,  'available'),
(18, 6,  'available'),
(19, 13, 'available'),
(20, 13, 'borrowed'),
(21, 14, 'borrowed'),
(22, 14, 'borrowed'),
(23, 15, 'available'),
(24, 16, 'borrowed'),
(25, 17, 'available'),
(26, 18, 'borrowed'),
(27, 19, 'damaged'),
(28, 20, 'lost'),
(29, 21, 'reserved'),
(30, 22, 'borrowed'),
(31, 23, 'borrowed'),
(32, 24, 'borrowed'),
(33, 25, 'borrowed'),
(34, 26, 'available'),
(35, 27, 'borrowed'),
(36, 28, 'available'),
(37, 29, 'borrowed'),
(38, 30, 'available'),
(39, 31, 'borrowed'),
(40, 32, 'available'),
(41, 33, 'borrowed'),
(42, 34, 'borrowed'),
(43, 35, 'available'),
(44, 36, 'borrowed'),
(45, 2,  'borrowed'),
(46, 3,  'borrowed'),
(47, 5,  'available'),
(48, 8,  'available'),
(49, 10, 'available'),
(50, 12, 'damaged'),
(51, 15, 'borrowed'),
(52, 21, 'borrowed'),
(53, 25, 'available'),
(54, 33, 'reserved');


-- ------------------------------------------------------------
-- BORROW_RECORDS (48)
-- IDs 1–16 unchanged. Bob (5) overdue; Anna (12) at limit.
-- ------------------------------------------------------------
INSERT INTO borrow_records (borrow_id, user_id, copy_id, borrow_date, due_date, return_date) VALUES
-- Original active loans (1–10)
(1,  6,  2,  '2026-06-01', '2026-06-29', NULL),
(2,  7,  3,  '2026-06-05', '2026-07-03', NULL),
(3,  8,  4,  '2026-05-20', '2026-06-17', NULL),
(4,  9,  5,  '2026-05-25', '2026-06-22', NULL),
(5,  5,  15, '2026-05-10', '2026-06-09', NULL),
(6,  12, 10, '2026-06-10', '2026-07-08', NULL),
(7,  12, 11, '2026-06-11', '2026-07-09', NULL),
(8,  12, 12, '2026-06-12', '2026-07-10', NULL),
(9,  12, 13, '2026-06-13', '2026-07-11', NULL),
(10, 12, 14, '2026-06-14', '2026-07-12', NULL),
-- Original returned loans (11–16)
(11, 5,  1,  '2026-03-01', '2026-03-29', '2026-03-25'),
(12, 6,  16, '2026-02-10', '2026-03-10', '2026-03-08'),
(13, 6,  17, '2026-04-01', '2026-04-29', '2026-04-20'),
(14, 7,  18, '2026-01-15', '2026-02-12', '2026-02-10'),
(15, 10, 6,  '2026-05-01', '2026-05-29', '2026-05-27'),
(16, 2,  6,  '2025-11-01', '2025-11-29', '2025-11-20'),
-- Additional active loans (17–28)
(17, 21, 20, '2026-06-02', '2026-06-30', NULL),
(18, 22, 21, '2026-06-03', '2026-07-01', NULL),
(19, 23, 22, '2026-05-18', '2026-06-15', NULL),
(20, 24, 26, '2026-06-08', '2026-07-06', NULL),
(21, 25, 30, '2026-06-09', '2026-07-07', NULL),
(22, 26, 31, '2026-06-10', '2026-07-08', NULL),
(23, 27, 32, '2026-05-12', '2026-06-10', NULL),
(24, 28, 33, '2026-06-11', '2026-07-09', NULL),
(25, 29, 35, '2026-06-12', '2026-07-10', NULL),
(26, 30, 37, '2026-06-13', '2026-07-11', NULL),
(27, 31, 39, '2026-06-14', '2026-07-12', NULL),
(28, 33, 42, '2026-05-08', '2026-06-06', NULL),
-- Additional returned loans (29–48)
(29, 21, 19, '2026-01-10', '2026-02-07', '2026-02-05'),
(30, 22, 23, '2026-02-15', '2026-03-15', '2026-03-12'),
(31, 23, 25, '2026-03-01', '2026-03-29', '2026-03-27'),
(32, 24, 34, '2026-03-10', '2026-04-07', '2026-04-05'),
(33, 25, 36, '2026-04-01', '2026-04-29', '2026-04-25'),
(34, 26, 38, '2026-04-10', '2026-05-08', '2026-05-06'),
(35, 27, 40, '2026-05-01', '2026-05-29', '2026-05-28'),
(36, 28, 41, '2026-05-10', '2026-06-07', '2026-06-05'),
(37, 29, 43, '2026-01-20', '2026-02-17', '2026-02-15'),
(38, 30, 44, '2026-02-01', '2026-03-01', '2026-02-28'),
(39, 31, 45, '2026-02-10', '2026-03-10', '2026-03-08'),
(40, 32, 46, '2026-03-15', '2026-04-12', '2026-04-10'),
(41, 33, 47, '2026-04-01', '2026-04-29', '2026-04-27'),
(42, 34, 48, '2026-04-15', '2026-05-13', '2026-05-11'),
(43, 15, 49, '2025-10-01', '2025-10-29', '2025-10-25'),
(44, 16, 50, '2025-11-01', '2025-11-29', '2025-11-27'),
(45, 17, 51, '2026-01-05', '2026-02-02', '2026-02-01'),
(46, 18, 52, '2026-02-01', '2026-03-01', '2026-02-27'),
(47, 19, 53, '2026-03-01', '2026-03-29', '2026-03-26'),
(48, 20, 1,  '2026-04-01', '2026-04-29', '2026-04-28');


-- ------------------------------------------------------------
-- RESERVATIONS (18)
-- IDs 1–6 unchanged. Book 2 queue + book 14 queue.
-- ------------------------------------------------------------
INSERT INTO reservations (reservation_id, book_id, user_id, reservation_date, status, expiry_date, queue_position) VALUES
(1,  2, 5,  '2026-06-18', 'active',    '2026-07-18', 1),
(2,  2, 6,  '2026-06-20', 'active',    '2026-07-20', 2),
(3,  2, 10, '2026-06-22', 'active',    '2026-07-22', 3),
(4,  1, 8,  '2026-05-01', 'fulfilled', '2026-06-01', 1),
(5,  3, 9,  '2026-04-10', 'cancelled', '2026-05-10', 1),
(6,  6, 7,  '2026-06-25', 'expired',   '2026-07-01', 1),
(7,  14, 21, '2026-06-19', 'active',   '2026-07-19', 1),
(8,  14, 22, '2026-06-21', 'active',   '2026-07-21', 2),
(9,  14, 23, '2026-06-23', 'active',   '2026-07-23', 3),
(10, 2, 24, '2026-06-24', 'active',   '2026-07-24', 4),
(11, 22, 25, '2026-06-15', 'active',  '2026-07-15', 1),
(12, 22, 26, '2026-06-17', 'active',  '2026-07-17', 2),
(13, 1, 27, '2026-05-05', 'fulfilled', '2026-06-05', 1),
(14, 13, 28, '2026-04-20', 'cancelled', '2026-05-20', 1),
(15, 25, 29, '2026-06-26', 'expired',  '2026-07-02', 1),
(16, 33, 30, '2026-06-27', 'active',  '2026-07-27', 1),
(17, 33, 31, '2026-06-28', 'active',  '2026-07-28', 2),
(18, 21, 32, '2026-06-29', 'active',  '2026-07-29', 1);


-- ------------------------------------------------------------
-- FINES (9)
-- IDs 1–3 unchanged. Additional unpaid, paid, waived.
-- ------------------------------------------------------------
INSERT INTO fines (fine_id, borrow_id, amount, paid_status, payment_date) VALUES
(1, 5,  12.50, 'unpaid',  NULL),
(2, 11,  5.00, 'paid',    '2026-03-26'),
(3, 14,  3.00, 'waived',  '2026-02-11'),
(4, 19,  8.00, 'unpaid',  NULL),
(5, 23, 15.00, 'unpaid',  NULL),
(6, 28,  6.50, 'unpaid',  NULL),
(7, 29,  4.00, 'paid',    '2026-02-06'),
(8, 35,  2.50, 'paid',    '2026-05-29'),
(9, 37,  1.50, 'waived',  '2026-02-16');


-- ============================================================
-- MODULE 2: ACADEMIC INTEGRATION
-- ============================================================

-- ------------------------------------------------------------
-- COURSES (15)
-- ------------------------------------------------------------
INSERT INTO courses (course_id, course_code, course_name, department_id) VALUES
(1,  'CS101',   'Introduction to Programming',  1),
(2,  'CS301',   'Database Systems',               1),
(3,  'MATH201', 'Linear Algebra',                 2),
(4,  'BUS110',  'Principles of Finance',          3),
(5,  'CS401',   'Advanced Algorithms',            1),
(6,  'ENG201',  'Thermodynamics',                 4),
(7,  'PHY101',  'Classical Mechanics',            5),
(8,  'CHEM201', 'Organic Chemistry Lab',          6),
(9,  'LAW110',  'Introduction to Law',            7),
(10, 'MED301',  'Clinical Diagnosis',             8),
(11, 'ART101',  'Art Appreciation',               9),
(12, 'CS201',   'Data Structures',                1),
(13, 'MATH301', 'Probability Theory',             2),
(14, 'BUS201',  'Marketing Fundamentals',         3),
(15, 'ENG301',  'Structural Analysis',            4);


-- ------------------------------------------------------------
-- TEXTBOOK_COURSES (18)
-- ------------------------------------------------------------
INSERT INTO textbook_courses (tc_id, book_id, course_id, semester, professor_id, is_required) VALUES
(1,  1,  2,  'SS2026', 2,  TRUE),
(2,  2,  3,  'SS2026', 3,  TRUE),
(3,  3,  5,  'WS2526', 2,  TRUE),
(4,  4,  4,  'SS2026', 4,  TRUE),
(5,  7,  3,  'WS2526', 3,  FALSE),
(6,  8,  2,  'SS2026', 2,  FALSE),
(7,  13, 12, 'SS2026', 2,  TRUE),
(8,  14, 13, 'SS2026', 3,  TRUE),
(9,  15, 14, 'WS2526', 4,  TRUE),
(10, 17, 12, 'SS2026', 15, TRUE),
(11, 21, 6,  'SS2026', 15, TRUE),
(12, 22, 7,  'WS2526', 16, TRUE),
(13, 23, 8,  'SS2026', 17, TRUE),
(14, 24, 9,  'WS2526', 18, TRUE),
(15, 25, 10, 'SS2026', 19, TRUE),
(16, 29, 6,  'WS2526', 15, FALSE),
(17, 30, 7,  'SS2026', 16, FALSE),
(18, 33, 10, 'WS2526', 19, FALSE);


-- ============================================================
-- MODULE 3: RESEARCH MANAGEMENT
-- ============================================================

-- ------------------------------------------------------------
-- AUTHORS (18)
-- ------------------------------------------------------------
INSERT INTO authors (author_id, name, affiliation, email) VALUES
(1,  'Dr. Alice Chen',      'University Research Lab',      'alice.chen@research.edu'),
(2,  'Dr. Ben Mueller',     'Institute for Data Science',   'ben.mueller@research.edu'),
(3,  'Dr. Carla Santos',    'Business School',              'carla.santos@research.edu'),
(4,  'Dr. Daniel Kim',      'Computer Science Department','daniel.kim@university.edu'),
(5,  'Dr. Elena Vogt',      'Mathematics Department',       'elena.vogt@university.edu'),
(6,  'Dr. Frank Okonkwo',   'International AI Centre',      'frank.okonkwo@research.edu'),
(7,  'Dr. Grace Park',      'Engineering Faculty',          'grace.park@university.edu'),
(8,  'Dr. Henry Liu',       'Physics Institute',            'henry.liu@university.edu'),
(9,  'Dr. Ingrid Novak',    'Chemistry Department',         'ingrid.novak@university.edu'),
(10, 'Dr. James Osei',      'Law School',                   'james.osei@university.edu'),
(11, 'Dr. Karen Patel',     'Medical School',               'karen.patel@university.edu'),
(12, 'Dr. Leo Hartmann',    'Arts Faculty',                 'leo.hartmann@university.edu'),
(13, 'Dr. Mona El-Sayed',   'Data Engineering Lab',         'mona.elsayed@research.edu'),
(14, 'Dr. Niels Andersen',  'Statistics Centre',            'niels.andersen@research.edu'),
(15, 'Dr. Olivia Grant',    'Finance Research Group',       'olivia.grant@research.edu'),
(16, 'Dr. Peter Walsh',     'Robotics Lab',                 'peter.walsh@university.edu'),
(17, 'Dr. Quinn Reed',      'Neuroscience Institute',       'quinn.reed@research.edu'),
(18, 'Dr. Rosa Mendez',     'Environmental Science',        'rosa.mendez@research.edu');


-- ------------------------------------------------------------
-- PUBLICATIONS (21)
-- ------------------------------------------------------------
INSERT INTO publications (publication_id, title, type, publication_date, abstract, doi) VALUES
(1,  'Optimizing Relational Query Execution',            'journal',      '2024-03-15', 'A study on index selection for OLTP workloads.',                     '10.1000/dbquery2024'),
(2,  'Graph Neural Networks for Citation Prediction',    'conference',   '2025-06-01', 'Predicting citation links using GNN architectures.',                 '10.1000/gnn2025'),
(3,  'Normalization Beyond 3NF in Practice',             'journal',      '2023-11-20', 'When denormalization is justified in production systems.',           '10.1000/norm2023'),
(4,  'Corporate Risk Models: A Comparative Review',      'book_chapter', '2022-09-10', 'Survey of quantitative risk frameworks.',                            '10.1000/risk2022'),
(5,  'Efficient B-Tree Implementations in Modern DBMS',  'thesis',       '2021-07-30', 'Master thesis on B-tree storage engine design.',                    '10.1000/btree2021'),
(6,  'Fairness Metrics in Library Recommendation Systems','conference',  '2026-01-12', 'Evaluating bias in academic resource recommenders.',                '10.1000/fair2026'),
(7,  'Stochastic Calculus in Quantitative Finance',      'journal',      '2020-05-05', 'Foundations for derivative pricing models.',                         '10.1000/stoch2020'),
(8,  'Index Structures for Time-Series Data',            'journal',      '2024-08-20', 'Comparing B-tree and LSM variants for temporal data.',               '10.1000/timeseries2024'),
(9,  'Machine Learning in Materials Science',            'conference',   '2025-03-10', 'Predicting alloy properties with neural networks.',                    '10.1000/mlmat2025'),
(10, 'Quantum Error Correction Survey',                  'journal',      '2023-06-15', 'Overview of stabiliser codes and fault tolerance.',                  '10.1000/qec2023'),
(11, 'Catalytic Pathways in Green Chemistry',            'journal',      '2022-11-01', 'Sustainable synthesis routes for industrial chemistry.',             '10.1000/greenchem2022'),
(12, 'Digital Evidence in Criminal Trials',              'book_chapter', '2021-04-22', 'Admissibility standards for electronic records.',                    '10.1000/diglaw2021'),
(13, 'AI-Assisted Radiology Diagnostics',                'journal',      '2025-09-05', 'Deep learning models for chest X-ray classification.',               '10.1000/radiology2025'),
(14, 'Renaissance Art and Patronage Networks',           'thesis',       '2020-12-18', 'PhD thesis on Florentine patronage structures.',                   '10.1000/artphd2020'),
(15, 'Distributed Transaction Protocols Compared',         'conference',   '2024-11-30', 'Two-phase commit vs saga patterns in microservices.',              '10.1000/disttx2024'),
(16, 'Bayesian Methods for Clinical Trials',             'journal',      '2023-02-28', 'Adaptive trial design using posterior updating.',                    '10.1000/bayestrial2023'),
(17, 'Renewable Grid Storage Economics',                   'journal',      '2025-01-20', 'Cost-benefit analysis of battery deployment.',                       '10.1000/grid2025'),
(18, 'Natural Language Interfaces to Databases',         'conference',   '2026-02-14', 'Text-to-SQL systems for non-technical users.',                       '10.1000/nltosql2026'),
(19, 'Topological Methods in Data Analysis',             'journal',      '2022-07-07', 'Persistent homology for high-dimensional datasets.',                 '10.1000/topo2022'),
(20, 'Ethics of Autonomous Vehicles',                    'book_chapter', '2024-05-12', 'Moral dilemmas in self-driving car algorithms.',                     '10.1000/avethics2024'),
(21, 'Blockchain for Academic Credential Verification',  'thesis',       '2025-10-01', 'Decentralised degree attestation prototype.',                        '10.1000/blockchain2025');


-- ------------------------------------------------------------
-- PUBLICATION_AUTHORS (39)
-- ------------------------------------------------------------
INSERT INTO publication_authors (publication_id, author_id, author_order) VALUES
(1,  1, 1), (1,  4, 2),
(2,  2, 1), (2,  6, 2),
(3,  4, 1), (3,  1, 2),
(4,  3, 1),
(5,  4, 1),
(6,  2, 1), (6,  1, 2), (6,  3, 3),
(7,  3, 1), (7,  5, 2),
(8,  1, 1), (8,  13, 2),
(9,  7, 1), (9,  16, 2),
(10, 8, 1), (10, 14, 2),
(11, 9, 1), (11, 18, 2),
(12, 10, 1),
(13, 11, 1), (13, 17, 2),
(14, 12, 1),
(15, 4, 1), (15, 13, 2),
(16, 11, 1), (16, 14, 2),
(17, 18, 1), (17, 7, 2),
(18, 2, 1), (18, 13, 2),
(19, 5, 1), (19, 14, 2),
(20, 10, 1), (20, 16, 2),
(21, 4, 1), (21, 15, 2);


-- ------------------------------------------------------------
-- CITATIONS (15)
-- ------------------------------------------------------------
INSERT INTO citations (citation_id, citing_publication_id, cited_publication_id, citation_context) VALUES
(1,  2, 1, 'Builds on query optimisation baseline from Chen et al.'),
(2,  2, 3, 'References normalisation trade-offs in schema design.'),
(3,  6, 2, 'Uses citation prediction methods for recommendation evaluation.'),
(4,  1, 5, 'Cites B-tree implementation details for index analysis.'),
(5,  4, 7, 'Financial risk section draws on stochastic calculus foundations.'),
(6,  8, 5, 'Extends B-tree analysis to time-series indexing.'),
(7,  8, 1, 'References OLTP index selection strategies.'),
(8,  15, 1, 'Distributed queries rely on relational optimisation.'),
(9,  15, 8, 'Time-series indexes inform transaction log design.'),
(10, 18, 1, 'NL-to-SQL systems depend on query execution models.'),
(11, 18, 3, 'Schema design affects text-to-SQL accuracy.'),
(12, 9, 10, 'Materials ML uses quantum simulation insights.'),
(13, 13, 16, 'Clinical AI builds on Bayesian trial methodology.'),
(14, 17, 7, 'Grid economics references financial modelling.'),
(15, 21, 3, 'Credential schema design references normalisation theory.');


-- ------------------------------------------------------------
-- RESEARCH_ACCESS (21)
-- ------------------------------------------------------------
INSERT INTO research_access (access_id, publication_id, user_id, access_type) VALUES
(1,  1, 2,  'open'),
(2,  2, 5,  'restricted'),
(3,  2, 2,  'subscription'),
(4,  3, 6,  'open'),
(5,  4, 4,  'subscription'),
(6,  6, 1,  'open'),
(7,  7, 9,  'restricted'),
(8,  8, 15, 'open'),
(9,  9, 16, 'subscription'),
(10, 10, 17, 'restricted'),
(11, 11, 18, 'open'),
(12, 12, 19, 'subscription'),
(13, 13, 20, 'open'),
(14, 14, 21, 'restricted'),
(15, 15, 22, 'subscription'),
(16, 16, 23, 'open'),
(17, 17, 24, 'restricted'),
(18, 18, 25, 'open'),
(19, 19, 26, 'subscription'),
(20, 20, 27, 'restricted'),
(21, 21, 28, 'open');


-- ------------------------------------------------------------
-- RESEARCH_ACCESS_LOG (24)
-- ------------------------------------------------------------
INSERT INTO research_access_log (log_id, access_id, user_id, access_timestamp, action_type, ip_address) VALUES
(1,  1, 2,  '2026-06-28 09:15:00', 'view',     '192.168.1.10'),
(2,  1, 2,  '2026-06-28 09:16:30', 'download', '192.168.1.10'),
(3,  2, 5,  '2026-06-29 14:02:00', 'view',     '10.0.0.45'),
(4,  3, 2,  '2026-06-30 11:30:00', 'cite',     '192.168.1.10'),
(5,  4, 6,  '2026-07-01 08:45:00', 'view',     '10.0.0.72'),
(6,  5, 4,  '2026-07-02 16:20:00', 'download', '192.168.2.5'),
(7,  6, 1,  '2026-07-02 17:00:00', 'view',     '192.168.0.1'),
(8,  7, 9,  '2026-07-03 10:10:00', 'view',     '10.0.1.88'),
(9,  8, 15, '2026-06-15 10:00:00', 'view',     '10.0.2.10'),
(10, 9, 16, '2026-06-16 11:30:00', 'download', '10.0.2.11'),
(11, 10, 17, '2026-06-17 09:45:00', 'view',     '10.0.2.12'),
(12, 11, 18, '2026-06-18 14:00:00', 'cite',     '10.0.2.13'),
(13, 12, 19, '2026-06-19 08:30:00', 'view',     '10.0.2.14'),
(14, 13, 20, '2026-06-20 16:15:00', 'download', '10.0.2.15'),
(15, 14, 21, '2026-06-21 10:45:00', 'view',     '10.0.2.16'),
(16, 15, 22, '2026-06-22 13:00:00', 'cite',     '10.0.2.17'),
(17, 16, 23, '2026-06-23 09:00:00', 'view',     '10.0.2.18'),
(18, 17, 24, '2026-06-24 11:00:00', 'download', '10.0.2.19'),
(19, 18, 25, '2026-06-25 15:30:00', 'view',     '10.0.2.20'),
(20, 19, 26, '2026-06-26 08:00:00', 'cite',     '10.0.2.21'),
(21, 20, 27, '2026-06-27 12:45:00', 'view',     '10.0.2.22'),
(22, 21, 28, '2026-06-28 17:00:00', 'download', '10.0.2.23'),
(23, 8, 15, '2026-07-01 09:30:00', 'view',     '10.0.2.10'),
(24, 1, 2,  '2026-07-03 08:00:00', 'view',     '192.168.1.10');
