# Publish Global Fish Connect from your Android phone

## A. Upload the files to GitHub
1. Download `Global_Fish_Connect_Complete.zip` from this ChatGPT conversation and extract it with your phone's Files app.
2. Open your repository on GitHub in Chrome.
3. Tap **Add file → Upload files**.
4. Select the files inside the extracted `Global_Fish_Connect` folder. Upload the files themselves into the repository root; do not upload only the ZIP and do not put them in a nested folder.
5. Scroll down and tap **Commit changes**.

Files to upload: `index.html`, `styles.css`, `app.js`, `config.js`, `supabase_setup.sql`, `README.md`, `manifest.webmanifest`, `icon.svg`, and `sw.js` (you may also upload this guide).

## B. Add the public Supabase key
1. In the repository, open `config.js` and tap the pencil/edit icon.
2. In Supabase Dashboard, open Project Settings → API Keys (wording may differ by dashboard version).
3. Copy only the **publishable** key, or the legacy **anon** key. Do not copy the `service_role` or `secret` key.
4. Replace the placeholder string in `SUPABASE_PUBLIC_KEY` and commit the change.

## C. Apply and verify database policies
1. Open Supabase → SQL Editor.
2. Read `supabase_setup.sql` first, then paste/run it with the project owner role.
3. If it reports a policy/table/column error, stop and share the exact error message; do not grant access to `auth.users` to fix it.
4. In Storage, verify the bucket is exactly `Fish-images`. It should allow public reads only because listing photos are meant to be public. Uploads must be restricted to signed-in users' own UID folder.

## D. Publish the website
1. On GitHub repository, open **Settings → Pages**.
2. Select **Deploy from a branch**, branch `main`, folder `/(root)`, and Save.
3. Wait for the published URL, then open it.
4. Test in this order: homepage loads; language toggle works; signup; email confirmation if enabled; sign in; submit a listing; upload an image; sign in as admin; approve the listing; verify it appears in public marketplace.

## Troubleshooting
- “Setup required” means the publishable/anon key is still a placeholder in `config.js`.
- If signup works but no session appears, check the email confirmation message and confirm the account.
- If listing insert fails, check the `Users can submit pending listings` policy and table constraints.
- If photo upload fails, check Storage bucket name, image size/type, and the `GFC users upload to own folder` policy.
- If admin tools are missing, check that `globalfishconnect@gmail.com` is an Auth user and its UUID exists in `public.admin_users`.
