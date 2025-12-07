# Mapbox Yapılandırması

Mapbox token'ı başarıyla eklendi! Ancak Android build için **SDK Registry Secret Token** gerekiyor.

## ✅ Yapılanlar

1. ✅ Mapbox public access token eklendi (`pk.eyJ...`)
2. ✅ Token `app_config.dart`'a eklendi
3. ✅ Token `main.dart`'da initialize edildi
4. ✅ Android permissions eklendi

## ⚠️ Gerekli: SDK Secret Token

Mapbox Maps Flutter plugin'i Android build için bir **secret token** gerektiriyor. Bu token'ı şu adımlarla alabilirsiniz:

### SDK Secret Token Nasıl Alınır?

1. Mapbox hesabınıza giriş yapın: https://account.mapbox.com/
2. **Account** > **Secret tokens** bölümüne gidin
3. **SDK Registry token** oluşturun veya mevcut token'ı kopyalayın
4. Token'ı `frontend/android/gradle.properties` dosyasına ekleyin:

```properties
MAPBOX_DOWNLOADS_TOKEN=YOUR_SECRET_TOKEN_HERE
```

### Örnek gradle.properties:

```properties
org.gradle.jvmargs=-Xmx8G -XX:MaxMetaspaceSize=4G -XX:ReservedCodeCacheSize=512m -XX:+HeapDumpOnOutOfMemoryError
android.useAndroidX=true
android.enableJetifier=true
MAPBOX_DOWNLOADS_TOKEN=YOUR_SECRET_TOKEN_HERE
```

## 📝 Token Türleri

- **Public Access Token** (pk. ile başlar): ✅ Zaten eklendi - Uygulamada harita görüntülemek için
- **Secret Token** (sk. veya SDK Registry token): ⚠️ Gerekli - Android build için

## 🚀 Sonraki Adımlar

1. SDK Secret Token'ı alın (yukarıdaki adımları izleyin)
2. `frontend/android/gradle.properties` dosyasına ekleyin
3. Uygulamayı tekrar build edin:

```bash
cd frontend
flutter clean
flutter pub get
flutter run
```

## 📚 Referanslar

- Mapbox Secret Tokens: https://account.mapbox.com/access-tokens/
- Mapbox Flutter Docs: https://docs.mapbox.com/flutter/maps/guides/install/

## Not

Secret token olmadan da uygulama çalışabilir, ancak Android build hatası alabilirsiniz. Secret token ekleyene kadar Mapbox özellikleri kullanılamayacak.

