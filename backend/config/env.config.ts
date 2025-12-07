// Environment configuration for Supabase backend

export const config = {
  supabase: {
    url: process.env.SUPABASE_URL || 'https://lsyzkkfardbfkbpncogn.supabase.co',
    anonKey: process.env.SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxzeXpra2ZhcmRiZmticG5jb2duIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUwNjYxMzEsImV4cCI6MjA4MDY0MjEzMX0.Tq-CiP4cyYFSup9Ze96qY_erbIKA1MGjagVXOUpQEh0',
    serviceRoleKey: process.env.SUPABASE_SERVICE_ROLE_KEY || '',
  },
  jwt: {
    secret: process.env.JWT_SECRET || 'your-jwt-secret-change-in-production',
    expiresIn: process.env.JWT_EXPIRES_IN || '1h',
    refreshExpiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '7d',
  },
  r2: {
    accountId: process.env.R2_ACCOUNT_ID || '',
    accessKeyId: process.env.R2_ACCESS_KEY_ID || '',
    secretAccessKey: process.env.R2_SECRET_ACCESS_KEY || '',
    bucket: process.env.R2_BUCKET || 'therapistsocial-images',
    publicUrl: process.env.R2_PUBLIC_URL || '',
  },
  mapbox: {
    accessToken: process.env.MAPBOX_ACCESS_TOKEN || 'pk.eyJ1IjoiaG11aW4iLCJhIjoiY21pdjFiM3R2MGgzMnpmcXZ4Yzlwb2NoZiJ9.HLl104cLoN24GRoC2we4oQ',
  },
  redis: {
    url: process.env.REDIS_URL || '',
  },
  port: process.env.PORT || 4000,
  nodeEnv: process.env.NODE_ENV || 'development',
};

