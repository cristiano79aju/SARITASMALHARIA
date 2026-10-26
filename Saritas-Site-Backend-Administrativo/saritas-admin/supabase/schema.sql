-- Execute este SQL no SQL Editor do Supabase.
create table if not exists public.site_settings (
  id integer primary key default 1 check (id = 1),
  brand_name text not null default 'SARITAS',
  brand_subtitle text not null default 'MALHARIA & BORDADOS',
  hero_title text not null default 'UNIFORMES COM SEU ESTILO.',
  hero_description text not null default 'Escolha o modelo, tamanho e personalização. Monte seu pedido e fale com a Saritas.',
  whatsapp text not null default '68996140548',
  instagram text not null default 'https://www.instagram.com/saritas_malharia_e_bordados/',
  logo_url text,
  updated_at timestamptz not null default now()
);
insert into public.site_settings (id) values (1) on conflict (id) do nothing;

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category text not null default 'jalecos',
  description text not null default '',
  image_url text not null default '',
  active boolean not null default true,
  sort_order integer not null default 100,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.site_settings enable row level security;
alter table public.products enable row level security;
alter table public.admin_users enable row level security;

drop policy if exists "Public can read settings" on public.site_settings;
create policy "Public can read settings" on public.site_settings for select using (true);
drop policy if exists "Admins can update settings" on public.site_settings;
create policy "Admins can update settings" on public.site_settings for update to authenticated using (exists(select 1 from public.admin_users a where a.user_id = auth.uid())) with check (exists(select 1 from public.admin_users a where a.user_id = auth.uid()));
drop policy if exists "Admins can insert settings" on public.site_settings;
create policy "Admins can insert settings" on public.site_settings for insert to authenticated with check (exists(select 1 from public.admin_users a where a.user_id = auth.uid()));

drop policy if exists "Public can read active products" on public.products;
create policy "Public can read active products" on public.products for select using (active = true or exists(select 1 from public.admin_users a where a.user_id = auth.uid()));
drop policy if exists "Admins can insert products" on public.products;
create policy "Admins can insert products" on public.products for insert to authenticated with check (exists(select 1 from public.admin_users a where a.user_id = auth.uid()));
drop policy if exists "Admins can update products" on public.products;
create policy "Admins can update products" on public.products for update to authenticated using (exists(select 1 from public.admin_users a where a.user_id = auth.uid())) with check (exists(select 1 from public.admin_users a where a.user_id = auth.uid()));
drop policy if exists "Admins can delete products" on public.products;
create policy "Admins can delete products" on public.products for delete to authenticated using (exists(select 1 from public.admin_users a where a.user_id = auth.uid()));

drop policy if exists "Admin can view own admin row" on public.admin_users;
create policy "Admin can view own admin row" on public.admin_users for select to authenticated using (user_id = auth.uid());

-- Bucket publico para imagens dos produtos e logo.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('saritas-media', 'saritas-media', true, 10485760, array['image/jpeg','image/png','image/webp','image/gif','image/svg+xml'])
on conflict (id) do nothing;

drop policy if exists "Public can view Saritas media" on storage.objects;
create policy "Public can view Saritas media" on storage.objects for select using (bucket_id = 'saritas-media');
drop policy if exists "Admins can upload Saritas media" on storage.objects;
create policy "Admins can upload Saritas media" on storage.objects for insert to authenticated with check (bucket_id = 'saritas-media' and exists(select 1 from public.admin_users a where a.user_id = auth.uid()));
drop policy if exists "Admins can update Saritas media" on storage.objects;
create policy "Admins can update Saritas media" on storage.objects for update to authenticated using (bucket_id = 'saritas-media' and exists(select 1 from public.admin_users a where a.user_id = auth.uid())) with check (bucket_id = 'saritas-media' and exists(select 1 from public.admin_users a where a.user_id = auth.uid()));
drop policy if exists "Admins can delete Saritas media" on storage.objects;
create policy "Admins can delete Saritas media" on storage.objects for delete to authenticated using (bucket_id = 'saritas-media' and exists(select 1 from public.admin_users a where a.user_id = auth.uid()));
