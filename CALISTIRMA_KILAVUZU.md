# 🚀 Uygulamayı Çalıştırma Kılavuzu

## 📋 Adımlar

### 1. Backend Sunucusu (Zaten Başlatıldı ✅)
Backend sunucusu arka planda çalışıyor. Port 4000'de GraphQL endpoint'i hazır olmalı.

**Manuel olarak başlatmak isterseniz:**
```powershell
cd backend
npm run dev
```

### 2. Frontend Uygulamasını Başlatma

**Yeni bir terminal/PowerShell penceresi açın ve şu komutları çalıştırın:**

```powershell
# Frontend klasörüne gidin
cd C:\Projects\TherapistSocial\frontend

# Bağımlılıkları kontrol edin (gerekirse yükleyin)
flutter pub get

# Uygulamayı çalıştırın
flutter run
```

**Veya belirli bir cihazda çalıştırmak için:**
```powershell
flutter run -d <cihaz-id>
```

Cihaz ID'sini görmek için:
```powershell
flutter devices
```

### 3. Kayıt (Sign Up) İşlemi

1. Uygulama açıldığında **Splash Screen** görünecek
2. **Login Screen**'e yönlendirileceksiniz
3. Alt kısımda **"Sign Up"** veya **"Kayıt Ol"** butonuna tıklayın
4. Kayıt formunu doldurun:
   - **İsim** (Name)
   - **Soyisim** (Surname)
   - **E-posta** (Email)
   - **Şifre** (Password)
   - **Meslek** (Profession) - Örnek: "Psychologist", "Therapist"
   - **Şehir** (City) - Örnek: "Istanbul", "Ankara"
   - **Telefon** (Phone) - Opsiyonel

5. **"Sign Up"** butonuna tıklayın
6. Başarılı kayıt sonrası otomatik olarak **ana ekrana** yönlendirileceksiniz

### 4. Feed Sayfasına Erişim

Kayıt olduktan sonra:
- Otomatik olarak **Main Navigation** ekranına yönlendirileceksiniz
- **Feed** sayfası varsayılan olarak ilk sekme (en alttaki navigasyon çubuğunda en soldaki ikon)
- Alt navigasyon çubuğunda 4 sekme var:
  1. 🏠 **Feed** - Ana sayfa (ilk sekme)
  2. 🔍 **Discover** - Keşfet
  3. 🗺️ **Map** - Harita
  4. 👤 **Profile** - Profil

**Feed sayfası zaten açık olacak!** Eğer başka bir sekmeye geçtiyseniz, alt navigasyondan **Feed** ikonuna tıklayarak geri dönebilirsiniz.

## 🔧 Sorun Giderme

### Backend bağlantı hatası alıyorsanız:
1. Backend'in çalıştığından emin olun (port 4000)
2. Tarayıcıda `http://localhost:4000/graphql` adresini açarak GraphQL Playground'u kontrol edin
3. Frontend'de `app_config.dart` dosyasındaki endpoint ayarlarını kontrol edin

### Flutter komutları çalışmıyorsa:
```powershell
# Flutter kurulumunu kontrol edin
flutter doctor

# Cache'i temizleyin
cd frontend
flutter clean
flutter pub get
```

### Android emulator kullanıyorsanız:
- Backend endpoint otomatik olarak `10.0.2.2:4000` olarak ayarlanmış (Android emulator için localhost)
- iOS simulator veya fiziksel cihaz kullanıyorsanız `localhost:4000` kullanılır

## 📱 Test Verileri

Kayıt için örnek veriler:
- **Email**: test@example.com
- **Password**: Test123!
- **Name**: Test
- **Surname**: User
- **Profession**: Psychologist
- **City**: Istanbul

## ✅ Başarı Kontrolü

1. ✅ Backend çalışıyor (port 4000)
2. ✅ Frontend çalışıyor
3. ✅ Kayıt ekranı açılıyor
4. ✅ Kayıt başarılı
5. ✅ Feed sayfası görünüyor

## 🎯 Hızlı Komutlar

**Backend:**
```powershell
cd backend
npm run dev          # Development mode
npm start            # Production mode
```

**Frontend:**
```powershell
cd frontend
flutter run          # Uygulamayı çalıştır
flutter devices      # Cihazları listele
flutter clean        # Cache temizle
```

