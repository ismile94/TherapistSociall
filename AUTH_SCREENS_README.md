# Authentication Screens - Karşılama Sayfaları

Uygulamayı açtığınızda karşılaşacağınız sayfalar oluşturuldu!

## 📱 Oluşturulan Ekranlar

### 1. Splash Screen (Başlangıç Ekranı)
- **Dosya**: `frontend/lib/features/auth/presentation/screens/splash_screen.dart`
- **Özellikler**:
  - Güzel animasyonlu açılış ekranı
  - Pastel mavi tema
  - Logo ve uygulama adı
  - 2 saniye sonra otomatik olarak login ekranına yönlendirme

### 2. Login Screen (Giriş Ekranı)
- **Dosya**: `frontend/lib/features/auth/presentation/screens/login_screen.dart`
- **Özellikler**:
  - Email ve şifre girişi
  - Şifre göster/gizle butonu
  - Form validasyonu
  - "Forgot Password" linki
  - Sign up sayfasına yönlendirme
  - Modern ve profesyonel tasarım

### 3. Sign Up Screen (Kayıt Ekranı)
- **Dosya**: `frontend/lib/features/auth/presentation/screens/signup_screen.dart`
- **Özellikler**:
  - İsim, soyisim, email, şifre
  - Profesyon (zorunlu)
  - Şehir (zorunlu)
  - Telefon (opsiyonel)
  - Tüm alanlar için validasyon
  - Login sayfasına geri dönüş

## 🎨 Tasarım Özellikleri

- ✅ Pastel mavi renk teması (#4FA3DA)
- ✅ Inter font kullanımı
- ✅ Modern Material Design 3
- ✅ Smooth animasyonlar
- ✅ Responsive tasarım
- ✅ Loading state'leri

## 🚀 Nasıl Çalıştırılır

1. Flutter bağımlılıklarını yükleyin:
```bash
cd frontend
flutter pub get
```

2. Uygulamayı çalıştırın:
```bash
flutter run
```

## 📋 Sayfa Akışı

```
Splash Screen (2 saniye)
    ↓
Login Screen
    ↓ (Create Account butonuna tıklayınca)
Sign Up Screen
    ↓ (Başarılı kayıt/girişten sonra)
Ana Sayfa (henüz oluşturulmadı)
```

## ⚠️ Notlar

- Şu anda login ve signup fonksiyonları **placeholder** - gerçek GraphQL entegrasyonu henüz yapılmadı
- Form validasyonları çalışıyor
- Tüm ekranlar responsive ve modern tasarıma sahip
- Router yapılandırması güncellendi

## 🔜 Yapılacaklar

- [ ] GraphQL login mutation'ı entegrasyonu
- [ ] GraphQL signup mutation'ı entegrasyonu
- [ ] JWT token yönetimi
- [ ] Secure storage entegrasyonu
- [ ] Error handling iyileştirmeleri
- [ ] Loading state'leri için daha iyi UX

## 📸 Ekran Görüntüleri

Ekranlar hazır! Uygulamayı çalıştırarak görebilirsiniz.

