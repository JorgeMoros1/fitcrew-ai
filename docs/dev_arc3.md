# FitCrew AI — Development Arc 3
**Goal:** Nutrition agent live + weekly summarizer cron + cross-agent shared context reads + production hardening
**Builds on:** Arc 2 complete — Router live, Running agent end-to-end, @ mention routing verified, conversation history per agent, all paths confirmed from phone
**Timeline:** One focused weekend, or ~4-5 evenings
**Definition of Done:** You tag @nutrition and get a real response that references your current training load. The weekly summarizer runs automatically. The system can run unattended without accumulating debt.

---

## What Arc 3 is NOT

- Not a mobile app or UI
- Not multi-user support
- Not a new database engine
- Not real-time HR or wearable integration
- Not a Raspberry Pi migration (deferred to Arc 4 if desired)

---

## The Four Milestones

### Milestone 1 — Nutrition agent live
**Done when:** `@nutrition` returns a real Claude response grounded in your current phase, calorie target, and protein target. The stub is gone. Memory JSON is parsed and written.

### Milestone 2 — Cross-domain reads
**Done when:** Nutrition agent has access to your last 4 weeks of `strength_sessions` volume and `run_logs` mileage. It references actual training load in its response — not generic advice.

### Milestone 3 — Weekly summarizer cron
**Done when:** A cron job inside Docker fires Sunday night, summarizes each agent's rolling conversation history, writes the result to `*_summary`, and prunes the `conversation_history` rows for that agent.

### Milestone 4 — Production hardening
**Done when:** Schema cleanup done (`load_kg` column renamed to `load_lbs`), cost logging to CSV active, deploy ritual documented and tested, error handling posts to WhatsApp instead of silent crash.

---

## Before You Write Any Code

### Step 1 — Run the ChatGPT export prompt on your Nutrition agent

```
I'm migrating you to a new system and need to export everything you know about me
before I lose this context. Please give me a complete structured export of everything
you have stored or remember about me across all our conversations.

Format your response in these sections:

BODY COMPOSITION PROFILE
- Current body weight
- Height / estimated body fat if known
- Current phase (bulk / cut / maintain)
- How long you've been in this phase

NUTRITION TARGETS
- Current calorie target (or range)
- Current protein target
- Any carb or fat targets if discussed
- Any meal timing preferences

EATING PATTERNS
- Typical meal frequency
- Any foods avoided or preferred
- Any dietary restrictions
- Any recurring patterns you've noticed

HISTORY
- Any phase changes (bulk → cut, etc.) with approximate dates
- Any weight trend data you have
- Any notable periods (vacation, holidays, travel)

FLAGS & NOTES
- Any emotional eating signals or anchoring bias patterns you've flagged
- Anything affecting your nutrition coaching recommendations
- Any supplements discussed

Be as specific and data-dense as possible. Include actual numbers wherever you have them.
If you're uncertain about something, flag it as approximate.
Do not summarize or paraphrase — I need the raw detail.
```

Bring the export here before writing any code — same process as Strength and Running. The export seeds `nutrition_summary` and initializes `shared_context` nutrition fields.

### Step 2 — Fill in the nutrition prompt file

`prompts/nutrition_system.md` does not exist yet. The starter prompt is in `docs/agent_architecture.md` under Agent 3. Copy it into the prompt file and add WhatsApp formatting rules (same block used in strength and running prompts).

---

## Task Breakdown

### 🔴 You must do this

| Task | Why | Est. time |
|------|-----|-----------|
| Run ChatGPT export on Nutrition agent | Only you have access | 10 min |
| Bring export here to parse into SQL seed | Same process as Strength and Running | 20 min |
| Run `db/seed_nutrition.sql` against the database | Your machine/server | 5 min |
| Test @nutrition from your phone | Only you can send the test | 15 min |
| Evaluate cross-domain response quality | Judgment call | Ongoing |

---

### 🟢 Delegate to Claude Code

#### Task A — Nutrition agent database tables

```
Add nutrition tables to db/init_db.py.

New tables (CREATE TABLE IF NOT EXISTS for all):

nutrition_summary:
  id INTEGER PRIMARY KEY AUTOINCREMENT
  content TEXT NOT NULL
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP

nutrition_log:
  id INTEGER PRIMARY KEY AUTOINCREMENT
  date TEXT NOT NULL
  calories INT
  protein_g INT
  carbs_g INT
  fat_g INT
  body_weight_kg REAL
  notes TEXT
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP

Run init_db.py against the live container after deploying to create the tables:
  docker-compose exec fitcrew python db/init_db.py

Update memory/writer.py TABLE_COLUMNS to include nutrition_log columns so
the schema whitelist handles any nutrition memory blocks correctly.
```

---

#### Task B — Nutrition agent memory reader/writer

```
Add nutrition memory functions to memory/reader.py and memory/writer.py.

memory/reader.py — add:
- get_nutrition_summary() -> str
  SELECT content FROM nutrition_summary ORDER BY updated_at DESC LIMIT 1
  Returns "No summary yet." if empty.

- get_recent_nutrition_logs(weeks=4) -> str
  SELECT * FROM nutrition_log WHERE date >= date('now', '-{weeks} weeks')
  ORDER BY date DESC
  Format as readable text block.

- get_cross_domain_load() -> str
  Assembles a combined training load snapshot for Nutrition agent:
  - Last 4 weeks of strength_sessions: total sets per week, avg load
  - Last 4 weeks of run_logs: total distance_km per week, any pain flags
  Returns formatted text block labeled STRENGTH_LOAD and RUN_LOAD.
  This is the cross-domain read the architecture doc specifies.

memory/writer.py — add:
- write_nutrition_log(data: dict)
  Inserts row into nutrition_log using existing _insert_row pattern.
  TABLE_COLUMNS whitelist must include nutrition_log.
```

---

#### Task C — Nutrition agent

```
Create agents/nutrition.py.

Function: async def call_nutrition_agent(message: str, model: str = None) -> str

Context assembly — query SQLite at DB_PATH and build:
- SUMMARY: get_nutrition_summary()
- RECENT_LOGS: get_recent_nutrition_logs(weeks=4)
- STRENGTH_LOAD + RUN_LOAD: get_cross_domain_load()
- SHARED: all fields from shared_context row id=1
- HISTORY: get_conversation_history('nutrition', limit=30)
- MESSAGE: the incoming message

Load system prompt from prompts/nutrition_system.md.
Use str.replace() substitution (NOT .format()) — same pattern as other agents.

Model selection: HAIKU_MODEL by default.
Sonnet triggers on: "plan", "program", "bulk", "cut", "analyze", "design my".

Memory JSON format for Nutrition:
{
  "store_log": true/false,
  "log_data": { nutrition_log fields } or null,
  "phase_update": "bulk" | "cut" | "maintain" | null,
  "shared_context_update": {...} or null
}

service.py must:
- Strip memory JSON before posting (same pattern as other agents)
- If store_log is true, write log_data to nutrition_log
- If phase_update is not null, update shared_context.phase field
- Write conversation turn after successful response
- Post response prefixed with "🥗 Nutrition:"
- Replace @nutrition stub with real call
```

---

#### Task D — Weekly summarizer cron

```
Create cron/summarizer.py.

The summarizer runs once per agent (strength, running, nutrition) and:
1. Reads the last 30 conversation_history turns for that agent
2. Makes one Sonnet API call with a summarization prompt
3. Writes the result to the agent's *_summary table (strength_summary, run_summary, nutrition_summary)
4. ONLY AFTER confirming the write succeeded, deletes the pruned conversation_history rows

Summarizer prompt (same for all agents, agent name injected):
"You are summarizing a coaching conversation for the {agent} agent of FitCrew AI.
Below are the last 30 exchanges between the coach and the athlete.
Write a dense, factual summary in 300-500 words. Include:
- Any sessions logged with specific weights, distances, or times
- Any injuries flagged or updated
- Any goals or phase changes mentioned
- Any notable progress or regressions
- Any plans or commitments made
Do not editorialize. Keep all numbers. Write in present tense as if describing current state."

Add cron scheduling to service.py using APScheduler:
- Add apscheduler to requirements.txt
- Schedule: every Sunday at 23:00 UTC
- Run all three agents sequentially (not parallel) to avoid DB contention
- Log success/failure per agent

If APScheduler adds complexity, an alternative is a separate cron_runner.py
that can be called from system cron inside the container via docker exec.
Recommend APScheduler for simplicity.
```

---

#### Task E — Schema cleanup

```
Rename load_kg column to load_lbs in strength_sessions table.

SQLite does not support ALTER TABLE RENAME COLUMN in older versions.
Safe migration approach:
1. CREATE TABLE strength_sessions_new with load_lbs instead of load_kg
2. INSERT INTO strength_sessions_new SELECT ..., load_kg as load_lbs, ... FROM strength_sessions
3. DROP TABLE strength_sessions
4. ALTER TABLE strength_sessions_new RENAME TO strength_sessions

Write this as db/migrate_load_column.py — a one-time migration script.
DO NOT run it automatically — Jorge runs it manually after backing up the DB.

After migration:
- Remove the load_lbs → load_kg rename logic from memory/writer.py
- Update TABLE_COLUMNS in memory/writer.py to use load_lbs
- Update any raw SQL in memory/reader.py that references load_kg
```

---

#### Task F — Cost logging

```
Add token cost logging to all agent calls.

After every successful API response, log to /data/cost_log.csv:
timestamp, agent, model, input_tokens, output_tokens, estimated_cost_usd

Use Anthropic's published token prices:
- Haiku input: $0.80/MTok, output: $4.00/MTok  
- Sonnet input: $3.00/MTok, output: $15.00/MTok

Create the CSV with headers if it doesn't exist.
Append one row per agent call.
Do not crash if logging fails — wrap in try/except.

Add a simple reader function that prints a monthly summary:
  python cron/cost_report.py
  → prints total calls, total tokens, total estimated cost for current month
```

---

#### Task G — Error handling overhaul

```
Update service.py error handling so failures post to WhatsApp instead of 
returning HTTP 500 silently.

Current behavior: exceptions are logged but WhatsApp gets a 500 with no reply.
New behavior:
- If any agent call raises an exception, catch it and post a brief error message:
  "⚠️ [Agent name] hit an error. Try again or check logs."
- Always return HTTP 200 to Meta — returning 500 causes Meta to retry,
  which causes duplicate messages (we've seen this happen)
- Log the full traceback to container logs as before

Also add a message deduplication guard:
- Store the last 10 WhatsApp message IDs in memory (a simple Python set)
- If the same message ID arrives twice within 60 seconds, drop the second one silently
- This prevents the duplicate-response issue caused by Meta retries on 500s
```

---

#### Task H — CLAUDE.md + deploy ritual update

```
Update CLAUDE.md with Arc 3 completion status and finalized deploy ritual:

DEPLOY RITUAL (after every code push):
1. git push (from Mac)
2. ssh root@178.156.243.64
3. cd fitcrew-ai && git pull && docker-compose down && docker-compose up --build -d
4. docker-compose exec fitcrew python db/init_db.py  (safe to run every time)
5. Meta dashboard → WhatsApp → Configuration → Verify and Save
6. Send a test message from phone, confirm response

Update Known Issues section to reflect Arc 3 state.
```

---

## Sequence to Follow

```
Before coding (you):
  └── Run ChatGPT export on Nutrition agent
  └── Bring export here → get seed SQL → run against DB
  └── Copy nutrition_system.md from docs/agent_architecture.md

Day 1 (delegate):
  └── Task A → nutrition DB tables
  └── Task B → nutrition reader/writer + cross-domain load function
  └── Task G → error handling overhaul + dedup guard (do this early — prevents duplicate hell)

Day 2 (delegate):
  └── Task C → agents/nutrition.py
  └── Rebuild and test: @nutrition responds with real data referencing training load

Day 2-3 (delegate):
  └── Task D → weekly summarizer cron
  └── Task F → cost logging
  └── Test summarizer manually before relying on schedule

Day 3 (you + delegate):
  └── Task E → schema migration (back up DB first, run manually)
  └── Task H → CLAUDE.md + deploy ritual
  └── End-to-end test all routing paths from phone
  └── Verify cost_log.csv is populating
```

---

## Definition of Done — Arc 3

- [ ] `@nutrition` returns real response grounded in phase, calorie target, protein target
- [ ] Nutrition response references actual strength volume and run mileage (cross-domain)
- [ ] `nutrition_log` rows written when store_log is true
- [ ] Phase changes written to shared_context
- [ ] Weekly summarizer fires and writes to `*_summary` tables
- [ ] Summarizer prunes `conversation_history` only after confirming write
- [ ] Cost log CSV populating with every agent call
- [ ] HTTP 500s eliminated — all agent failures post error message to WhatsApp
- [ ] Duplicate message dedup guard active
- [ ] `load_kg` → `load_lbs` migration complete and cleanup done in writer.py
- [ ] Deploy ritual documented and tested end-to-end

---

## What Arc 4 adds

**Agent consultation (cross-domain synthesis)**
For questions that require multiple agents to confer before responding (e.g. "should I run or lift tomorrow?", "am I recovered enough to train?", "is my nutrition supporting my training load?"), Arc 4 adds an orchestrator pattern:

1. Router detects consultation intent — a new message type alongside single-agent and fan-out
2. Relevant specialist agents (Strength, Running, Nutrition) are called in parallel with a modified "assessment mode" prompt — they return a structured internal assessment, not a WhatsApp message
3. A Synthesizer call (Sonnet) receives all assessments as input and writes one unified response

Example — "should I run or lift tomorrow?":
- Strength assessment: "Last session was heavy legs 2 days ago, elbow still remodeling → recommend upper push"
- Running assessment: "Right knee flagged last run, 3 days rest → cleared for easy run, keep short"
- Synthesizer output: "Either works. Lift = upper push only, legs need another day. Run = keep under 30 min easy given the knee. Avoid back-to-back hard days this week."

Cost: three API calls (two Haiku specialists + one Sonnet synthesizer) vs one call for normal messages. Estimated 15-20 cents per consultation query.

Technical requirements:
- New consultation intent classifier in router/classifier.py
- Assessment mode system prompt variant per agent (returns JSON assessment block, not WhatsApp reply)
- New agents/synthesizer.py — assembles assessments, calls Sonnet, returns unified response
- service.py consultation path alongside existing single-agent and fan-out paths

**Other Arc 4 additions**
Shared conversation log across agents (Strength/Running/Nutrition can see each other's recent responses), onboarding flow for new users, PR celebration messages, proactive check-ins (no session logged in 3 days), Raspberry Pi migration (optional — Hetzner is working fine).

---

*Based on FitCrew AI PRD v1.1 — Agent Architecture v2 — Arc 2 complete March 2026*
