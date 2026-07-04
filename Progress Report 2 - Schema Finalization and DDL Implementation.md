# PROGRESS REPORT 2: Schema Finalization & DDL Implementation of Group 3

**University Library & Research Management System**

**Course:** Database Systems
**Group:** 3 – Library Management
**Student Name:** Francis Okorie Iyeke-Kanu, Dhrumil Khandla
**Date:** 23 May 2026

---

## 1. Introduction

This project focuses on the design and implementation of a University Library & Research Management System, intended to model a real-world academic environment. The system extends beyond traditional library operations to include academic research publications, citation tracking, and textbook-course integration across three distinct modules.

The objective of this second progress report is to document the completion of Phase 2, which involved a critical review of the initial schema design, systematic correction of identified issues, finalization of the Entity-Relationship Diagram (ERD), and the production of a complete Data Definition Language (DDL) SQL script.


---

## 2. Phase 2 Summary

Phase 2 was planned in the previous report to cover ERD creation, schema design, and normalization. All planned objectives have been completed and extended, with the schema undergoing two rounds of structured review and revision before the final DDL was produced.

### 2.1 Planned Objectives (from Report 1)

- Finalize the ERD diagram
- Write complete SQL schema definitions
- Implement sample queries
- Enhance system functionality

### 2.2 Completed in This Phase

- Conducted a structured critical review of the initial schema design against the five system workflows (borrowing, return, reservation, research access, and citation management)
- Identified seven design issues in the initial schema (detailed in Section 3)
- Applied corrections iteratively, verified through two diagram revisions in Miro
- Produced a complete, normalized DDL script covering all 16 tables across three modules
- Added performance indexes for common query patterns

Sample query development has been carried forward to Phase 3, where it will be paired with realistic sample data insertion.


---

## 3. Schema Review: Issues Identified in the Initial Design

Upon reviewing the initial schema design against the project's system workflows and real-world requirements, seven issues were identified that would have prevented correct implementation.

### 3.1 Redundant Double-ID Pattern

Every table in the initial design contained both a generic surrogate key (`id`) and a named business key (e.g. `user_id`, `book_id`). This created ambiguity in queries and unnecessary redundancy. All tables were corrected to use a single, meaningfully named primary key.

### 3.2 Single-Author Limitation in Books

The `books` table stored author information as a single `VARCHAR` field, which does not support books with multiple authors and is inconsistent with the `authors` entity used for research publications. The field was renamed to `primary_author` to make its scope explicit (Option A — simple approach), with the option to extend to a `book_authors` junction table in a future phase if needed.

### 3.3 No Queue Ordering in Reservations

The `reservations` table had no mechanism to order waiting users per book. The borrowing and reservation flowcharts both require a queue — when a copy becomes available, the system must identify the next user in line. A `queue_position` column was added to enforce this ordering.

### 3.4 Missing Semester and Professor in Textbook–Course Mapping

The `textbook_courses` table linked books to courses but was missing two fields stated in the project scope: the semester in which the book is used (e.g. `SS2026`) and the professor responsible for the course. Both `semester` (VARCHAR) and `professor_id` (FK → users) were added.

### 3.5 No Audit Log for Research Access

The `research_access` table stored access rules per publication, but the research access workflow includes a "Log access" step — recording who accessed what, when, and how. A new `research_access_log` table was designed to capture each individual access event, including `user_id`, `access_timestamp`, `action_type`, and `ip_address`.

### 3.6 No Borrow Limit Stored in the Schema

The borrowing workflow includes a "Borrow limit reached?" decision. However, the initial schema provided no column to store what the limit is per user. A `borrow_limit` column (INTEGER, DEFAULT 5) was added to the `users` table, allowing limits to differ between user types.

### 3.7 Free-Text Fields for Constrained Values

Fields such as `copies.status`, `users.role`, `reservations.status`, `fines.paid_status`, `publications.type`, and `research_access.access_type` were defined as plain `VARCHAR`, allowing any string value to be inserted. These were all converted to `ENUM` types to enforce data integrity at the database level.


---

## 4. Design Corrections Applied

After the first round of corrections (diagram version 7.1), a second review identified four remaining issues that were resolved in diagram version 7.2:

### 4.1 Missing `user_id` in `research_access_log`

The initial version of the new audit log table did not include a `user_id` column, making it impossible to identify who performed each access action. A `user_id` FK (NOT NULL, referencing `users`) was added.

### 4.2 Incorrect FK Label on `semester`

The `semester` field in `textbook_courses` was incorrectly labeled as a foreign key in the diagram. Since semester is a plain string value (e.g. `'SS2026'`) with no corresponding lookup table, the label was corrected to `NOT NULL VARCHAR(10)`.

### 4.3 Incorrect FK Label on `borrow_limit`

Similarly, `borrow_limit` in the `users` table was incorrectly labeled as a foreign key. It is a plain integer value. The label was corrected to `NOT NULL INTEGER`.

### 4.4 Wrong ENUM Values for `research_access.access_type`

The initial ENUM values for `research_access.access_type` were `('view', 'download', 'cite')`, which describe user actions — not access levels. These values correctly belong in `research_access_log.action_type`. The access type field was corrected to `ENUM('open', 'restricted', 'subscription')`, reflecting the publication's access policy.


---

## 5. Finalized Database Schema

The finalized schema consists of 16 tables organized across three modules, normalized to the Third Normal Form (3NF).

### 5.1 Library Management Module (8 Tables)

| Table | Purpose |
|---|---|
| `departments` | Academic departments within the university |
| `categories` | Book classification categories |
| `users` | Students, faculty, staff, and admin accounts |
| `books` | Bibliographic details for all library books |
| `copies` | Individual physical copies of each book |
| `borrow_records` | Records of all borrowing transactions |
| `reservations` | Queue-based reservation system per book |
| `fines` | Overdue fine records linked to borrowing events |

### 5.2 Academic Integration Module (2 Tables)

| Table | Purpose |
|---|---|
| `courses` | University courses offered by departments |
| `textbook_courses` | Links textbooks to courses, professors, and semesters |

### 5.3 Research Management Module (6 Tables)

| Table | Purpose |
|---|---|
| `authors` | Research authors with affiliation details |
| `publications` | Journals, theses, conference papers, book chapters |
| `publication_authors` | Many-to-many link between publications and authors |
| `citations` | Self-referential citation relationships between publications |
| `research_access` | Per-user access level for each publication |
| `research_access_log` | Audit log of every research access event |


---

## 6. Key Design Decisions

Several design decisions were made during this phase that go beyond the initial plan:

- **Separation of Books and Copies**
  Each physical copy is tracked individually in `copies`, while `books` holds the shared bibliographic record. Reservations target the book; borrowing targets a specific copy.

- **Queue-Based Reservation System**
  The `queue_position` field in `reservations` enables ordered waiting lists per book, directly implementing the reservation flowchart designed in Phase 1.

- **Role-Based Borrow Limits**
  Rather than hardcoding borrow limits in application logic, the `borrow_limit` column on `users` allows per-user configuration, supporting different limits for students, faculty, and staff.

- **Separation of Access Rules and Access Events**
  `research_access` stores what a user is permitted to do with a publication. `research_access_log` records what they actually did. This separation supports both access control and auditing independently.

- **Self-Referential Citations**
  The `citations` table uses two foreign keys pointing to `publications` — `citing_publication_id` and `cited_publication_id` — implementing the recursive relationship from the citation workflow. A CHECK constraint prevents a publication from citing itself.

- **Cascading Deletes Applied Selectively**
  `ON DELETE CASCADE` is used only where removing the parent record makes orphaned child records meaningless (e.g. removing a publication removes its author links). `ON DELETE RESTRICT` is used on circulation tables to preserve borrowing history.

- **UNIQUE Constraints on Key Business Fields**
  `users.email`, `books.isbn`, `courses.course_code`, `publications.doi`, and the `(book_id, course_id, semester)` combination in `textbook_courses` are all enforced as unique to prevent duplicate records.


---

## 7. DDL Implementation

The complete DDL script (`schema.sql`) was written for MySQL 8.0+. It includes:

- `CREATE DATABASE` statement with UTF-8 encoding
- All 16 `CREATE TABLE` statements in correct dependency order (no forward references to tables not yet created)
- Primary keys, foreign keys, NOT NULL constraints, UNIQUE constraints, and ENUM types for all applicable fields
- CHECK constraints enforcing business rules (e.g. due date must not precede borrow date; fine amount must be positive; payment date must be set when a fine is marked paid or waived)
- 17 indexes on foreign key columns and commonly searched fields, including a composite index on `(book_id, status, queue_position)` for efficient reservation queue lookups

The script is organized in three clearly labelled sections corresponding to the three system modules.


---

## 8. Challenges Faced

During this phase, several challenges were encountered:

- **Identifying gaps between the diagram and the flowcharts**
  The initial schema looked complete in isolation, but comparing it against the five workflow diagrams revealed missing fields (queue position, semester, borrow limit) that were not obvious from the ERD alone.

- **Distinguishing access rules from access events**
  The original `research_access` table conflated two separate concerns: defining what access a user has, and logging that access occurred. Separating these into two tables required rethinking the relationship structure.

- **Selecting appropriate ON DELETE behaviors**
  Different tables required different cascading behaviors. Choosing between RESTRICT, CASCADE, and SET NULL required careful analysis of each relationship to avoid accidental data loss while also preventing orphaned records.

- **ENUM consistency across modules**
  Several fields initially used generic VARCHAR types. Identifying all constrained fields and agreeing on consistent, meaningful ENUM values required a full pass across all 16 tables.


---

## 9. Next Steps

The next phase (Phase 3) will focus on:

- **Sample Data Insertion**
  Writing `INSERT` statements for all 16 tables with realistic data representing students, faculty, books, copies, borrows, reservations, publications, and citations

- **Core Query Development**
  Implementing SQL queries for all five workflows:
  - Borrowing process (availability check, borrow limit check, fine check, assignment)
  - Return process (overdue check, fine calculation, copy status update)
  - Reservation queue management (enqueue, notify, fulfil, cancel)
  - Research access control (access level verification, logging)
  - Citation lookup and management

- **Reporting Queries**
  Developing standard report queries including overdue books, unpaid fines per user, most borrowed books, and publications by author

- **Phase 4 Preparation**
  Outlining the testing and validation approach for constraint enforcement and workflow correctness


---

## 10. Conclusion

Phase 2 has been successfully completed. The initial schema design was critically reviewed against the five system workflows, seven structural issues were identified and corrected through two iterations of revision, and a complete DDL script covering all 16 tables across three modules was produced.

The finalized schema reflects the full scope of the **University Library & Research Management System** — combining traditional library circulation, academic course integration, and research publication management in a normalized, constraint-enforced relational database.

The next phase will bring this schema to life through sample data and SQL query development for all core system workflows.
