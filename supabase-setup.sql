-- ============================================================
--  KROWN CRM — Supabase database setup
--  Run this ONCE in: Supabase dashboard → SQL Editor → New query
--  Then click "Run". It creates the leads table and locks it down
--  with Row Level Security (RLS).
-- ============================================================

-- 1) The table every website inquiry and phone-in lands in.
create table if not exists public.leads (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  name        text not null,
  phone       text not null,
  email       text,
  service     text,
  city        text,
  message     text,
  notes       text,                          -- your private follow-up notes
  status      text not null default 'New',   -- New | Contacted | Quoted | Won | Lost
  source      text default 'website'         -- website | phone
);

-- Helpful index for sorting newest-first.
create index if not exists leads_created_idx on public.leads (created_at desc);

-- 2) Turn ON Row Level Security.
--    WHY: with RLS on, the table is "deny by default" — nobody can
--    touch a row unless a policy below explicitly allows it. This is
--    what makes it safe to put the public anon key in your website.
alter table public.leads enable row level security;

-- 3) THE PUBLIC DOOR — anonymous visitors may ONLY insert (submit the form).
--    They cannot read, edit, or delete anything.
drop policy if exists "public can submit leads" on public.leads;
create policy "public can submit leads"
  on public.leads for insert
  to anon
  with check (true);

-- 4) THE OWNER DOORS — only signed-in users (you) can read/edit/delete.
drop policy if exists "authed can read leads"   on public.leads;
drop policy if exists "authed can update leads" on public.leads;
drop policy if exists "authed can delete leads" on public.leads;

create policy "authed can read leads"
  on public.leads for select to authenticated using (true);

create policy "authed can update leads"
  on public.leads for update to authenticated using (true) with check (true);

create policy "authed can delete leads"
  on public.leads for delete to authenticated using (true);

-- 5) Let the CRM receive realtime updates (new leads pop in live).
alter publication supabase_realtime add table public.leads;

-- ============================================================
--  DONE. Next:
--   • Create your login: Authentication → Users → Add user
--     (set email + password; you'll use these to sign into crm.html)
--   • Paste your Project URL + anon key into assets/config.js
-- ============================================================
