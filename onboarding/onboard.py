"""
FitCrew onboarding intake — run this AFTER seeding *_summary tables from ChatGPT exports.
Asks up to 7 questions and writes answers to the correct SQLite tables.
"""
import json
import os
import sqlite3
from datetime import date

DB_PATH = os.environ.get("DB_PATH", os.path.expanduser("~/fitcrew-workspace/fitcrew.db"))


def _connect() -> sqlite3.Connection:
    return sqlite3.connect(DB_PATH)


def _ask(prompt: str, valid: list[str] | None = None) -> str:
    while True:
        answer = input(f"{prompt} ").strip()
        if not answer:
            continue
        if valid and answer.lower() not in valid:
            print(f"  Please enter one of: {', '.join(valid)}")
            continue
        return answer


def _ask_optional(prompt: str) -> str:
    return input(f"{prompt} ").strip()


def run_onboarding() -> None:
    print("\n=== FitCrew Onboarding ===\n")
    print("Answer each question. Press Enter to skip optional fields.\n")

    # Q1 — Body weight
    bw_raw = _ask("Q1. Current body weight (kg)?")
    try:
        body_weight_kg = float(bw_raw)
    except ValueError:
        body_weight_kg = None
        print("  Could not parse weight — storing as null.")

    # Q2 — Training phase
    phase = _ask(
        "Q2. Current training phase? (bulk / cut / maintain)",
        valid=["bulk", "cut", "maintain"],
    )

    # Q3 — Primary goal
    goal = _ask("Q3. Primary goal (e.g. 'add 5 kg to bench press')?")

    # Q4 — Training frequency
    freq_raw = _ask("Q4. How many days per week do you currently train?")
    training_frequency = freq_raw  # store as text so "4-5 days" is fine

    # Q5 — Injuries
    has_injury = _ask("Q5. Do you have any active injuries?", valid=["yes", "no", "y", "n"])
    has_injury = has_injury.lower().startswith("y")

    injury_row = None
    if has_injury:
        # Q6 — Injury details
        details = _ask(
            "Q6. Which body part and what movements are affected?\n"
            "    (e.g. 'left shoulder — overhead press, lateral raises')"
        )
        parts = details.split("—", 1)
        body_part = parts[0].strip()
        affected_movements = parts[1].strip() if len(parts) > 1 else details.strip()

        # Q7 — Severity
        severity_raw = _ask(
            "Q7. Severity on a scale of 1–5? (1=minor discomfort, 5=debilitating)",
            valid=["1", "2", "3", "4", "5"],
        )
        severity = int(severity_raw)

        injury_row = {
            "date_onset": str(date.today()),
            "body_part": body_part,
            "affected_movements": affected_movements,
            "severity": severity,
            "status": "active",
        }
    else:
        print("  (Questions 6 and 7 skipped — no active injuries.)")

    # -----------------------------------------------------------------------
    # Write to DB
    # -----------------------------------------------------------------------
    conn = _connect()

    # Update shared_context (always UPDATE id=1, never INSERT)
    shared_fields: dict = {
        "current_phase": phase,
        "goal": goal,
        "body_weight_kg": body_weight_kg,
        "training_frequency": training_frequency,
    }
    if injury_row:
        shared_fields["active_injuries"] = json.dumps(
            [{"body_part": injury_row["body_part"], "severity": injury_row["severity"]}]
        )

    set_clause = ", ".join(f"{k} = ?" for k in shared_fields)
    conn.execute(
        f"UPDATE shared_context SET {set_clause} WHERE id = 1",
        list(shared_fields.values()),
    )

    # Insert injury row if present
    if injury_row:
        conn.execute(
            "INSERT INTO strength_injuries "
            "(date_onset, body_part, affected_movements, severity, status) "
            "VALUES (?, ?, ?, ?, ?)",
            [
                injury_row["date_onset"],
                injury_row["body_part"],
                injury_row["affected_movements"],
                injury_row["severity"],
                injury_row["status"],
            ],
        )

    conn.commit()
    conn.close()

    # -----------------------------------------------------------------------
    # Confirmation summary
    # -----------------------------------------------------------------------
    print("\n=== Onboarding complete — what was written ===\n")
    print(f"  shared_context (id=1):")
    for k, v in shared_fields.items():
        print(f"    {k}: {v}")
    if injury_row:
        print(f"\n  strength_injuries (new row):")
        for k, v in injury_row.items():
            print(f"    {k}: {v}")
    print(f"\n  DB path: {DB_PATH}\n")


if __name__ == "__main__":
    run_onboarding()
