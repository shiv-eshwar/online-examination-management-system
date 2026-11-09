# REST API Contract

Base path: `/api/v1`. JSON request/response. All endpoints except login and health require authentication. Use DTOs, never expose entities directly. Add pagination (`page`, `size`, `sort`) to large list endpoints.

## Authentication
- `POST /auth/login` — `{ "email": "...", "password": "..." }`; returns access token and safe user profile.
- `POST /auth/refresh` — if refresh tokens are implemented.
- `POST /auth/logout` — invalidate refresh token if applicable.
- `GET /auth/me` — current safe profile.

## Admin — ADMIN only
- `GET /admin/users`
- `POST /admin/users`
- `GET /admin/users/{id}`
- `PUT /admin/users/{id}`
- `PATCH /admin/users/{id}/deactivate`
- `GET /admin/courses`
- `POST /admin/courses`
- `PUT /admin/courses/{id}`
- `GET /admin/enrollments`
- `POST /admin/enrollments` — studentId, courseId.
- `DELETE /admin/enrollments/{studentId}/{courseId}` — reject if historical attempt constraints make deletion unsafe.
- `GET /admin/reports/overview`
- `GET /admin/reports/exam-performance`
- `GET /admin/reports/course-performance`
- `GET /admin/reports/pass-rates`

## Faculty — FACULTY only
- `GET /faculty/courses`
- `GET /faculty/courses/{courseId}/enrollments`
- `GET /faculty/exams`
- `POST /faculty/exams`
- `GET /faculty/exams/{examId}`
- `PUT /faculty/exams/{examId}` — draft only.
- `POST /faculty/exams/{examId}/questions`
- `PUT /faculty/exams/{examId}/questions/{questionId}` — draft only.
- `DELETE /faculty/exams/{examId}/questions/{questionId}` — draft only.
- `POST /faculty/exams/{examId}/publish`
- `POST /faculty/exams/{examId}/close`
- `GET /faculty/exams/{examId}/results`
- `GET /faculty/reports/course-performance`

## Student — STUDENT only
- `GET /student/courses`
- `GET /student/exams?courseId=...`
- `POST /student/exams/{examId}/attempts` — start or return conflict if already attempted; never create duplicate.
- `GET /student/attempts/{attemptId}` — own attempt only; no correctness flags before submit.
- `PUT /student/attempts/{attemptId}/responses` — batch save while in progress; validate all IDs and use transaction.
- `POST /student/attempts/{attemptId}/submit` — atomic final submit and server scoring.
- `GET /student/results`
- `GET /student/results/{attemptId}` — own submitted attempt only.

## Health
- `GET /api/v1/health` — minimal status; do not expose secrets or infrastructure internals.

## Error response
Use a consistent shape:
{
  "timestamp": "ISO-8601",
  "status": 409,
  "error": "CONFLICT",
  "message": "Student has already attempted this examination.",
  "path": "/api/v1/student/exams/1/attempts",
  "fieldErrors": {}
}

Use:
- 400 malformed/validation errors
- 401 unauthenticated
- 403 forbidden
- 404 missing resource
- 409 duplicate or invalid state transition
- 500 generic unexpected error without stack trace

## Important response rules
- Never return `password_hash`.
- Never expose `is_correct` in student exam payloads before submission.
- Never accept score, role, ownership, or authenticated student ID from client as authoritative.
- Student endpoints derive student identity from JWT principal.
- Faculty endpoints verify assigned course ownership on every operation.
