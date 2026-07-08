-- Permiso de actualizar/borrar SOLO en las dos tablas de propuestas — para
-- que se pueda gestionar la cola de revisión (marcar aprobado/rechazado,
-- limpiar filas de prueba) sin depender del Table Editor cada vez.
-- Los datos reales (market_groups, market_companies, etc.) siguen sin
-- ningún permiso de escritura para la anon key — esto no cambia.

create policy "public update proposals" on market_update_proposals
  for update using (true) with check (true);
create policy "public update proposals" on product_improvement_proposals
  for update using (true) with check (true);

create policy "public delete proposals" on market_update_proposals
  for delete using (true);
create policy "public delete proposals" on product_improvement_proposals
  for delete using (true);

grant update, delete on market_update_proposals, product_improvement_proposals to anon, authenticated;
