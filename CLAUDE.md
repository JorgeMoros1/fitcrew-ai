# FitCrew AI — Claude Code Context

## Current Status
**Last completed:** Arc 1 complete. Full stack live — WhatsApp Business API, Docker, Tailscale,
Strength agent with 518 sessions of seeded history, active injury constraint, memory
reads/writes confirmed over cellular.
**Next step:** Arc 2 — router/classifier + Running agent + @ mention routing for all three agents.
**Blocked on:** Nothing.

## Known Issues
None.

---

## What this is
WhatsApp-native multi-agent fitness coaching system. Three Claude-powered agents
(Strength, Running, Nutrition) respond in a single WhatsApp group chat. Runs locally
in Docker, accessed from phone via Tailscale. Single user (Jorge).

## Current Arc
**Arc 2 — Router/classifier + Running agent + @ mention routing for all three agents.**
Nutrition comes in Arc 3.
Do not implement Arc 3 features unless the task explicitly says so.
Reference: `docs/dev_arc2.md` for full task breakdown and sequencing.

## Repo Structure
```
fitcrew-ai/
├── CLAUDE.md
├── .env.example
├── .gitignore
├── README.md
├── requirements.txt
├── docker-compose.yml
├── Dockerfile
├── service.py                   ← main entry point, orchestrates everything
├── agents/
│   ├── strength.py              ← Arc 1: live
│   ├── running.py               ← Arc 2: live
│   └── nutrition.py             ← Arc 3: stub only
├── router/
│   ├── classifier.py            ← Arc 2: live
│   └── mention.py               ← Arc 2: live
├── memory/
│   ├── reader.py                ← Arc 1: live
│   ├── writer.py                ← Arc 1: live
│   ├── run_extractor.py         ← Arc 2: live (NLP sub-call for run logs)
│   └── summarizer.py            ← Arc 3: stub only
├── db/
│   ├── init_db.py               ← Arc 1: live
│   └── schema.sql               ← reference only
├── bridge/
│   ├── receiver.py              ← swap this for Business API later
│   └── sender.py                ← swap this for Business API later
├── onboarding/
│   └── onboard.py               ← Arc 1: live
├── scripts/
│   └── export_context.py        ← debugging utility
└── prompts/
    ├── strength_system.md        ← populated
    ├── running_system.md         ← Arc 2
    ├── nutrition_system.md       ← Arc 3
    ├── router_system.md          ← Arc 2
    └── summarizer_system.md      ← Arc 3
```

## Key Technical Decisions
- Python + asyncio for parallel agent calls — never use threads
- SQLite at `~/fitcrew-workspace/fitcrew.db` — outside repo, never committed
- Anthropic SDK for all Claude API calls
- Model: `claude-haiku-4-5` for routing and daily Q&A, `claude-sonnet-4-6` for complex requests
- Docker bound to `127.0.0.1` only — no LAN or internet exposure
- Tailscale for phone access — no open ports
- `ANTHROPIC_API_KEY` via environment variable only — never hardcoded anywhere
- DB path from environment variable `DB_PATH` — never hardcoded

## Environment Variables
All defined in `.env`, templated in `.env.example`:
- `ANTHROPIC_API_KEY` — required
- `DB_PATH` — path to SQLite file, default `/data/fitcrew.db` inside container
- `HAIKU_MODEL` — `claude-haiku-4-5`
- `SONNET_MODEL` — `claude-sonnet-4-6`
- `WHATSAPP_BOT_NUMBER` — Meta test number (e.g. 15551589093), used to drop bot echo messages
- `YOUR_WHATSAPP_NUMBER` — Jorge's personal number (kept in .env for reference)
- `WHATSAPP_MCP_HOST` / `WHATSAPP_MCP_PORT` — if using whatsapp-mcp bridge
- `WHATSAPP_BUSINESS_TOKEN` etc. — if using Business API bridge

## Database
Single SQLite file at `~/fitcrew-workspace/fitcrew.db` (maps to `/data/fitcrew.db` in container).

**9 tables (Arc 2 adds conversation_history):**
```
strength_sessions     — date, exercise, sets, reps, load_kg, rpe, notes
strength_injuries     — date_onset, body_part, affected_movements, severity (1-5), status (active/resolved)
strength_summary      — content (text), updated_at
run_logs              — date, distance_km, duration_min, avg_hr, max_hr, pain_flag, pain_body_part, pain_level, notes
run_summary           — content (text), updated_at
nutrition_log         — date, body_weight_kg, physique_notes, calorie_target, macro_split, phase, emotional_flags
nutrition_summary     — content (text), updated_at
shared_context        — ONE ROW ONLY (id=1, always UPDATE never INSERT)
                        fields: current_phase, goal, body_weight_kg, active_injuries (JSON), training_frequency
conversation_history  — Arc 2: id, agent ('strength'|'running'|'nutrition'), role ('user'|'assistant'),
                        content, timestamp. Keep last 30 pairs per agent (60 rows max per agent).
```

**Access rules:**
- Strength: R/W on strength_* tables + shared_context
- Running: R/W on run_* tables + shared_context
- Nutrition: READ on all tables, R/W on nutrition_* tables + shared_context

## Memory Architecture
Each agent appends a JSON memory block to the end of every response:
```json
{"store": {"table": "strength_sessions", "data": {...}}, "shared_context_update": {"key": "value"}}
```
Or if nothing to store:
```json
{"store": null, "shared_context_update": null}
```
`service.py` strips this block before posting to WhatsApp and writes it to SQLite.
The memory block must never appear in the WhatsApp response Jorge sees.

## System Prompts
All system prompts live in `prompts/` as markdown files.
Agents load them at runtime using a file read + `str.replace()` substitution (NOT `.format()` —
the prompt files contain JSON examples with curly braces that would break `.format()`).
Edit prompts by modifying the `.md` files — do not hardcode prompt strings in Python.

Template variables used in prompts:
`{summary}`, `{history}`, `{sessions}`, `{injuries}`, `{shared}`, `{message}`

## WhatsApp Routing (Arc 2)
1. Drop bot echo messages: if sender == `WHATSAPP_BOT_NUMBER`, drop silently
2. Check for @ mention via `router/mention.py` → `check_mention(message)`
   - `@strength` → Strength agent
   - `@running` → Running agent
   - `@nutrition` → hardcoded stub response ("🥗 Nutrition: Coming in Arc 3.")
3. If no @ mention → `router/classifier.py` → `classify_message(message)` (Haiku call)
   - Returns `{"agents": ["strength"|"running"|...]}` — fan out in parallel via `asyncio.gather`
   - Empty agents list → drop silently, no response
4. Per agent: call agent, strip memory JSON, write to SQLite, post with prefix
   - Strength: `💪 Strength:` — writes to strength_* tables
   - Running: `🏃 Running:` — writes to run_logs, fires NLP sub-call via `memory/run_extractor.py`
5. Write conversation turn to `conversation_history` after each successful response

## Arc 1 Definition of Done
- [ ] WhatsApp message received by Docker container from phone over Tailscale
- [ ] 💪 Strength: response posted back to WhatsApp group
- [ ] Lift log message creates a row in `strength_sessions`
- [ ] Follow-up message references the logged session (proves memory read works)
- [ ] Injury mentioned → row in `strength_injuries`, affected movement absent from next recommendation
- [ ] `shared_context` updates when phase or frequency mentioned
- [ ] `ANTHROPIC_API_KEY` only exists as env var — never hardcoded
- [ ] Container bound to `127.0.0.1` confirmed

## Arc 1 Task List (Claude Code Delegation)
These are the pending delegated tasks for Arc 1. Complete them in order after the
WhatsApp echo bot is confirmed working:

~~**Task A — `db/init_db.py`**~~
~~Creates all 8 tables, inserts single shared_context row (id=1, all fields NULL).~~
~~Prints sanity check: all table names + confirms shared_context has exactly 1 row.~~

~~**Task B — `service.py`**~~
~~Main orchestration. @ mention pre-check, calls Strength agent via asyncio,~~
~~strips memory JSON, writes to SQLite, posts to WhatsApp.~~
~~Stubs: `post_to_whatsapp()` and `receive_from_whatsapp()` print to console for now.~~

~~**Task C — `agents/strength.py`**~~
~~Context assembly + Strength API call.~~
~~Queries SQLite for summary, sessions (last 20), active injuries, shared_context.~~
~~Loads prompt from `prompts/strength_system.md`, substitutes template vars, calls API.~~
~~Returns full raw response string including memory JSON.~~

~~**Task D — `onboarding/onboard.py`**~~
~~Terminal intake script. Asks 7 questions, writes answers to correct SQLite tables.~~
~~Prints confirmation summary of what was written.~~

~~**Task E — `docker-compose.yml` + `Dockerfile`**~~
~~Python 3.11, bound to 127.0.0.1, mounts ~/fitcrew-workspace to /data,~~
~~reads ANTHROPIC_API_KEY from env, entrypoint: python service.py.~~

## Jorge's Context (for onboarding and seeding)
- Has ~1 year of upper body lift logs from ChatGPT Strength agent — to be parsed into
  `strength_sessions` rows when ready (bring the export here first for cleaning)
- No leg tracking currently
- ChatGPT exports (Strength, Running, Nutrition) to be run before onboarding and used
  to seed `*_summary` tables — do not run onboard.py cold
- Strength summary will be seeded manually via SQLite after onboarding script runs

## Arc 2 Task List (Claude Code Delegation)
See `docs/dev_arc2.md` for full task prompts. Complete in order after Running export is seeded.

**Task A — @ mention routing for all three agents (`service.py`)**
Extend mention pre-check: `@running` → Running agent, `@nutrition` → hardcoded stub response.

**Task B — `router/classifier.py` + `router/mention.py`**
`check_mention()` extracts agent + cleaned message from position-0 @mention.
`classify_message()` makes one Haiku call, returns `{"agents": [...]}`.
Update `service.py` to use both, fan out in parallel.

**Task C — `agents/running.py`**
Context assembly (run_summary, run_logs last 4 weeks, shared_context injuries, shared).
Loads `prompts/running_system.md`, str.replace() substitution, returns raw response.
Memory JSON format: `{"store_run": bool, "injury_update": {...}|null, "shared_context_update": {...}|null}`

**Task D — `memory/run_extractor.py`**
NLP sub-call: one Haiku call extracts structured run fields from natural language.
Returns `dict | None`. Returns `None` if no_run=true or parse fails.
Caller (service.py) writes result to `run_logs` if not None.

**Task E — `conversation_history` table + reader/writer updates**
Add table to `db/init_db.py` (CREATE IF NOT EXISTS, safe to run against existing DB).
`memory/writer.py`: `write_conversation_turn(agent, user_msg, assistant_response)`.
`memory/reader.py`: `get_conversation_history(agent, limit=30) -> str`.
Update `agents/strength.py` and `agents/running.py` to use history.

**Task F — Docker rebuild + CLAUDE.md update**
`docker compose up --build`, confirm all routing paths work, update CLAUDE.md.

## Pre-Arc 3 Infrastructure

### Meta Business Account Migration (required before permanent token)
**Status:** Resolved. Generated a permanent never-expiring System User token from the
954Food Meta Business account via Business Settings → System Users. `WHATSAPP_BUSINESS_TOKEN`
in `.env` is now the permanent token. No daily refresh needed.

## Things Claude Code Must Never Do
- Hardcode the API key or DB path
- Write data files to anywhere other than the path in `DB_PATH` env var
- Expose Docker ports beyond 127.0.0.1
- Modify the SQLite schema without being explicitly asked
- Implement Arc 2/3 features unless the task explicitly says so
- Use threads — this project uses asyncio throughout
- Insert a second row into shared_context — it is always UPDATE WHERE id=1
- Include the memory JSON block in the WhatsApp response Jorge sees
- Fabricate SQLite values — if data is absent, pass None/null

## Things Claude Code Must Always Do

- Update the `## Current Status` block in CLAUDE.md at the end of every task — last completed, next step, any blockers
- Add to `## Known Issues` if anything is broken, incomplete, or mid-implementation when a session ends
- Mark tasks in the Arc 1 Task List as complete (~~strikethrough~~) when done
- Read CLAUDE.md fully before starting any task
- Do NOT modify docs/dev_arc1.md or docs/dev_arc2.md — these are static planning documents