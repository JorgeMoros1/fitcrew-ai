import json
import os

import anthropic

from cron.cost_logger import log_call

SONNET_MODEL = os.environ.get("SONNET_MODEL", "claude-sonnet-4-6")

_SYSTEM_PROMPT = """\
You are the head coach for a multi-agent fitness coaching system.
You have received assessments from your specialist coaches and must
synthesize them into one clear, direct response for the athlete.

Rules:
- Give ONE concrete recommendation, not a list of options
- Reference specific data points from the assessments (weights, distances, dates)
- Acknowledge constraints (injuries, flags) explicitly
- Use WhatsApp formatting only (* for bold, - for lists)
- Be direct — do not hedge or give wishy-washy answers
- Keep it under 150 words\
"""


def _format_assessments(assessments: dict) -> str:
    lines = []
    for agent, data in assessments.items():
        lines.append(f"[{agent.upper()} COACH]")
        if isinstance(data, dict):
            lines.append(f"Recommendation: {data.get('recommendation', 'N/A')}")
            data_points = data.get("data_points", [])
            if data_points:
                lines.append("Data: " + ", ".join(data_points))
            constraints = data.get("constraints", [])
            if constraints:
                lines.append("Constraints: " + ", ".join(constraints))
            lines.append(f"Confidence: {data.get('confidence', 'unknown')}")
        else:
            lines.append(str(data))
        lines.append("")
    return "\n".join(lines).strip()


async def synthesize(message: str, assessments: dict) -> str:
    """
    Takes specialist assessments and synthesizes them into one unified WhatsApp response.
    Uses Sonnet. Returns clean formatted string with no memory block.
    """
    user_message = (
        f"Athlete question: {message}\n\n"
        f"Specialist assessments:\n{_format_assessments(assessments)}\n\n"
        "Write your unified response."
    )

    async with anthropic.AsyncAnthropic() as client:
        response = await client.messages.create(
            model=SONNET_MODEL,
            max_tokens=512,
            system=_SYSTEM_PROMPT,
            messages=[{"role": "user", "content": user_message}],
        )
    log_call("synthesizer", SONNET_MODEL, response.usage.input_tokens, response.usage.output_tokens)
    return response.content[0].text.strip()
