# Backend Setup ve Kontrol Rehberi

## 1. Backend'i Başlatma

Backend klasörüne gidin ve başlatın:

```bash
cd backend
npm install  # İlk kez çalıştırıyorsanız
npm run dev
```

Backend başarıyla başladığında şu mesajı görmelisiniz:
```
🚀 Server ready at http://localhost:4000/graphql
```

## 2. Backend'in Çalıştığını Kontrol Etme

### Tarayıcıdan Kontrol:
1. Tarayıcınızda şu adresi açın: `http://localhost:4000/graphql`
2. GraphQL Playground açılmalı (development modunda)

### Terminal'den Kontrol:
```bash
# Windows PowerShell
curl http://localhost:4000/graphql

# Veya tarayıcıda açın
start http://localhost:4000/graphql
```

## 3. Android Emülatör için Özel Ayarlar

Android emülatör kullanıyorsanız, `localhost` yerine `10.0.2.2` kullanılmalı. 
Bu zaten `AppConfig`'de otomatik olarak ayarlanmış durumda.

### Fiziksel Android Cihaz Kullanıyorsanız:

1. Bilgisayarınızın IP adresini öğrenin:
   ```bash
   # Windows
   ipconfig
   
   # Mac/Linux
   ifconfig
   ```

2. `AppConfig`'de IP adresini güncelleyin:
   ```dart
   // frontend/lib/core/config/app_config.dart
   static String get graphqlEndpoint {
     if (Platform.isAndroid) {
       // Fiziksel cihaz için bilgisayarınızın IP'sini kullanın
       return 'http://192.168.1.XXX:4000/graphql'; // XXX yerine IP'nizi yazın
     }
     return 'http://localhost:4000/graphql';
   }
   ```

3. Backend'in CORS ayarlarını kontrol edin (zaten `*` olarak ayarlı)

## 4. Sorun Giderme

### Backend başlamıyorsa:
- Node.js yüklü mü kontrol edin: `node --version`
- Port 4000 kullanımda mı kontrol edin
- `backend` klasöründe `npm install` çalıştırın

### "Connection refused" hatası alıyorsanız:
- Backend'in çalıştığından emin olun
- Firewall'ın port 4000'i engellemediğinden emin olun
- Android emülatör kullanıyorsanız `10.0.2.2` kullandığınızdan emin olun

### CORS hatası alıyorsanız:
- Backend'de CORS zaten `*` olarak ayarlı (tüm origin'lere izin veriyor)
- Eğer hala sorun varsa, `backend/src/index.ts` dosyasını kontrol edin

## 5. Test Etme

Backend çalıştıktan sonra Flutter uygulamasında signup işlemini deneyin.
Console'da detaylı hata mesajları göreceksiniz.

