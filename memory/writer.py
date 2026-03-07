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


# ---------------------------------------------------------------------------
# Strength memory
# ---------------------------------------------------------------------------

def write_memory(memory_block: dict) -> None:
    """Parse strength agent memory JSON and persist to SQLite."""
    store = memory_block.get("store")
    shared_update = memory_block.get("shared_context_update")

    if store:
        table = store.get("table")
        data = store.get("data")
        if table and data:
            _insert_row(table, data)

    if shared_update:
        update_shared_context(shared_update)


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
            if "load_lbs" in row:
                lbs_val = row.pop("load_lbs")
                if "load_kg" not in row:
                    row["load_kg"] = lbs_val
            # Normalize any list values (e.g. reps=[12,8,7] from per-set breakdown)
            for key in list(row.keys()):
                val = row[key]
                if isinstance(val, list):
                    if val and all(isinstance(v, (int, float)) for v in val):
                        breakdown = "/".join(str(v) for v in val)
                        row[key] = round(sum(val) / len(val))
                        existing_notes = row.get("notes") or ""
                        if breakdown not in existing_notes:
                            row["notes"] = f"{existing_notes} {key}:{breakdown}".strip()
                    else:
                        row[key] = "/".join(str(v) for v in val)
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


def update_shared_context(updates: dict) -> None:
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


# ---------------------------------------------------------------------------
# Running memory
# ---------------------------------------------------------------------------

def write_run_log(data: dict) -> None:
    """Insert a parsed run_logs row. Caller must include a 'date' field."""
    _insert_row("run_logs", data)


def merge_active_injury(injury_update: dict) -> None:
    """
    Merge a running injury update into shared_context.active_injuries (JSON array).
    Matches on body_part — updates existing entry or appends new one.
    """
    conn = _connect()
    cur = conn.cursor()
    cur.execute("SELECT active_injuries FROM shared_context WHERE id = 1")
    row = cur.fetchone()
    conn.close()

    existing: list = []
    if row and row[0]:
        try:
            existing = json.loads(row[0])
            if not isinstance(existing, list):
                existing = []
        except (json.JSONDecodeError, TypeError):
            existing = []

    body_part = injury_update.get("body_part")
    updated = False
    for i, inj in enumerate(existing):
        if isinstance(inj, dict) and inj.get("body_part") == body_part:
            existing[i] = {**inj, **injury_update}
            updated = True
            break
    if not updated:
        existing.append(injury_update)

    update_shared_context({"active_injuries": existing})


# ---------------------------------------------------------------------------
# Conversation history
# ---------------------------------------------------------------------------

def write_conversation_turn(agent: str, user_message: str, assistant_response: str) -> None:
    """
    Persist a user+assistant exchange for the given agent.
    Prunes to the most recent 30 pairs (60 rows) per agent after insertion.
    """
    conn = _connect()
    try:
        conn.execute(
            "INSERT INTO conversation_history (agent, role, content) VALUES (?, ?, ?)",
            (agent, "user", user_message),
        )
        conn.execute(
            "INSERT INTO conversation_history (agent, role, content) VALUES (?, ?, ?)",
            (agent, "assistant", assistant_response),
        )
        # Prune beyond 60 rows per agent
        conn.execute(
            "DELETE FROM conversation_history WHERE agent = ? AND id NOT IN "
            "(SELECT id FROM conversation_history WHERE agent = ? ORDER BY id DESC LIMIT 60)",
            (agent, agent),
        )
        conn.commit()
    except Exception as exc:
        logging.error("write_conversation_turn: failed for agent=%s: %s", agent, exc)
    finally:
        conn.close()
