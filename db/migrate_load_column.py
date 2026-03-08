"""
One-time migration: rename load_kg -> load_lbs in strength_sessions.

SQLite doesn't support ALTER TABLE RENAME COLUMN on older versions,
so we use the safe create-copy-drop-rename approach.

Run manually after backing up the DB:
    docker-compose exec fitcrew python db/migrate_load_column.py
"""
import os
import sqlite3

DB_PATH = os.environ.get("DB_PATH", os.path.expanduser("~/fitcrew-workspace/fitcrew.db"))


def migrate() -> None:
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()

    # Verify the column exists before migrating
    cur.execute("PRAGMA table_info(strength_sessions)")
    columns = [row[1] for row in cur.fetchall()]
    if "load_lbs" in columns and "load_kg" not in columns:
        print("Migration already applied — load_lbs column exists, load_kg absent. Nothing to do.")
        conn.close()
        return
    if "load_kg" not in columns:
        print("ERROR: load_kg column not found. Inspect the schema before proceeding.")
        conn.close()
        return

    row_count_before = cur.execute("SELECT COUNT(*) FROM strength_sessions").fetchone()[0]
    print(f"Rows before migration: {row_count_before}")

    cur.executescript("""
        CREATE TABLE strength_sessions_new (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            date        TEXT NOT NULL,
            exercise    TEXT NOT NULL,
            sets        INTEGER,
            reps        INTEGER,
            load_lbs    REAL,
            rpe         REAL,
            notes       TEXT
        );

        INSERT INTO strength_sessions_new
            (id, date, exercise, sets, reps, load_lbs, rpe, notes)
        SELECT  id, date, exercise, sets, reps, load_kg,  rpe, notes
        FROM strength_sessions;

        DROP TABLE strength_sessions;

        ALTER TABLE strength_sessions_new RENAME TO strength_sessions;
    """)

    conn.commit()

    row_count_after = cur.execute("SELECT COUNT(*) FROM strength_sessions").fetchone()[0]
    cur.execute("PRAGMA table_info(strength_sessions)")
    new_columns = [row[1] for row in cur.fetchall()]
    conn.close()

    print(f"Rows after migration:  {row_count_after}")
    print(f"New columns: {new_columns}")
    assert row_count_before == row_count_after, "Row count mismatch — check the DB!"
    assert "load_lbs" in new_columns, "load_lbs column missing!"
    assert "load_kg" not in new_columns, "load_kg column still present!"
    print("Migration complete.")


if __name__ == "__main__":
    migrate()
