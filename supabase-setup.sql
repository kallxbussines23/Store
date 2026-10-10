-- MAISON MARKET — Supabase setup
-- Run this whole script in Supabase Dashboard > SQL Editor.
-- Admin email is intentionally restricted to adamradit01@gmail.com.
-- Never put a Supabase service_role key in frontend code.

create extension if not exists pgcrypto;

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 1 and 120),
  description text,
  category text,
  price numeric(14,2) check (price is null or price >= 0),
  destination_url text not null check (destination_url ~* '^https?://'),
  images text[] not null default '{}',
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.products enable row level security;

drop policy if exists "Anyone can view published products" on public.products;
create policy "Anyone can view published products"
on public.products for select
to anon, authenticated
using (is_published = true or (auth.jwt() ->> 'email') = 'adamradit01@gmail.com');

drop policy if exists "Admin can add products" on public.products;
create policy "Admin can add products"
on public.products for insert to authenticated
with check ((auth.jwt() ->> 'email') = 'adamradit01@gmail.com');

drop policy if exists "Admin can update products" on public.products;
create policy "Admin can update products"
on public.products for update to authenticated
using ((auth.jwt() ->> 'email') = 'adamradit01@gmail.com')
with check ((auth.jwt() ->> 'email') = 'adamradit01@gmail.com');

drop policy if exists "Admin can delete products" on public.products;
create policy "Admin can delete products"
on public.products for delete to authenticated
using ((auth.jwt() ->> 'email') = 'adamradit01@gmail.com');

-- Public image bucket: visitors can view images; only the admin email can upload/delete.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('product-images', 'product-images', true, 5242880, array['image/jpeg','image/png','image/webp','image/avif'])
on conflict (id) do update set public = true, file_size_limit = 5242880,
  allowed_mime_types = array['image/jpeg','image/png','image/webp','image/avif'];

drop policy if exists "Anyone can view product images" on storage.objects;
create policy "Anyone can view product images"
on storage.objects for select to anon, authenticated
using (bucket_id = 'product-images');

drop policy if exists "Admin can upload product images" on storage.objects;
create policy "Admin can upload product images"
on storage.objects for insert to authenticated
with check (bucket_id = 'product-images' and (auth.jwt() ->> 'email') = 'adamradit01@gmail.com');

drop policy if exists "Admin can update product images" on storage.objects;
create policy "Admin can update product images"
on storage.objects for update to authenticated
using (bucket_id = 'product-images' and (auth.jwt() ->> 'email') = 'adamradit01@gmail.com')
with check (bucket_id = 'product-images' and (auth.jwt() ->> 'email') = 'adamradit01@gmail.com');

drop policy if exists "Admin can delete product images" on storage.objects;
create policy "Admin can delete product images"
on storage.objects for delete to authenticated
using (bucket_id = 'product-images' and (auth.jwt() ->> 'email') = 'adamradit01@gmail.com');

grant select, insert, update, delete on public.products to authenticated;
grant select on public.products to anon;
