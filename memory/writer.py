import json
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
        data = store.get("data") or {}
        if table and data:
            _insert_row(table, data)

    if shared_update:
        _update_shared_context(shared_update)


def _insert_row(table: str, data: dict) -> None:
    if table not in ALLOWED_TABLES:
        raise ValueError(f"Refusing to write to disallowed table: {table}")
    columns = ", ".join(data.keys())
    placeholders = ", ".join("?" * len(data))
    conn = _connect()
    conn.execute(
        f"INSERT INTO {table} ({columns}) VALUES ({placeholders})",
        list(data.values()),
    )
    conn.commit()
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
