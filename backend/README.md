# TherapistSocial Backend

GraphQL backend server for TherapistSocial platform using Supabase.

## Setup

1. Install dependencies:
```bash
npm install
```

2. Copy `.env.example` to `.env` and configure:
- Supabase credentials (already configured)
- JWT secret
- Cloudflare R2 credentials (for image storage)
- Mapbox access token

3. Run database migrations:
```bash
npm run migrate
```

4. Start development server:
```bash
npm run dev
```

## Database Migrations

Migrations are located in `src/migrations/`. To apply them to Supabase:

1. Go to Supabase Dashboard > SQL Editor
2. Copy and paste each migration file in order (001, 002, 003)
3. Execute each migration

Or use Supabase CLI:
```bash
supabase db push
```

## Project Structure

- `src/schema/` - GraphQL schema definitions
- `src/resolvers/` - GraphQL resolvers
- `src/services/` - Business logic services
- `src/migrations/` - Database migrations
- `config/` - Configuration files

## API Endpoint

GraphQL endpoint: `http://localhost:4000/graphql`

