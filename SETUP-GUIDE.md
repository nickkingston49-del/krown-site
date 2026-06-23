# Krown Website + CRM — Setup Guide

You've got three pieces that work as one system:

| File | What it is |
|------|-----------|
| `index.html` | Your homepage (SEO + lead form) |
| `gallery.html` | Project gallery |
| `crm.html` | Your private lead dashboard |
| `assets/` | Logo, photos, styles, config |
| `supabase-setup.sql` | One-time database setup |

The website form and the CRM both talk to **one backend: Supabase**. The form writes a lead in; the CRM reads it out. That's the whole loop — no separate tools to stitch together.

---

## The big picture (why it's built this way)

A static site has no server to catch a form submission, so the form has to send the lead *somewhere*. Supabase is that somewhere: it's a hosted database + login system + auto-built API, all in one. The site writes a row, the CRM reads it, and **Row Level Security** (set up by the SQL file) makes sure the public can only *drop off* leads — never read them. Only you, logged in, can see them.

That's why the anon key is safe to sit in your website code: the database itself enforces who can do what.

---

## Step 1 — Create your Supabase project (free)

1. Go to **supabase.com** → sign up → **New Project**.
2. Name it `krown`, set a strong database password (save it), pick the closest region (US East/Central).
3. Wait ~2 minutes for it to spin up.

## Step 2 — Build the leads table

1. In Supabase, open **SQL Editor** → **New query**.
2. Open `supabase-setup.sql`, copy everything, paste it in, hit **Run**.
3. You should see "Success." That created your `leads` table and locked it down.

## Step 3 — Create your login

1. Go to **Authentication** → **Users** → **Add user** → **Create new user**.
2. Enter your email + a password. **Check "Auto Confirm User"** so you can log in right away.
3. These are the credentials you'll use to sign into `crm.html`.

## Step 4 — Connect the files

1. In Supabase, go to **Settings** → **API**. You'll see two things you need:
   - **Project URL** (looks like `https://abcdxyz.supabase.co`)
   - **Project API keys → `anon` `public`** (a long string)
2. Open `assets/config.js` and paste them in:
   ```js
   SUPABASE_URL: "https://abcdxyz.supabase.co",
   SUPABASE_ANON_KEY: "paste-the-anon-public-key",
   ```
3. Save. **Do not** use the `service_role` key here — that one's a master key and never goes in the browser.

That's it. The form now writes to your database, and the CRM reads from it.

---

## Step 5 — Put it online

The whole thing is plain HTML, so it hosts anywhere. Easiest free option that fits your domain:

**GitHub Pages**
1. Create a free GitHub account → new repository (e.g. `krown-site`).
2. Upload the whole `krown` folder contents (keep the `assets` folder structure intact).
3. Repo **Settings** → **Pages** → Source: `main` branch, `/root`. Save.
4. Under the custom domain box, enter `www.krownconstruction.net` and follow the DNS instructions (you'll add a CNAME record at whoever manages your domain).
5. Once DNS points over, your new site replaces the old one at the same address.

> Until DNS is switched, you can test on the free `username.github.io` URL GitHub gives you.

**Your CRM** lives at `www.krownconstruction.net/crm.html` — it's hidden from Google (blocked in `robots.txt` and tagged `noindex`). Bookmark it. Anyone who finds the URL still can't see a thing without your login.

---

## Step 6 — Test the loop

1. Open your live homepage, scroll to the form, submit a fake lead.
2. Open `/crm.html`, log in — your fake lead should be sitting in the **New** column.
3. Drag it to **Contacted**, open **Details**, add a note, save. Delete it when you're done.

---

## A few things to set before you lean on it

- **Real review numbers.** In `index.html`, find the JSON-LD block tagged `_comment_ratings`. Replace `ratingValue` and `reviewCount` with your **actual Google numbers**. Google can penalize made-up review stars, so put the truth there.
- **Fallback email.** In `config.js`, `FALLBACK_EMAIL` is only used if Supabase ever isn't reachable — set it to your real inbox as a safety net.
- **Get pinged on new leads (optional, recommended).** In Supabase you can add a **Database Webhook** or **Edge Function** on the `leads` table that texts or emails you the moment a lead comes in, so you're not refreshing the CRM all day. Tell me when you're ready and I'll wire it up.

---

## What's strong here for SEO + conversions

- Local-business structured data (`RoofingContractor` schema) with your service area, hours, and services — this is what gets you into Google's local pack and rich results.
- One clear `<h1>` per page, real alt text on every photo, fast-loading local images, mobile-first layout, and a sticky **Call / Free Estimate** bar on phones.
- Title tags and descriptions written around how people actually search ("roofing nederland tx," "beaumont roof repair").
- `sitemap.xml` + `robots.txt` so Google indexes the right pages and skips your CRM.

## Where to push next (when you want)

- **Per-service pages** (one for roofing, one for remodeling, etc.) — each ranks for its own keyword and pulls in more local traffic. Biggest SEO lever left.
- A **storm-damage landing page** tied to your existing flyer/social campaign.
- Lead notifications by text (above).

Holler when you want any of those built.
