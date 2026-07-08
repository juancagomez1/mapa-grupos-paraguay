-- Capa consultable para un futuro copiloto de IA (Incentiva AI) + tablas de
-- propuestas para la automatización semanal. Ejecutar en el SQL Editor de
-- Supabase DESPUÉS de supabase_schema.sql y supabase_seed.sql.
--
-- Todo queda de solo lectura para la anon key (mismo modelo que las tablas
-- ya existentes: RLS activo + policy "public read" + grant explícito, para
-- no repetir el problema de permisos que tuvimos la primera vez).

-- =========================================================================
-- v_all_companies — une empresas de grupos + independientes en una sola
-- tabla consultable. Es el equivalente en SQL de lo que hoy hace allLeaves
-- en el JS del HTML (mapa-grupos-paraguay.html).
-- =========================================================================
create or replace view v_all_companies as
select
  mc.nombre,
  mc.rubro,
  'grupo'::text as source,
  mg.name as grupo,
  null::text as nota,
  mc.badge
from market_companies mc
join market_groups mg on mg.id = mc.group_id
union all
select
  mii.nombre,
  coalesce(mii.rubro, mis.rubro) as rubro,
  'independiente'::text as source,
  null::text as grupo,
  mii.nota,
  mii.badge
from market_independent_items mii
join market_independent_sections mis on mis.id = mii.section_id;

-- =========================================================================
-- get_competitors — dado un nombre de empresa (match parcial, no hace falta
-- el nombre exacto completo), devuelve las demás empresas de su mismo rubro.
-- Es el equivalente de la sección "Compite con" del panel lateral del HTML.
-- =========================================================================
create or replace function get_competitors(p_empresa text)
returns setof v_all_companies
language sql
stable
as $$
  select vac.*
  from v_all_companies vac
  where vac.rubro = (
    select rubro from v_all_companies where nombre ilike '%' || p_empresa || '%' limit 1
  )
  and vac.nombre not ilike '%' || p_empresa || '%';
$$;

-- =========================================================================
-- v_group_alerts — grupos con nota de due diligence (⚠️), pre-filtrados.
-- =========================================================================
create or replace view v_group_alerts as
select id, name, rubro, liderazgo, nota_rrhh
from market_groups
where nota_rrhh ilike '%⚠️%';

-- =========================================================================
-- market_update_proposals — B.1: propuestas de actualización de datos ya
-- mapeados (cambios de dueño, M&A, cifras, etc.) generadas por el cron
-- semanal de investigación. NUNCA se escribe directo sobre market_groups /
-- market_companies / market_independent_items — todo pasa por acá primero.
-- =========================================================================
create table if not exists market_update_proposals (
  id bigint generated always as identity primary key,
  entity_type text not null check (entity_type in ('group','company','independent_item')),
  entity_ref text not null,
  campo text not null,
  valor_actual text,
  valor_propuesto text not null,
  motivo text not null,
  fuente text not null,
  status text not null default 'pendiente' check (status in ('pendiente','aprobado','rechazado')),
  created_at timestamptz not null default now()
);

-- =========================================================================
-- product_improvement_proposals — B.2: mejora continua del producto y del
-- proceso (no solo frescura de datos): cobertura de rubros nuevos, UX/diseño,
-- código/performance. También generado por un cron semanal, también propone
-- sin aplicar solo.
-- =========================================================================
create table if not exists product_improvement_proposals (
  id bigint generated always as identity primary key,
  categoria text not null check (categoria in ('dato-nuevo','ux-diseno','codigo-perf','cobertura-rubro')),
  descripcion text not null,
  justificacion text not null,
  esfuerzo_estimado text,
  status text not null default 'pendiente' check (status in ('pendiente','aprobado','rechazado')),
  created_at timestamptz not null default now()
);

-- =========================================================================
-- RLS + políticas de solo lectura + grants explícitos (misma anon key que
-- ya usa el HTML). Las vistas heredan el acceso de las tablas base, pero se
-- deja el grant explícito sobre las vistas también para evitar el mismo
-- problema de permisos silenciosos que tuvimos con las tablas originales.
-- =========================================================================
alter table market_update_proposals enable row level security;
alter table product_improvement_proposals enable row level security;

create policy "public read" on market_update_proposals for select using (true);
create policy "public read" on product_improvement_proposals for select using (true);

grant select on v_all_companies, v_group_alerts to anon, authenticated;
grant select on market_update_proposals, product_improvement_proposals to anon, authenticated;
grant execute on function get_competitors(text) to anon, authenticated;

-- =========================================================================
-- Verificación rápida (correr después de todo lo de arriba):
-- select count(*) from v_all_companies;                 -- 245
-- select * from get_competitors('Mapfre Paraguay');      -- Patria, Itaú, Sudameris, Ueno...
-- select count(*) from v_group_alerts;                   -- 5
-- =========================================================================
