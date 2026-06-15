# Contributing to dbt-analytics-engineering

Thanks for helping improve this dbt data engineering project.

## Scope

Contributions should focus on:

- dbt models, tests, macros, and documentation
- CI/CD workflow improvements
- Local development setup and onboarding
- Data quality and modeling best practices

## Local setup

1. Fork and clone the repository.
2. Create a feature branch from `main`.
3. Copy `.env.example` → `.env` and `profiles.example.yml` → `~/.dbt/profiles.yml`.
4. Start SQL Server: `docker compose up -d`
5. Install dependencies: `pip install -r requirements.txt`
6. Validate locally before opening a PR:

```bash
dbt deps
dbt parse
dbt debug
dbt run
dbt test
```

Optional SQL linting:

```bash
sqlfluff lint models
```

## Pull request checklist

- [ ] Change is scoped and easy to review.
- [ ] Models include tests and descriptions where applicable.
- [ ] README or design docs updated if behavior changed.
- [ ] No secrets, passwords, or private endpoints committed.
- [ ] CI passes (`dbt-ci` workflow).

## Commit and PR guidelines

- Use descriptive titles (e.g. `feat: add stg_sales staging model`).
- Keep one topic per PR.
- Link related issue(s) when possible.
- Include validation notes in the PR description.

## What to avoid

- Do not commit `profiles.yml`, `.env`, or credentials.
- Do not remove existing layer structure without discussion.
- Do not skip tests for new models with business-critical fields.

## Review SLA

- First maintainer response target: within 2 business days.
- Follow-up review after updates: within 3 business days.

For behavior expectations, see [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
