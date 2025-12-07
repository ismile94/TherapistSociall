# ⚡ Hızlı Deployment Başlangıç Kılavuzu

Bu, Vercel'e deploy etmek için **en hızlı yöntem**. Detaylı kılavuz için `VERCEL_DEPLOYMENT.md` dosyasına bakın.

## 🎯 Adım Adım (5 Dakika)

### 1. Kodları GitHub'a Push Edin

```powershell
cd C:\Projects\TherapistSocial
git add .
git commit -m "Add Vercel deployment config"
git push origin main
```

### 2. Vercel'de Proje Oluşturun

1. https://vercel.com/signup adresine gidin
2. GitHub ile giriş yapın
3. "Add New Project" → Repository'nizi seçin → "Import"

### 3. Build Ayarları

- **Framework Preset:** `Other`
- **Root Directory:** `.`
- **Build Command:** `cd frontend && flutter build web --release`
- **Output Directory:** `frontend/build/web`

### 4. Environment Variables Ekleyin

Vercel Dashboard → Settings → Environment Variables → Aşağıdakileri ekleyin:

```
SUPABASE_URL=https://lsyzkkfardbfkbpncogn.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxzeXpra2ZhcmRiZmticG5jb2duIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUwNjYxMzEsImV4cCI6MjA4MDY0MjEzMX0.Tq-CiP4cyYFSup9Ze96qY_erbIKA1MGjagVXOUpQEh0
SUPABASE_SERVICE_ROLE_KEY=YOUR_SERVICE_ROLE_KEY_HERE
JWT_SECRET=your-super-secret-jwt-key-32-chars-long
JWT_EXPIRES_IN=1h
JWT_REFRESH_EXPIRES_IN=7d
MAPBOX_ACCESS_TOKEN=pk.eyJ1IjoiaG11aW4iLCJhIjoiY21pdjFiM3R2MGgzMnpmcXZ4Yzlwb2NoZiJ9.HLl104cLoN24GRoC2we4oQ
CORS_ORIGIN=*
NODE_ENV=production
```

### 5. Deploy!

"Deploy" butonuna tıklayın ve 5-10 dakika bekleyin.

### 6. Test Edin

Deployment tamamlandıktan sonra:
- Frontend: `https://your-app.vercel.app`
- GraphQL: `https://your-app.vercel.app/api/graphql`

---

## ⚠️ Önemli Notlar

1. **Flutter Web Build:** İlk deploy'da Vercel Flutter build edemeyebilir. Bu durumda local'de build yapıp commit edin:
   ```powershell
   cd frontend
   flutter build web --release
   git add frontend/build/web
   git commit -m "Add Flutter web build"
   git push
   ```

2. **Service Role Key:** Supabase Dashboard → Settings → API → Service Role Key'i kopyalayın.

3. **CORS:** İlk deploy sonrası CORS_ORIGIN'i Vercel URL'inizle güncelleyin.

---

**Detaylı kılavuz:** `VERCEL_DEPLOYMENT.md`
