# Target Repository Structure

Codex may adjust package names, but keep the separation of concerns.

```text
online-exam-system/
├── CODEX_MASTER_PROMPT.md
├── README.md
├── docker-compose.yml
├── .env.example
├── .gitignore
├── db/
│   ├── schema.sql
│   ├── seed.sql
│   ├── queries.sql
│   └── er_diagram.mmd
├── docs/
│   ├── functional_requirements.md
│   ├── architecture.md
│   ├── data_dictionary.md
│   ├── api_contract.md
│   ├── ui_ux.md
│   ├── test_plan.md
│   ├── rubric_traceability.md
│   └── IMPLEMENTATION_STATUS.md
├── backend/
│   ├── pom.xml
│   └── src/
│       ├── main/java/.../
│       └── main/resources/
│           ├── application.yml
│           └── db/migration/
└── frontend/
    ├── package.json
    ├── vite.config.ts
    └── src/
        ├── api/
        ├── auth/
        ├── components/
        ├── layouts/
        ├── pages/
        ├── hooks/
        ├── types/
        └── utils/
```

Codex must generate the actual source code, build configuration, migration, tests and README; this structure is guidance, not a pretense that those files already exist.
