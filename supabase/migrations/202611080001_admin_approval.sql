-- LSPD Digital HQ: Super Admin approval workflow
-- Run this once in Supabase SQL Editor for the LSPD Digital HQ project.

alter table public.profiles
  add column if not exists approval_status text not null default 'pending';

alter table public.profiles
  alter column active set default false;

do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conname = 'profiles_approval_status_check'
      and conrelid = 'public.profiles'::regclass
  ) then
    alter table public.profiles
      add constraint profiles_approval_status_check
      check (approval_status in ('pending', 'approved', 'rejected'));
  end if;
end $$;

-- Existing non-super-admin profiles must also wait for explicit approval.
update public.profiles p
set approval_status = 'pending', active = false
where not exists (
  select 1 from public.system_roles r
  where r.user_id = p.id and r.role = 'super_admin'
);

-- Preserve access for the already-designated Super Admin account.
update public.profiles p
set approval_status = 'approved', active = true
where exists (
  select 1 from public.system_roles r
  where r.user_id = p.id and r.role = 'super_admin'
);

-- Super Admin can review the full personnel queue; regular users retain existing visibility rules.
drop policy if exists profiles_super_admin_read_all on public.profiles;
create policy profiles_super_admin_read_all
on public.profiles
for select
to authenticated
using (public.is_super_admin());

-- Approval decisions can only be made by the Super Admin.
create or replace function public.review_personnel_approval(
  p_target_user_id uuid,
  p_decision text
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if auth.uid() is null or not public.is_super_admin() then
    raise exception 'Only the Super Administrator can review personnel approvals';
  end if;

  if p_decision not in ('approved', 'rejected') then
    raise exception 'Decision must be approved or rejected';
  end if;

  update public.profiles
  set approval_status = p_decision,
      active = (p_decision = 'approved'),
      updated_at = now()
  where id = p_target_user_id;

  if not found then
    raise exception 'Personnel profile not found';
  end if;
end;
$$;

revoke all on function public.review_personnel_approval(uuid, text) from public, anon;
grant execute on function public.review_personnel_approval(uuid, text) to authenticated;

-- Keep the Super Admin profile approved even if this script is re-run.
update public.profiles p
set approval_status = 'approved', active = true
where exists (
  select 1 from public.system_roles r
  where r.user_id = p.id and r.role = 'super_admin'
);
