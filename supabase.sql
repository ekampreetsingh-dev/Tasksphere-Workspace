-- TaskSphere profile storage: run this in Supabase SQL Editor.
-- The browser uses only the public anon key. RLS limits every row to its owner.
create table if not exists public.tasksphere_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  constraint tasksphere_payload_is_object check (jsonb_typeof(payload) = 'object')
);

alter table public.tasksphere_profiles enable row level security;
alter table public.tasksphere_profiles force row level security;

drop policy if exists "Owners can read their TaskSphere profile" on public.tasksphere_profiles;
create policy "Owners can read their TaskSphere profile"
  on public.tasksphere_profiles for select to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "Owners can create their TaskSphere profile" on public.tasksphere_profiles;
create policy "Owners can create their TaskSphere profile"
  on public.tasksphere_profiles for insert to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists "Owners can update their TaskSphere profile" on public.tasksphere_profiles;
create policy "Owners can update their TaskSphere profile"
  on public.tasksphere_profiles for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

revoke all on public.tasksphere_profiles from anon;
grant select, insert, update on public.tasksphere_profiles to authenticated;

-- Keep updated_at server controlled for direct table writes.
create or replace function public.tasksphere_set_updated_at()
returns trigger language plpgsql set search_path = '' as $$
begin
  new.updated_at = now();
  return new;
end;
$$;
drop trigger if exists tasksphere_profiles_updated_at on public.tasksphere_profiles;
create trigger tasksphere_profiles_updated_at
  before update on public.tasksphere_profiles
  for each row execute function public.tasksphere_set_updated_at();
