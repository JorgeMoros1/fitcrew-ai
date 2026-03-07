import json
import logging
import os

import anthropic

HAIKU_MODEL = os.environ.get("HAIKU_MODEL", "claude-haiku-4-5")

log = logging.getLogger("fitcrew")

_SYSTEM_PROMPT = (
    "Extract a structured run log from the following message. Return ONLY a JSON object "
    "with these fields. Set null for any field you cannot resolve from the message — "
    "NEVER fabricate values.\n\n"
    "Fields: distance_km (float), duration_min (int), avg_hr (int), max_hr (int), "
    "pain_flag (bool), pain_body_part (str or null), pain_level (int 1-5 or null), "
    "notes (str or null)\n\n"
    "If the message does not describe a completed run (e.g. skipped run, rest day), "
    'return: {"no_run": true}\n\n'
    "Message: {message}"
)


async def extract_run_log(message: str) -> dict | None:
    """
    Makes one Haiku call to extract structured run fields from natural language.
    Returns a dict of run fields, or None if no run or parse failure.
    """
    prompt = _SYSTEM_PROMPT.replace("{message}", message)

    try:
        async with anthropic.AsyncAnthropic() as client:
            response = await client.messages.create(
                model=HAIKU_MODEL,
                max_tokens=512,
                messages=[{"role": "user", "content": prompt}],
            )
        raw = response.content[0].text.strip()

        # Strip markdown code fence if present
        if raw.startswith("```"):
            parts = raw.split("```")
            raw = parts[1].lstrip("json").strip() if len(parts) > 1 else raw

        result = json.loads(raw)

        if not isinstance(result, dict):
            log.error("run_extractor: unexpected type %s", type(result))
            return None

        if result.get("no_run"):
            return None

        return result

    except json.JSONDecodeError as exc:
        log.error("run_extractor: JSON parse error: %s | raw=%r", exc, raw if "raw" in dir() else "")
        return None
    except Exception as exc:
        log.error("run_extractor: unexpected error: %s", exc)
        return None
