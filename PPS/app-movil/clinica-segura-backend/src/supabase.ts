import { createClient, type SupabaseClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config();

let client: SupabaseClient | null = null;

export const getSupabase = (): SupabaseClient => {
  if (client) return client;

  const supabaseUrl = process.env.SUPABASE_URL;
  const supabaseKey = process.env.SUPABASE_KEY;

  if (!supabaseUrl) {
    throw new Error('Falta SUPABASE_URL en variables de entorno');
  }

  if (!supabaseKey) {
    throw new Error('Falta SUPABASE_KEY en variables de entorno');
  }

  client = createClient(supabaseUrl, supabaseKey);
  return client;
};
