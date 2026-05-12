# Lab: SQL injection vulnerability in WHERE clause allowing retrieval of hidden data (PortSwigger)

## Scope / Target
- Target: PortSwigger Web Security Academy lab instance
- Scope: Lab environment only (no real targets)
- Date: 2026-05-12

## Summary
The product filter uses the `category` parameter directly in a SQL `WHERE` clause. By injecting SQL in the URL, the
query logic is changed so hidden/unreleased items are returned.

## Steps to Reproduce
1. Open the lab and browse a normal category page (for example `Gifts`) using:
   - `/filter?category=Gifts`
2. In the URL, inject into `category`:
   - `Gifts' OR 1=1--`
3. Reload the page with the payload:
   - `/filter?category=Gifts%27+OR+1=1--`
4. Observe that additional products appear (including hidden/unreleased data) and the lab is solved.

## Evidence
1) Baseline category view before injection (`category=Gifts`):
![Baseline Gifts category page](assets/01-baseline-gifts-filter.png)

2) URL SQL injection payload applied (`Gifts' OR 1=1--`) and lab solved:
![Injected category parameter showing solved state](assets/02-url-sqli-or-1-equals-1.png)

## Impact
SQL injection in filtering logic can expose hidden records and bypass business restrictions. In real systems, similar
flaws can lead to data leakage, auth bypass, or full database compromise.

## Severity
- Rating: Critical
- Rationale: Direct manipulation of backend SQL query logic via user input.

## Recommendation
- Use parameterized queries/prepared statements for all user input.
- Apply strict server-side validation and allowlisting for category values.
- Avoid exposing raw query results without authorization/business-rule checks.

## Retest Plan
- Re-test with payloads like `' OR 1=1--` and confirm they are treated as plain text input.
- Verify only allowed categories return expected, authorized records.
