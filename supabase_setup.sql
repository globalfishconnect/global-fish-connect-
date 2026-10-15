-- Global Fish Connect (GFC) — RLS and Storage setup
-- Review before running. This recreates the named GFC policies below.
-- Run in Supabase Dashboard > SQL Editor using the project owner/admin role.
-- NEVER grant browser users access to auth.users. NEVER put service_role/secret keys in frontend code.

-- 1) Enable Row Level Security
alter table public.profiles enable row level security;
alter table public.listings enable row level security;
alter table public.admin_users enable row level security;

-- 2) Admin list: a signed-in user can see their own admin membership only.
drop policy if exists "Admins can read admin list" on public.admin_users;
create policy "Admins can read admin list"
  on public.admin_users for select to authenticated
  using (user_id = (select auth.uid()));

-- 3) Listings: only approved listings are public; sellers can read their own rows;
-- admins can review all rows and update status; sellers may only submit pending rows.
drop policy if exists "Anyone can view approved listings" on public.listings;
create policy "Anyone can view approved listings"
  on public.listings for select to anon, authenticated
  using (status = 'approved');

drop policy if exists "Sellers can view own listings" on public.listings;
create policy "Sellers can view own listings"
  on public.listings for select to authenticated
  using (seller_id = (select auth.uid()));

drop policy if exists "Admins can view all listings" on public.listings;
create policy "Admins can view all listings"
  on public.listings for select to authenticated
  using (exists (select 1 from public.admin_users a where a.user_id = (select auth.uid())));

drop policy if exists "Users can submit pending listings" on public.listings;
create policy "Users can submit pending listings"
  on public.listings for insert to authenticated
  with check (seller_id = (select auth.uid()) and status = 'pending');

drop policy if exists "Admins can update listings" on public.listings;
create policy "Admins can update listings"
  on public.listings for update to authenticated
  using (exists (select 1 from public.admin_users a where a.user_id = (select auth.uid())))
  with check (exists (select 1 from public.admin_users a where a.user_id = (select auth.uid())));

-- 4) Profiles: users can manage their own profile. Public marketplace visitors can
-- read ONLY profiles that explicitly opt in to public contact details.
drop policy if exists "Users can insert own profile" on public.profiles;
create policy "Users can insert own profile"
  on public.profiles for insert to authenticated
  with check (id = (select auth.uid()));

drop policy if exists "Users can read own profile" on public.profiles;
create policy "Users can read own profile"
  on public.profiles for select to authenticated
  using (id = (select auth.uid()));

drop policy if exists "Users can update own profile" on public.profiles;
create policy "Users can update own profile"
  on public.profiles for update to authenticated
  using (id = (select auth.uid()))
  with check (id = (select auth.uid()));

drop policy if exists "Public can view contactable profiles" on public.profiles;
create policy "Public can view contactable profiles"
  on public.profiles for select to anon, authenticated
  using (contact_public = true);

-- 5) Add the known admin account and profile if they do not already exist.
-- The account must already exist in Supabase Authentication.
insert into public.admin_users (user_id)
select id from auth.users where email = 'globalfishconnect@gmail.com'
on conflict (user_id) do nothing;

insert into public.profiles (id, display_name, country, business_type, email, contact_public)
select id, 'Global Fish Connect Admin', 'Somaliland', 'other', email, false
from auth.users where email = 'globalfishconnect@gmail.com'
on conflict (id) do nothing;

-- 6) Storage policy for the existing public bucket `Fish-images`.
-- Public buckets allow public image viewing; this policy restricts uploads to each
-- signed-in user's own folder, e.g. <auth.uid()>/<filename>. Do not allow anon uploads.
drop policy if exists "GFC users upload to own folder" on storage.objects;
create policy "GFC users upload to own folder"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'Fish-images'
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );

-- Optional verification queries:
-- select id,email from auth.users where email='globalfishconnect@gmail.com';
-- select user_id from public.admin_users;
-- select status,count(*) from public.listings group by status;
