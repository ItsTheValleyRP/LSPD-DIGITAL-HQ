-- LSPD Digital HQ: administrator account directory access
-- Run this migration in the LSPD Digital HQ Supabase SQL Editor.

-- Lock the Super Administrator identity to the designated owner account.
-- This prevents another account from gaining Super Administrator access
-- merely by inserting a role row.
create or replace function public.is_super_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select auth.uid() = '7d618e2e-7770-4925-a8e2-e01be9783843'::uuid;
$$;

revoke all on function public.is_super_admin() from public, anon;
grant execute on function public.is_super_admin() to authenticated;

-- Administrators may view the full account directory, but this does not
-- grant them Super Administrator powers or permission to change roles.
create or replace function public.can_view_all_personnel()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.system_roles r
    where r.user_id = auth.uid()
      and r.role in ('super_admin', 'administrator')
  );
$$;

revoke all on function public.can_view_all_personnel() from public, anon;
grant execute on function public.can_view_all_personnel() to authenticated;

-- Replace the directory read policy so administrators and the designated
-- Super Admin can see all profile records, including pending/rejected ones.
drop policy if exists profiles_admin_read_all on public.profiles;
create policy profiles_admin_read_all
on public.profiles
for select
to authenticated
using (public.can_view_all_personnel());

-- IMPORTANT:
-- This migration grants directory visibility only to administrators.
-- It does not remove permissions previously granted by other RPC functions.
-- Rank changes, division membership management, approvals, and role changes
-- must continue to be enforced by their own server-side authorization checks.
