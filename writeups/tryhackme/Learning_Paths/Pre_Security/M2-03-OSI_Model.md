![Track](https://img.shields.io/static/v1?label=TRACK&message=APPSEC&color=0B7285&style=for-the-badge)
![Focus](https://img.shields.io/static/v1?label=FOCUS&message=TRYHACKME&color=1D4ED8&style=for-the-badge)
![Path](https://img.shields.io/static/v1?label=PATH&message=PRE%20SECURITY&color=7C3AED&style=for-the-badge)
![Module](https://img.shields.io/static/v1?label=MODULE&message=M2&color=E67700&style=for-the-badge)
![Last Update](https://img.shields.io/static/v1?label=LAST%20UPDATE&message=2026-05-17&color=334155&style=for-the-badge)

# OSI Model

Room link: https://tryhackme.com/room/osimodelzi

## Executive Summary
This room introduces the **OSI (Open Systems Interconnection) model** as a practical framework to reason about networking. The big win is not memorizing seven names; it's learning to ask the right question at the right layer:

- **What is the data called at this point?** (bits / frames / packets / segments)
- **What kind of address is used here?** (MAC vs IP vs port)
- **Where do we apply security controls?** (segmentation, firewalling, TLS, authentication, input validation)

If you can map a symptom to a layer, you can debug faster and write more confident security notes.

---

## Evidence (1–11) + deep analysis

### 1) OSI model overview + why "encapsulation" matters
![01](assets/M2-03-01.png)

This screenshot introduces the OSI stack (Layer 7 → Layer 1) and sets up a key idea used throughout networking: **encapsulation**.

What this means in practice:
- When an application sends data, each lower layer wraps it with its own metadata (headers/trailers).
- Those "wrappers" are what allow the network to deliver the data correctly:
  - **MAC** (Data Link) helps deliver inside the local network.
  - **IP** (Network) helps route between networks.
  - **Ports** (Transport) deliver to the right service/process.

AppSec angle:
- A lot of security mistakes come from trusting the wrong wrapper. Example: trusting a client-controlled header (app-layer) as if it proves identity (auth-layer). The OSI mental model helps separate "addressing" from "authentication".

---

### 2) Layer 1 — Physical (bits on a medium)
![02](assets/M2-03-02.png)

This screen focuses on the **physical layer**: cables, radio signals, and the concept that everything ultimately becomes **1s and 0s**.

Key takeaway:
- Physical layer is about *transporting bits*, not understanding meaning.
- The "binary numbering system" callout is a reminder that higher-level data eventually becomes raw electrical/optical/radio signals.

Security angle:
- Physical access is a trust boundary. If someone can plug in (or join Wi‑Fi), they may reach internal services unless later layers enforce isolation.
- Many "network problems" start here: a bad cable or weak signal can look like an "app issue" until you test the lower layer.

---

### 3) Layer 2 — Data Link (frames, MAC, and the NIC)
![03](assets/M2-03-03.png)

This screenshot introduces **Data Link** and highlights two important parts:

- **NIC (Network Interface Card)**: the hardware interface that connects a device to a network.
- **MAC address**: the identifier associated with the NIC, used for local delivery.

What’s really happening:
- Data Link is "local neighborhood delivery". Switches operate here.
- The layer receives a packet from Layer 3 and prepares it to be sent across the local medium as a **frame**.

Security angle:
- MAC addresses can be spoofed; they identify an interface but don't prove identity.
- This is why network access control needs more than "allow known MACs". It can reduce casual abuse, but it’s not strong security by itself.

---

### 4) Layer 4 — Transport (TCP: reliability and ordering)
![04](assets/M2-03-04.png)

This screenshot is **Transport layer** focusing on **TCP**.

What the table is teaching:
- TCP trades speed for reliability:
  - it checks delivery,
  - can retransmit missing parts,
  - keeps order so the receiver reconstructs data correctly.

Why TCP matters in real systems:
- Most web traffic is TCP (or QUIC over UDP, but reliability still matters).
- If TCP is unstable, everything above it (TLS/HTTP/app) will feel broken or inconsistent.

Security angle:
- Firewalls and rate limits often live at Layer 4 (ports/protocols).
- Many basic exposure problems are simply "a sensitive service is listening on a reachable port".

---

### 5) Transport (UDP: speed over guarantees)
![05](assets/M2-03-05.png)

This screenshot transitions to **UDP** and shows a visual where only some packets arrive, so the final image is incomplete.

Interpretation:
- UDP does not guarantee delivery, ordering, or retransmission.
- It can be faster and is useful where occasional loss is acceptable (streaming, discovery protocols, etc.).

Security angle:
- UDP-based services are commonly used for discovery and infrastructure.
- "Fast but lossy" changes how you debug: packet capture becomes more important because retry behavior isn’t built-in like TCP.

---

### 6) UDP example in practice (why dropped chunks are expected)
![06](assets/M2-03-06.png)

This screenshot continues the UDP concept using the same "packets of an image" idea.

What to learn:
- UDP is acceptable when the consumer can tolerate missing data (e.g., a few missing pixels in video).
- It also reinforces the core OSI habit: **the same app behavior can differ just by changing the transport protocol**.

AppSec angle:
- Some defenses assume reliable delivery (rate limits, replay detection, etc.). With UDP, you must design with loss/reordering in mind.

---

### 7) Layer 3 — Network (IP addressing + routing)
![07](assets/M2-03-07.png)

This screenshot introduces the **Network layer**: IP addressing and routing between networks.

What "Network layer" answers:
- "Where is the destination network?"
- "What next hop/router should this packet go to?"

Security angle:
- A large part of security is deciding which networks can route to which other networks (segmentation).
- Misrouting or over-broad exposure is how internal-only functionality becomes reachable.

---

### 8) Layer 5 — Session (state across multiple exchanges)
![08](assets/M2-03-08.png)

This screenshot explains **Session layer** as maintaining a conversation between endpoints.

How to think about it:
- The session layer is about *continuity* (keeping track of a multi-step interaction).
- In web apps, sessions are usually represented with cookies/tokens, but the OSI session concept is more general than "cookie = session".

AppSec angle:
- Session management is where many bugs live: weak session IDs, missing rotation, bad timeout logic, or confusing "logged in" state.

---

### 9) Layer 6 — Presentation (encoding + encryption)
![09](assets/M2-03-09.png)

This screenshot covers **Presentation layer**: data representation and encryption.

What this means in web contexts:
- TLS encryption, character encoding (UTF‑8), and serialization formats (JSON) relate to how data is represented.

Security angle:
- Encoding/decoding mistakes create real-world issues: validation bypass via encoding tricks, parser differentials, and TLS misconfigurations.

---

### 10) Layer 7 — Application (protocol meaning: HTTP, DNS, SMTP, …)
![10](assets/M2-03-10.png)

This screenshot frames the **Application layer** as "what the application understands": protocols and semantics.

Why this is the AppSec home base:
- Most vulnerabilities you write reports on are Layer 7: access control, injection, XSS, CSRF, auth/session flaws.

Important nuance:
- Lower-layer controls can reduce exposure, but **correct authorization and validation must still happen at the application layer**.

---

### 11) Knowledge check (answers blurred)
![11](assets/M2-03-11.png)

This final screen validates the room’s core skill: mapping concepts to layers without mixing them up.

What you should be able to do after this room:
- Distinguish **MAC vs IP vs port** (and know what each is used for).
- Explain why a "port open" is a transport-layer fact, while "403 forbidden" is an application-layer decision.
- Approach troubleshooting systematically: start low if nothing works; start high if the app responds but behaves wrong.

---

## Summary (how to use OSI going forward)
When something breaks (or when you're threat modeling), OSI gives you a checklist:

- **L1/L2:** Is the device even connected locally?
- **L3:** Can it route to the target network?
- **L4:** Is the service reachable on the expected port/protocol?
- **L5/L6:** Is session/encryption/encoding behaving?
- **L7:** Does the application correctly authenticate, authorize, and validate input?
