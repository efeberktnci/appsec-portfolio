# AppSec Portfolio (Job-Ready Junior Track)

This repository is my AppSec / Product Security portfolio: lab write-ups, pentest-style findings, Secure SDLC artifacts
(threat modeling, code review checklists), and CI/CD security demo outputs.

## What you’ll find here
- Reproducible findings with clear steps to reproduce
- Evidence-backed (sanitized) PoCs with no sensitive data
- Practical fixes and tests (not just “there is a vuln”, but “how to fix it”)

## By Platform (pick a lab environment)

### PortSwigger Web Security Academy
- All PortSwigger write-ups: [writeups/portswigger/](writeups/portswigger/)
- Access Control index: [writeups/portswigger/access-control/](writeups/portswigger/access-control/)
- Path Traversal index: [writeups/portswigger/server-side-vulns/path-traversal/](writeups/portswigger/server-side-vulns/path-traversal/)

#### Featured write-ups (PortSwigger)
- Access Control — Notes (core concepts): [00-notes-access-control-core-concepts.md](writeups/portswigger/access-control/00-notes-access-control-core-concepts.md)
- Lab — User role controlled by request parameter: [01-user-role-controlled-by-request-parameter.md](writeups/portswigger/access-control/01-user-role-controlled-by-request-parameter.md)
- Lab — User ID controlled by request parameter with password disclosure: [02-user-id-controlled-by-request-parameter-with-password-disclosure.md](writeups/portswigger/access-control/02-user-id-controlled-by-request-parameter-with-password-disclosure.md)
- Path Traversal — Reading arbitrary files (concept): [01-reading-arbitrary-files-via-path-traversal.md](writeups/portswigger/server-side-vulns/path-traversal/01-reading-arbitrary-files-via-path-traversal.md)
- Lab — File path traversal, simple case: [02-lab-file-path-traversal-simple-case.md](writeups/portswigger/server-side-vulns/path-traversal/02-lab-file-path-traversal-simple-case.md)

### OWASP Juice Shop
- Reports: [reports/](reports/) (coming soon)

### CI/CD Security Demos
- Companion repo: https://github.com/efeberktnci/appsec-tools-demo

## Standard Finding Format
Each finding follows the same structure:
- Scope / Target
- Steps to reproduce
- Evidence (sanitized request/response, screenshots, logs)
- Impact
- Severity (Low/Medium/High/Critical + rationale)
- Recommendation (fix + tests + defense-in-depth)
- Retest plan
- Executive summary (5–10 lines)

Template: [templates/FINDING_TEMPLATE.md](templates/FINDING_TEMPLATE.md)

## Quick Start (Add a new finding)
1. Copy `templates/FINDING_TEMPLATE.md`
2. Place it under the right folder:
   - PortSwigger / lab write-up: [writeups/](writeups/)
   - Juice Shop / report-style finding: [reports/](reports/)
3. Sanitize anything sensitive (no tokens/cookies/secrets/real target URLs)
4. Use clean commit messages: `writeup: <lab name>` or `report: <short title>`

## Folder Structure
- [writeups/](writeups/) PortSwigger + other lab write-ups
- [reports/](reports/) Juice Shop reports and findings (Markdown/PDF)
- [threat-models/](threat-models/) Threat model documents
- [checklists/](checklists/) Code review checklists
- [ci-cd-demo/](ci-cd-demo/) CI/CD security demo artifacts
- [templates/](templates/) Copy/paste templates

## Legal / Ethics
This repository is for labs and authorized targets only. No testing of real systems without explicit permission.
