# FitCrew AI — Claude Code Context

## Current Status
**Last completed:** Repo fully initialized — folder structure, CLAUDE.md, .env.example,
.gitignore, docs/ (PRD.md, agent_architecture.md, dev_arc1.md), prompts/strength_system.md populated.
**Next step:** Get WhatsApp echo bot working. Pick a bridge (whatsapp-mcp or Business API),
confirm echo bot receives and replies from phone over Tailscale before writing any agent code.
**Blocked on:** WhatsApp bridge — Meta Business API approval may be pending; fallback is whatsapp-mcp.

## Known Issues
None yet — no code written.

---

## What this is
WhatsApp-native multi-agent fitness coaching system. Three Claude-powered agents
(Strength, Running, Nutrition) respond in a single WhatsApp group chat. Runs locally
in Docker, accessed from phone via Tailscale. Single user (Jorge).

## Current Arc
**Arc 1 — Strength agent only, end-to-end with memory writes.**
Router, Running, and Nutrition come in Arc 2/3.
Do not implement Arc 2/3 features unless the task explicitly says so.
Files in Arc 2/3 folders should be stubbed with `# Arc 2` or `# Arc 3` comments only.

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
│   ├── running.py               ← Arc 2: stub only
│   └── nutrition.py             ← Arc 3: stub only
├── router/
│   ├── classifier.py            ← Arc 2: stub only
│   └── mention.py               ← Arc 2: stub only
├── memory/
│   ├── reader.py                ← Arc 1: live
│   ├── writer.py                ← Arc 1: live
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
- `YOUR_WHATSAPP_NUMBER` — Jorge's number, used to filter out bot's own messages
- `WHATSAPP_MCP_HOST` / `WHATSAPP_MCP_PORT` — if using whatsapp-mcp bridge
- `WHATSAPP_BUSINESS_TOKEN` etc. — if using Business API bridge

## Database
Single SQLite file at `~/fitcrew-workspace/fitcrew.db` (maps to `/data/fitcrew.db` in container).

**8 tables:**
```
strength_sessions   — date, exercise, sets, reps, load_kg, rpe, notes
strength_injuries   — date_onset, body_part, affected_movements, severity (1-5), status (active/resolved)
strength_summary    — content (text), updated_at
run_logs            — date, distance_km, duration_min, avg_hr, max_hr, pain_flag, pain_body_part, pain_level, notes
run_summary         — content (text), updated_at
nutrition_log       — date, body_weight_kg, physique_notes, calorie_target, macro_split, phase, emotional_flags
nutrition_summary   — content (text), updated_at
shared_context      — ONE ROW ONLY (id=1, always UPDATE never INSERT)
                      fields: current_phase, goal, body_weight_kg, active_injuries (JSON), training_frequency
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
Agents load them at runtime using a file read + `.format()` substitution.
Edit prompts by modifying the `.md` files — do not hardcode prompt strings in Python.

Template variables used in prompts:
`{summary}`, `{history}`, `{sessions}`, `{injuries}`, `{shared}`, `{message}`

## WhatsApp Routing (Arc 1 simplified)
1. Check for @ mention at start of message: `r'^@(strength|running|nutrition)\s+'` (case-insensitive)
   - If `@strength` → strip tag, call Strength agent directly (Arc 1: this is the only live path)
   - If `@running` or `@nutrition` → Arc 2/3, ignore for now
2. If no @ mention → for Arc 1, route to Strength by default (classifier comes in Arc 2)
3. Call Strength agent
4. Strip memory JSON from response
5. Write memory JSON to SQLite
6. Post cleaned response to WhatsApp prefixed with `💪 Strength:`
7. Filter out own messages: if sender == `YOUR_WHATSAPP_NUMBER`, drop silently

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

**Task A — `db/init_db.py`**
Creates all 8 tables, inserts single shared_context row (id=1, all fields NULL).
Prints sanity check: all table names + confirms shared_context has exactly 1 row.

**Task B — `service.py`**
Main orchestration. @ mention pre-check, calls Strength agent via asyncio,
strips memory JSON, writes to SQLite, posts to WhatsApp.
Stubs: `post_to_whatsapp()` and `receive_from_whatsapp()` print to console for now.

**Task C — `agents/strength.py`**
Context assembly + Strength API call.
Queries SQLite for summary, sessions (last 20), active injuries, shared_context.
Loads prompt from `prompts/strength_system.md`, substitutes template vars, calls API.
Returns full raw response string including memory JSON.

**Task D — `onboarding/onboard.py`**
Terminal intake script. Asks 7 questions, writes answers to correct SQLite tables.
Prints confirmation summary of what was written.

**Task E — `docker-compose.yml` + `Dockerfile`**
Python 3.11, bound to 127.0.0.1, mounts ~/fitcrew-workspace to /data,
reads ANTHROPIC_API_KEY from env, entrypoint: python service.py.

## Jorge's Context (for onboarding and seeding)
- Has ~1 year of upper body lift logs from ChatGPT Strength agent — to be parsed into
  `strength_sessions` rows when ready (bring the export here first for cleaning)
- No leg tracking currently
- ChatGPT exports (Strength, Running, Nutrition) to be run before onboarding and used
  to seed `*_summary` tables — do not run onboard.py cold
- Strength summary will be seeded manually via SQLite after onboarding script runs

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
- Do NOT modify docs/dev_arc1.md — it is a static planning document