# University Library & Research Management System — Project Plan

**Course:** Database Systems (BIT3.1) | SS 2026  
**Group 3:** Francis Okorie Iyeke-Kanu, Dhrumil Khandla

---

## Phase overview

| Phase | Focus | Status |
|-------|--------|--------|
| **Phase 1** | Requirements, workflow flowcharts, initial ERD | Complete |
| **Phase 2** | Schema review, normalization, DDL (`schema.sql`) | Complete |
| **Phase 3** | Data population and SQL query implementation | **Complete** |
| **Phase 4** | Testing, validation, final documentation | Planned |

---

## Phase 3 — Detailed stages

Phase 3 is split into ordered substages. Each stage builds on the previous one.

### Stage 3.1 — Synthetic / mock data insertion *(complete)*

**Deliverable:** `SQL/insert.sql` ✓

- `INSERT` statements for all 16 tables in FK dependency order
- Realistic university-themed sample records (departments, users, books, copies, etc.)
- Edge-case rows to support workflow and reporting queries:
  - Active borrows, returned borrows, and overdue borrows (`return_date IS NULL`, `due_date` in the past)
  - User at borrow limit vs user with capacity remaining
  - Unpaid, paid, and waived fines
  - Reservation queue with multiple `queue_position` values per book
  - Copy statuses: `available`, `borrowed`, `reserved`, `damaged`, `lost`
  - Research access rules and audit log entries
  - Publication citations (including multi-author publications)

**Run order:**

```bash
mysql -u <user> -p < SQL/schema.sql
mysql -u <user> -p library_db < SQL/insert.sql
```

### Stage 3.2 — Core workflow queries *(complete)*

**Deliverable:** `SQL/queries/` ✓

- `borrow.sql` — availability check, borrow limit, unpaid fines, borrow DML
- `return.sql` — active loans, overdue check, fine calculation, return DML
- `reservations.sql` — queue view, enqueue, next in line, fulfil, cancel
- `research_access.sql` — access check, logging, access history
- `citations.sql` — citation lookup, author list, add citation

Queries follow BIT3.1 class style: `SELECT-FROM-WHERE`, comma joins with aliases,
`ORDER BY`, `GROUP BY`, `NOT IN` subqueries, and simple `INSERT`/`UPDATE`.

### Stage 3.3 — Reporting queries *(complete)*

**Deliverable:** `SQL/queries/reports.sql` ✓

- Overdue books
- Unpaid fines per user
- Most borrowed books
- Publications by author

### Stage 3.4 — Phase 4 preparation

- Test plan for constraint enforcement (CHECK, FK, UNIQUE, ENUM)
- Workflow correctness checks against mock data
- Document expected query results for key scenarios

---

## Repository layout (target)

```
Assignment - Library Database/
├── PROJECT PLAN.md              ← this file
├── PROGRESS REPORT 2 ...md
├── Reference Material/
└── SQL/
    ├── schema.sql               ← Phase 2 (complete)
    ├── insert.sql               ← Phase 3.1 (complete)
    └── queries/                 ← Phase 3.2–3.3 (complete)
        ├── borrow.sql
        ├── return.sql
        ├── reservations.sql
        ├── research_access.sql
        ├── citations.sql
        └── reports.sql
```

---

## Current position

**Active stage:** 3.4 — Phase 4 preparation (testing & validation)  
**Completed:** 3.1 — mock data · 3.2 — workflow queries · 3.3 — reporting queries
