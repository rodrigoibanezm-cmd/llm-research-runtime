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
  response_text TEXT NOT NULL,
  raw_response_json JSONB NOT NULL DEFAULT '{}'::jsonb,

  run_id TEXT NOT NULL,
  input