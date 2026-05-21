![Track](https://img.shields.io/static/v1?label=TRACK&message=APPSEC&color=0B7285&style=for-the-badge)
![Focus](https://img.shields.io/static/v1?label=FOCUS&message=TRYHACKME&color=1D4ED8&style=for-the-badge)
![Path](https://img.shields.io/static/v1?label=PATH&message=CYBER%20SECURITY%20101&color=7C3AED&style=for-the-badge)
![Module](https://img.shields.io/static/v1?label=MODULE&message=M3-02&color=E67700&style=for-the-badge)
![Last Update](https://img.shields.io/static/v1?label=LAST%20UPDATE&message=2026-05-21&color=334155&style=for-the-badge)

# Windows Fundamentals 2

Room link: https://tryhackme.com/room/windowsfundamentals2x0x

## Executive Summary
- Bu room, Windows’un güvenlik tarafında gerçek operasyonel araçlara giriş yaptırıyor.
- Ana odak: kullanıcı/hesap yönetimi, UAC davranışı, Service/Task yapıları, Event Viewer, Registry, file-system güvenlik özellikleri ve built-in koruma mekanizmaları.
- Ekran akışı, “özellik nedir?” sorusundan “güvenlikte nasıl kullanılır?” sorusuna geçiyor.

## Evidence + Screenshot-based Analysis

### 1) Room açılışı ve kapsam
![01](assets/M3-02-01.png)
İlk görsel room’un kapsamını operasyonel güvenlik perspektifiyle çerçeveliyor. Önceki room’daki temel Windows bilgisi bu bölümde somut yönetim araçlarına bağlanıyor. Burada kritik mesaj, GUI bilgisi değil; Windows içindeki güvenlik karar noktalarını doğru araçlarla okuyabilme.

### 2) User/Account yönetimi mantığı
![02](assets/M3-02-02.png)
Bu bölüm yerel hesaplar, grup üyelikleri ve erişim alanı ilişkisini netleştiriyor. Kullanıcının hangi grupta olduğu çoğu zaman neyi görebileceğini/çalıştırabileceğini belirliyor. Güvenlik açısından bu katman yanlış yönetilirse privilege abuse çok kolaylaşır.

### 3) Standard user vs admin ayrımı
![03](assets/M3-02-03.png)
Görsel, “her işi admin ile yapma” prensibini pratik seviyeye taşıyor. Yetki ayrımı saldırı etkisini sınırlar ve yanlışlıkla yapılan sistem değişikliklerini azaltır. Kurumsal ortamlarda bu ayrımın bozulması, lateral movement ve persistence riskini dramatik artırır.

### 4) UAC ve elevation flow
![04](assets/M3-02-04.png)
UAC prompt davranışı bu ekranda güvenliğin insanla kesiştiği nokta olarak görünüyor. UAC, sessiz yetki yükseltmelerini zorlaştırır ve kritik işlemlerde görünür onay üretir. Bu, hem zararlı script’lere hem yanlış kullanıcı aksiyonlarına karşı tampon görevi görür.

### 5) Sadece quiz/soru doğrulama devamı (yorum yok)
![05](assets/M3-02-05.png)

### 6) System Configuration / msconfig benzeri yönetim görünümü
![06](assets/M3-02-06.png)
Bu ekran boot seçenekleri, servis başlangıç davranışları ve tanılama modlarını yönetme mantığını öğretiyor. Olay müdahalesinde selective startup/test boot gibi adımlar çok işe yarar. Yanlış servis veya başlangıç öğesi şüphesinde bu alan hızlı izolasyon imkânı verir.

### 7) Services konsolu ve servis yaşam döngüsü
![07](assets/M3-02-07.png)
Servislerin start/stop/startup type bilgisi burada güvenlik açısından okunuyor. Antivirüs ajanı, log forwarder veya kritik işletim servisi kapalıysa bunun etkisi doğrudan görünür olur. Bu nedenle “servis çalışıyor mu?” sorusu mavi takım refleksinin temelidir.

### 8) Sadece quiz/soru doğrulama devamı (yorum yok)
![08](assets/M3-02-08.png)

### 9) Scheduled Tasks (Task Scheduler) ve otomasyon riski
![09](assets/M3-02-09.png)
Task Scheduler yalnızca otomasyon değil, persistence vektörü olarak da kritik. Şüpheli scheduled task’ler çoğu saldırıda kalıcılık için kullanılır. Görsel bu yüzden hem yönetim kolaylığı hem güvenlik incelemesi için aynı aracı gösteriyor.

### 10) Event Viewer’a giriş
![10](assets/M3-02-10.png)
Event Viewer, “ne oldu?” sorusunu kanıta çeviren merkezdir. Security/System/Application log ayrımı olayın kaynağını daraltmayı sağlar. Bu ekran, yorum yerine veriyle konuşma kültürünün temelini koyar.

### 11) Sadece quiz/soru doğrulama devamı (yorum yok)
![11](assets/M3-02-11.png)

### 12) Registry temelleri
![12](assets/M3-02-12.png)
Registry, Windows davranışını belirleyen hiyerarşik bir yapı olarak anlatılıyor. Anahtar/değer mantığını anlamak, hem hardening hem de IOC/persistence avı için şart. Yanlış registry değişiklikleri sistem güvenliğini sessizce zayıflatabilir.

### 13) Registry hive yapısı ve kapsam farkları
![13](assets/M3-02-13.png)
HKLM/HKCU gibi hive’ların farklı etki alanları burada netleşiyor: makine-genel vs kullanıcı-bağlamlı ayarlar. Bu ayrım, bir değişikliğin sadece tek kullanıcıyı mı tüm host’u mu etkilediğini anlamada kritik.

### 14) Sadece quiz/soru doğrulama devamı (yorum yok)
![14](assets/M3-02-14.png)

### 15) File permissions/ACL ve güvenlik
![15](assets/M3-02-15.png)
Dosya izinleri okunurken “kim-ne yapabilir?” sorusuna net cevap aranıyor. ACL yanlışları çoğu veri sızıntısı ve yetkisiz değişiklik olayında kök neden olur. Görsel pratikte izin kontrolünü sadece teorik değil denetlenebilir bir adım hâline getiriyor.

### 16) Hidden/System dosya görünürlüğü ve adli farkındalık
![16](assets/M3-02-16.png)
Gizli/sistem dosyalarının görünür hâle getirilmesi, inceleme sırasında kaçabilecek artefact’ları yakalamayı sağlar. Saldırganlar görünürlüğü azaltmak için bu bayrakları kullanabilir. Bu yüzden görüntüleme ayarları bile güvenlik analizinde teknik bir karar noktasıdır.

### 17) Sadece quiz/soru doğrulama devamı (yorum yok)
![17](assets/M3-02-17.png)

### 18) Windows Defender ve koruma katmanları
![18](assets/M3-02-18.png)
Defender ekranı tehdit koruma, scan türleri ve gerçek zamanlı koruma mantığını bir araya getiriyor. Bu katman pasif bilgi değil aktif savunmadır; alarm üretimi ve otomatik engelleme davranışını etkiler. Host hijyeni için update + signature + scan üçlüsü birlikte düşünülmeli.

### 19) Firewall profil ve inbound/outbound farkı
![19](assets/M3-02-19.png)
Firewall tarafında profil bazlı yaklaşım (Domain/Private/Public) ve trafik yönü (inbound/outbound) ayrımı güvenlik kararının merkezidir. Yanlış profile geçmek ya da fazla geniş kural yazmak, host’u gereksiz açar. Görsel bunun operasyonel etkisini anlaşılır biçimde gösteriyor.

### 20) Sadece quiz/soru doğrulama devamı (yorum yok)
![20](assets/M3-02-20.png)

### 21) BitLocker / disk şifreleme bağlamı
![21](assets/M3-02-21.png)
Disk şifreleme özellikle fiziksel kayıp/çalıntı senaryolarında veri güvenliğini korur. Host ele geçirilmeden sadece diske erişimle veri okunmasını zorlaştırır. Bu yüzden endpoint güvenliğinde “cihaz güvenliği” katmanının temel kontrolüdür.

### 22) Windows Security merkezinde genel durum görünürlüğü
![22](assets/M3-02-22.png)
Tek panelde güvenlik durumu görmek operasyonel hız sağlar: hangi katman sağlıklı, hangisi aksiyon bekliyor hızlıca anlaşılır. Bu görünürlük olmadan savunma dağınık kalır. Görsel, merkezi takip modelinin neden etkili olduğunu vurguluyor.

### 23) Sadece quiz/soru doğrulama devamı (yorum yok)
![23](assets/M3-02-23.png)

### 24) Pratik görev akışı ve doğrulama
![24](assets/M3-02-24.png)
Bu ekranlarda hedef, GUI’de rastgele gezmek değil doğru güvenlik panelini açıp istenen kontrolü teyit etmek. Doğru cevaba giden yolun belge/kanıt üretmesi öğreniliyor. Bu yaklaşım gerçek ortamda checklist-temelli güvenlik denetimine birebir benzer.

### 25) Sadece quiz/soru doğrulama devamı (yorum yok)
![25](assets/M3-02-25.png)

### 26) Room kapanışı ve kavram konsolidasyonu
![26](assets/M3-02-26.png)
Son ekran, Windows iç güvenlik bileşenlerinin tek bir modelde birleştiğini gösteriyor: hesap/yetki, servis/görev, log/registry, defender/firewall, disk koruması. Bu birleşim, sonraki odalarda tehdit modelleme ve olay analizi yaparken temel referans seti olacak.

## Key Takeaways
- Windows güvenliği, tek ayar değil çok katmanlı bir kontrol sistemi.
- En güçlü refleks: least privilege + log-first doğrulama + düzenli hardening.
- Registry, services ve scheduled tasks birlikte okunmadan host güvenliği eksik kalır.
- Bu room, GUI bilgisini doğrudan güvenlik operasyon pratiğine dönüştürüyor.
