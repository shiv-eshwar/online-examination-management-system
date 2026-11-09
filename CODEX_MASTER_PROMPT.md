# MASTER CODEX BUILD PROMPT
## Build a complete Online Examination Management System

You are the lead full-stack engineer. Build a complete, polished, secure, runnable Online Examination Management System in this workspace. Read `README_FIRST.md` and all files in `docs/`, `db/`, and `PROJECT_STRUCTURE.md` before coding. The teacher's assessment requirements are in `TEACHER_REQUIREMENTS_SOURCE.md`; treat them as acceptance requirements.

**Do not merely explain, scaffold, mock, or create static screens. Implement a working application connected to a real MySQL database.** Do not use hard-coded arrays as substitutes for database results. Do not leave TODOs, placeholder buttons, fake charts, or nonfunctional CRUD controls in the final result.

## 1. Fixed technology stack
- Frontend: React, Vite, TypeScript, Tailwind CSS.
- Backend: Java 21, Spring Boot 3.x, Maven.
- Database: MySQL 8.0.16 or newer.
- API: Spring MVC REST endpoints returning JSON.
- Persistence: Spring Data JPA/Hibernate. Use parameterized repository queries or safe JPQL/native SQL.
- Authentication/authorization: Spring Security, BCrypt password hashes, JWT-based stateless API authentication.
- Validation: Jakarta Bean Validation plus service-layer business validation and database constraints.
- Tests: JUnit 5, Spring Boot Test, Testcontainers if available; frontend tests with Vitest/React Testing Library; Playwright for key end-to-end flows if practical.
- Do not introduce a different primary stack. Avoid unnecessary paid services.

## 2. Product goal
Create a professional university examination portal with three roles:
1. ADMIN — manages users, courses, faculty assignments, enrollments, and institution-wide reports.
2. FACULTY — manages only courses assigned to them, creates exams and MCQ questions, publishes/closes exams, and views results for their courses.
3. STUDENT — sees courses in which they are enrolled, sees eligible exams, takes each exam at most once, submits answers, and views released results.

The application must enforce access rules in backend services and database queries, not only by hiding frontend controls.

## 3. Required workflows (all must work end-to-end)
A. Authentication and account administration
- Login/logout; secure password hashing; role-specific navigation.
- Admin can create, list, update, and deactivate users.
- Admin can create courses and assign a faculty member.
- Validate unique email and course code.
- Never expose password hashes in API responses.
- Do not provide public self-registration unless it is deliberately implemented with safe defaults; seed demo accounts for assessment.

B. Enrollment
- Admin enrolls a student in a course and can remove an enrollment only when doing so will not violate historical data constraints.
- Prevent duplicate enrollment.
- Only STUDENT users may be enrolled and only valid courses may be selected.
- Student can view their own enrollments; faculty can view enrollments for their assigned courses.

C. Exam authoring and publishing
- Faculty can create a DRAFT exam only for a course assigned to them.
- Faculty can add, edit, and delete questions/options while the exam is DRAFT.
- Support MCQ questions with exactly four options (A-D) and exactly one correct option for this project.
- Validate positive marks and non-empty question/option text.
- Publishing requires at least one question, exactly four options per question, exactly one correct option per question, a valid schedule, and sum(question marks) equal to exam.totalMarks.
- Once PUBLISHED, exam content and schedule cannot be edited. Faculty may close an exam through a valid transition. Enforce status transitions server-side.
- Admin may inspect exams but should not silently bypass ownership rules.

D. Student examination
- Student can list exams only for courses in which they are enrolled.
- Student can start an exam only if it is PUBLISHED and current time is within the allowed exam window.
- One attempt per student per exam, enforced by a UNIQUE database constraint as well as application logic.
- Attempt duration is the smaller of the configured duration and remaining time until exam end.
- Show a countdown based on server-provided timestamps; do not trust the browser clock as the authority.
- Student can save answers and submit. A response must belong to the same exam as its attempt and the selected option must belong to that exact question.
- Submission must be atomic: validate all submitted responses, calculate score on the server using stored correct-answer flags, persist responses and final score, set submitted timestamp/status, and commit in one transaction. On any failure, rollback all writes in that operation.
- Never send correct-answer flags to student-facing exam APIs before result release.
- Prevent changes to submitted attempts. Reject late submission according to the server-side deadline policy.
- Handle empty/unanswered questions consistently (zero marks).

E. Results and reports
- Student can view only their own submitted attempts and only when result visibility policy permits. Use a simple policy: results become visible after submission; do not reveal correct answers until submission.
- Faculty can view results only for exams in courses assigned to them.
- Admin can view institution-wide reports.
- Provide useful report screens and real SQL-backed data:
  1. exam participation and average/highest score,
  2. course-wise performance,
  3. pass percentage (pass threshold default 40%, configurable centrally),
  4. student attempt history.
- Use JOINs and GROUP BY. Include the SQL/JPQL/native query used and explain its derivation in documentation.
- Empty report states must be handled gracefully.

## 4. Database
Use `db/schema.sql` as the baseline and `db/seed.sql` for deterministic demo records. Review and improve them if needed, but preserve the eight normalized entities and their integrity intent:
- users
- courses
- enrollments
- exams
- questions
- question_options
- attempts
- responses

Use Flyway migrations in the generated backend. Put the baseline schema in a Flyway migration and keep the standalone SQL scripts synchronized. Use `ddl-auto=validate` (not `create`/`update`) for normal runs. Database credentials must come from environment variables and must never be committed.

Important integrity requirements:
- primary keys and foreign keys on all relationships,
- NOT NULL, UNIQUE and CHECK constraints where appropriate,
- composite keys/foreign keys to prevent cross-exam and cross-question response mismatches,
- one attempt per student per exam,
- duplicate enrollments prevented,
- role and ownership checks in application logic,
- transaction around final submission,
- indexes for common filters and joins.

MySQL CHECK constraints are enforced in MySQL 8.0.16+. Ensure compatibility with that minimum version.

## 5. Frontend quality bar
Build a cohesive, polished, responsive academic portal. Use a consistent design system, spacing, typography, restrained color palette, accessible contrast, keyboard focus states, loading states, empty states, success/error feedback, and confirmation dialogs for destructive actions.

Required pages:
- Login
- Role-specific dashboard
- User management (admin)
- Course management (admin)
- Enrollment management (admin)
- Faculty course list
- Exam list and exam editor (faculty)
- Question/option editor
- Exam preview and publish confirmation
- Student course/exam list
- Exam-taking interface with countdown and submit confirmation
- Student results/history
- Faculty results and reports
- Admin reports

Navigation and data must be role-aware. Tables need search/filter where useful, pagination for larger lists, readable status indicators, and responsive behavior. Forms must show field-level validation messages. Never use a fake chart; chart values must come from report APIs.

## 6. Backend quality bar
- Layered architecture: controller → service → repository → entity/DTO.
- Use DTOs; do not serialize JPA entities directly.
- Centralized exception handling with consistent error response shape.
- Validate request bodies using Jakarta validation.
- Use method/service authorization and ownership-aware queries.
- Use BCrypt; never log passwords or JWTs.
- Configure CORS only for the frontend origin from configuration.
- Use parameterized queries.
- Avoid N+1 query patterns in dashboards/reports.
- Add pagination where appropriate.
- Add database indexes for foreign keys and report filters.
- Use `@Transactional` for multi-record changes and final submission.
- Return useful HTTP status codes (400 validation, 401 unauthenticated, 403 forbidden, 404 missing, 409 duplicate/state conflict).
- Never leak stack traces or secrets to clients.

## 7. API and documentation
Follow `docs/api_contract.md`. You may add endpoints if needed, but document them. Provide:
- root README with prerequisites, environment setup, database setup, run commands, demo credentials, and troubleshooting;
- `.env.example` and `application.yml` using environment placeholders;
- Flyway migrations;
- OpenAPI/Swagger UI;
- ER diagram source and exported image if practical;
- report SQL with explanations;
- compact test-case table with input, expected result, observed result (fill observed after actually running tests);
- screenshots of key workflows if browser automation is available;
- GitHub-ready `.gitignore`.

Do not put real credentials in source control. Demo passwords may be documented only if they are clearly local-only seeded demo credentials and are hashed before storage. The SQL seed uses a `BOOTSTRAP_WITH_BCRYPT` marker; implement a dev-profile initializer that replaces/creates these accounts with BCrypt hashes before login is tested. Never authenticate against the marker.

## 8. Test and acceptance process — mandatory
Before declaring completion:
1. Run backend tests and frontend tests; fix failures.
2. Start MySQL and the backend; verify Flyway migrations apply.
3. Start frontend and verify API connectivity.
4. Run the complete happy path:
   admin login → create faculty/student/course → enroll student → faculty creates exam/questions → publish → student login → start → submit → view result → faculty/admin report.
5. Verify invalid and duplicate email/course code/enrollment/attempt are rejected.
6. Verify non-enrolled student cannot access or start exam.
7. Verify faculty cannot modify another faculty member's course/exam.
8. Verify draft cannot be attempted; published exam cannot be edited.
9. Verify cross-exam question/option IDs are rejected.
10. Verify a failed multi-record submission leaves no partial final submission and the attempt remains in a consistent state.
11. Restart the app and verify persisted records remain.
12. Verify report queries use actual database data and JOIN/GROUP BY.
13. Record actual commands and test outcomes in `docs/IMPLEMENTATION_STATUS.md`.

If Docker is available, provide `docker-compose.yml` for MySQL and optionally the full app. If not, provide exact local MySQL instructions. Do not claim a test passed unless it was run and passed. If the environment prevents a test, state exactly what could not be verified and why.

## 9. Working method
- First inspect the workspace and produce a concise implementation plan.
- Implement in small phases, keeping the application runnable.
- Do not stop after generating a plan or initial scaffold.
- After each phase, run relevant tests and fix issues.
- Keep SQL schema, Flyway migrations, entities, DTOs, and docs consistent.
- If a requirement is ambiguous, choose the simplest defensible implementation and document the decision rather than blocking.
- At the end, summarize implemented features, setup commands, demo credentials, test results, and known limitations.

## 10. Definition of done
The project is done only when:
- a user can run it locally from documented steps;
- the UI performs real CRUD and workflows against MySQL;
- all three roles are enforced server-side;
- four required workflows work end-to-end;
- invalid/duplicate/domain-invalid data is rejected;
- data persists after restart;
- atomic submission is implemented and tested;
- JOIN/GROUP BY reports work on stored data;
- documentation, ER diagram, test cases, and GitHub-ready files are present.

Start now. Read all specification files, inspect the workspace, then implement the full application.
