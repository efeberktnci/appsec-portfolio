# Lab: OS command injection, simple case (PortSwigger)

## Scope / Target
- Target: PortSwigger Web Security Academy lab instance
- Scope: Lab environment only (no real targets)
- Date: 2026-05-12

## Summary
The stock check feature builds an operating-system command using user input from `storeId`. Because the input is not
safely handled, command separators can be injected. Appending `|whoami` executes an extra command and leaks the server
user (`peter-1uzI5L` in this lab instance).

## Steps to Reproduce
1. Open a product page and click **Check stock** to generate the stock-check request.
2. In Burp Proxy, capture the `POST /product/stock` request containing `productId` and `storeId`.
3. Send the request to Repeater.
4. Inject an OS command into `storeId` using a command separator:
   - `storeId=1|whoami`
5. Send the modified request.
6. Observe the command output in the response body. In this run, the output includes `peter-1uzI5L`, confirming
   OS command injection.

## Evidence
1) Baseline stock-check request captured in Burp (`POST /product/stock`):
![Captured stock-check request in Burp Proxy](assets/01-stock-check-request-captured.png)

2) Baseline product page before injection (normal workflow):
![Normal product page view before payload injection](assets/02-baseline-product-page.png)

3) Repeater request with injected payload `storeId=1|whoami` and response returning server user `peter-1uzI5L`:
![OS command injection result showing whoami output](assets/03-whoami-injection-result.png)

## Impact
An attacker can execute arbitrary OS commands on the server process context. This can lead to sensitive data exposure,
command execution chaining, and potentially full server compromise depending on environment permissions.

## Severity
- Rating: Critical
- Rationale: Direct server-side command execution via user-controlled input.

## Recommendation
- Never concatenate user input into shell/system commands.
- Use safe APIs that avoid shell invocation where possible.
- Apply strict allowlisting for expected input values (for `storeId`, numeric-only validation).
- Use least-privilege service accounts and isolate command execution paths.

## Retest Plan
- Re-send payloads like `|whoami`, `;whoami`, `&&whoami` and confirm they are rejected or treated as plain input.
- Verify only expected `storeId` values are accepted and command output is never reflected.
