-- Corrección adicional tras auditar los 17 grupos completos por el mismo
-- patrón (unidad de negocio genérica en vez de nombre real de empresa).

-- GARDEN (group_id=5): "Seguros (correduría vinculada)" es en realidad la
-- misma Cuevas Hermanos S.A. (confirmado en garden.com.py/seguros: "Cuevas
-- Hermanos SA Corredores de seguros") — no es una empresa aparte, se fusiona
-- con su fila existente y se borra la fila duplicada.
update market_companies set
  nombre = $txt$Cuevas Hermanos S.A. (Nissan desde 2017; también corredores de seguros del grupo)$txt$
where id = 49;

delete from market_companies where id = 52; -- "Seguros (correduría vinculada)", duplicado de Cuevas Hermanos

-- "Lubricantes" y "Repuestos y talleres mecánicos" no son empresas propias
-- verificables (son servicios internos de las concesionarias ya listadas,
-- sin razón social propia identificada) — se borran en vez de dejarlas
-- como si fueran compañías reales.
delete from market_companies where id = 51;
delete from market_companies where id = 53;

-- BOGARÍN (group_id=7): reemplazo por nombre real encontrado en registros
-- públicos.
update market_companies set
  nombre = $txt$Empedrill S.A. (explotación agrícola-ganadera, Estancia Carla María)$txt$
where id = 74;

-- VIERCI (group_id=3): reemplazo por el nombre real de su brazo inmobiliario.
update market_companies set
  nombre = $txt$Inmobiliaria Nacional (gestión de espacios comerciales, oficinas y depósitos del grupo, desde 1976)$txt$
where id = 36;

-- Verificación:
-- select nombre from market_companies where group_id=5 order by sort_order; -- 8 filas, ninguna genérica
-- select nombre from market_companies where group_id=7 and id=74; -- Empedrill S.A.
-- select nombre from market_companies where group_id=3 and id=36; -- Inmobiliaria Nacional
