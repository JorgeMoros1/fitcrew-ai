import os
import sqlite3

DB_PATH = os.environ.get("DB_PATH", os.path.expanduser("~/fitcrew-workspace/fitcrew.db"))


def init_db():
    os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()

    cur.executescript("""
        CREATE TABLE IF NOT EXISTS strength_sessions (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            date        TEXT NOT NULL,
            exercise    TEXT NOT NULL,
            sets        INTEGER,
            reps        INTEGER,
            load_kg     REAL,
            rpe         REAL,
            notes       TEXT
        );

        CREATE TABLE IF NOT EXISTS strength_injuries (
            id                  INTEGER PRIMARY KEY AUTOINCREMENT,
            date_onset          TEXT,
            body_part           TEXT,
            affected_movements  TEXT,
            severity            INTEGER CHECK(severity BETWEEN 1 AND 5),
            status              TEXT CHECK(status IN ('active', 'resolved'))
        );

        CREATE TABLE IF NOT EXISTS strength_summary (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            content     TEXT,
            updated_at  TEXT
        );

        CREATE TABLE IF NOT EXISTS run_logs (
            id              INTEGER PRIMARY KEY AUTOINCREMENT,
            date            TEXT NOT NULL,
            distance_km     REAL,
            duration_min    REAL,
            avg_hr          INTEGER,
            max_hr          INTEGER,
            pain_flag       INTEGER DEFAULT 0,
            pain_body_part  TEXT,
            pain_level      INTEGER,
            notes           TEXT
        );

        CREATE TABLE IF NOT EXISTS run_summary (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            content     TEXT,
            updated_at  TEXT
        );

        CREATE TABLE IF NOT EXISTS nutrition_log (
            id              INTEGER PRIMARY KEY AUTOINCREMENT,
            date            TEXT NOT NULL,
            body_weight_kg  REAL,
            physique_notes  TEXT,
            calorie_target  INTEGER,
            macro_split     TEXT,
            phase           TEXT,
            emotional_flags TEXT
        );

        CREATE TABLE IF NOT EXISTS nutrition_summary (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            content     TEXT,
            updated_at  TEXT
        );

        CREATE TABLE IF NOT EXISTS shared_context (
            id                  INTEGER PRIMARY KEY,
            current_phase       TEXT,
            goal                TEXT,
            body_weight_kg      REAL,
            active_injuries     TEXT,
            training_frequency  TEXT
        );

        CREATE TABLE IF NOT EXISTS conversation_history (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            agent       TEXT NOT NULL,
            role        TEXT NOT NULL,
            content     TEXT NOT NULL,
            timestamp   DATETIME DEFAULT CURRENT_TIMESTAMP
        );
    """)

    # Ensure exactly one row in shared_context (id=1)
    cur.execute("SELECT COUNT(*) FROM shared_context WHERE id = 1")
    if cur.fetchone()[0] == 0:
        cur.execute(
            "INSERT INTO shared_context (id, current_phase, goal, body_weight_kg, active_injuries, training_frequency) "
            "VALUES (1, NULL, NULL, NULL, NULL, NULL)"
        )

    conn.commit()

    # Sanity check
    cur.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name")
    tables = [row[0] for row in cur.fetchall()]
    print("Tables created:")
    for t in tables:
        print(f"  {t}")

    cur.execute("SELECT COUNT(*) FROM shared_context WHERE id = 1")
    count = cur.fetchone()[0]
    print(f"\nshared_context rows with id=1: {count} (expected 1)")
    assert count == 1, "shared_context must have exactly 1 row"

    conn.close()
    print(f"\nDB initialised at: {DB_PATH}")


if __name__ == "__main__":
    init_db()
