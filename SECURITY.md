# Security Policy

This repository is **public** — everything pushed is world-readable. Assume any file
that leaves your machine in this repo will be seen by anyone.

## Reporting a Vulnerability

Please **do not open a public issue** for security problems. Report privately:

- Open a [GitHub Security Advisory](https://github.com/korey-barrett/xiaozhi-esp32-server-en-standalone/security/advisories)
  on this repository, or
- Email the maintainer directly (address on the GitHub profile).

You can expect an acknowledgement within 3 business days and a fix plan shortly after.
If a vulnerability is accepted, we will coordinate a public disclosure date.

## Secret handling (SSO, API keys, credentials)

- **Never commit secrets** — OAuth client secrets, SSO passcodes, API keys, DB/Redis
  passwords, or `.env` values.
- SSO secrets are **runtime-injected**, never in `application.yml` (placeholders only):
  `SSO_PASSCODE` and `GITHUB_CLIENT_SECRET` live in the gitignored
  `main/xiaozhi-server/.env`, are interpolated by the compose files into the web
  container, and are forwarded to the JVM by `docs/docker/start.sh`. Unset env vars
  fall back to `YOUR_` placeholders so SSO fails **safe** (never an empty passcode).
- If a secret ever lands in git (even in an unpushed commit) or in a chat, treat it as
  **compromised** and rotate it immediately:
  - **GitHub OAuth client secret** — regenerate in
    Settings → Developer settings → OAuth Apps (regeneration invalidates the old value
    immediately).
  - **SSO passcode** — replace the value in `main/xiaozhi-server/.env`.
  - **Any API key** — revoke on the provider console and issue a new one.
  SSO rotation is a `.env` edit + web-container recreate (`docker compose -f
  docker-compose.local.yml up -d --no-deps --force-recreate xiaozhi-esp32-server-web`);
  no image rebuild is needed.

## Supported Versions

This project tracks a single moving `main` branch. Only the latest state of `main`
receives security fixes.
