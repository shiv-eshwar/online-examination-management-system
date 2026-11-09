-- Online Examination Management System
-- MySQL 8.0.16+ (CHECK constraints are enforced from 8.0.16)
CREATE DATABASE IF NOT EXISTS online_exam_system
  CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE online_exam_system;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS responses;
DROP TABLE IF EXISTS attempts;
DROP TABLE IF EXISTS question_options;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS exams;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE users (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('ADMIN','FACULTY','STUDENT') NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_users_email UNIQUE (email),
    INDEX idx_users_role_active (role, is_active)
) ENGINE=InnoDB;

CREATE TABLE courses (
    course_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL,
    course_name VARCHAR(120) NOT NULL,
    description TEXT,
    faculty_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_courses_code UNIQUE (course_code),
    CONSTRAINT fk_courses_faculty FOREIGN KEY (faculty_id)
      REFERENCES users(user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_courses_faculty (faculty_id)
) ENGINE=InnoDB;

CREATE TABLE enrollments (
    student_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    enrollment_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    PRIMARY KEY (student_id, course_id),
    CONSTRAINT fk_enrollments_student FOREIGN KEY (student_id)
      REFERENCES users(user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_enrollments_course FOREIGN KEY (course_id)
      REFERENCES courses(course_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_enrollments_course (course_id)
) ENGINE=InnoDB;

CREATE TABLE exams (
    exam_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    course_id BIGINT NOT NULL,
    created_by BIGINT NOT NULL,
    exam_title VARCHAR(150) NOT NULL,
    description TEXT,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    duration_minutes INT NOT NULL,
    total_marks DECIMAL(8,2) NOT NULL,
    pass_percentage DECIMAL(5,2) NOT NULL DEFAULT 40.00,
    status ENUM('DRAFT','PUBLISHED','CLOSED') NOT NULL DEFAULT 'DRAFT',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_exams_course FOREIGN KEY (course_id)
      REFERENCES courses(course_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_exams_creator FOREIGN KEY (created_by)
      REFERENCES users(user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_exams_duration CHECK (duration_minutes > 0),
    CONSTRAINT chk_exams_total_marks CHECK (total_marks > 0),
    CONSTRAINT chk_exams_schedule CHECK (end_time > start_time),
    CONSTRAINT chk_exams_pass_percentage CHECK (pass_percentage >= 0 AND pass_percentage <= 100),
    INDEX idx_exams_course_status (course_id, status),
    INDEX idx_exams_schedule (status, start_time, end_time)
) ENGINE=InnoDB;

CREATE TABLE questions (
    question_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    exam_id BIGINT NOT NULL,
    question_text TEXT NOT NULL,
    marks DECIMAL(7,2) NOT NULL,
    question_order INT NOT NULL,
    CONSTRAINT fk_questions_exam FOREIGN KEY (exam_id)
      REFERENCES exams(exam_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_questions_marks CHECK (marks > 0),
    CONSTRAINT chk_questions_order CHECK (question_order > 0),
    CONSTRAINT uq_questions_exam_order UNIQUE (exam_id, question_order),
    CONSTRAINT uq_questions_question_exam UNIQUE (question_id, exam_id),
    INDEX idx_questions_exam (exam_id)
) ENGINE=InnoDB;

CREATE TABLE question_options (
    option_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    question_id BIGINT NOT NULL,
    option_label CHAR(1) NOT NULL,
    option_text TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_options_question FOREIGN KEY (question_id)
      REFERENCES questions(question_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_option_label CHECK (option_label IN ('A','B','C','D')),
    CONSTRAINT uq_options_question_label UNIQUE (question_id, option_label),
    CONSTRAINT uq_options_question_option UNIQUE (question_id, option_id)
) ENGINE=InnoDB;

CREATE TABLE attempts (
    attempt_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    exam_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    started_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    submitted_at DATETIME NULL,
    score DECIMAL(8,2) NOT NULL DEFAULT 0.00,
    status ENUM('IN_PROGRESS','SUBMITTED') NOT NULL DEFAULT 'IN_PROGRESS',
    CONSTRAINT fk_attempts_exam FOREIGN KEY (exam_id)
      REFERENCES exams(exam_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_attempts_student FOREIGN KEY (student_id)
      REFERENCES users(user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_attempt_student_exam UNIQUE (exam_id, student_id),
    CONSTRAINT uq_attempt_id_exam UNIQUE (attempt_id, exam_id),
    CONSTRAINT chk_attempt_score CHECK (score >= 0),
    CONSTRAINT chk_attempt_submission CHECK (
      (status = 'IN_PROGRESS' AND submitted_at IS NULL) OR
      (status = 'SUBMITTED' AND submitted_at IS NOT NULL)
    ),
    INDEX idx_attempts_student (student_id, status),
    INDEX idx_attempts_exam (exam_id, status)
) ENGINE=InnoDB;

CREATE TABLE responses (
    attempt_id BIGINT NOT NULL,
    exam_id BIGINT NOT NULL,
    question_id BIGINT NOT NULL,
    selected_option_id BIGINT NULL,
    answered_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (attempt_id, question_id),
    CONSTRAINT fk_responses_attempt_exam FOREIGN KEY (attempt_id, exam_id)
      REFERENCES attempts(attempt_id, exam_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_responses_question_exam FOREIGN KEY (question_id, exam_id)
      REFERENCES questions(question_id, exam_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_responses_option_question FOREIGN KEY (question_id, selected_option_id)
      REFERENCES question_options(question_id, option_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_responses_exam_question (exam_id, question_id)
) ENGINE=InnoDB;
