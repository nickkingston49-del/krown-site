/* ============================================================
   Krown Website + CRM — Supabase configuration
   ------------------------------------------------------------
   Both index.html (the lead form) and crm.html (your dashboard)
   read these values to talk to your Supabase backend.

   The publishable key below is SAFE to sit in public website
   code: Row Level Security in your database decides who can do
   what (the public can only drop off leads; only you, logged in,
   can read them).

   NEVER put the service_role / "secret" key in this file.
   ============================================================ */

window.KROWN_CONFIG = {
  // Supabase  ->  Project URL
  SUPABASE_URL: "https://dowuilwpulaemjqrlnwz.supabase.co",

  // Supabase  ->  Settings  ->  API Keys  ->  Publishable key
  // (browser-safe because Row Level Security is enabled)
  SUPABASE_ANON_KEY: "sb_publishable_AYehP1dFj0O6zdQelAjJcA_1XM2VXTf",

  // Safety net: if Supabase is ever unreachable, the form opens the
  // visitor's email app addressed here so no lead is ever lost.
  FALLBACK_EMAIL: "nickkingston49@gmail.com"
};

/* Flag the site checks before contacting Supabase.
   True only when both values above are actually filled in. */
window.KROWN_READY = Boolean(
  window.KROWN_CONFIG.SUPABASE_URL &&
  window.KROWN_CONFIG.SUPABASE_ANON_KEY &&
  !/YOUR-|paste/i.test(window.KROWN_CONFIG.SUPABASE_URL) &&
  !/YOUR-|paste/i.test(window.KROWN_CONFIG.SUPABASE_ANON_KEY)
);
