# Implementation and verification status

Verified 2026-11-08 on macOS ARM64 with Java 21.0.13, Maven 3.10, Node/npm, MySQL 8.4.13. Native Homebrew MySQL was used; Docker daemon is unavailable.

## Implemented

- React/TypeScript/Vite/Tailwind frontend and Spring Boot REST backend.
- MySQL Flyway migration for all eight supplied entities; BCrypt local seeding; JPA native-query persistence; Spring Data repository; Hibernate validation enabled.
- JWT stateless authentication; role namespaces; backend faculty ownership and enrollment/attempt scoping; activity checks on every authenticated request.
- User create/read/update/deactivate, course create/read/update/faculty assignment, enrollment add/list/remove with historical-data safeguard.
- Faculty exam create/edit/preview, question/options create/edit/delete, publish and close lifecycle.
- Student eligible exam list, start/resume, deadline countdown, debounced autosave/manual save, atomic scoring/submission, result history and submitted question review.
- Admin/faculty submitted histories, course aggregate report and live pass-rate bars. Exam-performance/pass-rate APIs also supplied.
- Responsive forms, native required/email/range validation, backend error banners, confirmation dialogs, tables, search and pagination. User search/pagination has SQL support; other table search/pagination is client-side over real API records.
- Swagger/OpenAPI, setup guide, ER source, SQL examples, normalization report, acceptance script, test cases and Chrome screenshot.

## Actual executed checks

| Input or scenario | Command / steps | Expected | Observed |
|---|---|---|---|
| Backend integration tests | `JAVA_HOME=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home mvn -q -f backend/pom.xml test` | Role/validation/lifecycle/JWT tests pass | PASS: 4 JUnit tests, zero failures/errors |
| Frontend tests | `cd frontend && npm test` | Server-relative countdown, expired countdown, accessible login, login error | PASS: 4 tests in 2 files |
| Production build | `cd frontend && npm run build` | TypeScript and Vite compile | PASS |
| Fresh database | Start backend on empty online_exam_system | V1 migration and demo initialization | PASS: Flyway applied, real BCrypt login succeeded |
| Four main workflows | `python3 scripts/acceptance.py` | Admin setup → enrollment → faculty publish → student submit → report | PASS: 53 HTTP checks plus assertions; retained unique records |
| Duplicate user/course/enrollment/attempt | Acceptance script | 409, no duplicate | PASS |
| Malformed email/non-student enrollment | Acceptance script | 400 | PASS |
| Student in admin namespace | Acceptance script | 403 | PASS |
| Other faculty creating/editing/viewing results | Acceptance script | 403 | PASS |
| Non-enrolled student starting exam | Acceptance script | 404, no attempt | PASS |
| Attempt draft; edit published content | Acceptance script | 409 | PASS |
| Missing questions publication | Acceptance script / JUnit | Rejected, remains draft | PASS |
| Cross-question/cross-exam response after earlier valid write | Acceptance script | Operation rejected, all new answers rolled back, attempt remains IN_PROGRESS | PASS; response list remained empty |
| Correct answer scoring | Acceptance script | 20/20, SUBMITTED | PASS |
| Mutate/resubmit final attempt | Acceptance script | 409 | PASS |
| Effective deadline elapsed | Acceptance script modifies test attempt start using local MySQL CLI | 409 | PASS |
| JOIN/GROUP BY report | Acceptance script | 1 submitted, mean/highest 20, pass 100% for created exam | PASS |
| Restart persistence | Stop process on 8080, restart `scripts/run-backend.sh`, authenticate retained student and fetch result | Same submitted score remains | PASS: attempt 4 retained, score 20 |
| Swagger schema | `curl http://localhost:8080/v3/api-docs` | HTTP 200 | PASS |
| Frontend API proxy | `curl http://localhost:5173/api/v1/health` | HTTP 200 | PASS |
| Actual Chrome UI | Login admin, inspect live dashboard, Users → Create User → save Browser Verification Student | New student shown from MySQL | PASS; screenshot captured |
| Production dependency audit | `npm audit --omit=dev` | No known runtime dependency vulnerabilities | PASS: 0 |

Raw HTTP evidence: `acceptance-results.txt`. Tests were rerun after relevant fixes. Early failures included a seeder transaction-proxy field access error, a missing TypeScript DOM.Iterable library, an incorrect duplicate test fixture, and jsdom form submission handling. Those were corrected before recording passes.

## Verification limits and implementation tradeoffs

- Complete four-workflow verification was at the HTTP API/MySQL layer. Chrome verification covered admin login, real reports and user creation; full faculty/student click-through and responsive/mobile visual QA remain unverified. Do not describe those as browser E2E passes.
- Docker Compose is supplied but was not run because the Docker daemon is unavailable.
- No Playwright suite or exported ER image was produced; Mermaid source is provided.
- Only the users table has a JPA entity mapping; native JPA projections implement the remaining domains. Flyway and MySQL constraints define/validate their relational structure. This is a deliberate compact implementation, rather than eight entity/repository packages.
- JSON projection maps are used instead of typed DTO classes for most endpoints. Login uses Jakarta Bean Validation; other bodies use service validation and database checks. Forms use native field validation plus general API error feedback.
- Most lists are loaded as full API arrays, then searched/paginated in the browser. User endpoint additionally supports SQL `search/page/size`. Large-institution scalability has not been load-tested.
- Logout discards the short-lived access token; no refresh/revocation store. Late submissions are rejected rather than auto-finalized. Expired in-progress attempts retain their saved history.
- The running frontend has nonfatal Vite/plugin deprecation warnings. Backend tests and the acceptance deadline fixture assume the local assessment MySQL account/path; adapt them as documented for another machine.

## Public repository preparation — 2026-11-09

- Rewrote README with exact HTTPS clone URL, prerequisites, Docker/local MySQL setup, configuration, demo walkthrough, test instructions and troubleshooting.
- Added GitHub Actions for Java 21 + MySQL 8.4 integration tests and Node 22 frontend tests/build. Check the remote run for its current status.
- Backend tests now use configured datasource credentials; `scripts/test-backend.sh` loads `.env`. The acceptance script supports a portable MySQL client, configured host/port/account, and API_BASE_URL.
- Reran backend tests: 4 passed; frontend tests: 4 passed; frontend build: passed; HTTP acceptance: 53 checks passed.
- Staged source scan found no credential patterns or private `.env` secret values. Excluded local screenshots, Word handout, dependency directories, compiled files and environment credentials from publication.
- The original 2026-11-08 evidence above remains historical; current tests no longer hard-code the local root datasource in the JUnit annotation.
- A fresh `npm ci` exposed an incompatible Vite React plugin. Updated `@vitejs/plugin-react` to 6.3, refreshed the lockfile, and verified a subsequent clean `npm ci`, 4 frontend tests, and production build all pass. Full npm audit reports zero known vulnerabilities; the previous Vite/plugin deprecation warnings are resolved.
