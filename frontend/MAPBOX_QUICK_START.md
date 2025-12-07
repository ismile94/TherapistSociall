# Mapbox Hızlı Kurulum

## ✅ Yapılanlar

1. ✅ Mapbox public token eklendi: `pk.eyJ1IjoiaWhtdWluIiwiYSI6ImNtaXYxYjN0djBoM3IzZnF2eGM5cG9jaGYifQ.HLl104cLoN24GRoC2we4oQ`
2. ✅ Token `app_config.dart` ve `main.dart`'a eklendi
3. ✅ Android permissions eklendi

## ⚠️ ÖNEMLİ: SDK Secret Token Gerekli

Android build için Mapbox **SDK Registry Secret Token** gerekiyor.

### Adımlar:

1. **Secret Token Alın:**
   - https://account.mapbox.com/access-tokens/ adresine gidin
   - "Secret tokens" sekmesine tıklayın
   - Yeni bir secret token oluşturun (veya mevcut olanı kullanın)
   - Token'ı kopyalayın

2. **gradle.properties'e Ekleyin:**
   
   `frontend/android/gradle.properties` dosyasını açın ve şu satırı ekleyin:
   
   ```properties
   MAPBOX_DOWNLOADS_TOKEN=your_secret_token_here
   ```

3. **Temiz Build:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## 📝 Not

Secret token olmadan uygulama çalışmaz - Android build hatası alırsınız. Secret token ekleyene kadar Mapbox özellikleri kullanılamayacak.

## 🔗 Faydalı Linkler

- Mapbox Access Tokens: https://account.mapbox.com/access-tokens/
- Mapbox Flutter Docs: https://docs.mapbox.com/flutter/maps/guides/install/

