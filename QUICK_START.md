# TherapistSocial - Hızlı Başlangıç Kılavuzu

## 🚀 Uygulamayı Çalıştırma

Flutter projesi `frontend/` klasöründe bulunuyor. Tüm Flutter komutlarını **frontend klasörü içinde** çalıştırmanız gerekiyor.

### Doğru Komutlar:

```bash
# 1. Frontend klasörüne gidin
cd frontend

# 2. Cache'i temizleyin
flutter clean

# 3. Bağımlılıkları yükleyin
flutter pub get

# 4. Uygulamayı çalıştırın
flutter run -d RZCY10F3NZH
```

### Yanlış ❌:
```bash
C:\Projects\TherapistSocial> flutter run  # ❌ HATA! Root dizinde çalıştırılamaz
```

### Doğru ✅:
```bash
C:\Projects\TherapistSocial\frontend> flutter run  # ✅ DOĞRU!
```

## 📁 Proje Yapısı

```
TherapistSocial/
├── frontend/          # Flutter uygulaması (BURADA ÇALIŞTIRILMALI)
│   ├── lib/
│   ├── pubspec.yaml  # Flutter proje dosyası
│   └── ...
└── backend/          # GraphQL backend
```

## 💡 İpucu

PowerShell'de hızlıca frontend klasörüne gitmek için:

```powershell
cd C:\Projects\TherapistSocial\frontend
```

Veya root dizindeyken:

```powershell
cd frontend
```

## 🎯 Hızlı Komutlar

Frontend klasöründe:

```bash
# Temizle ve yeniden yükle
flutter clean && flutter pub get

# Uygulamayı çalıştır
flutter run

# Belirli bir cihazda çalıştır
flutter run -d RZCY10F3NZH

# Build al
flutter build apk
```

## ⚠️ Önemli Notlar

1. **Her zaman `frontend/` klasöründe çalıştırın** - Flutter komutları burada çalışır
2. **Backend ayrı bir proje** - Node.js/TypeScript projesi, `backend/` klasöründe
3. **Mapbox token'ları yapılandırıldı** - Artık çalışmaya hazır!

## 🔧 Sorun Giderme

### "No pubspec.yaml file found" hatası alıyorsanız:
- Mutlaka `frontend/` klasöründe olduğunuzdan emin olun
- `cd frontend` komutuyla doğru klasöre gidin

### Komutlar çalışmıyorsa:
```bash
cd C:\Projects\TherapistSocial\frontend
flutter doctor  # Flutter kurulumunu kontrol edin
```

