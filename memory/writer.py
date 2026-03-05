import json
import logging
import os
import sqlite3

DB_PATH = os.environ.get("DB_PATH", os.path.expanduser("~/fitcrew-workspace/fitcrew.db"))

ALLOWED_TABLES = {"strength_sessions", "strength_injuries", "run_logs", "nutrition_log"}
SHARED_CONTEXT_FIELDS = {
    "current_phase", "goal", "body_weight_kg", "active_injuries", "training_frequency"
}


def _connect() -> sqlite3.Connection:
    return sqlite3.connect(DB_PATH)


def write_memory(memory_block: dict) -> None:
    """Parse memory JSON from agent response and persist to SQLite."""
    store = memory_block.get("store")
    shared_update = memory_block.get("shared_context_update")

    if store:
        table = store.get("table")
        data = store.get("data")
        if table and data:
            _insert_row(table, data)

    if shared_update:
        _update_shared_context(shared_update)


def _insert_row(table: str, data) -> None:
    if not data:
        return
    if table not in ALLOWED_TABLES:
        raise ValueError(f"Refusing to write to disallowed table: {table}")
    rows = data if isinstance(data, list) else [data]
    conn = _connect()
    try:
        for row in rows:
            if not isinstance(row, dict) or not row:
                logging.warning("_insert_row: skipping non-dict row: %r", row)
                continue
            columns = ", ".join(row.keys())
            placeholders = ", ".join("?" * len(row))
            try:
                conn.execute(
                    f"INSERT INTO {table} ({columns}) VALUES ({placeholders})",
                    list(row.values()),
                )
            except Exception as e:
                logging.error("_insert_row: failed to insert into %s: %s | row=%r", table, e, row)
        conn.commit()
    finally:
        conn.close()


def _update_shared_context(updates: dict) -> None:
    filtered = {k: v for k, v in updates.items() if k in SHARED_CONTEXT_FIELDS}
    if not filtered:
        return
    if "active_injuries" in filtered and not isinstance(filtered["active_injuries"], str):
        filtered["active_injuries"] = json.dumps(filtered["active_injuries"])
    set_clause = ", ".join(f"{k} = ?" for k in filtered)
    conn = _connect()
    conn.execute(
        f"UPDATE shared_context SET {set_clause} WHERE id = 1",
        list(filtered.values()),
    )
    conn.commit()
    conn.close()
