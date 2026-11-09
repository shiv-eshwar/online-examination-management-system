# Teacher Rubric Traceability — 20 Marks

This mapping is based on the supplied `DBMS Mini Project Requirements` handout.

| Teacher criterion | Marks | Implementation/evidence |
|---|---:|---|
| Database design | 3 | Eight related MySQL tables; ER diagram; PK/FK/UNIQUE/CHECK; 3NF rationale; composite response constraints |
| Access and roles | 2 | ADMIN/FACULTY/STUDENT; backend role checks; faculty course ownership; student enrollment ownership |
| Core workflows | 4 | User/course/enrollment administration; exam authoring/publishing; student attempt/submission; results/reporting |
| Technical validation | 3 | Bean Validation, DB constraints, duplicate rejection, schedule/state/eligibility checks |
| Connectivity and integrity | 2 | Real React→Spring Boot→MySQL persistence; transactions; restart persistence; centralized errors |
| Query complexity and reports | 2 | JOIN and GROUP BY reports for participation, averages, course performance and pass rates |
| Usability | 2 | Responsive role-specific UI, search/filter, CRUD, confirmations, field errors, loading/empty states |
| Documentation and viva | 2 | README, ER diagram, schema, selected SQL, test-case table, setup instructions, demo script |
| **Total** | **20** | |

## Explicit handout checks
- Four or more complete workflows: documented in `functional_requirements.md`.
- At least four meaningful entities: eight tables.
- Relational ER diagram, keys, constraints and normalization to 3NF: `db/er_diagram.mmd` and `data_dictionary.md`.
- CRUD, lists, search/filter, destructive safeguards: `ui_ux.md`.
- Real database persistence: master prompt acceptance process.
- Nontrivial business rule and useful report: enrollment eligibility, one attempt, exam lifecycle, server-side scoring; SQL reports.
- Validation: application + DB constraints.
- Access control: backend and query-level ownership checks.
- Safe operations: parameterized APIs, BCrypt, no committed secrets.
- Consistency: transaction on batch response save and final submission.
- Error handling: consistent API error shape.
- Live evidence: `test_plan.md`.
