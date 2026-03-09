import datetime
import json
import os
import re
from pathlib import Path

import anthropic

from cron.cost_logger import log_call
from memory.reader import (
    get_active_injuries,
    get_conversation_history,
    get_recent_sessions,
    get_shared_context,
    get_strength_summary,
)

HAIKU_MODEL = os.environ.get("HAIKU_MODEL", "claude-haiku-4-5")
SONNET_MODEL = os.environ.get("SONNET_MODEL", "claude-sonnet-4-6")

PROMPT_PATH = Path(__file__).parent.parent / "prompts" / "strength_system.md"

# Messages that need a full program build get the Sonnet model
_COMPLEX_RE = re.compile(
    r"\b(plan|program|periodize|design\s+my|build\s+me)\b",
    re.IGNORECASE,
)


def _select_model(message: str) -> str:
    return SONNET_MODEL if _COMPLEX_RE.search(message) else HAIKU_MODEL


async def call_strength_agent(message: str) -> str:
    """
    Assembles context from SQLite, calls the Strength agent, and returns the
    raw response string (including the trailing memory JSON block).
    """
    summary = get_strength_summary()
    sessions = get_recent_sessions(20)
    injuries = get_active_injuries()
    shared = get_shared_context()

    history = get_conversation_history("strength", limit=30)

    substitutions = {
        "{date}": datetime.date.today().isoformat(),
        "{summary}": summary or "No summary available.",
        "{history}": history or "No conversation history yet.",
        "{sessions}": json.dumps(sessions, indent=2) if sessions else "No recent sessions.",
        "{injuries}": json.dumps(injuries, indent=2) if injuries else "No active injuries.",
        "{shared}": json.dumps(shared, indent=2) if shared else "No shared context.",
        "{message}": message,
    }
    system_prompt = PROMPT_PATH.read_text()
    for placeholder, value in substitutions.items():
        system_prompt = system_prompt.replace(placeholder, value)

    model = _select_model(message)
    async with anthropic.AsyncAnthropic() as client:
        response = await client.messages.create(
            model=model,
            max_tokens=2048,
            system=system_prompt,
            messages=[{"role": "user", "content": message}],
        )
    log_call("strength", model, response.usage.input_tokens, response.usage.output_tokens)
    return response.content[0].text
