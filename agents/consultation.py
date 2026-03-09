import datetime
import json
import os
from pathlib import Path

import anthropic

from cron.cost_logger import log_call
from memory.reader import (
    get_active_injuries,
    get_nutrition_summary,
    get_recent_nutrition_logs,
    get_recent_run_logs,
    get_recent_sessions,
    get_run_summary,
    get_shared_context,
    get_strength_summary,
    get_cross_domain_load,
)

SONNET_MODEL = os.environ.get("SONNET_MODEL", "claude-sonnet-4-6")

PROMPT_PATH = Path(__file__).parent.parent / "prompts" / "consultation_system.md"


async def call_consultation_agent(message: str) -> str:
    """
    Assembles all three agents' context and makes a single Sonnet call.
    Returns a clean WhatsApp-formatted string with no memory block.
    """
    shared = get_shared_context()
    strength_summary = get_strength_summary()
    sessions = get_recent_sessions(20)
    injuries = get_active_injuries()
    run_summary = get_run_summary()
    run_logs = get_recent_run_logs(weeks=4)
    nutrition_summary = get_nutrition_summary()
    nutrition_logs = get_recent_nutrition_logs(weeks=4)
    training_load = get_cross_domain_load()

    substitutions = {
        "{date}": datetime.date.today().isoformat(),
        "{shared}": json.dumps(shared, indent=2) if shared else "No shared context.",
        "{strength_summary}": strength_summary or "No summary available.",
        "{sessions}": json.dumps(sessions, indent=2) if sessions else "No recent sessions.",
        "{injuries}": json.dumps(injuries, indent=2) if injuries else "No active injuries.",
        "{run_summary}": run_summary or "No run summary yet.",
        "{run_logs}": json.dumps(run_logs, indent=2) if run_logs else "No recent run logs.",
        "{nutrition_summary}": nutrition_summary or "No nutrition summary yet.",
        "{nutrition_logs}": nutrition_logs or "No recent nutrition logs.",
        "{training_load}": training_load or "No training load data.",
        "{message}": message,
    }

    system_prompt = PROMPT_PATH.read_text()
    for placeholder, value in substitutions.items():
        system_prompt = system_prompt.replace(placeholder, value)

    async with anthropic.AsyncAnthropic() as client:
        response = await client.messages.create(
            model=SONNET_MODEL,
            max_tokens=512,
            system=system_prompt,
            messages=[{"role": "user", "content": message}],
        )
    log_call("consultation", SONNET_MODEL, response.usage.input_tokens, response.usage.output_tokens)
    return response.content[0].text.strip()
