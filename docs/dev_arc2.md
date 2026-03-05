# FitCrew AI — Development Arc 2
**Goal:** Router/classifier live + Running agent end-to-end + @ mention routing for all three agents
**Builds on:** Arc 1 complete — Strength agent working with full seeded history, memory writes confirmed, Tailscale confirmed over cellular
**Timeline:** One focused weekend, or ~4-5 evenings
**Definition of Done:** You text the group, the right agent(s) respond automatically. @running logs a run. @strength still works. Router correctly routes ambiguous messages.

---

## What Arc 2 is NOT

- Not the Nutrition agent
- Not the weekly summarizer cron
- Not Nutrition cross-domain reads
- Not production hardening or error handling overhaul

---

## The Four Milestones

### Milestone 1 — @ mention routing for all three agents
**Done when:** `@running` and `@nutrition` prefixes route correctly in service.py. `@nutrition` stubs a "not yet implemented" response. `@strength` continues to work unchanged.

### Milestone 2 — Router/classifier live
**Done when:** A message with no @ prefix is classified by Haiku and routed to the correct agent(s). "ran 5k this morning" routes to Running. "hit 225 bench" routes to Strength. "should I cut?" routes to Nutrition (stub). Ambiguous messages route to multiple agents in parallel.

### Milestone 3 — Running agent end-to-end
**Done when:** A natural language run log is received, the Running agent responds, the NLP extraction sub-call fires, and a row is written to `run_logs`. Follow-up message references the logged run.

### Milestone 4 — Rolling conversation history
**Done when:** The last 30 exchanges per agent are stored and passed as context on each call. Agent references something from earlier in the conversation without being reminded.

---

## Before You Write Any Code

### Step 1 — Run the ChatGPT export prompt on your Running agent

```
I'm migrating you to a new system and need to export everything you know about me
before I lose this context. Please give me a complete structured export of everything
you have stored or remember about me across all our conversations.

Format your response in these sections:

RUNNING PROFILE
- Current weekly mileage
- Typical run types (easy, tempo, long run, etc.)
- How long I've been running
- Current goal (base building, race prep, casual, etc.)

RUN LOG DATA
- Any specific runs you remember (date if known, distance, pace, HR, notes)
- Recent weekly volume trend

INJURIES & FLAGS
- Any active or recent running injuries (body part, severity, status)
- Any pain flags or recurring issues across runs
- Any movements or surfaces I've been avoiding

PROGRESSION HISTORY
- Any mileage increases we've discussed
- Any return-to-run periods
- Any races or events

PATTERNS & NOTES
- Anything you've noticed about my running, recovery, or injury risk
- Any recurring themes
- Anything I've told you that affects your coaching recommendations

Be as specific and data-dense as possible. Include actual numbers wherever you have them.
If you're uncertain about something, flag it as approximate.
Do not summarize or paraphrase — I need the raw detail.
```

Bring the export here before running onboarding — same approach as Strength. The export seeds `run_summary` and any `run_logs` rows that can be parsed from it.

### Step 2 — Fill in the remaining prompt files

`prompts/running_system.md` and `prompts/router_system.md` are currently stubbed. Both system prompts are already written in `docs/agent_architecture.md` — copy them into the prompt files before starting Claude Code.

---

## Task Breakdown

### 🔴 You must do this

| Task | Why | Est. time |
|------|-----|-----------|
| Run ChatGPT export on Running agent | Only you have access | 10 min |
| Bring Running export here to parse into SQL seed | Same process as Strength | 20 min |
| Run `db/seed_running.sql` against the database | Your machine | 5 min |
| Run `onboarding/onboard.py` for Running agent | You are the user | 10 min |
| Test @ mention routing from your phone | Only you can send the test | 15 min |
| Evaluate router classification quality | Judgment call on what feels right | Ongoing |

---

### 🟢 Delegate to Claude Code

#### Task A — @ mention routing for Running and Nutrition

```
Update service.py to handle @ mention routing for all three agents.

Currently only @strength routes to a real agent. Extend the @ mention 
pre-check to handle:
- @running → call Running agent (agents/running.py — stub for now if not built yet)
- @nutrition → return a hardcoded stub response: 
  "🥗 Nutrition: Coming in Arc 3. Tag @strength or @running for now."

The @ mention regex and strip logic already exists for @strength — 
extend it to cover all three. No other changes to service.py needed.

Also add @nutrition stub response directly in service.py for now — 
do not create agents/nutrition.py yet.
```

---

#### Task B — Router/classifier

```
Implement router/classifier.py and router/mention.py.

router/mention.py:
- Function: check_mention(message: str) -> tuple[str | None, str]
- Checks if message starts with @strength, @running, or @nutrition 
  (case-insensitive, strip leading whitespace)
- Returns (agent_name, cleaned_message) if matched, (None, original_message) if not
- Mid-sentence @mentions are ignored — only position 0 triggers

router/classifier.py:
- Function: async classify_message(message: str) -> dict
- Makes one Haiku API call to classify the message
- System prompt loaded from prompts/router_system.md
- Returns: {"agents": ["strength"], "model": "haiku"} 
  or {"agents": ["running", "nutrition"], "model": "haiku"}
  or {"agents": [], "model": "haiku"}
- If agents is empty, return None so service.py can drop the message silently
- Model from HAIKU_MODEL env var (always Haiku for router, never Sonnet)

Update service.py to use both:
1. Call check_mention() first
2. If no mention, call classify_message()  
3. Fan out to relevant agents based on result
4. For Arc 2: Running agent is live, Nutrition returns stub, Strength unchanged
```

---

#### Task C — Running agent

```
Create agents/running.py.

Function: async def call_running_agent(message: str, model: str = None) -> str

Context assembly — query SQLite at DB_PATH and build:
- SUMMARY: full text from run_summary.content (latest row). If empty: "No summary yet."
- HISTORY: last 30 rows from a new run_history table (see below) — or placeholder
- RUN_LOGS: last 4 weeks of run_logs rows ordered by date desc
- INJURIES: active running injuries from... 

Wait — there is no run_injuries table in the schema. Use shared_context.active_injuries 
JSON array filtered for running-related injuries only.

- SHARED: all fields from shared_context row id=1
- MESSAGE: the incoming message

Load system prompt from prompts/running_system.md.
Use str.replace() substitution (NOT .format()) — same pattern as agents/strength.py.

Model selection: use HAIKU_MODEL by default. If message contains keywords 
"plan", "program", "build me", "schedule" — use SONNET_MODEL.

Return full raw response string including memory JSON.

Memory JSON format for Running:
{"store_run": true/false, "injury_update": {...} or null, "shared_context_update": {...} or null}

service.py should:
- Strip memory JSON before posting (same pattern as Strength)
- If store_run is true, fire a SECOND Haiku call for NLP extraction (see Task D)
- Write injury_update to shared_context.active_injuries if present
- Post response prefixed with "🏃 Running:"
```

---

#### Task D — NLP extraction sub-call

```
Create memory/run_extractor.py.

Function: async def extract_run_log(message: str) -> dict | None

Makes one Haiku API call using this system prompt exactly:

"Extract a structured run log from the following message. Return ONLY a JSON object
with these fields. Set null for any field you cannot resolve from the message —
NEVER fabricate values.

Fields: distance_km (float), duration_min (int), avg_hr (int), max_hr (int),
pain_flag (bool), pain_body_part (str or null), pain_level (int 1-5 or null),
notes (str or null)

If the message does not describe a completed run (e.g. skipped run, rest day),
return: {\"no_run\": true}

Message: {message}"

Parse the JSON response and return as dict.
If no_run is true, return None.
On any parse error, log the error and return None — never crash.

Caller (service.py) writes the result to run_logs table if not None.
```

---

#### Task E — Rolling conversation history

```
Add rolling conversation history storage per agent.

Create a new table in the SQLite database called conversation_history:
  id INTEGER PRIMARY KEY AUTOINCREMENT
  agent TEXT NOT NULL  (values: 'strength', 'running', 'nutrition')
  role TEXT NOT NULL   (values: 'user', 'assistant')
  content TEXT NOT NULL
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP

Add to db/init_db.py so it creates this table on init.
Run the ALTER TABLE or CREATE IF NOT EXISTS directly for existing databases.

Update memory/writer.py:
- Function: write_conversation_turn(agent, user_message, assistant_response)
- Inserts two rows: one role='user', one role='assistant'
- After inserting, delete rows beyond the last 30 per agent (keep most recent 30 pairs = 60 rows)

Update memory/reader.py:
- Function: get_conversation_history(agent, limit=30) -> str
- Returns last N turns formatted as readable conversation log
- Format: "User: [message]\nAssistant: [response]\n\n"

Update agents/strength.py and agents/running.py to:
- Call get_conversation_history('strength'/'running') for the HISTORY context variable
- Call write_conversation_turn() after each successful response
```

---

#### Task F — Docker rebuild + CLAUDE.md update

```
Rebuild the Docker container with all Arc 2 changes:
docker compose up --build

Then update CLAUDE.md Current Status:
- Last completed: Arc 2 complete (or in progress — update accurately)
- Next step: whatever is next
- Known issues: anything broken or incomplete
```

---

## Sequence to Follow

```
Before coding (you):
  └── Run ChatGPT export on Running agent
  └── Bring export here → get seed SQL → run against DB
  └── Copy running_system.md and router_system.md from docs/agent_architecture.md

Day 1 (delegate):
  └── Task A → @ mention routing for all three agents
  └── Task B → router/classifier.py and router/mention.py
  └── Rebuild and test: "ran 5k today" → routes to Running (stub ok)
  └── Test: "hit 225 bench" → routes to Strength (unchanged)

Day 2 (delegate):
  └── Task C → agents/running.py
  └── Task D → memory/run_extractor.py
  └── Rebuild and test: "ran 8k, knee felt tight at mile 3" → Running responds + NLP row in run_logs

Day 2-3 (delegate):
  └── Task E → conversation history table + reader/writer + agent updates
  └── Test: multi-turn conversation where agent references earlier message

Day 3 (you):
  └── Run onboarding for Running agent
  └── End-to-end test all routing paths from phone
  └── Evaluate router classification on 10+ real messages
  └── Update CLAUDE.md
```

---

## Definition of Done — Arc 2

- [ ] `@running` routes to Running agent, NLP extraction fires, row in `run_logs`
- [ ] `@strength` still works unchanged
- [ ] `@nutrition` returns stub response
- [ ] No @ prefix → classifier routes correctly for Strength and Running messages
- [ ] Multi-agent parallel response works (e.g. fatigue message → both Strength and Running respond)
- [ ] Running agent references seeded history in responses
- [ ] Conversation history persists across messages (agent references earlier turn)
- [ ] Empty classifier result → message dropped silently, no error
- [ ] All memory JSON stripped before WhatsApp post
- [ ] Docker rebuild clean

---

## What Arc 3 adds

Nutrition agent with cross-domain reads (strength volume + run mileage), weekly summarizer cron, Raspberry Pi migration, production error handling, schema cleanup (`load_kg` → `load_lbs`).

---

*Based on FitCrew AI PRD v1.1 — Agent Architecture v2 — Arc 1 complete March 2026*
