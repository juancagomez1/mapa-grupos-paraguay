# Traspaso a Claude Code — Mapa de Grupos Empresariales Paraguay

## Quién soy y para qué es esto
Juan Carlos Gómez, Líder de Selección en Incentiva RRHH (Asunción, Paraguay; Directora: Lic. Felipa Mersán). Este mapa es una herramienta de inteligencia de mercado para hunting ejecutivo: entender qué grupos empresariales/conglomerados existen en Paraguay, qué empresas los componen, quién compite con quién, y usar eso para armar ternas y contactar candidatos con contexto real de mercado.

**Objetivo final:** que esto deje de ser un artifact de chat y se convierta en una app standalone o extensión de navegador.

## Cómo quiero que trabajes conmigo (léelo antes de tocar código)
- Soy directo y quiero acción, no explicaciones largas. Si algo no funciona, corregilo y seguí — no sobre-expliques.
- Los errores tienen que ser **visibles, nunca silenciosos**. Si hay un bug, decímelo explícitamente en vez de dejar que lo descubra yo.
- Priorizo iteración rápida sobre planificación extensa.
- Cuando pido una cantidad exacta de algo, quiero exactamente esa cantidad — no de más, no de menos.
- No inventes empresas, cifras o nombres que no salieron de una fuente real. Si no hay dato público, decilo explícitamente en vez de rellenar.
- Trabajo en simultáneo con ChatGPT (arquitectura/scaffold) y Gemini (research) en otro proyecto llamado "Incentiva AI" — un co-piloto personal con backend en Supabase. Este mapa de mercado es un proyecto hermano que eventualmente se conecta a esa misma base de datos.

## Estado actual del archivo
Archivo principal: `mapa-grupos-paraguay.html` — un único HTML autocontenido (sin build step), con D3.js vía CDN, pensado para poder extraerse después a una extensión de Chrome o app standalone sin reescritura mayor.

**6 pestañas:**
1. **Resumen** — dashboard con stats agregados, alertas de due diligence (grupos marcados con ⚠️), ranking de grupos por empresas mapeadas.
2. **Grupos** — mapa de burbujas por grupo familiar (fuerza D3), filtrable por rubro, con buscador.
3. **Márgenes** — datos de participación de mercado *solo con fuente pública verificable* (nunca cifras inventadas).
4. **Competencia** — vista orbital **por empresa individual** (no por grupo agregado), con el grupo de pertenencia como capa secundaria/color. Esto se corrigió recientemente porque antes agrupaba mal (ej. Toyotoshi aparecía completo en "Industria" por una sola empresa suya, distorsionando su rubro real que es automotriz).
5. **Zonal** — treemap D3 que junta TODAS las empresas (de grupos + independientes) agrupadas por zona de mercado amplia (Combustibles/Energía, Financiero/Seguros, Retail/Consumo, Medios/Telecom, Salud/Farma, Agroindustria, Automotor, Construcción/Industria, Logística, Inmobiliario).
6. **Personas** — directorio de liderazgo por grupo.
7. **Panorama** — actores independientes/multinacionales que NO pertenecen a ningún grupo familiar (bancos, financieras, cooperativas, laboratorios farmacéuticos, traders de granos, etc.), organizados por sub-rubro.

Botón **⇩ JSON** exporta todo el dataset (`data`, `independientes`, `marketShare`, `marketScale`).

## Datos actuales (aprox., van a seguir creciendo)
- **16 grupos familiares** (~114 empresas): Azeta/Zuccolillo, Cartes/Cartes Montaña, Vierci, Zapag, Garden, Harrison, Bogarín, Riquelme, Pettengill, Ortega, Martín Martín, Gorostiaga, Luminotecnia, Alkan/Hoeckle, Toyotoshi, Distribuidora Gloria.
- **19 secciones de independientes** (~81 empresas): banca, financieras, casas de crédito, casas de cambio, cooperativas, seguros, retail/supermercados, consumo masivo (segmentado por tipo de producto), farmacéutica, agroindustria/trading de granos, telecom/logística, automotor adicional, construcción — grandes contratistas.
- Cada empresa de grupo puede tener: `nombre`, `rubro`, `badge` (`gptw` o `topofmind`, solo si está confirmado con fuente real).
- Cada grupo tiene: `empleados`, `facturacion`, `liderazgo`, `notaRRHH` (esta última incluye alertas de due diligence marcadas con ⚠️ cuando corresponde — ej. Cartes por reestructuración OFAC, Alkan por exposición política).

## Bugs conocidos / lecciones ya aprendidas (no las repitas)
1. **Al editar el archivo con reemplazos de texto parciales, más de una vez se borró sin querer la línea de apertura de un objeto** (`{ grupo:"Grupo X",`) al usar un fragmento de una sola línea como ancla de reemplazo. Siempre verificar con un parser/linter real después de cada edit grande, no solo visualmente.
2. El buscador (`#search`) una vez quedó referenciado en JS sin existir en el HTML → rompía todo el script en silencio. Cualquier `getElementById` debe tener su elemento real en el DOM.
3. Antes de asumir que algo "no se ve bien", revisar: falta `<meta name="viewport">`, layout con alturas calculadas a mano en vez de flexbox, elementos que dependen de `window.resize` en vez de `ResizeObserver` (este último es más confiable dentro de visores embebidos).

## Pendiente / próximos pasos
- **Cargar todo a Supabase** (proyecto Incentiva AI): ya generé una vez un script SQL (`market_groups`, `market_companies`, `market_share`) pero **pausamos generarlo de nuevo** hasta terminar de ampliar datos y diseño — retomar cuando el usuario lo pida explícitamente.
- Supabase del proyecto Incentiva AI: `https://yigedbrpvvxjmmrpeifr.supabase.co` (RLS desactivado, 9 tablas ya existentes del otro proyecto — esto sería tablas nuevas adicionales).
- Seguir ampliando rubros con la misma profundidad que ya se usó en financiero (bancos + financieras + casas de crédito + casas de cambio + cooperativas): replicar ese patrón en salud, seguros específicos, construcción, etc.
- Investigar rigurosamente antes de agregar — no rellenar con nombres no verificados. El usuario prefiere que falte un dato a que esté inventado.
- Evaluar routing hacia extensión de Chrome o app standalone una vez el dataset esté más maduro.

## Archivos de este traspaso
- `mapa-grupos-paraguay.html` — la app completa.
- Este archivo (`HANDOFF.md`).
