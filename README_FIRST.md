# Online Examination Management System — Codex Handoff

This package is a build specification and starter database kit for a complete DBMS mini-project. Give the entire extracted folder to Codex and start with `CODEX_MASTER_PROMPT.md`.

## Selected stack
- Frontend: React + Vite + TypeScript + Tailwind CSS
- Backend: Java 21 + Spring Boot 3.x
- Database: MySQL 8.0.16+
- API: REST/JSON
- Authentication: Spring Security + BCrypt password hashing + JWT (short-lived access token; refresh-token strategy may be implemented securely)
- Database access: Spring Data JPA/Hibernate, with explicit SQL/native queries where useful for reports

## Start here
1. Extract the ZIP.
2. Open the extracted folder as the workspace in Codex.
3. Open `CODEX_MASTER_PROMPT.md`.
4. Tell Codex: **"Read CODEX_MASTER_PROMPT.md and every referenced file. Build the complete application in this workspace. Do not stop at scaffolding; implement, run, test, and fix it."**
5. Let Codex work in phases and review its test results.

## Important
This ZIP is a complete implementation brief, database starter, and acceptance-test pack. It is not itself the finished application binary. Codex must generate the frontend/backend source code, run the application, and verify the acceptance criteria.

## Files
- `CODEX_MASTER_PROMPT.md` — main build instruction; read first.
- `docs/` — functional requirements, architecture, data dictionary, API contract, UI guidance, test plan, and rubric traceability.
- `db/schema.sql` — MySQL schema.
- `db/seed.sql` — deterministic demo data.
- `db/queries.sql` — report and demonstration queries.
- `db/er_diagram.mmd` — Mermaid ER diagram source.
- `.env.example` — configuration variable names; no secrets.
- `PROJECT_STRUCTURE.md` — target repository structure.
- `TEACHER_REQUIREMENTS_SOURCE.md` — requirements transcribed from the supplied handout.
