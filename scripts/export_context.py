"""
Debugging utility — dumps all SQLite tables to stdout as JSON.
Usage: DB_PATH=~/fitcrew-workspace/fitcrew.db python scripts/export_context.py
"""
import json
import os
import sqlite3

DB_PATH = os.environ.get("DB_PATH", os.path.expanduser("~/fitcrew-workspace/fitcrew.db"))

TABLES = [
    "strength_sessions",
    "strength_injuries",
    "strength_summary",
    "run_logs",
    "run_summary",
    "nutrition_log",
    "nutrition_summary",
    "shared_context",
]


def export() -> None:
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    out = {}
    for table in TABLES:
        try:
            cur = conn.execute(f"SELECT * FROM {table}")
            out[table] = [dict(r) for r in cur.fetchall()]
        except sqlite3.OperationalError as e:
            out[table] = {"error": str(e)}
    conn.close()
    print(json.dumps(out, indent=2, default=str))


if __name__ == "__main__":
    export()
