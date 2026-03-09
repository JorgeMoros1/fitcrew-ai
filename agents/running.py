import datetime
import json
import os
import re
from pathlib import Path

import anthropic

from cron.cost_logger import log_call
from memory.reader import (
    get_conversation_history,
    get_recent_run_logs,
    get_run_summary,
    get_shared_context,
)

HAIKU_MODEL = os.environ.get("HAIKU_MODEL", "claude-haiku-4-5")
SONNET_MODEL = os.environ.get("SONNET_MODEL", "claude-sonnet-4-6")

PROMPT_PATH = Path(__file__).parent.parent / "prompts" / "running_system.md"
ASSESSMENT_PROMPT_PATH = Path(__file__).parent.parent / "prompts" / "running_assessment.md"

_COMPLEX_RE = re.compile(
    r"\b(plan|program|schedule|build\s+me|design\s+my|training\s+plan)\b",
    re.IGNORECASE,
)


def _select_model(message: str) -> str:
    return SONNET_MODEL if _COMPLEX_RE.search(message) else HAIKU_MODEL


async def call_running_agent(message: str, mode: str = "normal") -> str:
    """
    Assembles context from SQLite, calls the Running agent, and returns the
    raw response string (including the trailing memory JSON block).
    If mode='assessment', loads the assessment prompt and returns structured JSON only.
    Assessment calls do not write conversation history or memory.
    """
    summary = get_run_summary()
    run_logs = get_recent_run_logs(weeks=4)
    shared = get_shared_context()

    substitutions = {
        "{date}": datetime.date.today().isoformat(),
        "{summary}": summary or "No run summary yet.",
        "{run_logs}": json.dumps(run_logs, indent=2) if run_logs else "No recent run logs.",
        "{shared}": json.dumps(shared, indent=2) if shared else "No shared context.",
        "{message}": message,
    }

    if mode == "assessment":
        prompt_path = ASSESSMENT_PROMPT_PATH
        model = HAIKU_MODEL
    else:
        history = get_conversation_history("running", limit=30)
        substitutions["{history}"] = history or "No conversation history yet."
        prompt_path = PROMPT_PATH
        model = _select_model(message)

    system_prompt = prompt_path.read_text()
    for placeholder, value in substitutions.items():
        system_prompt = system_prompt.replace(placeholder, value)

    async with anthropic.AsyncAnthropic() as client:
        response = await client.messages.create(
            model=model,
            max_tokens=512 if mode == "assessment" else 2048,
            system=system_prompt,
            messages=[{"role": "user", "content": message}],
        )
    log_call("running", model, response.usage.input_tokens, response.usage.output_tokens)
    return response.content[0].text
