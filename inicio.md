**LLM Research Runtime — Documento de inicio**

**Qué es esto:**
Un sistema para observar qué narrativas construyen los modelos de lenguaje (LLMs) sobre marcas, productos y servicios. No es GEO ni optimización. Es investigación de mercado aplicada a una nueva fuente observable.

**El problema que resuelve:**
Cuando un consumidor consulta un LLM antes de decidir una compra de alta implicancia — refrigerador, isapre, clínica, auto — recibe una narrativa sintetizada sobre la marca. Esa narrativa ya existe, ya influye, y hoy nadie la está midiendo sistemáticamente.

**Principio central:**
```
LLM ejecuta prompts y clasifica narrativas dentro de un pool cerrado entregado por llm.
Backend entrega datos estructurados.
Agente interpreta y responde.
```

**Stack:**
- Vercel (runtime)
- Neon/Postgres (observaciones, clasificaciones, series temporales)
- Redis/Upstash (personas estandarizadas, configuración de prompts, variables de control)
- Node.js / ESM

**Variables de control:**
- Modelo: ChatGPT, Gemini, DeepSeek, Claude
- Modo: base vs web
- Persona: perfil estandarizado del consultante
- Prompt: pregunta controlada y reproducible
- Fecha: para series temporales

**Lo que quiero que haga el sistema:**
1. Ejecutar un prompt con una persona específica en uno o varios modelos
2. Guardar la respuesta como observación en Neon
3. Clasificar la narrativa (tono, recomendación, sensibilidad)
4. Permitir consultar observaciones por marca, modelo, fecha
5. Detectar cambios en narrativa en el tiempo

**Lo que NO hace:**
- No optimiza visibilidad en LLMs (eso es GEO)
- No evalúa si las respuestas son correctas
- No reemplaza investigación cualitativa

**Referencia:**
Tengo una repo similar en producción: `gmb-cidef`. Misma arquitectura — runtime separado de operaciones, Neon como plano de decisión, LLM hace semántica. Seguir esos mismos principios.

**Estado actual:**
Repo creada y vacía. Arrancamos por arquitectura y README.

---
