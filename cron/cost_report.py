#!/usr/bin/env python3
"""Print a monthly cost summary from the cost log CSV.

Usage (inside container):
    docker-compose exec fitcrew python cron/cost_report.py
"""
import csv
import datetime
import os
from pathlib import Path

COST_LOG_PATH = os.environ.get("COST_LOG_PATH", "/data/cost_log.csv")


def main() -> None:
    path = Path(COST_LOG_PATH)
    if not path.exists():
        print("No cost log found.")
        return

    month_prefix = datetime.datetime.utcnow().strftime("%Y-%m")
    rows = []
    with open(path, newline="") as f:
        for row in csv.DictReader(f):
            if row["timestamp"].startswith(month_prefix):
                rows.append(row)

    if not rows:
        print(f"No calls logged for {month_prefix}.")
        return

    total_calls = len(rows)
    total_input = sum(int(r["input_tokens"]) for r in rows)
    total_output = sum(int(r["output_tokens"]) for r in rows)
    total_cost = sum(float(r["estimated_cost_usd"]) for r in rows)

    print(f"\n=== FitCrew Cost Report — {month_prefix} ===")
    print(f"  Total calls:         {total_calls}")
    print(f"  Total input tokens:  {total_input:,}")
    print(f"  Total output tokens: {total_output:,}")
    print(f"  Estimated cost:      ${total_cost:.4f}")

    by_agent: dict = {}
    for r in rows:
        a = r["agent"]
        by_agent.setdefault(a, {"calls": 0, "cost": 0.0})
        by_agent[a]["calls"] += 1
        by_agent[a]["cost"] += float(r["estimated_cost_usd"])

    print("\n  By agent:")
    for agent, data in sorted(by_agent.items()):
        print(f"    {agent}: {data['calls']} calls, ${data['cost']:.4f}")
    print()


if __name__ == "__main__":
    main()
