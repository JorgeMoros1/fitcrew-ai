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
        "SELECT date, exercise, sets, reps, load_lbs, rpe, notes "
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

# ---------------------------------------------------------------------------
# Nutrition reads
# ---------------------------------------------------------------------------

def get_nutrition_summary() -> str:
    conn = _connect()
    cur = conn.cursor()
    cur.execute("SELECT content FROM nutrition_summary ORDER BY updated_at DESC LIMIT 1")
    row = cur.fetchone()
    conn.close()
    return row["content"] if row else "No summary yet."


def get_recent_nutrition_logs(weeks: int = 4) -> str:
    conn = _connect()
    cur = conn.cursor()
    cur.execute(
        "SELECT date, body_weight_kg, physique_notes, calorie_target, macro_split, phase, emotional_flags "
        "FROM nutrition_log "
        "WHERE date >= DATE('now', ? || ' days') "
        "ORDER BY date DESC",
        (f"-{weeks * 7}",),
    )
    rows = [dict(r) for r in cur.fetchall()]
    conn.close()
    if not rows:
        return "No nutrition logs in the past 4 weeks."
    lines = []
    for r in rows:
        parts = [r["date"]]
        if r["body_weight_kg"]:
            parts.append(f"weight={r['body_weight_kg']}kg")
        if r["calorie_target"]:
            parts.append(f"kcal={r['calorie_target']}")
        if r["macro_split"]:
            parts.append(f"macros={r['macro_split']}")
        if r["phase"]:
            parts.append(f"phase={r['phase']}")
        if r["physique_notes"]:
            parts.append(f"physique={r['physique_notes']}")
        if r["emotional_flags"]:
            parts.append(f"flags={r['emotional_flags']}")
        lines.append(" | ".join(parts))
    return "\n".join(lines)


def get_cross_domain_load() -> str:
    """4-week training load snapshot for the Nutrition agent (STRENGTH_LOAD + RUN_LOAD)."""
    conn = _connect()
    cur = conn.cursor()

    cur.execute(
        """
        SELECT STRFTIME('%Y-W%W', date) AS week,
               COUNT(*) AS total_sets,
               ROUND(AVG(load_lbs), 1) AS avg_load_lbs
        FROM strength_sessions
        WHERE date >= DATE('now', '-28 days')
        GROUP BY week ORDER BY week DESC
        """
    )
    strength_rows = cur.fetchall()

    cur.execute(
        """
        SELECT STRFTIME('%Y-W%W', date) AS week,
               ROUND(SUM(distance_km), 1) AS total_km,
               SUM(pain_flag) AS pain_sessions
        FROM run_logs
        WHERE date >= DATE('now', '-28 days')
        GROUP BY week ORDER BY week DESC
        """
    )
    run_rows = cur.fetchall()
    conn.close()

    if strength_rows:
        lines = [f"  {r['week']}: {r['total_sets']} sets, avg load {r['avg_load_lbs']} lbs" for r in strength_rows]
        strength_block = "STRENGTH_LOAD (last 4 weeks):\n" + "\n".join(lines)
    else:
        strength_block = "STRENGTH_LOAD: No sessions logged in the past 4 weeks."

    if run_rows:
        lines = []
        for r in run_rows:
            pain = f", {r['pain_sessions']} pain session(s)" if r["pain_sessions"] else ""
            lines.append(f"  {r['week']}: {r['total_km']} km{pain}")
        run_block = "RUN_LOAD (last 4 weeks):\n" + "\n".join(lines)
    else:
        run_block = "RUN_LOAD: No runs logged in the past 4 weeks."

    return f"{strength_block}\n\n{run_block}"


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
