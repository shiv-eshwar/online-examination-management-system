# Data Dictionary

All table names are lowercase snake_case. IDs are generated integer primary keys except `enrollments` and `responses`, which use composite primary keys.

## users
- `user_id`: primary key.
- `full_name`: required display name.
- `email`: required unique login identifier; normalize to lowercase in service.
- `password_hash`: BCrypt hash only.
- `role`: ADMIN, FACULTY, STUDENT.
- `is_active`: soft-disable login/access.
- `created_at`, `updated_at`: audit timestamps.

## courses
- `course_id`: primary key.
- `course_code`: unique code.
- `course_name`: required title.
- `description`: optional.
- `faculty_id`: user assigned as faculty owner; application validates role FACULTY.

## enrollments
- Composite PK `(student_id, course_id)`.
- Both columns are FKs.
- `enrollment_date`: date of enrollment.
- Application validates that `student_id` has STUDENT role.

## exams
- `exam_id`: primary key.
- `course_id`: course FK.
- `created_by`: faculty user FK; application validates it is the course's assigned faculty.
- `exam_title`, `description`.
- `start_time`, `end_time`: scheduled window.
- `duration_minutes`: positive duration.
- `total_marks`: positive and equal to sum of question marks at publish.
- `pass_percentage`: default 40.00; range 0..100.
- `status`: DRAFT, PUBLISHED, CLOSED.

## questions
- `question_id`: primary key.
- `exam_id`: exam FK.
- `question_text`: required.
- `marks`: positive decimal.
- Unique `(question_id, exam_id)` supports composite response FK.

## question_options
- `option_id`: primary key.
- `question_id`: question FK.
- `option_label`: A, B, C, D.
- `option_text`: required.
- `is_correct`: boolean.
- Unique `(question_id, option_label)` and `(question_id, option_id)`.

## attempts
- `attempt_id`: primary key.
- `exam_id`, `student_id`: FKs.
- `started_at`, `submitted_at`.
- `score`: server-calculated decimal.
- `status`: IN_PROGRESS, SUBMITTED.
- Unique `(exam_id, student_id)` enforces one attempt.
- Unique `(attempt_id, exam_id)` supports composite response FK.

## responses
- Composite PK `(attempt_id, question_id)`.
- `exam_id` binds response to the same exam as attempt and question.
- `selected_option_id` nullable to represent unanswered questions.
- Composite FKs ensure attempt and question belong to same exam and selected option belongs to that question.
