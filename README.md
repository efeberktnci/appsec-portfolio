# AppSec Portfolio

![Track: AppSec](https://img.shields.io/badge/Track-AppSec-0B7285?style=for-the-badge)
![Focus: PortSwigger](https://img.shields.io/badge/Focus-PortSwigger-1C7ED6?style=for-the-badge)
![Status: Active](https://img.shields.io/badge/Status-Active-2F9E44?style=for-the-badge)
![Last update](https://img.shields.io/badge/Last%20update-2026--05--17-495057?style=for-the-badge)

This repository is my AppSec / Product Security portfolio: lab write-ups, pentest-style findings, Secure SDLC artifacts
(threat modeling, code review checklists), and CI/CD security demo outputs.

## What you'll find here
- Reproducible findings with clear steps to reproduce
- Practical fixes and tests (not just "there is a vuln", but "how to fix it")

## By Platform (pick a lab environment)

This section is intentionally short and scannable. Each platform has its own index README for details.

| Platform | Index | Featured |
|---|---|---|
| <img src="https://img.shields.io/static/v1?style=flat-square&message=%20&logo=portswigger&label=&color=FF6633&logoColor=white" height="18" alt="PortSwigger" /> **PortSwigger Web Security Academy** | [writeups/portswigger/](writeups/portswigger/) | [Server-side vulnerabilities (ordered)](writeups/portswigger/server-side-vulns/) · [CSRF](writeups/portswigger/csrf/) |
| <img src="https://img.shields.io/static/v1?style=flat-square&message=%20&logo=tryhackme&label=&color=212C42&logoColor=white" height="18" alt="TryHackMe" /> **TryHackMe** | [writeups/tryhackme/](writeups/tryhackme/) | _In progress_ |
| <img src="https://raw.githubusercontent.com/juice-shop/juice-shop/develop/frontend/src/assets/public/images/JuiceShop_Logo_100px.png" height="18" alt="OWASP Juice Shop logo" /> **OWASP Juice Shop** | _Coming soon_ | _Coming soon_ |

## Threat Models
- Threat model index: [threat-models/](threat-models/)

## CI/CD Security Demos
- Companion repo: https://github.com/efeberktnci/appsec-tools-demo

## Standard Finding Format
Each finding follows the same structure:
- Scope / Target
- Steps to reproduce
- Evidence (request/response, screenshots, logs)
- Impact
- Severity (Low/Medium/High/Critical + rationale)
- Recommendation (fix + tests + defense-in-depth)
- Retest plan
- Executive summary (5-10 lines)

Template: [templates/FINDING_TEMPLATE.md](templates/FINDING_TEMPLATE.md)

## Quick Start (Add a new finding)
1. Copy `templates/FINDING_TEMPLATE.md`
2. Place it under the right folder:
   - PortSwigger / lab write-up: [writeups/](writeups/)
   - Juice Shop / report-style finding: `reports/` (coming soon)
3. Remove sensitive values (no tokens/cookies/secrets/real target URLs)
4. Use clean commit messages: `writeup: <lab name>` or `report: <short title>`

## Folder Structure
- [writeups/](writeups/) PortSwigger + other lab write-ups
- `reports/` Juice Shop reports and findings (coming soon)
- [threat-models/](threat-models/) Threat model documents
- [checklists/](checklists/) Code review checklists
- [ci-cd-demo/](ci-cd-demo/) CI/CD security demo artifacts
- [templates/](templates/) Copy/paste templates

## Legal / Ethics
This repository is for labs and authorized targets only. No testing of real systems without explicit permission.

