# Security Policy

## Supported usage

This repository provides local development patterns and command references. It is not a production-hardened platform.

## Reporting a vulnerability

Please do not open public issues for sensitive vulnerabilities.

Instead, contact maintainers privately with:

- affected file/path,
- reproduction steps,
- impact assessment,
- suggested fix (if available).

You should receive an acknowledgment within 3 business days.

## Secret handling

- Never commit `.env` files, credentials, tokens, or connection strings.
- Treat bootstrap scripts as templates and replace sample passwords.
- Rotate any secret immediately if accidentally exposed.

