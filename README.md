# AppSec Portfolio (Job-Ready Junior Track)

Bu repo, AppSec/Product Security odakli portfolyomu tek yerde toplar: lab write-up'lari, pentest-style finding raporlari,
threat model ve code review checklist gibi Secure SDLC artefact'lari, CI/CD guvenlik demo ciktisi.

## Ne goreceksin?
- Tekrarlanabilir (reproducible) adimlarla yazilmis finding raporlari
- Kanit (evidence) iceren ama hassas veri icermeyen (sanitized) PoC'ler
- Fix / test onerileri (sadece "acik var" degil, "nasil kapanir")

## Standart Finding Formati
Her finding su bloklari icerir:
- Scope/Target
- Steps to reproduce
- Evidence (sanitized request/response, screenshot, log)
- Impact
- Severity (Low/Med/High/Critical + gerekce)
- Recommendation (fix + test + defense-in-depth)
- Retest plan
- Executive summary (5–10 satir)

Sablon: `templates/FINDING_TEMPLATE.md`

## Hizli Baslangic (Yeni Finding Eklemek)
1. `templates/FINDING_TEMPLATE.md` dosyasini kopyala
2. Uygun klasore koy:
   - PortSwigger / lab write-up: `writeups/`
   - Juice Shop / rapor: `reports/`
3. Hassas verileri sansurle (token/cookie/secret/real target URL yok)
4. Commit mesaji: `report: <kisa baslik>` veya `writeup: <lab adi>`

## Klasor Yapisi
- `writeups/` PortSwigger ve diger lab write-up'lari
- `reports/` Juice Shop ve finding raporlari (Markdown/PDF)
- `threat-models/` Threat model dokumanlari
- `checklists/` Code review checklist
- `ci-cd-demo/` CI/CD guvenlik demo artefact'lari
- `templates/` Kopyala-yapistir sablonlar

## Not
Bu repo "is hayati raporu" gorunumunu hedefler ama sadece lab/izinli hedefler icindir. Gercek sistemlere izinsiz test yok.
