import json
import os
import sqlite3

DB_PATH = os.environ.get("DB_PATH", os.path.expanduser("~/fitcrew-workspace/fitcrew.db"))


def _connect() -> sqlite3.Connection:
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


# ---------------------------------------------------------------------------
# Strength reads
# ---------------------------------------------------------------------------

def get_strength_summary() -> str | None:
    conn = _connect()
    cur = conn.cursor()
    cur.execute("SELECT content FROM strength_summary ORDER BY updated_at DESC LIMIT 1")
    row = cur.fetchone()
    conn.close()
    return row["content"] if row else None


def get_recent_sessions(limit: int = 20) -> list[dict]:
    conn = _connect()
    cur = conn.cursor()
    cur.execute(
        "SELECT date, exercise, sets, reps, load_kg, rpe, notes "
        "FROM strength_sessions ORDER BY date DESC, id DESC LIMIT ?",
        (limit,),
    )
    rows = [dict(r) for r in cur.fetchall()]
    conn.close()
    return rows


def get_active_injuries() -> list[dict]:
    conn = _connect()
    cur = conn.cursor()
    cur.execute(
        "SELECT date_onset, body_part, affected_movements, severity "
        "FROM strength_injuries WHERE status = 'active'"
    )
    rows = [dict(r) for r in cur.fetchall()]
    conn.close()
    return rows


# ---------------------------------------------------------------------------
# Running reads
# ---------------------------------------------------------------------------

def get_run_summary() -> str | None:
    conn = _connect()
    cur = conn.cursor()
    cur.execute("SELECT content FROM run_summary ORDER BY updated_at DESC LIMIT 1")
    row = cur.fetchone()
    conn.close()
    return row["content"] if row else None


def get_recent_run_logs(weeks: int = 4) -> list[dict]:
    conn = _connect()
    cur = conn.cursor()
    cur.execute(
        "SELECT date, distance_km, duration_min, avg_hr, max_hr, "
        "pain_flag, pain_body_part, pain_level, notes "
        "FROM run_logs "
        "WHERE date >= DATE('now', ? || ' days') "
        "ORDER BY date DESC",
        (f"-{weeks * 7}",),
    )
    rows = [dict(r) for r in cur.fetchall()]
    conn.close()
    return rows


# ---------------------------------------------------------------------------
# Shared context
# ---------------------------------------------------------------------------

def get_shared_context() -> dict:
    conn = _connect()
    cur = conn.cursor()
    cur.execute(
        "SELECT current_phase, goal, body_weight_kg, active_injuries, training_frequency "
        "FROM shared_context WHERE id = 1"
    )
    row = cur.fetchone()
    conn.close()
    if not row:
        return {}
    d = dict(row)
    if d.get("active_injuries"):
        try:
            d["active_injuries"] = json.loads(d["active_injuries"])
        except (json.JSONDecodeError, TypeError):
            pass
    return d


# ---------------------------------------------------------------------------
# Conversation history
# ---------------------------------------------------------------------------

def get_conversation_history(agent: str, limit: int = 30) -> str:
    """
    Returns the last `limit` turns (user+assistant pairs) for the given agent,
    formatted as a readable conversation log.
    """
    conn = _connect()
    cur = conn.cursor()
    cur.execute(
        "SELECT role, content FROM conversation_history "
        "WHERE agent = ? ORDER BY id DESC LIMIT ?",
        (agent, limit * 2),
    )
    rows = cur.fetchall()
    conn.close()

    if not rows:
        return ""

    rows = list(reversed(rows))
    parts = []
    for row in rows:
        label = "User" if row["role"] == "user" else "Assistant"
        parts.append(f"{label}: {row['content']}")

    return "\n".join(parts)
