USE online_exam_system;

-- 1. Relationship-spanning query: students enrolled in a course.
SELECT u.user_id, u.full_name, u.email, c.course_code, c.course_name
FROM enrollments en
JOIN users u ON u.user_id = en.student_id
JOIN courses c ON c.course_id = en.course_id
WHERE c.course_id = 1
ORDER BY u.full_name;

-- 2. Exam participation, average and highest score (JOIN + GROUP BY).
SELECT e.exam_id, e.exam_title,
       COUNT(a.attempt_id) AS total_attempts,
       ROUND(AVG(a.score), 2) AS average_score,
       MAX(a.score) AS highest_score
FROM exams e
LEFT JOIN attempts a
  ON a.exam_id = e.exam_id AND a.status = 'SUBMITTED'
GROUP BY e.exam_id, e.exam_title
ORDER BY e.exam_title;

-- 3. Course-wise performance (multiple JOINs + GROUP BY).
SELECT c.course_code, c.course_name,
       COUNT(a.attempt_id) AS submitted_attempts,
       ROUND(AVG(a.score), 2) AS average_score
FROM courses c
JOIN exams e ON e.course_id = c.course_id
LEFT JOIN attempts a ON a.exam_id = e.exam_id AND a.status = 'SUBMITTED'
GROUP BY c.course_id, c.course_code, c.course_name
ORDER BY c.course_name;

-- 4. Pass percentage per exam (aggregate + CASE).
SELECT e.exam_id, e.exam_title,
       COUNT(a.attempt_id) AS submitted_attempts,
       SUM(CASE WHEN (a.score / e.total_marks) * 100 >= e.pass_percentage
                THEN 1 ELSE 0 END) AS passed_count,
       ROUND(
         100.0 * SUM(CASE WHEN (a.score / e.total_marks) * 100 >= e.pass_percentage
                          THEN 1 ELSE 0 END) / NULLIF(COUNT(a.attempt_id), 0),
         2
       ) AS pass_percentage
FROM exams e
LEFT JOIN attempts a
  ON a.exam_id = e.exam_id AND a.status = 'SUBMITTED'
GROUP BY e.exam_id, e.exam_title, e.total_marks, e.pass_percentage;

-- 5. Individual student attempt history.
SELECT u.full_name, e.exam_title, c.course_code,
       a.started_at, a.submitted_at, a.score, e.total_marks,
       ROUND(100.0 * a.score / e.total_marks, 2) AS percentage
FROM attempts a
JOIN users u ON u.user_id = a.student_id
JOIN exams e ON e.exam_id = a.exam_id
JOIN courses c ON c.course_id = e.course_id
WHERE a.student_id = 3 AND a.status = 'SUBMITTED'
ORDER BY a.submitted_at DESC;
