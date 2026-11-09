# Functional Requirements

## Scope
A browser-based Online Examination Management System for a university. It supports administrator, faculty, and student workflows. Exams are MCQ-only for a manageable mini-project scope.

## Actors and permissions

| Capability | Admin | Faculty | Student |
|---|---:|---:|---:|
| Manage users | Yes | No | No |
| Create/manage courses | Yes | Assigned courses only (content view) | No |
| Manage enrollments | Yes | View own-course enrollments | View own |
| Create exams | Inspect | Assigned courses only | No |
| Add/edit questions | No | Own draft exams | No |
| Publish/close exams | No | Own exams | No |
| Attempt exam | No | No | Enrolled students only |
| View all reports | Yes | Own-course reports | No |
| View own results | No | No | Yes |

Admin creates and assigns faculty to courses. Faculty ownership must be checked on the backend. A faculty user must not create exams in another faculty member's course.

## Functional requirements
FR-01 Login using email and password.
FR-02 Return role and safe user profile; never return password hash.
FR-03 Admin creates, reads, updates, and deactivates users.
FR-04 Admin creates, reads, updates, and lists courses.
FR-05 Admin enrolls students in courses and prevents duplicate enrollment.
FR-06 Students view only their own courses.
FR-07 Faculty views only courses assigned to them.
FR-08 Faculty creates a draft exam for an assigned course.
FR-09 Faculty manages questions and exactly four options per question while draft.
FR-10 Faculty publishes a valid exam.
FR-11 Faculty closes an exam when appropriate.
FR-12 Student views published exams only for enrolled courses.
FR-13 Student starts an exam within its scheduled window.
FR-14 Student has at most one attempt per exam.
FR-15 Student saves and submits responses.
FR-16 Server calculates score; client never supplies score or correctness.
FR-17 Student views own result after submission.
FR-18 Faculty views results for assigned courses.
FR-19 Admin views institution-wide reports.
FR-20 Search/filter and pagination are provided for relevant lists.
FR-21 Destructive operations require confirmation.
FR-22 Application displays useful validation, conflict, and server error messages.

## Non-functional requirements
- Responsive and accessible interface.
- Persist data in MySQL across restarts.
- Password hashes use BCrypt.
- REST API protected by Spring Security.
- Parameterized database access.
- Transactions for multi-record operations.
- Centralized error handling.
- Configuration and secrets externalized.
- Reproducible local setup documented.
