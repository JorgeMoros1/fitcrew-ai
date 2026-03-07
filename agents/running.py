import json
import os
import re
from pathlib import Path

import anthropic

from memory.reader import (
    get_conversation_history,
    get_recent_run_logs,
    get_run_summary,
    get_shared_context,
)

HAIKU_MODEL = os.environ.get("HAIKU_MODEL", "claude-haiku-4-5")
SONNET_MODEL = os.environ.get("SONNET_MODEL", "claude-sonnet-4-6")

PROMPT_PATH = Path(__file__).parent.parent / "prompts" / "running_system.md"

_COMPLEX_RE = re.compile(
    r"\b(plan|program|schedule|build\s+me|design\s+my|training\s+plan)\b",
    re.IGNORECASE,
)


def _select_model(message: str) -> str:
    return SONNET_MODEL if _COMPLEX_RE.search(message) else HAIKU_MODEL


async def call_running_agent(message: str) -> str:
    """
    Assembles context from SQLite, calls the Running agent, and returns the
    raw response string (including the trailing memory JSON block).
    """
    summary = get_run_summary()
    run_logs = get_recent_run_logs(weeks=4)
    shared = get_shared_context()
    history = get_conversation_history("running", limit=30)

    substitutions = {
        "{summary}": summary or "No run summary yet.",
        "{history}": history or "No conversation history yet.",
        "{run_logs}": json.dumps(run_logs, indent=2) if run_logs else "No recent run logs.",
        "{shared}": json.dumps(shared, indent=2) if shared else "No shared context.",
        "{message}": message,
    }
    system_prompt = PROMPT_PATH.read_text()
    for placeholder, value in substitutions.items():
        system_prompt = system_prompt.replace(placeholder, value)

    async with anthropic.AsyncAnthropic() as client:
        response = await client.messages.create(
            model=_select_model(message),
            max_tokens=2048,
            system=system_prompt,
            messages=[{"role": "user", "content": message}],
        )
    return response.content[0].text
