# Architecture and Design Decisions

## High-level architecture
React SPA → Spring Boot REST API → MySQL.

Frontend responsibilities: navigation, forms, client-side convenience validation, loading/error states, exam timer display, report visualization.

Backend responsibilities: authentication, authorization, ownership checks, validation, scheduling enforcement, scoring, transactions, report queries.

Database responsibilities: durable persistence, keys, referential integrity, uniqueness, checks, indexes.

## Backend package suggestion
`config`, `security`, `auth`, `user`, `course`, `enrollment`, `exam`, `question`, `attempt`, `report`, `common`.

Each domain should use controller, service, repository, entity, DTO and mapper as appropriate.

## Security
- BCrypt password encoder.
- JWT validation in a Spring Security filter.
- Role-based authorization plus service-level ownership checks.
- Do not trust user IDs or role values supplied by the browser. Derive identity from authenticated principal.
- CORS origin configurable by environment.
- Do not store JWT or passwords in logs.
- Keep secrets out of Git.

## Exam lifecycle
DRAFT → PUBLISHED → CLOSED.
- Draft content can be edited.
- Publish only after all validation succeeds.
- Published exam content/schedule is immutable.
- A published exam can become CLOSED. Closed exams cannot be started.
- A scheduled exam can be published before its start time.

## Attempt lifecycle
IN_PROGRESS → SUBMITTED.
- Start only within exam window and if enrolled.
- Unique `(exam_id, student_id)` guarantees one attempt.
- Server is authoritative for start/deadline timestamps.
- Effective deadline = earlier of `started_at + duration_minutes` and `exam.end_time`.
- Submit only before or at effective deadline, according to server time.
- Submission validates all question/option relationships, computes score on server, stores responses and marks attempt submitted in one transaction.
- Once submitted, no response edits are allowed.

## Scoring
Each question has a positive mark value. Each question has exactly four options and exactly one correct option. Correct response earns full question marks; incorrect or unanswered response earns zero. No negative marking. Exam total marks must equal the sum of question marks at publication.

## Result policy
Submitted attempt results are visible to the student immediately. Correct-answer details may be shown only after submission. Exam-taking payloads must never expose `is_correct`.

## Data retention
Use deactivation for users rather than deleting users with historical records. Use restrictive deletion for courses/exams/attempts with history. Draft question deletion may cascade to options. Never cascade-delete submitted attempt history.
