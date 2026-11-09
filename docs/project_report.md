# Online Examination Management System — project report

## Problem and users

A university needs consistent enrollment, controlled examination publishing, secure student submissions and trustworthy performance reports. Administrators maintain accounts and courses, assigned faculty author examinations, and enrolled students submit one timed attempt. Four complete workflows connect real browser forms and JSON APIs to durable MySQL records: administration/enrollment; examination authoring/publishing; attempt/save/submission; result reporting.

## Relational design and normalization

The eight entities and cardinalities are defined in `../db/er_diagram.mmd` and `data_dictionary.md`. Users have a unique email. Courses have a unique code and one faculty owner. Enrollments resolve the student/course many-to-many relationship using a composite key. Exams belong to courses; questions belong to exams; four labeled options belong to each question. Attempts relate a student and exam with a unique pair. Responses relate an attempt and question and optionally one selected option.

1NF: columns hold scalar values; options and responses are rows, not repeating columns or arrays. 2NF: enrollment date depends on the entire enrollment pair; a response's answer depends on its entire attempt/question pair. Other domain tables have single-column primary keys. 3NF: user names, course names and option text are not duplicated into attempts or responses. Score is an intentionally materialized final outcome calculated atomically, rather than client-controlled input. The response exam ID is a deliberate integrity redundancy used by composite foreign keys to bind both question and attempt to the same examination.

The schema enforces positive marks/duration, ordered dates, one attempt, unique enrollments, referential integrity, and same-question options. Services enforce role, ownership, enrollment, four options/one correct answer, lifecycle and timing rules that span rows. Published content cannot change, so finalized scoring remains reproducible.

## Atomicity and access

Spring Security validates HMAC JWT signatures and expiry, reloads account activity and role, and restricts role namespaces. The service additionally scopes courses to faculty and attempts to the current student. JWT student identity overrides any supplied client identity. BCrypt protects stored passwords. Native queries bind input parameters. A row lock serializes attempt mutation; saving and scoring share a transaction. If a later answer references another question or exam, earlier writes in that operation roll back. The acceptance suite verifies the response table is still empty and status remains IN_PROGRESS.

## Query derivation

`Portal.report` is the running aggregate implementation. It starts with courses, LEFT JOINs exams, then LEFT JOINs submitted attempts, preserving courses/exams with no submissions. GROUP BY course or exam gives one report row per group. COUNT excludes null joined attempts, AVG and MAX use stored scores, and CASE counts attempts reaching each exam's pass threshold. The pass rate divides that count by submitted attempts; NULLIF avoids division by zero. COALESCE maps empty aggregates to zero. Faculty predicates restrict the query to assigned courses before aggregation. `PASS_PERCENTAGE` centrally configures the default threshold copied to newly authored exams.

`db/queries.sql` includes the equivalent teaching queries. The enrollment roster uses a JOIN of users, courses and enrollments to retrieve student names without copying them. Attempt history joins users, exams and courses, preserving the normalized model. Indexes on relationships, schedule/status, and student/status support common access paths.

## Evidence

Actual API outcomes are in `acceptance-results.txt`, build/test/restart outcomes in `IMPLEMENTATION_STATUS.md`, and local Chrome screenshot evidence (excluded from the public repository to avoid sharing browser-profile details). No frontend workflow beyond those explicitly recorded is represented as browser-tested. No team-member contribution names have been invented; fill in actual contributors before submission.
