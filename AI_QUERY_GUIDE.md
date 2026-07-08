# Guía de consulta para un copiloto de IA (Incentiva AI)

Este documento es el contrato para que cualquier asistente de IA (Incentiva AI, o
cualquier otro) consulte el dataset del Mapa de Grupos Empresariales de Paraguay
sin tener que leer `mapa-grupos-paraguay.html` ni reimplementar su lógica.

Proyecto Supabase: `https://yigedbrpvvxjmmrpeifr.supabase.co`
Autenticación: header `apikey` + `Authorization: Bearer <anon key>` (la misma
key pública que usa el HTML — es de solo lectura, RLS activo en todas las
tablas y vistas de este documento).

Todas las consultas son HTTP GET a la REST API que Supabase genera sola
(PostgREST) — no hace falta ningún SDK.

## 1. Todas las empresas (grupos + independientes)

```
GET /rest/v1/v_all_companies?select=*
```

Columnas: `nombre`, `rubro`, `source` (`grupo` o `independiente`), `grupo`
(nombre del grupo familiar, null si es independiente), `nota`, `badge`
(`gptw`, `topofmind` o null).

Filtrar por rubro:
```
GET /rest/v1/v_all_companies?select=*&rubro=ilike.*seguros*
```

## 2. Quién compite con quién

```
GET /rest/v1/rpc/get_competitors?p_empresa=Mapfre
```
(POST también funciona, con `{"p_empresa": "Mapfre"}` en el body — es una
función `stable`, se puede llamar como GET vía PostgREST.)

Devuelve las demás empresas del mismo rubro que la que se busca. El match de
`p_empresa` es parcial (`ilike`), no hace falta el nombre completo exacto.

## 3. Grupos con alertas de due diligence

```
GET /rest/v1/v_group_alerts?select=*
```

Grupos cuya nota de RRHH incluye una advertencia ⚠️ (cambios societarios sin
confirmar, exposición política, conflictos de interés, etc.) — útil para
preguntas tipo "¿hay algo que revisar antes de este proceso?".

## 4. Grupos familiares completos (con sus empresas)

```
GET /rest/v1/market_groups?select=*,market_companies(*)
```

Trae cada grupo con su arreglo de empresas anidado en una sola consulta
(PostgREST resuelve el join automáticamente por la foreign key).

## 5. Márgenes de mercado (con el "motivo", no solo el número)

```
GET /rest/v1/market_share?select=*
GET /rest/v1/market_scale?select=*
```

## 6. Propuestas pendientes de revisión (generadas por los crons semanales)

```
GET /rest/v1/market_update_proposals?status=eq.pendiente&select=*
GET /rest/v1/product_improvement_proposals?status=eq.pendiente&select=*
```

Estas dos tablas son donde el copiloto (o cualquier proceso automatizado)
debería **escribir propuestas**, nunca modificar `market_groups` /
`market_companies` / `market_independent_items` directamente. El dueño del
dataset (Juan Carlos) revisa y aprueba desde ahí.

## Reglas para cualquier IA que use este dataset

1. **Nunca inventar** una empresa, cifra o dato que no venga de una fuente
   real citada — si no hay dato público, el campo dice `N/D` explícitamente.
2. **Nunca escribir directo** sobre `market_groups`, `market_companies` ni
   `market_independent_items` — cualquier corrección pasa primero por
   `market_update_proposals` para que un humano la apruebe.
3. Si una empresa parece pertenecer a un grupo familiar ya mapeado, verificarlo
   antes de asumirlo (ver el caso Garden/Mercedes-Benz y Cogorno/Interfisa en
   el historial del proyecto — ambos eran errores/omisiones reales que costó
   encontrar).
