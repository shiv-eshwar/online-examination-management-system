# Teacher Handout — Database Mini Project Requirements (20 Marks)

Transcribed from the two-page handout supplied by the student. This is the basis for the project traceability matrix.

## 1. Project scope and minimum requirements
- Define the problem, intended users, user roles where relevant, and at least four complete application workflows.
- Model at least four meaningful data entities as related tables or collections. Relational projects must show an ER diagram, keys, constraints, and normalization up to 3NF.
- Build a usable interface with forms, record lists, search or filters, and appropriate create, read, update, and delete operations. Destructive actions should have a confirmation or equivalent safeguard.
- Connect the interface to a real database. Data entered or edited in the interface must persist after the application closes and restarts. Do not present hard-coded screens as database results.
- Implement at least one nontrivial business rule and one useful report. Demonstrate joined or linked data and aggregation using SQL joins and GROUP BY, or MongoDB aggregation with $lookup where relationships require it. Explain how the report is derived from stored records.

## 2. Technical implementation requirements
- Data integrity: primary and foreign keys with relevant NOT NULL, UNIQUE, CHECK, or equivalent constraints.
- Validation: reject missing/malformed inputs, invalid ranges or dates, duplicates, and rule violations. Validate in application layer and database where supported.
- Access control: multiple roles may access only permitted records/actions. Enforce in server/application logic and queries, not solely by hiding UI controls.
- Safe operations: parameterized SQL or safe driver query APIs. Store password hashes if authentication is included. Never commit database credentials or secrets to GitHub.
- Consistency: use transactions for workflows changing multiple records, or justify equivalent strategy. Avoid partial updates on failure.
- Error handling: handle failed connections, invalid requests, missing records and constraint errors with understandable feedback; application remains usable.

## 3. Evidence for live demonstration
- Submit a valid record, restart application, and retrieve it.
- Submit invalid or duplicate value and show rejection without corrupting stored data.
- Try an action violating a role, ownership, enrollment, or other domain rule, if applicable.
- Demonstrate a failed multi-record operation and show no partial update remains, if applicable.
- Explain one relationship-spanning query and one aggregate query used by application/report.
- Example online assessment: faculty publishes a test, enrolled student submits an attempt, ineligible student denied access, authorized principal views report.

## 4. Evaluation rubric

| Criterion | Marks |
|---|---:|
| Database design | 3 |
| Access and roles | 2 |
| Core workflows | 4 |
| Technical validation | 3 |
| Connectivity and integrity | 2 |
| Query complexity and reports | 2 |
| Usability | 2 |
| Documentation and viva | 2 |
| **Total** | **20** |

## 5. Submission checklist
- Short report: title, problem statement, users, requirements, data model, design rationale, workflow screenshots, selected SQL queries. Relational projects include ER diagram, schema and normalization rationale.
- GitHub repository: source code, database setup/seed scripts, README with dependencies/configuration/sample data/exact run steps. Exclude secrets and personal data.
- Compact test-case table: input, expected result, observed result for valid, invalid, duplicate, access restriction if applicable, and failure case.
- Live demonstration using submitted code and database. Every team member should explain contribution and database design.
