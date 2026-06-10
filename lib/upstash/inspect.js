import { redis } from "./client.js";

function previewValue(value, maxChars) {
  const raw = typeof value === "string" ? value : JSON.stringify(value);
  return {
    length: raw.length,
    preview: raw.length > maxChars ? raw.slice(0, maxChars) + "..." : raw,
  };
}

export async function inspectKey(key, maxChars) {
  const type = await redis(["TYPE", key]);
  const value = await readValueByType(type, key);
  return { key, type, ...previewValue(value, maxChars) };
}

async function readValueByType(type, key) {
  if (type === "string") return redis(["GET", key]);
  if (type === "list") return redis(["LRANGE", key, 0, 9]);
  if (type === "set") return redis(["SMEMBERS", key]);
  if (type === "zset") return redis(["ZRANGE", key, 0, 9]);
