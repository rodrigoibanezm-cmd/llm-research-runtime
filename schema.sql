CREATE TABLE IF NOT EXISTS observations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  provider TEXT NOT NULL,
  model TEXT NOT NULL,
  mode TEXT NOT NULL DEFAULT 'base',
  session_type TEXT NOT NULL DEFAULT 'new',

  persona_id TEXT NOT NULL,
  prompt_id TEXT NOT NULL,
  prompt_text TEXT NOT NULL,
  input_text TEXT NOT NULL,
  response_text TEXT NOT NULL,
  raw_response_json JSONB NOT NULL DEFAULT '{}'::jsonb,

  run_id TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_observations_run_id
ON observations (run_id);

CREATE INDEX IF NOT EXISTS idx_observations_provider_model
ON observations (provider, model);

CREATE INDEX IF NOT EXISTS idx_observations_persona_prompt
ON observations (persona_id, prompt_id);