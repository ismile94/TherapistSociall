# TODO'lar - Durum Raporu

Bu dosyadaki TODO'lar **normal** ve **beklenen** durumdadır. Uygulama çalışıyor, ancak bazı özellikler henüz placeholder durumunda.

## 📋 Mevcut TODO'lar

### 1. GraphQL Client - Token Storage
**Dosya:** `frontend/lib/core/network/graphql_client.dart`
**Durum:** ⏳ Backend hazır olduğunda implement edilecek
**Açıklama:** Secure storage'dan token almak için backend authentication hazır olması gerekiyor

### 2. Login Logic - GraphQL
**Dosya:** `frontend/lib/features/auth/presentation/screens/login_screen.dart`
**Durum:** ⏳ Backend GraphQL server hazır olduğunda implement edilecek
**Açıklama:** Şu an placeholder - gerçek login mutation'ı backend hazır olunca eklenecek

### 3. Signup Logic - GraphQL
**Dosya:** `frontend/lib/features/auth/presentation/screens/signup_screen.dart`
**Durum:** ⏳ Backend GraphQL server hazır olduğunda implement edilecek
**Açıklama:** Şu an placeholder - gerçek signup mutation'ı backend hazır olunca eklenecek

### 4. Forgot Password
**Dosya:** `frontend/lib/features/auth/presentation/screens/login_screen.dart`
**Durum:** ⏳ İleride implement edilecek
**Açıklama:** MVP'de öncelikli değil, sonraki versiyonda eklenecek

## ✅ Şu An Çalışan Özellikler

- ✅ Splash Screen (animasyonlu)
- ✅ Login Screen (UI hazır)
- ✅ Signup Screen (UI hazır)
- ✅ Form validasyonları
- ✅ Ana navigasyon (Bottom Nav Bar)
- ✅ Feed, Discover, Map, Profile ekranları (placeholder)
- ✅ Tema ve stil (pastel mavi)
- ✅ i18n yapısı hazır

## 🚀 Sonraki Adımlar

1. **Backend GraphQL server'ı çalıştırın**
   - Resolver'ları implement edin
   - Database migration'ları uygulayın

2. **Authentication entegrasyonu**
   - Login mutation implement et
   - Signup mutation implement et
   - Token storage entegrasyonu

3. **Feature ekranlarını tamamlayın**
   - Feed screen
   - Discover screen
   - Map screen
   - Profile screen

## 💡 Not

TODO'lar şu an için **kritik değil**. Uygulama çalışıyor ve test edilebilir durumda. Backend hazır oldukça bu özellikler adım adım eklenecek.

