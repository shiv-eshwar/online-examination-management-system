
-- Demo accounts are initialized by the Spring Boot development seeder, not with plaintext SQL passwords.
-- Implement a dev-profile DataInitializer that creates these users with BCryptPasswordEncoder:
-- admin@demo.edu / Admin@123 (ADMIN)
-- maya.faculty@demo.edu / Faculty@123 (FACULTY)
-- roshan.student@demo.edu / Student@123 (STUDENT)
-- aarav.student@demo.edu / Student@123 (STUDENT)
-- Do not insert a fake BCrypt string: generate real hashes in the application.
INSERT INTO users (user_id, full_name, email, password_hash, role) VALUES
(1, 'System Administrator', 'admin@demo.edu', 'BOOTSTRAP_WITH_BCRYPT', 'ADMIN'),
(2, 'Dr. Maya Sharma', 'maya.faculty@demo.edu', 'BOOTSTRAP_WITH_BCRYPT', 'FACULTY'),
(3, 'Roshan Student', 'roshan.student@demo.edu', 'BOOTSTRAP_WITH_BCRYPT', 'STUDENT'),
(4, 'Aarav Student', 'aarav.student@demo.edu', 'BOOTSTRAP_WITH_BCRYPT', 'STUDENT');

INSERT INTO courses (course_id, course_code, course_name, description, faculty_id) VALUES
(1, 'CSE201', 'Database Management Systems', 'Relational databases, SQL and normalization.', 2),
(2, 'CSE202', 'Data Structures', 'Core data structures and algorithms.', 2);

INSERT INTO enrollments (student_id, course_id) VALUES
(3, 1), (4, 1), (3, 2);

INSERT INTO exams
(exam_id, course_id, created_by, exam_title, description, start_time, end_time,
 duration_minutes, total_marks, pass_percentage, status)
VALUES
(1, 1, 2, 'DBMS Fundamentals Quiz', 'Demo published MCQ examination.',
 DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(NOW(), INTERVAL 30 DAY),
 30, 20.00, 40.00, 'PUBLISHED');

INSERT INTO questions (question_id, exam_id, question_text, marks, question_order) VALUES
(1, 1, 'Which key uniquely identifies a row in a relational table?', 10.00, 1),
(2, 1, 'Which normal form removes transitive dependencies?', 10.00, 2);

INSERT INTO question_options (question_id, option_label, option_text, is_correct) VALUES
(1, 'A', 'Primary key', TRUE),
(1, 'B', 'Foreign key', FALSE),
(1, 'C', 'Composite attribute', FALSE),
(1, 'D', 'View', FALSE),
(2, 'A', 'First Normal Form', FALSE),
(2, 'B', 'Second Normal Form', FALSE),
(2, 'C', 'Third Normal Form', TRUE),
(2, 'D', 'Domain-Key Normal Form', FALSE);

-- Demo attempt records are intentionally not inserted. Create attempts through the app
-- so the service-layer enrollment, schedule and scoring rules are exercised.
