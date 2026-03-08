-- seed_nutrition.sql
-- Run once against the live DB to seed nutrition context from ChatGPT export.
-- Safe to run: uses INSERT (nutrition_summary is append-only) and UPDATE WHERE id=1 (shared_context).
--
-- Usage:
--   Local:     sqlite3 ~/fitcrew-workspace/fitcrew.db < db/seed_nutrition.sql
--   Container: docker-compose exec fitcrew sqlite3 /data/fitcrew.db < db/seed_nutrition.sql

-- ─── nutrition_summary ───────────────────────────────────────────────────────

INSERT INTO nutrition_summary (content, updated_at) VALUES (
'NUTRITION COACHING SUMMARY — seeded from ChatGPT export (Jan 2026)

CURRENT STATE
Phase: Lean bulk. Target bodyweight 175 lb. Currently ~166 lb (75.3 kg) morning weight as of Jan 15 2026.
Height: 5''11". Estimated BF ~15% (BIA). Has been lean bulking since ~Feb 2025 (+15 lb from 151 lb post-cut).

CALORIE TARGETS
Maintenance: ~2500–2600 kcal/day (empirically tested).
Bulk target: 2750–2850 kcal/day (+250–300 kcal surplus).
Protein: ≥180 g/day. No fixed carb/fat split — emphasis on consistent carbs and sodium day-to-day.

PHASE HISTORY
Aug 2024: Started cut at ~173 lb.
Feb 2025: Ended cut at ~151 lb (-22 lb over ~6 months).
Feb 2025–Jan 2026: Lean bulk — 151 → 166 lb (+15 lb over ~11 months).
Bulk target endpoint: 175 lb.

BODY COMPOSITION MONITORING
Uses BIA scale daily. Same reported BF% and muscle mass at 166 lb during both cut (Dec 2024) and bulk (Jan 2026) — user is aware this is a cross-state BIA comparison limitation.
Body weight normalises within ~1 week after travel/dietary disruptions (cruise spike: 173 lb night weight → 166 lb in 10 days).

ACTIVITY PROFILE
Lifting: 5x/week (upper body focus — no leg tracking).
Running: 1–2x/week, typically 5 km.
Tennis: 1–2x/week, 60–90 min sessions.
Combined cardio days (run + tennis): ≤3/week.
Steps: ~8k/day baseline, ~20k during travel.

NOTABLE STRENGTH PROGRESS (proxy for bulk quality, past ~2 months)
Incline press: up to 2 plates for ~7–7.5 reps.
DB incline: 65 lb × 10.
DB overhead press: 45 → 50 lb.
Weighted pull-ups: +10 lb → +25 lb.
Lat pulldown: 160 → 180 lb × 9–9.5.
T-bar row: 2 plates × 9 → 10.

COACHING FLAGS (psychological patterns to account for)
Scale anchoring: strong focus on daily weigh-ins; prone to misattributing water-weight fluctuations as fat gain.
Softness sensitivity: frequently reports feeling "fluffy" or "clunky" during bulk — needs reframing toward strength trend.
Bulk-phase doubt: questions bulk effectiveness despite clear strength progression.
Data-driven: responds well to quantified trends, structured experiments, weekly averages, clear decision frameworks.
Approach: always emphasise weekly average weight trend and strength gains as hypertrophy proxy. Avoid day-to-day scale interpretation.

SUPPLEMENTS: None reported.',
datetime('now')
);

-- ─── shared_context ───────────────────────────────────────────────────────────
-- Only update fields that need nutrition-sourced values.
-- current_phase ('lean_bulk') and training_frequency already set from Arc 1/2.
-- active_injuries already set from Arc 1/2 — not touched here.

UPDATE shared_context
SET
    goal           = 'lean bulk to 175 lb (79.4 kg); current weight 166 lb (75.3 kg)',
    body_weight_kg = 75.3
WHERE id = 1;
