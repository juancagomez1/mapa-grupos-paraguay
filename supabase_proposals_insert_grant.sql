-- Permiso de escritura SOLO para las dos tablas de propuestas — el cron
-- semanal necesita poder insertar sus hallazgos, pero jamás debe poder
-- tocar market_groups / market_companies / market_independent_items
-- (esas siguen siendo de solo lectura para la anon key).

create policy "public insert proposals" on market_update_proposals
  for insert with check (true);
create policy "public insert proposals" on product_improvement_proposals
  for insert with check (true);

grant insert on market_update_proposals, product_improvement_proposals to anon, authenticated;
