# AppSec Portfolio (Job-Ready Junior Track)

This repository is my AppSec / Product Security portfolio: lab write-ups, pentest-style findings, Secure SDLC artifacts
(threat modeling, code review checklists), and CI/CD security demo outputs.

## What you’ll find here
- Reproducible findings with clear steps to reproduce
- Evidence-backed (sanitized) PoCs with no sensitive data
- Practical fixes and tests (not just “there is a vuln”, but “how to fix it”)

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

Template: `templates/FINDING_TEMPLATE.md`

## Quick Start (Add a new finding)
1. Copy `templates/FINDING_TEMPLATE.md`
2. Place it under the right folder:
   - PortSwigger / lab write-up: `writeups/`
   - Juice Shop / report-style finding: `reports/`
3. Sanitize anything sensitive (no tokens/cookies/secrets/real target URLs)
4. Use clean commit messages: `writeup: <lab name>` or `report: <short title>`

## Folder Structure
- `writeups/` PortSwigger + other lab write-ups
- `reports/` Juice Shop reports and findings (Markdown/PDF)
- `threat-models/` Threat model documents
- `checklists/` Code review checklists
- `ci-cd-demo/` CI/CD security demo artifacts
- `templates/` Copy/paste templates

## Legal / Ethics
This repository is for labs and authorized targets only. No testing of real systems without explicit permission.
