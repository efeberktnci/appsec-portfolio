![Track](https://img.shields.io/static/v1?label=TRACK&message=APPSEC&color=0B7285&style=for-the-badge)
![Focus](https://img.shields.io/static/v1?label=FOCUS&message=LETSDEFEND&color=1D4ED8&style=for-the-badge)
![Course](https://img.shields.io/static/v1?label=COURSE&message=SOC%20FUNDAMENTALS&color=E67700&style=for-the-badge)
![Lesson](https://img.shields.io/static/v1?label=LESSON&message=SIEM%20AND%20ANALYST%20RELATIONSHIP&color=7C3AED&style=for-the-badge)
![Last Update](https://img.shields.io/static/v1?label=LAST%20UPDATE&message=2026-10-07&color=334155&style=for-the-badge)

# SIEM and Analyst Relationship

Course link: https://app.letsdefend.io/path/soc-analyst-learning-path

## 1) What SIEM does
![What is SIEM](assets/01-what-is-siem.png)
This screenshot explains SIEM as a solution that collects event data, filters it, and generates alerts when suspicious activity matches defined rules or thresholds.

The example about repeated failed Windows logins shows the basic detection idea clearly: raw events become useful for a SOC analyst only after they are collected, filtered, and turned into an alert worth reviewing.

## 2) Relationship between SOC analyst and SIEM alerts
![SIEM alert channels](assets/02-siem-alert-channels.png)
This section shows the monitoring interface and explains the analyst's role in the alert flow. SOC analysts usually track and review alerts, while separate teams or roles may handle rule development, correlation logic, and configuration.

The key point is that an alert is only the beginning of the investigation. The analyst checks details, decides whether it looks like a real threat or a false positive, and uses other SOC products such as EDR, log management, and threat intelligence to support the decision.

## 3) Monitoring checkpoint
![Monitoring question checkpoint](assets/03-monitoring-question-checkpoint.png)

## Key Takeaways
- SIEM collects and filters events before generating analyst-facing alerts.
- SOC analysts validate alerts instead of blindly trusting every SIEM match.
- Alert review often requires context from other SOC tools, not only the SIEM screen.
