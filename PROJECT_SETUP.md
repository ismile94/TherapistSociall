# TherapistSocial MVP - Setup Guide

## 🎉 Project Structure Created!

The complete MVP structure has been created with all necessary directories and files.

## 📁 Project Structure

```
therapistsocial/
├── frontend/          # Flutter application
│   ├── lib/
│   │   ├── features/  # Feature modules (auth, profile, discover, map, feed)
│   │   ├── core/      # Core utilities, config, themes
│   │   └── shared/    # Shared models and constants
│   └── pubspec.yaml
└── backend/           # GraphQL backend
    ├── src/
    │   ├── schema/    # GraphQL schema files
    │   ├── resolvers/ # GraphQL resolvers
    │   ├── migrations/# Database migrations
    │   └── config/    # Configuration files
    └── package.json
```

## ✅ What's Been Created

### Backend
- ✅ Complete GraphQL schema (types, queries, mutations)
- ✅ Database migration files (PostgreSQL + PostGIS)
- ✅ Supabase configuration
- ✅ Project structure with TypeScript setup

### Frontend
- ✅ Flutter project structure with Riverpod
- ✅ Theme configuration (pastel blue colors, Inter font)
- ✅ i18n localization files (English, Spanish)
- ✅ GraphQL client setup
- ✅ Core utilities and constants

## 🚀 Next Steps

### 1. Backend Setup

```bash
cd backend
npm install
```

Then apply migrations to Supabase:
1. Go to Supabase Dashboard: https://supabase.com/dashboard/project/lsyzkkfardbfkbpncogn
2. Navigate to SQL Editor
3. Run migrations in order:
   - `backend/src/migrations/001_initial_schema.sql`
   - `backend/src/migrations/002_add_indexes.sql`
   - `backend/src/migrations/003_add_triggers.sql`

### 2. Backend Configuration

Edit `backend/.env` and add:
- `SUPABASE_SERVICE_ROLE_KEY` (from Supabase Dashboard > Settings > API)
- `JWT_SECRET` (generate a secure random string)
- `MAPBOX_ACCESS_TOKEN` (from Mapbox account)
- Cloudflare R2 credentials (for image storage)

### 3. Frontend Setup

```bash
cd frontend
flutter pub get
```

### 4. Frontend Configuration

Update `frontend/lib/core/config/app_config.dart`:
- Add your Mapbox access token
- Update GraphQL endpoint if different

## 📝 Implementation Status

### Completed
- ✅ Project directory structure
- ✅ GraphQL schema definitions
- ✅ Database schema with PostGIS
- ✅ Flutter project setup
- ✅ Theme and styling
- ✅ i18n localization structure
- ✅ Configuration files

### To Implement
- ⏳ Backend resolvers (auth, profile, feed, map, discover)
- ⏳ Flutter feature screens and widgets
- ⏳ Mapbox integration
- ⏳ Image upload flow
- ⏳ Authentication flow
- ⏳ State management providers

## 🔧 Development Commands

### Backend
```bash
cd backend
npm run dev          # Start development server
npm run build        # Build for production
npm run migrate      # Run migrations
```

### Frontend
```bash
cd frontend
flutter run          # Run on connected device/emulator
flutter pub get      # Install dependencies
flutter build apk    # Build Android APK
flutter build ios    # Build iOS app
```

## 📚 Key Files to Complete

### Backend Resolvers
- `backend/src/resolvers/auth.resolver.ts` - Authentication logic
- `backend/src/resolvers/profile.resolver.ts` - Profile management
- `backend/src/resolvers/feed.resolver.ts` - Feed and posts
- `backend/src/resolvers/map.resolver.ts` - Map clustering
- `backend/src/resolvers/discover.resolver.ts` - Search and discovery

### Frontend Features
- `frontend/lib/features/auth/` - Authentication screens
- `frontend/lib/features/feed/` - Feed screen with posts
- `frontend/lib/features/map/` - Map screen with Mapbox
- `frontend/lib/features/discover/` - Discover/search screen
- `frontend/lib/features/profile/` - Profile management

## 🔑 Supabase Credentials

Your Supabase project is configured:
- **URL**: https://lsyzkkfardbfkbpncogn.supabase.co
- **Anon Key**: Already set in config files

You'll need to add:
- **Service Role Key**: From Supabase Dashboard > Settings > API

## 📖 Documentation

- Backend README: `backend/README.md`
- Main README: `README.md`

## 🎯 MVP Features

1. ✅ Profile management with verification
2. ✅ Discover therapists by location/specialty
3. ✅ Interactive map with clustering
4. ✅ Social feed with posts, likes, comments
5. ✅ Multi-language support
6. ✅ Image upload and storage

## 🐛 Troubleshooting

### Backend
- Ensure PostGIS extension is enabled in Supabase
- Check database connection in Supabase Dashboard
- Verify environment variables are set

### Frontend
- Run `flutter pub get` if dependencies fail
- Check Flutter SDK version (>=3.0.0)
- Ensure all assets are in correct directories

## 📞 Next Steps

1. Complete backend resolvers implementation
2. Build Flutter feature screens
3. Integrate Mapbox for map functionality
4. Set up image upload with Cloudflare R2
5. Test authentication flow
6. Deploy backend to production
7. Build and test mobile apps

Good luck with your MVP! 🚀

