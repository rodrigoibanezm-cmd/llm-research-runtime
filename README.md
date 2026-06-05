# LLM Research Runtime

## Qué es esto

Un sistema para ejecutar prompts estandarizados en múltiples modelos de lenguaje y guardar las respuestas como observaciones en Neon.

Primera etapa: capturar.
Después: analizar.

---

## Principio central

```txt
Redis -> personas + prompts + variables de control
Neon  -> observaciones (respuestas crudas)
LLM   -> ejecuta el prompt y devuelve respuesta
```

---

## Stack

