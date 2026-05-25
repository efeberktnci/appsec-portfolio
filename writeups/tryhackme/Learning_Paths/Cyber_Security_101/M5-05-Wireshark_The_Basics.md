![Last Update](https://img.shields.io/badge/LAST_UPDATE-2026--05--25-5D646F?style=for-the-badge)

# Wireshark: The Basics

![TRACK](https://img.shields.io/badge/TRACK-APPSEC-4B5563?style=for-the-badge)
![FOCUS](https://img.shields.io/badge/FOCUS-TRYHACKME-0EA5E9?style=for-the-badge)
![PATH](https://img.shields.io/badge/PATH-CYBER_SECURITY_101-7C3AED?style=for-the-badge)
![MODULE](https://img.shields.io/badge/MODULE-M5--05-F59E0B?style=for-the-badge)
![LAST UPDATE](https://img.shields.io/badge/LAST_UPDATE-2026--05--25-111827?style=for-the-badge)

Room link: https://tryhackme.com/room/wiresharkthebasics

## 1) Tool overview and GUI map
![01](assets/M5-05-01.png)
This screenshot explains Wireshark’s core use cases (troubleshooting, anomaly detection, and protocol investigation) and clearly maps the interface parts: toolbar, display filter bar, recent files, interfaces/capture controls, and status bar. The key message is that Wireshark is a **traffic analyzer**, not an active IDS.

## 2) Loading a PCAP and understanding the 3 analysis panes
![02](assets/M5-05-02.png)
This image focuses on opening `http1.pcap` and reading packets through the three-pane model: packet list, packet details, and packet bytes. It shows how each pane gives a different abstraction level from summary to raw evidence.

## 3) Coloring packets for fast triage
![03](assets/M5-05-03.png)
Here the room explains default coloring rules and how colors speed up traffic triage before deep inspection. It distinguishes temporary/conversation coloring from permanent profile-based rules and highlights where those settings are managed.

## 4) Starting/stopping capture and merge workflow
![04](assets/M5-05-04.png)
This screenshot shows capture controls (start/stop/restart), then transitions to **merging PCAP files** from the File menu. It teaches operational handling of multiple captures and preserving a merged output file for later analysis.

## 5) Capture file properties: comments, packet count, hashes
![05](assets/M5-05-05.png)
The section demonstrates reading file-level metadata via Capture File Properties, including packet totals, timing/statistics, comments, and SHA256 hash. This is important for evidence integrity and repeatable reporting.

## 6) Packet dissection concept and layer-by-layer decode
![06](assets/M5-05-06.png)
This screenshot introduces protocol dissection: selecting a packet and expanding decoded fields across layers while the matching bytes are highlighted. It reinforces how Wireshark maps OSI/TCP-IP decoding to raw packet data.

## 7) Deep packet details navigation
![07](assets/M5-05-07.png)
Here the workflow continues with practical navigation inside packet details, emphasizing field expansion and correlation with bytes. The focus is accuracy when extracting exact protocol values.

## 8) Following protocol conversations (stream analysis)
![08](assets/M5-05-08.png)
This stage demonstrates using follow-stream style analysis to reconstruct request/response conversations instead of reading isolated packets. It helps identify full transaction context.

## 9) Display filter fundamentals in practice
![09](assets/M5-05-09.png)
The screenshot shows filtering logic used to isolate relevant traffic subsets quickly. The takeaway is that filtering is the main method to remove noise in real captures.

## 10) Building focused filters for target evidence
![10](assets/M5-05-10.png)
This part applies more targeted filtering, likely mixing protocol/host/port constraints to narrow results. It reflects practical analyst workflow: broad first, then iterative refinement.

## 11) Reading protocol context from filtered packets
![11](assets/M5-05-11.png)
After filtering, this screenshot focuses on interpreting protocol behavior and packet roles from the selected subset. It emphasizes evidence-based interpretation rather than guessing.

## 12) Correlating packet list and details panes
![12](assets/M5-05-12.png)
This step reinforces pane correlation: selecting in the list, validating in details, confirming in bytes. It is essential for precise answer extraction in room questions.

## 13) Statistics view for traffic overview
![13](assets/M5-05-13.png)
The screenshot appears to move into aggregated views/statistics to summarize capture behavior. This gives macro-level insight before returning to packet-level evidence.

## 14) Practical extraction checkpoint
![14](assets/M5-05-14.png)
Here the room tests whether the learner can extract exact values from the current capture state. It validates interpretation accuracy after using filters and packet inspection.

## 15) Practical extraction checkpoint (continued)
![15](assets/M5-05-15.png)
This image continues answer-focused extraction, usually requiring strict field matching from Wireshark output. The purpose is reproducibility and precision.

## 16) Practical extraction checkpoint (continued)
![16](assets/M5-05-16.png)
The task remains evidence-driven: isolate the right packet set, then read exact requested values from details/bytes. This mirrors real triage workflows.

## 17) Practical extraction checkpoint (continued)
![17](assets/M5-05-17.png)
This stage extends the same methodology with additional prompts. It reinforces consistency when handling repeated but slightly varied analysis questions.

## 18) Practical extraction checkpoint (continued)
![18](assets/M5-05-18.png)
The screenshot likely captures another question block or narrowed packet context. The learner is expected to maintain methodical packet validation.

## 19) Practical extraction checkpoint (continued)
![19](assets/M5-05-19.png)
Here the room keeps focus on direct evidence extraction from Wireshark views. It builds confidence in translating packet artifacts to exact answers.

## 20) Practical extraction checkpoint (continued)
![20](assets/M5-05-20.png)
This step continues with analyst-style interpretation under constrained prompts, preserving the same sequence: filter → inspect → verify → answer.

## 21) Practical extraction checkpoint (continued)
![21](assets/M5-05-21.png)
The screenshot likely includes one more verification-focused question set. It ensures the learner can repeat the workflow without drifting into assumptions.

## 22) Practical extraction checkpoint (continued)
![22](assets/M5-05-22.png)
This section keeps building operational fluency in packet evidence reading. It stresses exact field retrieval and consistency across multiple prompts.

## 23) Practical extraction checkpoint (continued)
![23](assets/M5-05-23.png)
The image continues the room’s assessment pattern, requiring accurate interpretation of packet/stream data under quiz constraints.

## 24) Practical extraction checkpoint (continued)
![24](assets/M5-05-24.png)
This screenshot likely captures additional answers that depend on prior filtering and packet-selection choices. It rewards disciplined workflow.

## 25) Practical extraction checkpoint (continued)
![25](assets/M5-05-25.png)
The task remains aligned with core basics: read the right packet, inspect the right field, and report exact values. This is foundational for later advanced labs.

## 26) Practical extraction checkpoint (continued)
![26](assets/M5-05-26.png)
This near-final step appears to complete the practical answer chain and confirm that the full Wireshark baseline workflow has been applied correctly.

## 27) Final completion and retained skills
![27](assets/M5-05-27.png)
The final screenshot closes the room by confirming the learner can navigate Wireshark, load/merge PCAPs, use filters, inspect packet layers, interpret metadata, and extract precise evidence from captures.
