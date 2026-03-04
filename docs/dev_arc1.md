# FitCrew AI — Development Arc 1
**Goal:** Working WhatsApp echo bot → single agent (Strength) responding with memory writes
**Timeline:** One focused weekend, or ~4 evenings
**Definition of Done:** You text the WhatsApp group from your phone, 💪 Strength responds with context-aware coaching, and the session is written to SQLite.

---

## What Arc 1 is NOT

- Not all three agents
- Not the router/classifier
- Not @ mention routing
- Not Nutrition cross-domain reads
- Not the weekly summarizer
- Not Running NLP extraction

All of that comes in Arc 2 and 3. Arc 1 is the thinnest possible slice that proves the full stack works end-to-end.

---

## The Four Milestones

### Milestone 1 — WhatsApp bridge live
**Done when:** You send a message to a WhatsApp group from your phone and a Python script running in Docker receives it and echoes it back.

### Milestone 2 — SQLite database initialized
**Done when:** `fitcrew.db` exists at `~/fitcrew-workspace/fitcrew.db`, all 8 tables are created, and the single `shared_context` row is inserted.

### Milestone 3 — Strength agent responds
**Done when:** Your Python service receives a WhatsApp message, calls the Strength agent with assembled context, and posts the response back to the group prefixed with 💪 Strength:.

### Milestone 4 — Memory writes confirmed
**Done when:** After a session log message (e.g. "hit 225 bench 3x5 today"), you can open SQLite and see a new row in `strength_sessions`. On the next message, the agent references that session in its response.

---

## Task Breakdown

### 🔴 You must do this — cannot delegate

| Task | Why it's yours | Est. time |
|------|---------------|-----------|
| Install and configure whatsapp-mcp | Unofficial library, QR scan requires your phone, connection behavior is unpredictable | 2–4 hrs |
| Scan QR code and verify session persistence | Physical action, your account | 15 min |
| Install Docker, Tailscale on phone | Setup on your machines | 30 min |
| Test echo bot from your phone over Tailscale | Only you can send the test message | 30 min |
| Run onboarding script and answer intake questions | You are the user — agent needs your actual data | 20 min |
| Review Strength agent responses and flag what's wrong | Prompt quality judgment, only you know if the coaching feels right | Ongoing |
| Set Anthropic API spend cap ($15) | Your account | 5 min |

**Your total: ~4–6 hours, mostly front-loaded on the WhatsApp bridge.**

---

### 🟢 Delegate to Claude Code

Each item below is a Claude Code task. Paste the prompt, review the output, run it.

---

#### Task A — SQLite initialization script

**Delegate prompt:**
```
Create a Python script called `init_db.py` that initializes the FitCrew SQLite database.

Database path: ~/fitcrew-workspace/fitcrew.db

Create these 8 tables exactly:

strength_sessions: id (PK), date, exercise, sets, reps, load_kg, rpe, notes
strength_injuries: id (PK), date_onset, body_part, affected_movements, severity (1-5), status (active/resolved)
strength_summary: id (PK), content (text), updated_at
run_logs: id (PK), date, distance_km, duration_min, avg_hr, max_hr, pain_flag (bool), pain_body_part, pain_level (1-5), notes
run_summary: id (PK), content (text), updated_at
nutrition_log: id (PK), date, body_weight_kg, physique_notes, calorie_target, macro_split, phase (bulk/cut/maintain), emotional_flags
nutrition_summary: id (PK), content (text), updated_at
shared_context: id (PK, always 1), current_phase, goal, body_weight_kg, active_injuries (JSON text), training_frequency, updated_at

After creating all tables, insert one row into shared_context with id=1 and all fields as NULL.
Add a sanity check at the end: print all table names and confirm shared_context has exactly 1 row.
```

---

#### Task B — Python service skeleton

**Delegate prompt:**
```
Create a Python file called `service.py` that is the core orchestration layer for FitCrew AI.

For Arc 1, it only needs to handle the Strength agent. Build it with extensibility in mind.

Requirements:
- Receives an inbound WhatsApp message (string) from a handler function you'll stub out
- Checks for @ mention override: regex match on r'^@(strength|running|nutrition)\s+' (case-insensitive). 
  If matched, strip the tag and route directly. For Arc 1, only @strength needs to do anything real.
- If no @ mention, for now just route to Strength agent by default (classifier comes in Arc 2)
- Calls the Strength agent asynchronously using asyncio
- Strips the JSON memory block from the agent response before posting to WhatsApp
  (memory block format: JSON object on the last line of the response, starting with {"store":)
- Parses the memory block and writes it to SQLite (strength_sessions or strength_injuries table)
- Posts the cleaned response to WhatsApp prefixed with "💪 Strength:"
- Stubs for post_to_whatsapp(message: str) and receive_from_whatsapp() that print to console for now

Use asyncio. Use the anthropic Python SDK for API calls. Use sqlite3 for DB. 
DB path: ~/fitcrew-workspace/fitcrew.db
Anthropic API key from environment variable ANTHROPIC_API_KEY.
Model: claude-haiku-4-5 for now.
```

---

#### Task C — Strength agent context assembly

**Delegate prompt:**
```
Create a Python file called `agents/strength.py`.

This module assembles context and calls the Strength agent.

Function signature: async def call_strength_agent(message: str, model: str = "claude-haiku-4-5") -> str

Context assembly — query SQLite at ~/fitcrew-workspace/fitcrew.db and build this context block:
- SUMMARY: full text from strength_summary.content (latest row). If empty, use "No summary yet."
- SESSIONS: last 20 rows from strength_sessions ordered by date desc, formatted as readable lines
- INJURIES: all rows from strength_injuries where status='active'
- SHARED: all fields from shared_context row id=1
- HISTORY: not implemented in Arc 1 — insert placeholder "No prior history."
- MESSAGE: the incoming message

System prompt to use (paste exactly):
---
You are the FitCrew Strength Coach — a direct, data-driven load management system 
optimizing hypertrophy for Jorge. You have one principle: advice without data is noise.

CONTEXT:
SUMMARY: {summary}
HISTORY: {history}
SESSIONS (last 20): {sessions}
ACTIVE INJURIES: {injuries}
SHARED CONTEXT: {shared}

YOUR BEHAVIOR:
1. Answer using logged data. If data is absent, say so and ask.
2. Never program movements listed in ACTIVE INJURIES affected_movements.
3. For PR logs: compare to stored max for that exercise in SESSIONS. Acknowledge briefly. Project next session target.
4. For deload questions: reference actual session frequency and RPE trend, not generic timing.
5. Be brief unless complexity demands otherwise.

MEMORY DECISION:
After your response, on a new line output a JSON object (and nothing else after it):
{"store": {"table": "strength_sessions", "data": {...}} or null, "shared_context_update": {...} or null}
If nothing relevant to store: {"store": null, "shared_context_update": null}
---

Return the full raw response string including the memory JSON.
```

---

#### Task D — Onboarding script

**Delegate prompt:**
```
Create a Python script called `onboard.py` that seeds the Strength agent's initial memory.

It should ask Jorge these questions one by one in the terminal, then write the answers to SQLite at ~/fitcrew-workspace/fitcrew.db:

1. "What's your current training program or split? (e.g. PPL, Upper/Lower, 5/3/1)" → write to strength_summary.content as "Program: [answer]"
2. "How many days per week are you training?" → write to shared_context.training_frequency
3. "What's your current squat 1RM or recent working weight?" → write to strength_sessions (exercise='squat', notes='onboarding PR seed')
4. "What's your current bench 1RM or recent working weight?" → same for bench
5. "What's your current deadlift 1RM or recent working weight?" → same for deadlift
6. "Any active injuries? If yes, describe (body part, what movements it affects, severity 1-5). Type 'none' to skip." → write to strength_injuries if not 'none'
7. "Current goal — bulk, cut, or maintain?" → write to shared_context.current_phase

Print a confirmation summary at the end showing what was written to each table.
```

---

#### Task E — Docker setup

**Delegate prompt:**
```
Create a Dockerfile and docker-compose.yml for the FitCrew AI service.

Requirements:
- Python 3.11 base image
- Install dependencies: anthropic, apscheduler, sqlite3 (stdlib)
- Bind to 127.0.0.1 only — no external port exposure
- Mount ~/fitcrew-workspace as a volume at /data inside the container
- DB path inside container: /data/fitcrew.db
- Read ANTHROPIC_API_KEY from environment
- Entrypoint: python service.py
- Do NOT mount the entire home directory — only ~/fitcrew-workspace

Also create a requirements.txt with pinned versions for: anthropic, apscheduler.
```

---

## Sequence to follow

```
Day 1 (you)
  └── Install Docker, Tailscale on machine + phone
  └── Clone whatsapp-mcp, follow setup, scan QR
  └── Confirm session persists after terminal close
  └── Send test message, confirm it hits your Python stub

Day 1-2 (delegate)
  └── Run Task A → init_db.py → execute it → confirm tables exist
  └── Run Task D → onboard.py → run it → answer your actual intake questions

Day 2 (delegate)
  └── Run Task C → agents/strength.py
  └── Run Task B → service.py
  └── Run Task E → Dockerfile + docker-compose.yml

Day 2-3 (you)
  └── Wire whatsapp-mcp into service.py receive/post stubs
  └── Run full stack in Docker
  └── Send "hit 225 bench 3x5 today" from phone
  └── Confirm 💪 Strength: response arrives
  └── Open SQLite, confirm row in strength_sessions
  └── Send follow-up "should I deload?" — confirm agent references the session you just logged
```

---

## Definition of Done — Arc 1

- [ ] WhatsApp message received by Docker container from phone over Tailscale
- [ ] 💪 Strength: response posted back to WhatsApp group
- [ ] Lift log message creates a row in `strength_sessions`
- [ ] Follow-up message references the logged session (proves memory read works)
- [ ] Injury mentioned → row in `strength_injuries`, that movement absent from next recommendation
- [ ] `shared_context` updates when phase or frequency mentioned
- [ ] `ANTHROPIC_API_KEY` only exists as env var — never hardcoded
- [ ] Container bound to `127.0.0.1` confirmed (no LAN exposure)

---

## What Arc 2 adds (after this works)

Router/classifier, Running agent + NLP extraction, @ mention routing for all three agents, rolling conversation history window.

## What Arc 3 adds

Nutrition agent with cross-domain reads, weekly summarizer cron, full production hardening.

---

*Based on FitCrew AI PRD v1.1 — Agent Architecture v2*