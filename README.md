# TherapistSocial - Professional Social Platform MVP

A professional social platform for verified therapists to discover each other by location and specialty, and share professional content.

## Tech Stack

- **Frontend**: Flutter (iOS + Android) with Riverpod state management
- **Backend**: GraphQL with Supabase (PostgreSQL + PostGIS)
- **Maps**: Mapbox GL with server-side clustering
- **Storage**: Cloudflare R2 for images
- **Caching**: Redis (via Supabase)
- **i18n**: Multi-language support (EN, ES, FR, DE, PT)

## Project Structure

```
therapistsocial/
├── frontend/          # Flutter application
└── backend/           # GraphQL backend (Supabase Edge Functions)
```

## Getting Started

### Prerequisites

- Flutter SDK (latest stable)
- Node.js 18+
- Supabase CLI
- Mapbox account

### Environment Setup

1. Copy `.env.example` to `.env` and fill in your credentials
2. Run database migrations
3. Start the development server

## Features

- ✅ User authentication (JWT + refresh tokens)
- ✅ Profile management with verification
- ✅ Discover therapists by location and specialty
- ✅ Interactive map with clustering
- ✅ Social feed with posts, likes, comments
- ✅ Multi-language support
- ✅ Offline caching
- ✅ Image upload and storage

## Development

See individual README files in `frontend/` and `backend/` directories.

