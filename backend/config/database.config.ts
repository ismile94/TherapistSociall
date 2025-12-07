// Database configuration using Supabase

import { createClient } from '@supabase/supabase-js';
import { config } from './env.config';

export const supabase = createClient(
  config.supabase.url,
  config.supabase.serviceRoleKey || config.supabase.anonKey
);

// Direct PostgreSQL connection for complex queries
export const getDbConnection = () => {
  // Use Supabase's PostgREST API or direct connection
  return supabase;
};

// Helper for raw SQL queries via Supabase
export const executeSql = async (query: string, params: any[] = []) => {
  const { data, error } = await supabase.rpc('execute_sql', {
    query_text: query,
    params: params,
  });
  
  if (error) {
    throw new Error(`SQL Error: ${error.message}`);
  }
  
  return data;
};

