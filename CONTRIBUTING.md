# Contributing to data-stack-setup

Thanks for helping improve this data engineering companion repo.

## Scope and intent

This repository is a command/reference baseline, not a production data platform. Keep contributions focused on:

- practical setup guidance,
- clear command snippets,
- safe local defaults,
- better onboarding for data engineers.

## Local setup

1. Fork and clone the repository.
2. Create a feature branch from `main`.
3. Make focused changes with clear commit messages.
4. Run checks before opening a PR.

## Pull request checklist

- [ ] Change is scoped and easy to review.
- [ ] README/docs are updated if behavior changed.
- [ ] No secrets, passwords, or private endpoints were committed.
- [ ] Shell snippets are reviewed for safety and portability notes.
- [ ] CI passes.

## Commit and PR guidelines

- Use descriptive titles (for example: `docs: clarify Airflow bootstrap quickstart`).
- Keep one topic per PR.
- Link related issue(s) when possible.
- Include test/validation notes in PR description.

## What to avoid

- Do not convert this repository into a production deployment template.
- Do not remove useful existing command patterns without replacement.
- Do not introduce hardcoded credentials.

## Good first contributions

- Fix command typos or broken links.
- Improve wording for beginner onboarding.
- Add safer defaults and explicit warning notes.
- Add examples for common ETL/ELT workflows.

## Review and response SLA

- First maintainer response target: within 2 business days.
- Follow-up review target after updates: within 3 business days.

For behavior expectations, see `CODE_OF_CONDUCT.md`.
