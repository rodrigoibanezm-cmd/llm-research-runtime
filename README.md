# llm-research-runtime — MVP del Runner de Prompts

## Objetivo

Ejecutar un set de prompts, uno por persona, contra múltiples LLMs y guardar la respuesta cruda de cada uno en Neon, sin scoring ni clasificación todavía.

Esto valida el pipeline completo:

```txt
prompt -> modelo -> almacenamiento
```

**Caso demo:** Dongfeng / autos chinos en Chile.

```txt
3 personas x 3 prompts x N providers
```

Providers del MVP:

1. OpenAI, cuenta paga, listo.
2. Gemini, tier gratis vía Google AI Studio, después de validar OpenAI.

La implementación va en secuencia: primero una ruta completa con OpenAI funcionando de punta a punta; recién después se agrega Gemini duplicando el adapter.

El diseño debe permitir sumar Claude, Kimi, DeepSeek, Grok u otros providers agregando un adapter, sin tocar la lógica central.

---

## Principio central

Este proyecto no analiza todavía.

Solo captura respuestas.

Fuera del MVP quedan:

- scoring
- tags
- clasificación
- dashboards
- Narrative Disparity Index
- modo web
- historial conversacional

Primero se generan datos reales. Después se analizan.

---

## Schema de Neon

Tabla única del MVP: `observations`.

```sql
CREATE TABLE observations (
  id                SERIAL PRIMARY KEY,
  run_id            TEXT NOT NULL,
  provider          TEXT NOT NULL,
  model             TEXT NOT NULL,
  mode              TEXT NOT NULL,
  session_type      TEXT NOT NULL,
  persona_id        TEXT NOT NULL,
  prompt_id         TEXT NOT NULL,
  prompt_text       TEXT NOT NULL,
  input_text        TEXT NOT NULL,
  response_text     TEXT NOT NULL,
  raw_response_json JSONB NOT NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

Para el MVP:

```txt
mode = base
session_type = new
```

`run_id` identifica una corrida completa, por ejemplo:

```txt
2026-06-10-dongfeng-v1
```

Esto permite comparar corridas completas en el futuro, por ejemplo T1 vs T2.

`input_text` guarda el mensaje completo enviado al modelo, es decir persona + prompt. No basta con guardar `prompt_text`, porque para auditoría metodológica hay que saber exactamente qué recibió cada modelo.

---

## Estructura de carpetas

```txt
llm-research-runtime/
├── data/
│   ├── personas.json
│   └── prompts.json
├── adapters/
│   ├── openai.js
│   └── gemini.js
├── lib/
│   ├── db.js
│   └── buildMessage.js
├── schema.sql
├── run.js
├── .env.example
├── README.md
└── package.json
```

Los archivos `personas.json` y `prompts.json` viven en GitHub para este MVP.

No se usa Redis todavía. Evita una dependencia innecesaria y deja trazabilidad clara de cambios en prompts y personas.

---

## Contrato de adapters

Cada adapter expone una función `run` con la misma firma.

El adapter no construye el prompt. Solo recibe `inputText`, llama a su API y retorna un shape estándar.

```js
export async function run({ inputText }) {
  return {
    model: "gpt-4o",
    response_text: "...",
    raw_response_json: {}
  };
}
```

Shape obligatorio:

```js
{
  model: string,
  response_text: string,
  raw_response_json: object
}
```

---

## buildMessage.js

`lib/buildMessage.js` es el único lugar donde se combina persona + prompt.

Esto garantiza que OpenAI, Gemini y cualquier provider futuro reciban exactamente el mismo input para la misma combinación persona/prompt.

Eso es clave para comparar respuestas entre modelos.

---

## run.js

`run.js` coordina el loop principal:

```txt
personas -> prompts -> providers -> saveObservation
```

Para la primera corrida:

```txt
3 personas x 3 prompts x 1 provider = 9 observaciones
```

Después, al agregar Gemini:

```txt
3 personas x 3 prompts x 2 providers = 18 observaciones
```

El proceso corre secuencialmente. No se paraleliza en el MVP.

Si falla una llamada, se registra el error y el batch continúa.

---

## Variables de entorno

`.env.example`:

```txt
DATABASE_URL=
OPENAI_API_KEY=
GEMINI_API_KEY=
```

Para la primera etapa solo se requiere:

```txt
DATABASE_URL
OPENAI_API_KEY
```

---

## Ejecución local

```bash
node run.js
```

Primero se ejecuta local.

No se usa Vercel todavía.

Cuando el pipeline esté probado, se puede envolver en un endpoint o cron job sin cambiar la lógica interna.

---

## Orden de implementación

1. `README.md` con este MVP.
2. `schema.sql` con tabla `observations`.
3. `data/personas.json` con 3 personas del caso Dongfeng.
4. `data/prompts.json` con 3 prompts del caso Dongfeng.
5. `lib/buildMessage.js`.
6. `lib/db.js`.
7. `adapters/openai.js`.
8. `run.js` solo con OpenAI.
9. Ejecutar una vez y verificar 9 filas en Neon.
10. Agregar `adapters/gemini.js`.
11. Agregar Gemini al objeto `providers` en `run.js`.
12. Ejecutar de nuevo y verificar 18 filas.

---

## Decisiones explícitas del MVP

- GitHub guarda personas y prompts.
- Neon guarda observaciones.
- OpenAI primero.
- Gemini después.
- Sin Redis.
- Sin Vercel.
- Sin scoring.
- Sin clasificación.
- Sin dashboard.

La meta no es construir el producto final.

La meta es validar que el pipeline captura respuestas reales de modelos reales y las deja auditables en base de datos.
