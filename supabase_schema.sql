-- Mapa de Grupos Empresariales Paraguay — schema Supabase
-- Proyecto: Incentiva AI (yigedbrpvvxjmmrpeifr) — tablas nuevas, no tocan las 9 existentes.
-- Ejecutar este archivo completo una sola vez en el SQL Editor de Supabase antes de supabase_seed.sql.

create table if not exists market_groups (
  id bigint generated always as identity primary key,
  name text not null,
  rubro text not null,
  size int,
  empleados text,
  facturacion text,
  liderazgo text,
  nota_rrhh text,
  sort_order int not null,
  created_at timestamptz not null default now()
);

create table if not exists market_companies (
  id bigint generated always as identity primary key,
  group_id bigint not null references market_groups(id) on delete cascade,
  nombre text not null,
  rubro text not null,
  badge text check (badge in ('gptw','topofmind')),
  sort_order int not null
);

create table if not exists market_independent_sections (
  id bigint generated always as identity primary key,
  rubro text not null,
  sort_order int not null
);

create table if not exists market_independent_items (
  id bigint generated always as identity primary key,
  section_id bigint not null references market_independent_sections(id) on delete cascade,
  nombre text not null,
  rubro text,
  nota text,
  badge text check (badge in ('gptw','topofmind')),
  sort_order int not null
);

create table if not exists market_share (
  id bigint generated always as identity primary key,
  rubro text not null,
  grupo_label text not null,
  empresa text not null,
  valor numeric(5,2) not null,
  dato text not null,
  fuente text not null,
  sort_order int not null
);

create table if not exists market_scale (
  id bigint generated always as identity primary key,
  rubro text not null,
  grupo_label text not null,
  empresa text not null,
  dato text not null,
  fuente text not null,
  sort_order int not null
);

create index if not exists idx_market_companies_group on market_companies(group_id);
create index if not exists idx_market_independent_items_section on market_independent_items(section_id);

-- =========================================================================
-- RLS: ACTIVADO en producción (2026-07-08) con políticas de solo lectura.
-- La anon key queda embebida en el HTML público — sin estas políticas esa
-- key podría tener permisos de escritura heredados del schema, así que RLS
-- + policy de solo-select es obligatorio, no opcional, para este proyecto.
-- Statements ya ejecutados (se dejan documentados acá para referencia):
--
-- alter table market_groups enable row level security;
-- alter table market_companies enable row level security;
-- alter table market_independent_sections enable row level security;
-- alter table market_independent_items enable row level security;
-- alter table market_share enable row level security;
-- alter table market_scale enable row level security;
--
-- create policy "public read" on market_groups for select using (true);
-- create policy "public read" on market_companies for select using (true);
-- create policy "public read" on market_independent_sections for select using (true);
-- create policy "public read" on market_independent_items for select using (true);
-- create policy "public read" on market_share for select using (true);
-- create policy "public read" on market_scale for select using (true);
-- =========================================================================
