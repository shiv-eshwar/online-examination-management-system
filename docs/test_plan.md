# Test Plan and Demonstration Script

## Required test cases

| ID | Scenario / input | Expected result |
|---|---|---|
| T01 | Login with valid admin credentials | 200; admin dashboard/profile |
| T02 | Login with wrong password | 401; no token |
| T03 | Create user with duplicate email | 409; no duplicate row |
| T04 | Create course with duplicate course code | 409; no duplicate row |
| T05 | Enroll valid student in valid course | Enrollment persisted |
| T06 | Enroll same student/course twice | 409; one enrollment remains |
| T07 | Try to enroll a FACULTY user as student | 400/409; no enrollment |
| T08 | Faculty creates exam for own course | Draft created |
| T09 | Faculty creates exam for another faculty's course | 403 |
| T10 | Publish exam with missing/invalid options | 400; remains DRAFT |
| T11 | Publish exam with marks sum not equal total | 400; remains DRAFT |
| T12 | Student not enrolled tries to list/start exam | Denied; no attempt row |
| T13 | Enrolled student attempts DRAFT exam | Denied; no attempt row |
| T14 | Enrolled student starts published exam in window | Attempt created |
| T15 | Same student starts same exam again | 409; only one attempt |
| T16 | Submit option belonging to another question | 400; no partial submission |
| T17 | Submit a valid answer batch | Responses and score persisted; status SUBMITTED |
| T18 | Submit same attempt again | 409; no score/status mutation |
| T19 | Student requests another student's result | 403/404 |
| T20 | Faculty requests result for another faculty's course | 403 |
| T21 | Restart backend and retrieve saved data | Data persists |
| T22 | Report endpoint with sample attempts | Correct JOIN/GROUP BY aggregates |
| T23 | Force failure during multi-response submission | Transaction rolls back; no partial finalization |
| T24 | Attempt submission after effective deadline | Rejected |

## Live demonstration sequence
1. Login as admin.
2. Create a faculty account and a student account.
3. Create a course and assign the faculty member.
4. Enroll the student.
5. Login as faculty; create an exam, add at least two MCQs with four options each, publish.
6. Login as student; open eligible exam, answer questions and submit.
7. Show score and student result history.
8. Login as faculty; show exam results and course report.
9. Login as admin; show overview and pass-rate report.
10. Demonstrate duplicate enrollment or duplicate attempt rejection.
11. Demonstrate a forbidden action (non-enrolled student or faculty accessing another faculty's exam).
12. Restart application and retrieve a saved record.
13. Explain one relationship-spanning query and one GROUP BY report query.

## Test evidence
Codex must fill observed results only after executing tests. Include test command, date, and pass/fail. Do not mark unexecuted tests as passed.
