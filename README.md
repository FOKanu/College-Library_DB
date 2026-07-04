# University Library & Research Management System

**Course:** Database Systems (BIT3.1) · SS 2026  
**Group 3:** Francis Okorie Iyeke-Kanu, Dhrumil Khandla  
**Repository:** [github.com/FOKanu/College-Library_DB](https://github.com/FOKanu/College-Library_DB)

A relational database for a university library that covers traditional circulation (borrow, return, reservations, fines), academic textbook–course linking, and research publication management with citations and access control.

---

## Project status at a glance

| Phase | Description | Status |
|-------|-------------|--------|
| **Phase 1** | Requirements, workflow flowcharts, ERD design | ✅ Complete |
| **Phase 2** | Schema review, normalization (3NF), DDL | ✅ Complete |
| **Phase 3** | Mock data, workflow queries, reporting queries | ✅ Complete |
| **Phase 4** | Testing, validation, final documentation | ⏳ Not started |

**Bottom line:** The database is fully defined, populated with sample data, and queryable. What remains is systematic testing and a final progress report.

---

## What has been implemented

### Database schema (`SQL/schema.sql`)

- **16 tables** across **3 modules**, normalized to **3NF**
- **MySQL 8.0+** (`library_db`, `utf8mb4`, InnoDB)
- **20 foreign keys**, **7 UNIQUE constraints**, **10 CHECK constraints**, **6 ENUM types**
- **17 secondary indexes** for common lookups
- Triggers on `citations` to prevent self-citation (MySQL-compatible alternative to CHECK on FK columns)

#### Module 1 — Library management (8 tables)

`departments` · `categories` · `users` · `books` · `copies` · `borrow_records` · `reservations` · `fines`

#### Module 2 — Academic integration (2 tables)

`courses` · `textbook_courses`

#### Module 3 — Research management (6 tables)

`authors` · `publications` · `publication_authors` · `citations` · `research_access` · `research_access_log`

### Mock data (`SQL/insert.sql`)

Sample data for all 16 tables (~3× expanded dataset). Key test scenarios are preserved with fixed IDs so queries stay predictable:

| Scenario | How to find it in data |
|----------|------------------------|
| User at borrow limit | **Anna Limit** — `user_id = 12` (5 active loans) |
| Overdue loan + unpaid fine | **Bob Student** — `user_id = 5`, `borrow_id = 5` |
| Normal borrow candidate | **Clara Student** — `user_id = 6` |
| Book with available copies | **Introduction to Algorithms** — `book_id = 3` |
| Reservation queue (all copies out) | **Linear Algebra** — `book_id = 2` (queue positions 1–4) |
| Uncategorised book | `book_id = 12` or `36` (`category_id IS NULL`) |
| Fine statuses | Unpaid, paid, and waived examples in `fines` |

**Approximate row counts:** 36 users · 36 books · 54 copies · 48 borrow records · 18 reservations · 21 publications · etc.

### Workflow queries (`SQL/queries/`)

Five workflow files, each broken into numbered steps. SQL style matches BIT3.1 lectures (SELECT-FROM-WHERE, comma joins, subqueries, simple DML).

| File | Workflow |
|------|----------|
| `borrow.sql` | Check availability → borrow limit → unpaid fines → INSERT borrow + UPDATE copy |
| `return.sql` | Active loans → overdue check → fine calculation → return + copy update |
| `reservations.sql` | Availability → view queue → enqueue → next in line → fulfil / cancel |
| `research_access.sql` | Access check → list permissions → log access → history |
| `citations.sql` | Citation lookup → cited-by / cites → authors → add citation |

> **Note:** DML steps in workflow files modify data. Re-run `insert.sql` to reset the database before testing again.

### Reporting queries (`SQL/queries/reports.sql`)

| Report | Description |
|--------|-------------|
| Overdue books | Active loans past `due_date` |
| Unpaid fines per user | `GROUP BY` user with `SUM(amount)` |
| Most borrowed books | Borrow count per title |
| Publications by author | Publications listed per author in citation order |

### Documentation

| File | Contents |
|------|----------|
| `Progress Report 2 - Schema Finalization and DDL Implementation.md` | Phase 2: design review, 7 issues fixed, design decisions |
| `Project Plan.md` | Full phase breakdown and repository layout |
| `Reference Material/` | ERD diagrams (v7.2), flowcharts, exercise pack, Progress Report 1 & 2 PDFs |

---

## What has not been implemented yet

### Phase 4 — Testing & validation (planned)

- [ ] Test plan for constraint enforcement (CHECK, FK, UNIQUE, ENUM)
- [ ] Verify each workflow query against expected mock-data results
- [ ] Negative tests (e.g. invalid dates, self-citation, duplicate email)
- [ ] Progress Report 3 (data + queries phase)
- [ ] Final submission packaging

### Out of scope (not planned for this assignment)

- Application / UI layer
- Stored procedures or triggers beyond self-citation prevention
- Production deployment or user authentication

---

## Quick start

### Prerequisites

- **MySQL 8.0+** (tested on MySQL 9.x)
- MySQL client (`mysql` CLI or MySQL Workbench)

### 1. Create the database and tables

```bash
mysql -u root -p < SQL/schema.sql
```

### 2. Load sample data

```bash
mysql -u root -p library_db < SQL/insert.sql
```

`insert.sql` truncates all tables first, so it is safe to re-run when resetting test data.

### 3. Run queries

```bash
# Reporting
mysql -u root -p library_db < SQL/queries/reports.sql

# Individual workflows
mysql -u root -p library_db < SQL/queries/borrow.sql
mysql -u root -p library_db < SQL/queries/return.sql
mysql -u root -p library_db < SQL/queries/reservations.sql
mysql -u root -p library_db < SQL/queries/research_access.sql
mysql -u root -p library_db < SQL/queries/citations.sql
```

Or open any `.sql` file in MySQL Workbench and execute step by step.

---

## Repository structure

```
College-Library_DB/
├── README.md                          ← this file
├── Project Plan.md                    ← phase plan and current status
├── Progress Report 2 ...md            ← Phase 2 documentation
├── Reference Material/                ← ERD, flowcharts, PDFs
└── SQL/
    ├── schema.sql                     ← DDL (16 tables, constraints, indexes)
    ├── insert.sql                     ← mock data (all tables)
    └── queries/
        ├── borrow.sql
        ├── return.sql
        ├── reservations.sql
        ├── research_access.sql
        ├── citations.sql
        └── reports.sql
```

---

## Key design decisions (summary)

1. **Books vs copies** — Bibliographic record in `books`; each physical item in `copies`. Reservations target a book; borrows target a copy.
2. **Queue-based reservations** — `queue_position` on `reservations` implements FIFO per book.
3. **Borrow limits in the database** — `users.borrow_limit` (default 5); role-specific limits can be set per user.
4. **Access rules vs audit log** — `research_access` stores permissions; `research_access_log` records actual access events.
5. **Single author on books** — `books.primary_author` is a string; research uses full `authors` + `publication_authors` model.
6. **Selective cascading** — `ON DELETE RESTRICT` on circulation history; `CASCADE` only where child rows are meaningless without the parent.

Full rationale is in Progress Report 2.

---

## For colleagues joining the project

1. Clone the repo and run **Quick start** steps above.
2. Read **Progress Report 2** for schema background and **Project Plan.md** for what is next.
3. Use the **test scenario table** above when running workflow queries — IDs are intentional.
4. Next task: **Phase 4** testing. See `Project Plan.md` → Stage 3.4 for the checklist.
5. After workflow DML tests, always reset with `insert.sql` before the next run.

---

## Contact

**Group 3** — Francis Okorie Iyeke-Kanu, Dhrumil Khandla  
Course: Database Systems (BIT3.1), SS 2026
