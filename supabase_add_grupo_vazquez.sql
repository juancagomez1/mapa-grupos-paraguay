-- Alta de Grupo Vázquez (familias Villasanti + Vázquez) como 18º grupo empresarial,
-- y limpieza de 3 filas de "independientes" que en realidad son parte de este grupo:
-- Financiera Ueno (id 14), Ueno Seguros (id 31) y Visión Banco (id 8) — ueno bank
-- absorbió a Visión Banco en una fusión en 2024, y Financiera Ueno / Ueno Seguros
-- ya eran parte del mismo grupo.

insert into market_groups (name, rubro, size, empleados, facturacion, liderazgo, nota_rrhh, sort_order)
values (
  $txt$Grupo Vázquez$txt$,
  $txt$Diversificado$txt$,
  90,
  $txt$5.500+ colaboradores$txt$,
  $txt$Facturación diaria superior a US$1 millón según reportes de prensa (sin cifra anual oficial consolidada)$txt$,
  $txt$Miguel Vázquez Villasanti (líder actual, une las dos ramas fundadoras: Villasanti por Cóndor SACI y Vázquez por Credicentro/ueno). Víctor Hugo Vázquez fundó Credicentro en 1984, germen financiero del grupo.$txt$,
  $txt$⚠️ Due diligence: prensa (ABC Color, dic. 2025) reportó que el grupo fue favorecido con aprox. US$780 millones en contratos y depósitos públicos desde agosto 2023, incluyendo depósitos del IPS en ueno bank, contratos tecnológicos vía Itti SAECA y adjudicaciones de máquinas de votación (US$35M) y actualización de sistemas bancarios (US$20M). ueno bank absorbió a Visión Banco en una fusión completada en 2024, hoy es el banco #1 del país por cantidad de clientes (2M+) y tarjetas de crédito. Cóndor SACI es representante exclusivo de Mercedes-Benz en Paraguay desde 1951 (empresa fundada en 1946, raíz Villasanti del grupo).$txt$,
  18
);

insert into market_companies (group_id, nombre, rubro, badge, sort_order) values
((select id from market_groups where name = $txt$Grupo Vázquez$txt$), $txt$Cóndor SACI$txt$, $txt$Automotor$txt$, null, 1),
((select id from market_groups where name = $txt$Grupo Vázquez$txt$), $txt$ueno bank$txt$, $txt$Financiero$txt$, null, 2),
((select id from market_groups where name = $txt$Grupo Vázquez$txt$), $txt$ueno Seguros$txt$, $txt$Seguros$txt$, $txt$gptw$txt$, 3),
((select id from market_groups where name = $txt$Grupo Vázquez$txt$), $txt$ueno Casa de Bolsa$txt$, $txt$Financiero$txt$, null, 4),
((select id from market_groups where name = $txt$Grupo Vázquez$txt$), $txt$upay$txt$, $txt$Fintech$txt$, null, 5),
((select id from market_groups where name = $txt$Grupo Vázquez$txt$), $txt$wepa$txt$, $txt$Fintech$txt$, null, 6),
((select id from market_groups where name = $txt$Grupo Vázquez$txt$), $txt$Itti S.A.E.C.A.$txt$, $txt$Tecnología$txt$, null, 7),
((select id from market_groups where name = $txt$Grupo Vázquez$txt$), $txt$Muv$txt$, $txt$Tecnología$txt$, null, 8),
((select id from market_groups where name = $txt$Grupo Vázquez$txt$), $txt$Más Money$txt$, $txt$Fintech$txt$, null, 9),
((select id from market_groups where name = $txt$Grupo Vázquez$txt$), $txt$IDL$txt$, $txt$Tecnología$txt$, null, 10),
((select id from market_groups where name = $txt$Grupo Vázquez$txt$), $txt$Vinanzas$txt$, $txt$Fintech$txt$, null, 11),
((select id from market_groups where name = $txt$Grupo Vázquez$txt$), $txt$Conto$txt$, $txt$Tecnología$txt$, null, 12),
((select id from market_groups where name = $txt$Grupo Vázquez$txt$), $txt$Uela$txt$, $txt$Retail$txt$, null, 13),
((select id from market_groups where name = $txt$Grupo Vázquez$txt$), $txt$Tuti$txt$, $txt$Retail$txt$, null, 14),
((select id from market_groups where name = $txt$Grupo Vázquez$txt$), $txt$Puka$txt$, $txt$Retail$txt$, null, 15),
((select id from market_groups where name = $txt$Grupo Vázquez$txt$), $txt$Monchis$txt$, $txt$Retail$txt$, null, 16),
((select id from market_groups where name = $txt$Grupo Vázquez$txt$), $txt$Don Miguel$txt$, $txt$Agro$txt$, null, 17),
((select id from market_groups where name = $txt$Grupo Vázquez$txt$), $txt$Costa Flor$txt$, $txt$Agro$txt$, null, 18),
((select id from market_groups where name = $txt$Grupo Vázquez$txt$), $txt$Costanera Shopping$txt$, $txt$Inmobiliario$txt$, null, 19),
((select id from market_groups where name = $txt$Grupo Vázquez$txt$), $txt$Place Analyzer$txt$, $txt$Inmobiliario$txt$, null, 20);

-- Limpieza: estas 3 filas de independientes pasan a formar parte de Grupo Vázquez.
delete from market_independent_items where id in (14, 31, 8);

-- Verificación sugerida:
-- select id, name, sort_order from market_groups where name = 'Grupo Vázquez';
-- select nombre, rubro, badge, sort_order from market_companies
--   where group_id = (select id from market_groups where name = 'Grupo Vázquez') order by sort_order;
-- select id from market_independent_items where id in (14, 31, 8); -- debe devolver 0 filas
