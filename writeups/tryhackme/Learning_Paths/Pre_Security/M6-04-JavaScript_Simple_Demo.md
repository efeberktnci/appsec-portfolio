![Track](https://img.shields.io/static/v1?label=TRACK&message=APPSEC&color=0B7285&style=for-the-badge)
![Focus](https://img.shields.io/static/v1?label=FOCUS&message=TRYHACKME&color=1D4ED8&style=for-the-badge)
![Path](https://img.shields.io/static/v1?label=PATH&message=PRE%20SECURITY&color=7C3AED&style=for-the-badge)
![Module](https://img.shields.io/static/v1?label=MODULE&message=M6-04&color=E67700&style=for-the-badge)
![Last Update](https://img.shields.io/static/v1?label=LAST%20UPDATE&message=2026-05-19&color=334155&style=for-the-badge)

# JavaScript Simple Demo

Room link: https://tryhackme.com/room/javascriptsimpledemo

## Executive Summary
- This room moves from static markup into client-side logic and interaction.
- Main focus is understanding how JavaScript reads page elements, reacts to user actions, and updates visible output.
- For AppSec foundations, this is key because many client-side issues (DOM injection, insecure logic, exposed data paths) start exactly here.

## Walkthrough (Evidence + Analysis)

### 1) Room scope and JS mindset shift
![M6-04-1 room intro](assets/M6-04-1.png)
This first screen introduces the core shift from "display-only" pages to behavior-driven pages. The important concept is that JavaScript controls how front-end reacts after the page loads.

### 2) JavaScript execution in browser context
![M6-04-2 browser execution](assets/M6-04-2.png)
Here we see JS being executed by the browser runtime. This matters for security because code execution happens on user-controlled clients, so assumptions about trust must stay server-side.

### 3) Variables and dynamic values
![M6-04-3 variables basics](assets/M6-04-3.png)
This section shows variable assignment and reuse. In practical terms, user data gets stored, transformed, and reused in page logic, which is where validation mistakes can propagate quickly.

### 4) Functions and reusable behavior
![M6-04-4 functions](assets/M6-04-4.png)
Functions package repeated logic into reusable blocks. The screenshot highlights that frontend workflows are typically function-driven (read input -> process -> render), which is the same flow many injection flaws abuse.

### 5) Reading input from DOM elements
![M6-04-5 input from dom](assets/M6-04-5.png)
This is a critical step: pulling raw user input from form fields. From an AppSec lens, this is the moment attacker-controlled data enters app logic.

### 6) Writing output back to the page
![M6-04-6 output rendering](assets/M6-04-6.png)
Now the script writes processed data into visible HTML. If output encoding/sanitization is missing, this exact stage can become DOM-based injection territory.

### 7) Event-driven behavior (click/action flow)
![M6-04-7 event handling](assets/M6-04-7.png)
The screenshot demonstrates event-based execution (`onclick`/button trigger). This models real web apps where business actions are often initiated via DOM events.

### 8) Logic chaining: input -> function -> result
![M6-04-8 logic pipeline](assets/M6-04-8.png)
This part connects previous pieces into a full mini flow. It reinforces that front-end is not just styling; it is a data pipeline that must be handled safely.

### 9) Practical interactive mini-lab
![M6-04-9 practical task](assets/M6-04-9.png)
The practical section validates whether the code actually behaves as expected in runtime, not just syntactically. This execution-first habit is essential for both debugging and security testing.

### 10) Question checks and concept validation
![M6-04-10 answer checks](assets/M6-04-10.png)
The checkpoint confirms understanding of JS fundamentals (logic, syntax, execution order). For portfolio progression, this is the baseline before deeper web-security modules.

### 11) Final completion and consolidation
![M6-04-11 completion](assets/M6-04-11.png)
Final screen shows successful completion and concept consolidation. At this stage, you can reason about how user input becomes DOM output — a direct prerequisite for understanding XSS/DOM security rooms later.

## Key Takeaways
- JavaScript introduces state, behavior, and event-driven UI updates in the browser.
- Every client input path must be treated as untrusted before rendering.
- DOM read/write flows are foundational for later AppSec topics, especially XSS and client-side logic flaws.
- Building and testing small interactive scripts improves both coding confidence and vulnerability intuition.
