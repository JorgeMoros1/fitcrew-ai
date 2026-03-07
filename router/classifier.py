import json
import logging
import os
from pathlib import Path

import anthropic

HAIKU_MODEL = os.environ.get("HAIKU_MODEL", "claude-haiku-4-5")
PROMPT_PATH = Path(__file__).parent.parent / "prompts" / "router_system.md"

log = logging.getLogger("fitcrew")


async def classify_message(message: str) -> dict:
    """
    Classify a message with no @ prefix using Haiku.
    Returns {"agents": [...], "model": "haiku"|"sonnet"}.
    Returns {"agents": [], "model": "haiku"} for off-topic or on parse failure.
    """
    system_prompt = PROMPT_PATH.read_text()

    async with anthropic.AsyncAnthropic() as client:
        response = await client.messages.create(
            model=HAIKU_MODEL,
            max_tokens=256,
            system=system_prompt,
            messages=[{"role": "user", "content": message}],
        )

    raw = response.content[0].text.strip()

    # Strip markdown code fence if the model wraps it anyway
    if raw.startswith("```"):
        parts = raw.split("```")
        raw = parts[1].lstrip("json").strip() if len(parts) > 1 else raw

    try:
        result = json.loads(raw)
        if isinstance(result, dict) and "agents" in result:
            return result
    except json.JSONDecodeError:
        log.error("classifier: failed to parse JSON response: %r", raw)

    return {"agents": [], "model": "haiku"}
