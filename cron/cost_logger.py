import csv
import datetime
import logging
import os
from pathlib import Path

log = logging.getLogger("fitcrew.cost")

COST_LOG_PATH = os.environ.get("COST_LOG_PATH", "/data/cost_log.csv")

# Prices per million tokens (Anthropic published rates)
_HAIKU_INPUT = 0.80
_HAIKU_OUTPUT = 4.00
_SONNET_INPUT = 3.00
_SONNET_OUTPUT = 15.00


def _estimate_cost(model: str, input_tokens: int, output_tokens: int) -> float:
    if "haiku" in model.lower():
        return (input_tokens * _HAIKU_INPUT + output_tokens * _HAIKU_OUTPUT) / 1_000_000
    return (input_tokens * _SONNET_INPUT + output_tokens * _SONNET_OUTPUT) / 1_000_000


def log_call(agent: str, model: str, input_tokens: int, output_tokens: int) -> None:
    """Append one row to the cost log CSV. Never raises — failures are warnings only."""
    cost = _estimate_cost(model, input_tokens, output_tokens)
    row = {
        "timestamp": datetime.datetime.utcnow().isoformat(),
        "agent": agent,
        "model": model,
        "input_tokens": input_tokens,
        "output_tokens": output_tokens,
        "estimated_cost_usd": round(cost, 6),
    }
    try:
        path = Path(COST_LOG_PATH)
        path.parent.mkdir(parents=True, exist_ok=True)
        write_header = not path.exists()
        with open(path, "a", newline="") as f:
            writer = csv.DictWriter(f, fieldnames=list(row.keys()))
            if write_header:
                writer.writeheader()
            writer.writerow(row)
    except Exception as exc:
        log.warning("cost_logger: failed to write: %s", exc)
