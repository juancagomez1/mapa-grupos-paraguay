-- Corrección de datos: Grupo Luminotecnia y Grupo Martín Martín.
-- Antes: varias líneas eran unidades de negocio/rubros genéricos, no
-- nombres reales de empresa (mismo error que se cometió antes con
-- Alkan/Hoeckle). Ahora reemplazadas por las razones sociales reales,
-- verificadas contra sitios corporativos y prensa.

-- ============================ LUMINOTECNIA (group_id=12) ============================
-- id=90 Luminotecnia (retail) y id=92 Fabrimet ya eran correctos, no se tocan.

update market_companies set
  nombre = $txt$Lumicorp (atención a clientes corporativos y proyectos de gran envergadura, desde 1991)$txt$,
  rubro = $txt$Construcción$txt$
where id = 91;

update market_companies set
  nombre = $txt$Condel (fabricación de cables y conductores de cobre y aluminio, desde 2009 — la primera empresa industrial del grupo)$txt$,
  rubro = $txt$Industria$txt$
where id = 93;

update market_companies set
  nombre = $txt$VCP (marca propia del grupo desde 2003 — climatización, iluminación LED, herramientas, redes y cableado estructurado)$txt$,
  rubro = $txt$Construcción$txt$
where id = 94;

update market_companies set
  nombre = $txt$Insel (instalaciones electromecánicas)$txt$,
  rubro = $txt$Construcción$txt$
where id = 95;

update market_companies set
  nombre = $txt$Construplak (construcción en seco: cielorrasos, divisiones internas y vidriería)$txt$,
  rubro = $txt$Construcción$txt$
where id = 96;

insert into market_companies (group_id, nombre, rubro, badge, sort_order) values
(12, $txt$Labsol (laboratorio de ensayos eléctricos acreditado por el ONA, desde 2010 — nació para certificar los cables de Condel)$txt$, $txt$Industria$txt$, null, 8);

-- ============================ MARTÍN MARTÍN (group_id=11) ============================
-- id=88 Fuelpar y id=89 Districom ya eran correctos, no se tocan.

insert into market_companies (group_id, nombre, rubro, badge, sort_order) values
(11, $txt$Puerto Santo Domingo (terminal fluvial propia sobre el río Paraguay, pilar logístico del grupo junto con Fuelpar)$txt$, $txt$Logística$txt$, null, 3);

update market_groups set
  liderazgo = $txt$Familia Martín — Adolfo Martín (presidente de Fuelpar), Alberto Martín (vicepresidente), Cristina Martín, Lilia Acevedo$txt$,
  nota_rrhh = $txt$Fuerte presencia regional en la zona norte del país, con terminal fluvial propia (Puerto Santo Domingo) como pilar logístico — perfil interesante para búsquedas fuera de Asunción/Gran Asunción. Prensa menciona también líneas de desarrollo urbano y agroindustria del grupo, sin nombres de razón social confirmados aún — pendiente de verificar antes de mapear como empresas propias.$txt$
where id = 11;

-- Verificación rápida:
-- select nombre, rubro from market_companies where group_id=12 order by sort_order; -- 8 filas, todas con nombre real
-- select nombre, rubro from market_companies where group_id=11 order by sort_order; -- 3 filas
