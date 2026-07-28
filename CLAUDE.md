# CLAUDE.md — Generador de Invitaciones XV

**Never get lost again.** Complete routing and state management guide for the invitations generator.

## Project Structure

```
repos-activos/invitaciones-mexico/
├── src/
│   ├── App.tsx          (~3500 lines) — main editor UI + state management
│   ├── types.ts         — TypeScript interfaces (InvitacionDatos, TemaConfig, etc.)
│   ├── data.ts          — static content (12 temas, 3 paquetes, placeholder photos)
│   ├── templates.ts     — `generarHTMLFinal(datos, tema)` — HTML string renderer for invitations
│   ├── main.tsx         — root mount point
│   └── index.css        — minimal styles
├── package.json
├── vite.config.ts
└── .env.example
```

## Deployments & URLs

### Production (Editor + Demo)

**Editor (Private, SSO Protected):**
- Domain: `https://invitacionmx-generador.vercel.app`
- Direct URL: `https://invitacionmx-generador-1plstqpk9-isaacrbs-projects.vercel.app`
- Status: Production, alias managed by Vercel
- Access: Team members only (Vercel SSO)
- Last build: commit 58915da

**Demo (Public Read-Only):**
- Domain: `https://invitacionmx-demo.vercel.app`
- Status: Production
- Access: Anyone (public)
- `VITE_PUBLIC_DEMO_ONLY=true` blocks all editor UI, shows only catalog + view modes

## Key Features: Tipo de Apertura & Símbolos de Lluvia

**CRITICAL: These controls are NOW AVAILABLE FOR ALL 12 THEMES** (as of commit 58915da).

### Where Controls Live

**File: src/App.tsx, lines ~2291-2340**

```
{/* TIPO DE APERTURA Y SÍMBOLOS DE LA LLUVIA */}
<div className="border-t border-slate-200 pt-6">
  <div className="p-4 bg-purple-50/20 border border-purple-100 rounded-xl space-y-3">
    {/* Tipo de Apertura section */}
    {/* Símbolos de la Lluvia section */}
  </div>
</div>
```

**Location in UI:** 
- Tab: "Tema/Paquete" (`panelPestana === "ajustes"`)
- Placement: Between "2. Tema de la Invitación" section and "Estilo de Contenedores de Sección"
- Visibility: Always visible, not nested inside any conditional render

### Constants

**File: src/App.tsx, lines ~440-455**

```typescript
const TIPOS_APERTURA = [
  { id: "tarjeta", nombre: "Tarjeta 🎴", desc: "..." },
  { id: "sobre", nombre: "Sobre 💌", desc: "..." },
  { id: "cortina", nombre: "Cortina 🎭", desc: "..." }
];

const PALETAS_ANIMACION = [
  { id: "elegante", nombre: "Elegante ✨", simbolos: ["✨", "🌟", "🪙", "✨"] },
  { id: "floral", nombre: "Floral 🌸", simbolos: ["🌸", "🌹", "🍃", "💮"] },
  // ... 4 more palettes
];
```

### Data Structure

**File: src/types.ts, lines ~44-50**

Root level properties (moved out of `personalizacion` object):
```typescript
tipoApertura?: "sobre" | "cortina" | "tarjeta";
simbolosCaida?: string[];
```

### URL Encoding

**File: src/App.tsx, KEY_MAP (lines ~79-80)**

For shareable links:
```typescript
tipoApertura: "ta",
simbolosCaida: "sd"
```

### Template Rendering

**File: src/templates.ts:**
- Line ~170: Uses `datos.tipoApertura` (no theme restriction)
- Line ~1263: Uses `datos.simbolosCaida` (no theme restriction)

## Core State Management (src/App.tsx)

### Main State Hook

```typescript
const [datos, setDatos] = useState<InvitacionDatos>(...)
```

### Tab Navigation

Controlled by `panelPestana` state:
- `"ajustes"` — "Tema/Paquete" tab (where controls are)
- `"quince"` — "Quinceañera"
- `"lugares"` — "Direcciones"
- `"itincode"` — "Agenda y Vestido"
- `"familia"` — "Familia"
- `"regalos"` — "Regalos"
- `"fotos"` — "Galería de Fotos"
- `"invitados"` — "Invitados"
- `"personalizar"` — "A Medida" (Personalización)

**Code:** Lines ~2044-2110 (tab buttons) + ~2112-2569 (content)

### Conditional Rendering

```typescript
{panelPestana === "ajustes" && (
  <div className="space-y-6">
    {/* All Tema/Paquete content lives here */}
  </div>
)}
```

## The 12 Themes

**File: src/data.ts, `temas` array**

1. Dorado Clásico ✨
2. Floral Acuarela 🌸
3. Vuelo de Mariposas 🦋
4. XV Coquette Listones Rose 🎀
5. XV Coquette Luxe 💎
6. Aurora Boreal 🌌
7. Personalizado 🎨
8. Mármol & Oro Geométrico
9. Ciber Cyber Neon ⚡
10. Misticus Celestial 🌙
11. Eucalipto Botánico 🍃
12. Glam Rose Oro 💖

## The 3 Packages

**File: src/data.ts, `paquetes` object**

- **Básico** ($499 MXN): 4 max fotos
- **Premium** ($799 MXN): 8 max fotos
- **Deluxe** ($1,199 MXN): 14 max fotos

Each package defines which sections are available via `paquetes[key].secciones`.

## Recent Fixes (July 27, 2026)

### Commit 80a1ef0
- **Issue**: Controls were placed inside "Estilo de Contenedores de Sección" (wrong location)
- **What happened**: Only visible when scrolling past all theme options
- **Status**: Incomplete; code was in wrong location

### Commit 58915da (Current)
- **Fix**: Moved controls to correct location (between "Selector de Temas" and "Estilo de Contenedores")
- **Result**: Controls now visible for ALL themes without needing to select "Personalizado"
- **Deployment**: Promoted to Production
- **URLs**: Active on both direct URL and alias (alias updates within 15 min of deployment)

## Common Tasks

### Add/Modify a Theme

1. Add entry to `temas` array (src/data.ts)
2. Add case in `getColorSugeridoPorTema` (src/App.tsx) if custom dress-color recommendations needed
3. (Optional) Add placeholder photos to `fotosFicticiasDefault` (src/data.ts)
4. (Optional) Add special opening-animation styling in `generarHTMLFinal` (src/templates.ts) if theme has custom animation

### Add/Remove a Section

1. Add/remove entry in `paquetes[key].secciones` (src/data.ts)
2. Update `NOMBRES_SECCIONES` (src/App.tsx) with human label
3. Add/remove `const xSeccionHTML` in `generarHTMLFinal` (src/templates.ts)
4. Update `SECCIONES_CONTENIDO_HTML` map (src/templates.ts)

### Change Section Order

Users control via `datos.ordenSecciones`. Use `getOrdenSeccionesEfectivo()` (src/data.ts) for validation and fallback.

## Development

```bash
npm run dev        # Vite dev server on :3000
npm run build      # Production build → dist/
npm run preview    # Preview production build locally
npm run lint       # TypeScript check (tsc --noEmit, no linter)
npm run clean      # Remove dist/ + server.js
```

## External Services

- **Cloudinary**: Unsigned image uploads to cloud `dswrrm5u1`, preset `invitaciones-xv`
- **Supabase**: Row in `invitaciones` table + shared custom backgrounds (`fondos_personalizados`)
- **WhatsApp**: Share links via `https://api.whatsapp.com/send?phone=...&text=...`

## Environment Variables

See `.env.example`:
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`
- `VITE_PUBLIC_DEMO_ONLY` (true on demo.vercel.app)

## Never Lose Track Again

**If features stop appearing on prod:**
1. Check deployment status on https://vercel.com/isaacrbs-projects/invitacionmx-generador/deployments
2. If latest commit is "Ready" but not visible: alias hasn't propagated yet (5-15 min)
3. Use direct URL (`invitacionmx-generador-1plstqpk9-isaacrbs-projects.vercel.app`) to verify code is live
4. Check KEY_MAP (src/App.tsx line 52-81) for URL encoding of new fields

**If controls disappear for a specific theme:** Check `panelPestana === "ajustes"` conditional render chain — controls must be outside any theme-specific condition.

**If new state fields don't serialize in shareable links:** Add to KEY_MAP with short alias (e.g., `newFeature: "nf"`).
