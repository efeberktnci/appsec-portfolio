![Track](https://img.shields.io/static/v1?label=TRACK&message=APPSEC&color=0B7285&style=for-the-badge)

![Focus](https://img.shields.io/static/v1?label=FOCUS&message=TRYHACKME&color=1D4ED8&style=for-the-badge)

![Path](https://img.shields.io/static/v1?label=PATH&message=CYBER%20SECURITY%20101&color=7C3AED&style=for-the-badge)

![Module](https://img.shields.io/static/v1?label=MODULE&message=M3-02&color=E67700&style=for-the-badge)

![Last Update](https://img.shields.io/static/v1?label=LAST%20UPDATE&message=2026-05-22&color=334155&style=for-the-badge)

# Windows Fundamentals 2

Room link: https://tryhackme.com/room/windowsfundamentals2x0x

## Executive Summary
- This room introduces practical Windows security administration using native tools.
- The screenshots focus on UAC, System Configuration, Computer Management, Services, Task Scheduler, Event Viewer, and Registry.
- Main objective: read the panel, understand the control, verify the state.

## Evidence + Screenshot-based Analysis

### 1) Room intro and scope
![01](assets/M3-02-01.png)

The room opening states this module is a continuation of Windows Fundamentals and shifts toward host administration and security tooling. The key message is operational use of native Windows consoles.

### 2) UAC concept
![02](assets/M3-02-02.png)

This screenshot explains UAC as an elevation checkpoint. The room text ties it to reducing silent privilege changes.

### 3) UAC levels
![03](assets/M3-02-03.png)

The panel shows that notification strictness can be tuned. The room highlights the security trade-off between fewer prompts and less visibility.

### 4) System Configuration (msconfig)
![04](assets/M3-02-04.png)

This section introduces msconfig for startup and boot diagnostics. It is presented as a troubleshooting and control-validation utility.

### 5) Answer checkpoint
![05](assets/M3-02-05.png)

### 6) Computer Management hub
![06](assets/M3-02-06.png)

The screenshot shows Computer Management as a central place for multiple admin areas. The room emphasizes faster triage by using this consolidated console.

### 7) Services management
![07](assets/M3-02-07.png)

Service state and startup type are the focus here. The room text connects service status directly to security and reliability.

### 8) Answer checkpoint
![08](assets/M3-02-08.png)

### 9) Task Scheduler
![09](assets/M3-02-09.png)

This section explains scheduled tasks with triggers and actions. The room points out automation value and why task entries should be reviewed carefully.

### 10) Event Viewer
![10](assets/M3-02-10.png)

The screenshot introduces logs as evidence. The room message is to use event timelines for confirmation, not assumptions.

### 11) Answer checkpoint
![11](assets/M3-02-11.png)

### 12) Registry basics
![12](assets/M3-02-12.png)

Registry is shown as a hierarchical settings database. The room explains it as a core location for system and user configuration values.

### 13) Registry hives and scope
![13](assets/M3-02-13.png)

The hive layout demonstrates different configuration scopes. The text emphasizes understanding user-level versus machine-level impact.

### 14) Answer checkpoint
![14](assets/M3-02-14.png)

### 15) File permissions
![15](assets/M3-02-15.png)

This screen focuses on access control at file/folder level. The room links this directly to confidentiality and integrity.

### 16) Hidden and system files
![16](assets/M3-02-16.png)

The screenshot explains visibility settings in Explorer. The practical takeaway is that default views can hide relevant investigation artifacts.

### 17) Answer checkpoint
![17](assets/M3-02-17.png)

### 18) Windows Defender
![18](assets/M3-02-18.png)

Defender is presented as active endpoint protection with state and health indicators. The room stresses continuous verification.

### 19) Firewall and profile context
![19](assets/M3-02-19.png)

The panel topic is host firewall behavior by network profile. The room text highlights policy correctness by context.

### 20) Answer checkpoint
![20](assets/M3-02-20.png)

### 21) Device-level protection context
![21](assets/M3-02-21.png)

This section points to host protections beyond normal app usage. It reinforces layered endpoint defense.

### 22) Security status overview
![22](assets/M3-02-22.png)

The screenshot shows a centralized security overview. The room uses this as a quick posture check.

### 23) Answer checkpoint
![23](assets/M3-02-23.png)

### 24) Practical validation task
![24](assets/M3-02-24.png)

This stage checks whether the learner can locate and verify the right controls in practice.

### 25) Answer checkpoint
![25](assets/M3-02-25.png)

### 26) Completion recap
![26](assets/M3-02-26.png)

The final screen closes the room by connecting all native controls into one host-security workflow.

## Key Takeaways
- Windows Fundamentals 2 is a tool-driven security operations room.
- Each screenshot maps a specific console to a specific security purpose.
- The strongest skill gained is state verification across native Windows controls.

