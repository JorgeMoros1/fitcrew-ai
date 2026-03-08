"""
Weekly summarizer — runs once per agent every Sunday at 23:00 UTC.

For each agent:
1. Reads last 30 conversation_history pairs
2. Makes one Sonnet API call to produce a dense narrative summary
3. Writes the result to the agent's *_summary table
4. Only AFTER confirming the write, prunes the processed conversation_history rows

Can be run manually:
    docker-compose exec fitcrew python cron/summarizer.py
"""
import asyncio
import datetime
import logging
import os
import sqlite3

import anthropic

from cron.cost_logger import log_call

log = logging.getLogger("fitcrew.summarizer")

DB_PATH = os.environ.get("DB_PATH", os.path.expanduser("~/fitcrew-workspace/fitcrew.db"))
SONNET_MODEL = os.environ.get("SONNET_MODEL", "claude-sonnet-4-6")

_SUMMARY_TABLES = {
    "strength": "strength_summary",
    "running": "run_summary",
    "nutrition": "nutrition_summary",
}

_SUMMARIZER_PROMPT = """\
You are summarizing a coaching conversation for the {agent} agent of FitCrew AI.
Below are the last 30 exchanges between the coach and the athlete.
Write a dense, factual summary in 300-500 words. Include:
- Any sessions logged with specific weights, distances, or times
- Any injuries flagged or updated
- Any goals or phase changes mentioned
- Any notable progress or regressions
- Any plans or commitments made
Do not editorialize. Keep all numbers. Write in present tense as if describing current state.\
"""


def _get_history(agent: str) -> list[dict]:
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    cur = conn.cursor()
    cur.execute(
        "SELECT id, role, content FROM conversation_history "
        "WHERE agent = ? ORDER BY id DESC LIMIT 60",
        (agent,),
    )
    rows = [dict(r) for r in cur.fetchall()]
    conn.close()
    return list(reversed(rows))


def _write_summary(agent: str, content: str) -> None:
    table = _SUMMARY_TABLES[agent]
    conn = sqlite3.connect(DB_PATH)
    conn.execute(
        f"INSERT INTO {table} (content, updated_at) VALUES (?, ?)",
        (content, datetime.datetime.utcnow().isoformat()),
    )
    conn.commit()
    conn.close()


def _prune_history(ids: list[int]) -> None:
    if not ids:
        return
    conn = sqlite3.connect(DB_PATH)
    conn.execute(
        f"DELETE FROM conversation_history WHERE id IN ({','.join('?' * len(ids))})",
        ids,
    )
    conn.commit()
    conn.close()


async def _summarize_agent(agent: str) -> None:
    rows = _get_history(agent)
    if not rows:
        log.info("SUMMARIZER [%s]: no history — skipping", agent)
        return

    ids = [r["id"] for r in rows]
    exchanges = "\n".join(
        f"{'User' if r['role'] == 'user' else 'Coach'}: {r['content']}"
        for r in rows
    )
    prompt = _SUMMARIZER_PROMPT.replace("{agent}", agent)

    async with anthropic.AsyncAnthropic() as client:
        response = await client.messages.create(
            model=SONNET_MODEL,
            max_tokens=1024,
            system=prompt,
            messages=[{"role": "user", "content": f"CONVERSATION:\n{exchanges}"}],
        )

    summary = response.content[0].text.strip()

    # Log cost
    try:
        log_call("summarizer_" + agent, SONNET_MODEL,
                 response.usage.input_tokens, response.usage.output_tokens)
    except Exception:
        pass

    # Write summary first — only prune after confirming write succeeded
    _write_summary(agent, summary)
    log.info("SUMMARIZER [%s]: wrote %d chars to %s", agent, len(summary), _SUMMARY_TABLES[agent])

    _prune_history(ids)
    log.info("SUMMARIZER [%s]: pruned %d conversation_history rows", agent, len(ids))


def run_weekly_summarizer() -> None:
    """Entry point for APScheduler and manual invocation."""
    log.info("SUMMARIZER: starting weekly run")
    for agent in ("strength", "running", "nutrition"):
        try:
            asyncio.run(_summarize_agent(agent))
        except Exception as exc:
            log.error("SUMMARIZER [%s] failed: %s", agent, exc)
    log.info("SUMMARIZER: weekly run complete")


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
    run_weekly_summarizer()
