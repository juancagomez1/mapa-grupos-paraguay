-- Separar rubros mezclados dentro de una misma sección: "Telecomunicaciones /
-- logística" y "Bebidas / consumo masivo" agrupaban 2 mercados distintos bajo
-- un mismo título de sección, lo que hacía que el mapa Zonal no pudiera
-- distinguirlos (motivo real de la sobrepoblación de "Otros").

update market_independent_items set rubro = 'Telecom' where id in (117, 118, 119, 120);
update market_independent_items set rubro = 'Logística' where id = 121;

update market_independent_items set rubro = 'Bebidas' where id = 79;
update market_independent_items set rubro = 'Tabaco' where id = 80;

-- Verificación:
-- select id, nombre, rubro from market_independent_items where id in (117,118,119,120,121,79,80);
