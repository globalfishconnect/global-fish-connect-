# Global Fish Connect (GFC)

A responsive bilingual (English/Somali) seafood marketplace MVP. It uses Supabase Auth, Postgres tables (`profiles`, `listings`, `admin_users`) and the public Storage bucket named exactly `Fish-images`.

## Files
- `index.html` — main site, marketplace, signup/signin, seller area and admin review area.
- `styles.css` — responsive ocean-inspired design.
- `app.js` — client-side behaviour and Supabase integration.
- `config.js` — Supabase project URL and **browser-safe publishable/anon key only**.
- `supabase_setup.sql` — RLS policies and admin seed for the known project schema.
- `manifest.webmanifest`, `icon.svg`, `sw.js` — optional installable PWA shell/offline static shell.
- `DEPLOYMENT_GUIDE.md` — mobile-friendly deployment steps.

## Configure Supabase
1. Open `config.js` and replace `PASTE_YOUR_SUPABASE_PUBLISHABLE_OR_ANON_KEY_HERE` with the project's **publishable key** (or legacy anon key). The project URL is already set for the current GFC project.
2. Never paste a `service_role` or `secret` key into this repository, any frontend file, or a public chat.
3. Confirm that the existing `profiles`, `listings`, and `admin_users` columns match the project schema described in `supabase_setup.sql`.
4. Read `supabase_setup.sql` before running it in Supabase SQL Editor. It recreates the named GFC policies, so check for any custom policies you added. It does not grant access to `auth.users` for browser roles.
5. The admin account `globalfishconnect@gmail.com` must already exist in Supabase Authentication before the admin seed statements can add it to `admin_users`.
6. In Supabase Storage, the existing bucket name must be exactly `Fish-images`. Keep it public only if uploaded fish photos are intended for public viewing. The SQL creates an authenticated upload policy limited to the user's own UID folder. In Storage bucket settings, set a 5 MB file limit and allow only JPEG, PNG and WebP if those options are available.
7. In Supabase Authentication settings, decide whether to require email confirmation. If enabled, test using an inbox you can access.

## Deploy with GitHub Pages (Android-friendly)
1. Upload all files in this folder to the **root** of the `global-fish-connect` repository, next to `README.md` (not inside another folder).
2. In GitHub open the repository **Settings → Pages**.
3. Under Build and deployment, choose **Deploy from a branch**, branch `main`, folder `/(root)`, then Save.
4. Wait for the deployment URL shown in Settings → Pages. It will usually resemble `https://globalfishconnect.github.io/global-fish-connect/` if `globalfishconnect` is the exact GitHub username.
5. Open the site URL on your phone and test signup, email confirmation, sign-in, listing submission, photo upload, admin approval and public visibility.

## Important limitations
- This is a functional MVP starter, not a security-audited production marketplace. Test all policies and flows before advertising it publicly.
- Listings are intentionally inserted with `status='pending'`; only an admin can approve them.
- Seller contact details are only displayed when `profiles.contact_public=true` and a phone or WhatsApp number exists.
- Public browser code must only use the publishable/anon key. Security comes from correct RLS and Storage policies, not from hiding that public key.
- The app does not process payments, verify fish quality, manage shipping or resolve disputes.
