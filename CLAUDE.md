# FitCrew AI — Claude Code Context

## What this is
WhatsApp-native multi-agent fitness coaching system. Three Claude-powered agents 
(Strength, Running, Nutrition) respond in a single WhatsApp group chat. Runs locally 
in Docker, accessed from phone via Tailscale. Single user (Jorge).

## Current arc
Arc 1 — Strength agent only, end-to-end with memory writes.
Router, Running, and Nutrition come in Arc 2/3.

## Repo structure
service.py          — main entry point, orchestrates everything
agents/             — one file per agent, each handles context assembly + API call
router/             — classifier (Arc 2) and @ mention pre-check
memory/             — all SQLite reads and writes, summarizer cron
db/                 — schema and init script
bridge/             — WhatsApp receive/send (swap this layer for Business API later)
onboarding/         — one-time intake scripts per agent

## Key technical decisions
- Python + asyncio for parallel agent calls
- SQLite at ~/fitcrew-workspace/fitcrew.db (outside repo, never committed)
- Anthropic SDK for all Claude API calls
- Model: claude-haiku-4-5 for routing and daily Q&A, claude-sonnet-4-6 for complex requests
- Docker bound to 127.0.0.1 only
- Tailscale for phone access — no open ports
- ANTHROPIC_API_KEY via environment variable only — never hardcoded

## Memory architecture
Each agent appends a JSON memory block to the end of every response:
{"store": {"table": "...", "data": {...}} or null, "shared_context_update": {...} or null}
service.py strips this block before posting to WhatsApp and writes it to SQLite.

## Database
Single SQLite file. 8 tables:
- strength_sessions, strength_injuries, strength_summary (Strength private)
- run_logs, run_summary (Running private)  
- nutrition_log, nutrition_summary (Nutrition private)
- shared_context (one row, always updated in-place, read by all agents)

Nutrition has read access to all tables.
Strength and Running read/write their own partition + shared_context only.

## WhatsApp routing
1. Check for @ mention at start of message: @strength, @running, @nutrition
   → strip tag, skip classifier, route direct to that agent
2. If no @ mention → call Router (Haiku classifier) to get agent list
3. Call selected agents in parallel via asyncio.gather
4. Strip memory JSON from each response
5. Post to WhatsApp prefixed with emoji label (💪 Strength:, 🏃 Running:, 🥗 Nutrition:)
6. Write memory JSON to SQLite

## What's stubbed vs live in Arc 1
LIVE: Strength agent, SQLite writes, memory strip, bridge stubs (print to console)
STUBBED: Router classifier, Running agent, Nutrition agent, @ mention for running/nutrition
Files marked "# Arc 2" are placeholders — do not implement unless explicitly asked.

## Running the project
cp .env.example .env          # add your API key
python db/init_db.py          # run once to create tables
python onboarding/onboard.py  # run once to seed Strength memory
docker-compose up             # start the service

## Things Claude Code should never do
- Hardcode the API key
- Write to ~/Documents or anywhere outside ~/fitcrew-workspace for data files
- Expose Docker ports beyond 127.0.0.1
- Modify the SQLite schema without being explicitly asked
- Implement Arc 2/3 features unless the task explicitly says so
- Use threads — this project uses asyncio throughout