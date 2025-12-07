# 🚀 Vercel Deployment Kılavuzu - TherapistSocial

Bu kılavuz, TherapistSocial uygulamasını Vercel'e deploy etmek için gereken tüm adımları detaylı bir şekilde açıklamaktadır.

## 📋 İçindekiler

1. [Hazırlık](#hazırlık)
2. [Vercel Hesabı Oluşturma](#vercel-hesabı-oluşturma)
3. [GitHub Repository'yi Hazırlama](#github-repositoryyi-hazırlama)
4. [Vercel'de Proje Oluşturma](#vercelde-proje-oluşturma)
5. [Environment Variables Ayarlama](#environment-variables-ayarlama)
6. [Build Ayarlarını Yapılandırma](#build-ayarlarını-yapılandırma)
7. [Deployment](#deployment)
8. [Sorun Giderme](#sorun-giderme)

---

## 🎯 Hazırlık

### 1.1 Gerekli Yazılımlar

Deployment yapmadan önce bilgisayarınızda şunların yüklü olduğundan emin olun:

- ✅ **Git** - Versiyon kontrolü için
- ✅ **Node.js** (v18 veya üzeri) - Backend build için
- ✅ **Flutter SDK** - Frontend web build için
- ✅ **GitHub Hesabı** - Kodunuzu saklamak için

#### Git Kontrolü
```bash
git --version
```
Eğer yüklü değilse: https://git-scm.com/downloads

#### Node.js Kontrolü
```bash
node --version
```
Eğer yüklü değilse veya versiyon düşükse: https://nodejs.org/

#### Flutter Kontrolü
```bash
flutter --version
```
Eğer yüklü değilse: https://flutter.dev/docs/get-started/install

---

## 🔐 Vercel Hesabı Oluşturma

### 2.1 Vercel Hesabı Oluştur

1. **Tarayıcınızı açın** ve şu adrese gidin:
   ```
   https://vercel.com/signup
   ```

2. **"Sign Up"** butonuna tıklayın.

3. **GitHub ile giriş yapın** (önerilen):
   - "Continue with GitHub" butonuna tıklayın
   - GitHub hesabınızla giriş yapın
   - Vercel'in GitHub'a erişim izni vermesini onaylayın
   
   > 💡 **Neden GitHub ile?** Bu sayede Vercel otomatik olarak repository'nizi görebilir ve her push'ta otomatik deploy yapabilir.

4. Eğer email ile kaydolmak istiyorsanız:
   - Email adresinizi girin
   - Şifrenizi oluşturun
   - Email'inizi doğrulayın

5. **Onboarding sırasında** Vercel size bazı sorular sorabilir, bunları geçebilirsiniz (Skip).

✅ **Tamamlandı!** Artık Vercel hesabınız hazır.

---

## 📦 GitHub Repository'yi Hazırlama

### 3.1 Kodunuzu GitHub'a Push Edin

Eğer kodunuz henüz GitHub'da değilse:

#### 3.1.1 GitHub'da Yeni Repository Oluştur

1. **GitHub.com**'a gidin ve giriş yapın.

2. Sağ üstteki **"+"** butonuna tıklayın → **"New repository"** seçin.

3. Repository bilgilerini doldurun:
   - **Repository name**: `TherapistSociall` (veya istediğiniz isim)
   - **Description**: `Professional social platform for verified therapists`
   - **Visibility**: 
     - 🔒 **Private** (önerilen) - Sadece siz görebilirsiniz
     - 🌐 **Public** - Herkes görebilir
   - **⚠️ ÖNEMLİ**: "Initialize this repository with a README" seçeneğini **işaretlemeyin** (çünkü zaten kodunuz var)

4. **"Create repository"** butonuna tıklayın.

#### 3.1.2 Local Kodunuzu GitHub'a Push Edin

**Windows PowerShell'de şu komutları çalıştırın:**

```powershell
# 1. Proje dizinine gidin
cd C:\Projects\TherapistSocial

# 2. Git repository'sinin durumunu kontrol edin
git status

# 3. Eğer henüz git init yapılmadıysa:
git init

# 4. Tüm dosyaları ekleyin
git add .

# 5. Commit yapın
git commit -m "Add Vercel deployment configuration"

# 6. GitHub repository URL'inizi ekleyin (YOUR_USERNAME yerine GitHub kullanıcı adınızı yazın)
git remote add origin https://github.com/YOUR_USERNAME/TherapistSociall.git

# Örnek: git remote add origin https://github.com/ismile94/TherapistSociall.git

# 7. Ana branch'i main olarak ayarlayın (eğer master kullanıyorsanız)
git branch -M main

# 8. GitHub'a push edin
git push -u origin main
```

**⚠️ Dikkat:** Eğer GitHub repository'nizde zaten dosyalar varsa (örn. README), önce pull yapmanız gerekebilir:

```powershell
git pull origin main --allow-unrelated-histories
```

Sonra tekrar push edin.

#### 3.1.3 Push İşlemi Sırasında Kimlik Doğrulama

GitHub, push işlemi sırasında kimlik doğrulama isteyebilir:

**Seçenek 1: Personal Access Token (Önerilen)**

1. GitHub.com → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. "Generate new token" → "Generate new token (classic)"
3. Not: `Vercel Deployment` yazın
4. Expiration: `No expiration` (veya istediğiniz süre)
5. Scope: `repo` seçeneğini işaretleyin
6. "Generate token" butonuna tıklayın
7. **Token'ı kopyalayın** (bir daha gösterilmeyecek!)
8. Push yaparken password yerine bu token'ı kullanın

**Seçenek 2: GitHub CLI**

```powershell
# GitHub CLI'yi yükleyin
winget install --id GitHub.cli

# Giriş yapın
gh auth login

# Push yapın
git push -u origin main
```

✅ **Kontrol:** GitHub repository sayfanızda dosyalarınızı görüyor musunuz? Evet ise başarılı!

---

## 🏗️ Vercel'de Proje Oluşturma

### 4.1 Yeni Proje İçe Aktarma

1. **Vercel Dashboard**'a gidin: https://vercel.com/dashboard

2. **"Add New..."** butonuna tıklayın → **"Project"** seçin

3. **Repository Seçimi:**
   - GitHub ile giriş yaptıysanız, repository listeniz görünecektir
   - **"TherapistSociall"** repository'sini bulun ve **"Import"** butonuna tıklayın
   - Eğer göremiyorsanız:
     - "Adjust GitHub App Permissions" linkine tıklayın
     - Repository'leri seçin ve "Save" yapın
     - Sayfayı yenileyin

4. **Project Configuration** sayfasına geldiğinizde:

   **Framework Preset:** `Other` seçin
   
   **Root Directory:** `.` (nokta) - Root dizinde olduğunu belirtir
   
   **Build Command:** 
   ```
   cd frontend && flutter build web --release
   ```
   
   **Output Directory:**
   ```
   frontend/build/web
   ```
   
   **Install Command:** (Boş bırakabilirsiniz veya)
   ```
   cd backend && npm install && cd ../frontend && flutter pub get
   ```

5. **"Environment Variables"** bölümüne geçmeden önce **"Deploy"** butonuna **ŞİMDİLİK TIKLAMAYIN!** 

   ⚠️ Önce environment variables'ları ayarlamamız gerekiyor.

---

## 🔧 Environment Variables Ayarlama

Environment variables, uygulamanızın production'da çalışması için gereken gizli bilgilerdir (API anahtarları, veritabanı bağlantıları, vb.).

### 5.1 Vercel'de Environment Variables Eklemek

Vercel proje sayfanızda (henüz deploy etmeden önce):

1. **"Environment Variables"** sekmesine tıklayın

2. Aşağıdaki variable'ları **tek tek** ekleyin:

#### 5.1.1 Supabase Configuration

| Key | Value | Açıklama |
|-----|-------|----------|
| `SUPABASE_URL` | `https://lsyzkkfardbfkbpncogn.supabase.co` | Supabase proje URL'iniz |
| `SUPABASE_ANON_KEY` | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxzeXpra2ZhcmRiZmticG5jb2duIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUwNjYxMzEsImV4cCI6MjA4MDY0MjEzMX0.Tq-CiP4cyYFSup9Ze96qY_erbIKA1MGjagVXOUpQEh0` | Supabase anon key |
| `SUPABASE_SERVICE_ROLE_KEY` | `YOUR_SERVICE_ROLE_KEY` | ⚠️ Supabase Dashboard'dan alın |

**Service Role Key Nasıl Alınır:**
1. https://supabase.com/dashboard adresine gidin
2. Projenizi seçin
3. Settings → API
4. "service_role" altındaki "secret" key'i kopyalayın
5. Vercel'e yapıştırın

#### 5.1.2 JWT Configuration

| Key | Value | Açıklama |
|-----|-------|----------|
| `JWT_SECRET` | `your-super-secret-jwt-key-change-this-in-production` | ⚠️ Güçlü bir random string oluşturun |
| `JWT_EXPIRES_IN` | `1h` | Token geçerlilik süresi |
| `JWT_REFRESH_EXPIRES_IN` | `7d` | Refresh token geçerlilik süresi |

**Güçlü JWT Secret Oluşturma (PowerShell):**
```powershell
# 32 karakterlik random string
-join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | ForEach-Object {[char]$_})
```

#### 5.1.3 Cloudflare R2 (Image Storage) - Opsiyonel

Eğer Cloudflare R2 kullanıyorsanız:

| Key | Value | Açıklama |
|-----|-------|----------|
| `R2_ACCOUNT_ID` | `your-account-id` | Cloudflare R2 Account ID |
| `R2_ACCESS_KEY_ID` | `your-access-key-id` | R2 Access Key |
| `R2_SECRET_ACCESS_KEY` | `your-secret-access-key` | R2 Secret Key |
| `R2_BUCKET` | `therapistsocial-images` | R2 Bucket adı |
| `R2_PUBLIC_URL` | `https://your-bucket.r2.dev` | R2 Public URL |

**Eğer R2 kullanmıyorsanız:** Bu variable'ları boş bırakabilirsiniz, uygulama çalışmaya devam eder.

#### 5.1.4 Mapbox Configuration

| Key | Value | Açıklama |
|-----|-------|----------|
| `MAPBOX_ACCESS_TOKEN` | `pk.eyJ1IjoiaG11aW4iLCJhIjoiY21pdjFiM3R2MGgzMnpmcXZ4Yzlwb2NoZiJ9.HLl104cLoN24GRoC2we4oQ` | Mapbox access token |

#### 5.1.5 CORS Configuration

| Key | Value | Açıklama |
|-----|-------|----------|
| `CORS_ORIGIN` | `*` | ⚠️ İlk deploy için `*`, sonra Vercel URL'inizi ekleyin |

**Not:** İlk deploy sonrası CORS_ORIGIN'i şu şekilde güncelleyin:
```
https://your-app-name.vercel.app
```

#### 5.1.6 Node Environment

| Key | Value | Açıklama |
|-----|-------|----------|
| `NODE_ENV` | `production` | Production modu |
| `PORT` | `3000` | Vercel otomatik ayarlar, ama ekleyebilirsiniz |

### 5.2 Environment Variables Ekleme Adımları (Vercel UI'da)

Her variable için:

1. **"Key"** kutusuna variable adını yazın (örn: `SUPABASE_URL`)
2. **"Value"** kutusuna değerini yazın
3. **Environment** seçeneklerini işaretleyin:
   - ✅ **Production**
   - ✅ **Preview** 
   - ✅ **Development** (opsiyonel)
4. **"Add"** butonuna tıklayın

⚠️ **Dikkat:** Her variable'ı ekledikten sonra "Add" butonuna tıklayın, aksi halde kaydedilmez!

✅ **Kontrol:** Tüm variable'ları ekledikten sonra, listede göründüklerinden emin olun.

---

## ⚙️ Build Ayarlarını Yapılandırma

### 6.1 Vercel Build Ayarları

Vercel proje sayfanızda:

1. **Settings** sekmesine gidin (üst menüden)

2. **General** → **Build & Development Settings** bölümüne gidin

3. **Build Command** alanına:
   ```bash
   cd frontend && flutter build web --release
   ```

4. **Output Directory** alanına:
   ```
   frontend/build/web
   ```

5. **Install Command** alanına (opsiyonel):
   ```bash
   cd backend && npm install && cd ../frontend && flutter pub get
   ```

6. **Node.js Version:** `18.x` seçin

7. **Save** butonuna tıklayın

### 6.2 Flutter Web Build İçin Gerekli Ayarlar

Flutter web build yapmak için sisteminizde Flutter'ın web desteği aktif olmalı:

```powershell
# Flutter web desteğini kontrol edin
flutter doctor -v

# Web desteği yüklü değilse:
flutter config --enable-web

# Flutter channel'ı kontrol edin
flutter channel

# Eğer stable değilse:
flutter channel stable
flutter upgrade
```

---

## 🚀 Deployment

### 7.1 İlk Deploy

Tüm ayarları yaptıktan sonra:

1. Vercel proje sayfanızda **"Deploy"** butonuna tıklayın

2. Vercel build işlemini başlatacak. Bu işlem **5-10 dakika** sürebilir (ilk kez).

3. Build sırasında:
   - Backend TypeScript kodları compile edilecek
   - Flutter web build yapılacak
   - Tüm dosyalar Vercel sunucularına yüklenecek

4. Build tamamlandığında:
   - ✅ **"Success"** mesajı göreceksiniz
   - 🌐 **Production URL** otomatik oluşturulacak (örn: `https://therapistsocial-abc123.vercel.app`)

### 7.2 Deployment Sonrası Kontroller

#### 7.2.1 GraphQL Endpoint'i Test Edin

Tarayıcınızda şu URL'e gidin:
```
https://your-app-name.vercel.app/api/graphql
```

Veya GraphQL Playground için:
```
https://your-app-name.vercel.app/api/graphql
```

**Beklenen Sonuç:** GraphQL endpoint çalışıyor olmalı. Eğer hata alıyorsanız, [Sorun Giderme](#sorun-giderme) bölümüne bakın.

#### 7.2.2 Frontend'i Test Edin

Tarayıcınızda ana URL'e gidin:
```
https://your-app-name.vercel.app
```

**Beklenen Sonuç:** Flutter web uygulamanız açılmalı.

#### 7.2.3 CORS Ayarlarını Güncelleyin

İlk deploy'dan sonra, CORS ayarlarını güncelleyin:

1. Vercel Dashboard → **Settings** → **Environment Variables**
2. `CORS_ORIGIN` variable'ını bulun
3. Değerini şu şekilde güncelleyin:
   ```
   https://your-app-name.vercel.app
   ```
4. **"Save"** yapın
5. **"Redeploy"** yapın (Deployments → Latest → "..." → "Redeploy")

### 7.3 Otomatik Deployment (GitHub Integration)

Artık her GitHub'a push yaptığınızda otomatik deploy yapılacak:

```powershell
# Kod değişikliği yaptınız
git add .
git commit -m "Update features"
git push origin main

# Vercel otomatik olarak yeni bir deployment başlatacak!
```

---

## 🐛 Sorun Giderme

### Problem 1: Build Başarısız Oluyor

**Hata:** `flutter: command not found`

**Çözüm:**
- Vercel build ortamında Flutter yüklü değil. Flutter web build'i local'de yapıp sonuçları commit etmemiz gerekiyor.

**Alternatif Çözüm (Önerilen):**

1. Local'de Flutter web build yapın:
```powershell
cd frontend
flutter clean
flutter pub get
flutter build web --release
```

2. Build edilmiş dosyaları commit edin:
```powershell
git add frontend/build/web
git commit -m "Add Flutter web build"
git push origin main
```

3. Vercel build ayarlarını güncelleyin:
   - **Build Command:** `echo "Build already done"`
   - **Output Directory:** `frontend/build/web`

### Problem 2: GraphQL Endpoint Çalışmıyor

**Hata:** `404 Not Found` veya `500 Internal Server Error`

**Kontrol Listesi:**

1. ✅ `backend/api/graphql.ts` dosyası var mı?
2. ✅ `vercel.json` dosyası doğru yapılandırılmış mı?
3. ✅ Environment variables doğru ayarlanmış mı?
4. ✅ `@vercel/node` package backend/package.json'da mı?

**Çözüm:**

Vercel Dashboard → **Deployments** → **Latest** → **"Functions"** sekmesine gidin. Hata loglarını kontrol edin.

### Problem 3: Frontend GraphQL'e Bağlanamıyor

**Hata:** `CORS error` veya `Connection refused`

**Çözüm:**

1. `CORS_ORIGIN` environment variable'ının doğru ayarlandığından emin olun
2. Frontend'de `app_config.dart` dosyasında GraphQL endpoint'in doğru olduğunu kontrol edin
3. Browser console'da (F12) network tab'ını açın ve hataları kontrol edin

### Problem 4: Environment Variables Görünmüyor

**Çözüm:**

1. Vercel Dashboard → **Settings** → **Environment Variables**
2. Her variable'ın doğru environment'larda işaretli olduğunu kontrol edin
3. Değişiklik yaptıktan sonra **mutlaka "Redeploy"** yapın

### Problem 5: Flutter Web Build Çok Büyük

**Çözüm:**

Build'i optimize edin:
```powershell
flutter build web --release --web-renderer html
```

---

## 📱 Custom Domain Ayarlama (Opsiyonel)

Vercel'de custom domain eklemek için:

1. Vercel Dashboard → **Settings** → **Domains**
2. **"Add Domain"** butonuna tıklayın
3. Domain adınızı girin (örn: `therapistsocial.com`)
4. Vercel'in verdiği DNS kayıtlarını domain sağlayıcınızda ayarlayın
5. DNS propagasyon için 24-48 saat bekleyin

---

## ✅ Deployment Checklist

Deployment öncesi kontrol listesi:

- [ ] GitHub repository oluşturuldu ve kod push edildi
- [ ] Vercel hesabı oluşturuldu
- [ ] Vercel'de proje import edildi
- [ ] Tüm environment variables eklendi
- [ ] Build ayarları yapılandırıldı
- [ ] İlk deploy yapıldı
- [ ] GraphQL endpoint test edildi
- [ ] Frontend test edildi
- [ ] CORS ayarları güncellendi
- [ ] Otomatik deployment çalışıyor

---

## 🎉 Tebrikler!

Uygulamanız artık Vercel'de canlıda! 🚀

**Production URL:** `https://your-app-name.vercel.app`

Her GitHub push'unuz otomatik olarak yeni bir deployment başlatacak.

---

## 📞 Yardım

Sorun yaşarsanız:
1. Vercel Dashboard → **Deployments** → Hata loglarını kontrol edin
2. Vercel Community: https://github.com/vercel/vercel/discussions
3. Vercel Docs: https://vercel.com/docs

**Başarılar! 🎊**
