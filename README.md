# llm-research-runtime — MVP del Runner de Prompts

## Objetivo

Ejecutar un set de prompts contra múltiples LLMs y guardar la respuesta cruda de cada uno en Neon, sin scoring ni clasificación todavía.

Esto valida el pipeline completo:

```txt
prompt -> modelo -> almacenamiento
```

Caso demo: Dongfeng / autos chinos en Chile.

MVP inicial:

```txt
3 personas x 3 prompts x 1 provider = 9 observaciones
```

Primero se implementa OpenAI de punta a punta. Después se agrega Gemini duplicando el adapter.

---

## Principio central

Este proyecto no analiza todavía.

Solo captura respuestas cr