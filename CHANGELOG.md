# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog and follows Semantic Versioning.

## [Unreleased]

### Added

- dbt project configuration with staging / intermediate / marts layer defaults.
- `requirements.txt`, `packages.yml`, and `profiles.example.yml` for reproducible setup.
- `.env.example` for local environment variables.
- GitHub Actions workflows:
  - `dbt-ci.yml` — lint, parse, compile, run, and test against SQL Server.
  - `dbt-cd.yml` — deploy to production using repository secrets.
  - `dbt-docs.yml` — generate docs and publish to GitHub Pages.
- CI helper scripts: `scripts/wait_for_sqlserver.sh`, `scripts/ci-init-db.sql`.
- SQLFluff configuration (`.sqlfluff`).
- Local setup script: `scripts/setup-local-dev.sh`.

### Changed

- `README.md` rewritten to match actual project layout and document CI/CD.
- `docker-compose.yml` uses environment variables and a health check.
- `CONTRIBUTING.md` updated for dbt-specific contribution guidelines.
- `dbt_project.yml` aligned with medallion layering strategy.

## [0.1.0] - 2026-05-15

### Added

- Initial public baseline for DE setup references and command cheat sheets.
- Community docs (`CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`).
- GitHub issue and pull request templates.
