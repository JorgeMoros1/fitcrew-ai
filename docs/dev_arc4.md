# FitCrew AI — Development Arc 4
**Goal:** Agent consultation architecture + LLM evaluation framework + RAG memory + observability dashboards + voice message support
**Builds on:** Arc 3 complete — Nutrition agent live, cross-domain reads, weekly summarizer, cost logging, error handling, dedup guard, schema cleanup
**Timeline:** 2-3 focused weekends
**Definition of Done:** Agents consult each other and return one unified response. Router accuracy is measurable. Semantic memory retrieval works. A dashboard shows system health. Voice messages are transcribed and routed.

---

## What Arc 4 is NOT

- Not a mobile app or UI
- Not multi-user support
- Not a hosted SaaS product
- Not a full Postgres migration (deferred — SQLite + pgvector extension is sufficient for RAG)

---

## Career ROI Framing

Arc 4 is the arc that converts FitCrew from a cool personal project into serious AI engineering work. The three highest-leverage additions per career coaching analysis:

1. **LLM evaluation framework** — most AI candidates can't speak to this at all
2. **RAG / semantic memory** — core expected skill for AI engineer roles
3. **Observability dashboards** — shows production systems thinking

Agent consultation is the headline product feature. Eval + RAG + observability are the engineering depth that makes interviews go well.

---

## The Five Milestones

### Milestone 1 — Agent consultation
**Done when:** "Should I run or lift tomorrow?" returns one unified response that references both your last strength session and last run log. The synthesizer is visibly grounding its answer in real data.

### Milestone 2 — LLM evaluation framework
**Done when:** You can run `python evals/run_evals.py` and get a printed report showing router accuracy, response quality scores, and any regressions from the last run.

### Milestone 3 — RAG memory
**Done when:** "How have my squats progressed over the last 3 months?" returns a semantically retrieved summary grounded in actual session data, not just the last 30 turns of conversation history.

### Milestone 4 — Observability dashboard
**Done when:** A local Grafana dashboard (or lightweight alternative) shows daily requests, agent usage distribution, token cost, latency, and failure rate — updating in real time.

### Milestone 5 — Voice message support
**Done when:** You can send a WhatsApp voice note saying "ran 5k this morning, knee felt fine" and it gets transcribed, routed to the Running agent, and logged exactly as if you had typed it.

---

## Before You Write Any Code

### Step 1 — Decide on vector DB
Two viable options given current SQLite stack:

- **ChromaDB** — easiest to add, runs embedded (no new server), Python-native, good for getting started fast
- **pgvector** — requires migrating to Postgres, more production-grade, enables future multi-user

Recommendation: ChromaDB for Arc 4. Postgres migration is a clean Arc 5 project if needed.

### Step 2 — Get a Whisper API key
OpenAI Whisper API is the transcription layer for voice messages. Pricing: ~$0.006/min — negligible for personal use. Set `OPENAI_API_KEY` in `.env`.

### Step 3 — Decide on observability stack
Two options:

- **Prometheus + Grafana** — industry standard, more setup, runs in Docker alongside the app
- **Lightweight SQLite dashboard** — simpler, already have the cost CSV, build a Flask route that renders charts

Recommendation: Prometheus + Grafana for the resume signal. Worth the setup.

---

## Task Breakdown

### 🔴 You must do this

| Task | Why | Est. time |
|------|-----|-----------|
| Choose ChromaDB vs pgvector | Architecture decision | 15 min |
| Get OpenAI API key for Whisper | Only you have access | 5 min |
| Add `OPENAI_API_KEY` to server `.env` | Credentials | 5 min |
| Build eval dataset (50+ labeled examples) | Only you can label ground truth | 1-2 hrs |
| Test consultation from phone | Only you can send the test | 20 min |
| Test voice message end-to-end | Only you can record the test | 15 min |

---

### 🟢 Delegate to Claude Code

#### Task A — Agent consultation architecture

```
Implement agent consultation — a new routing path for cross-domain synthesis questions.

Consultation intent examples:
"should I run or lift tomorrow"
"am I recovered enough to train"
"is my nutrition supporting my training load"
"what should I do today"
"how is my overall progress"

Step 1 — Update router/classifier.py:
Add a new return type: {"agents": [...], "model": "sonnet", "mode": "consult"}
Mode "consult" means: call agents in assessment mode, then synthesize.
Mode "fanout" (existing) means: call agents independently, post both responses.
Consultation triggers when 2+ agents are relevant AND the question requires
a single unified answer rather than parallel independent responses.

Step 2 — Add assessment mode prompts:
Create prompts/strength_assessment.md and prompts/running_assessment.md
and prompts/nutrition_assessment.md.
Assessment mode prompt: same context as normal but different instruction.
Instead of "respond to the user via WhatsApp", instruct:
"Return a JSON assessment block only. No WhatsApp formatting. Fields:
  recommendation: str (1-2 sentences)
  data_points: list[str] (specific numbers from memory that informed this)
  constraints: list[str] (active injuries, flags, limitations)
  confidence: 'high' | 'medium' | 'low'
"

Step 3 — Add assessment mode to each agent:
agents/strength.py, agents/running.py, agents/nutrition.py
Add optional parameter: mode='normal' | 'assessment'
If mode='assessment', load assessment prompt instead of normal system prompt.
Return raw JSON only, no memory block needed.

Step 4 — Create agents/synthesizer.py:
Function: async def synthesize(message: str, assessments: dict) -> str
assessments = {"strength": {...}, "running": {...}, "nutrition": {...}}
Makes one Sonnet call with all assessments assembled into context.
System prompt: "You are a head coach synthesizing input from specialist coaches.
Given the athlete's question and the assessments below, write one clear,
direct response in WhatsApp format. Reference specific data points from
the assessments. Do not hedge — give a concrete recommendation."
Returns clean WhatsApp-formatted response string (no memory block needed).

Step 5 — Update service.py:
Add consultation path alongside existing single-agent and fan-out paths:
if mode == "consult":
    assessments = await asyncio.gather(all relevant agents in assessment mode)
    response = await synthesize(message, assessments)
    post response with "🤖 FitCrew:" prefix (not agent-specific)
```

---

#### Task B — LLM evaluation framework

```
Create evals/ directory with a router accuracy eval and a response quality eval.

evals/dataset.py:
Define an eval dataset as a list of dicts:
[
  {
    "message": "hit 225 bench today",
    "expected_agents": ["strength"],
    "expected_mode": "normal",
    "expected_action": "log_session"
  },
  {
    "message": "should I run or lift tomorrow",
    "expected_agents": ["strength", "running"],
    "expected_mode": "consult",
    "expected_action": "consultation"
  },
  ...
]
Build at least 50 examples covering: strength logs, run logs, nutrition questions,
consultation questions, off-topic (expected_agents=[]), slang/casual phrasing.
Store as evals/eval_dataset.json.

evals/router_eval.py:
Function: async def run_router_eval(dataset) -> dict
For each example, calls classify_message() and compares result to expected.
Metrics:
  - overall_accuracy: correct / total
  - precision_per_agent: TP / (TP + FP) per agent
  - recall_per_agent: TP / (TP + FN) per agent
  - mode_accuracy: correct mode (normal/fanout/consult) / total
  - false_positive_rate: off-topic messages incorrectly routed
  - false_negative_rate: valid messages incorrectly dropped
Writes results to evals/results/router_YYYYMMDD.json

evals/response_eval.py:
Function: async def run_response_eval(dataset, sample_size=20) -> dict
For a random sample of messages, calls the full agent pipeline and evaluates
the response using a Haiku judge call:
Judge prompt: "Rate this fitness coaching response on a scale of 1-5 for:
  - groundedness: does it reference specific data from the athlete's history?
  - instruction_following: does it follow the coaching constraints (injuries, phase)?
  - conciseness: is it appropriately brief for WhatsApp?
Return JSON only: {groundedness: int, instruction_following: int, conciseness: int}"
Writes results to evals/results/response_YYYYMMDD.json

evals/run_evals.py:
CLI entry point. Runs both evals and prints a summary report:
  Router accuracy: 94% (47/50)
  Precision: strength=0.96, running=0.91, nutrition=0.88
  Recall: strength=0.95, running=0.93, nutrition=0.85
  Mode accuracy: 88%
  Avg response scores: groundedness=4.2, instruction_following=4.5, conciseness=3.8
  Full results saved to evals/results/
```

---

#### Task C — RAG memory

```
Add semantic memory retrieval using ChromaDB.

Install chromadb and add to requirements.txt.

memory/embeddings.py:
Manages a ChromaDB collection per agent (strength_sessions_vdb, run_logs_vdb).
Functions:
  - index_strength_sessions(): reads all strength_sessions rows, embeds
    each as "{date} {exercise} {load_lbs}lbs {sets}x{reps} {notes}",
    upserts to ChromaDB with row id as document id
  - index_run_logs(): reads all run_logs rows, embeds each as
    "{date} {distance_km}km {duration_min}min HR {avg_hr} {notes}",
    upserts to ChromaDB
  - query_strength(query: str, n=5) -> str: semantic search, returns
    top-n matching sessions as formatted text block
  - query_runs(query: str, n=5) -> str: semantic search, returns
    top-n matching run logs as formatted text block
  - update_index_on_write(): called after any new session/run write to
    keep the index in sync

ChromaDB collection stored at /data/chroma/ (add to docker-compose volume mount).

Update agents/strength.py context assembly:
Add SEMANTIC_MEMORY section — called only when the message contains
retrospective keywords: "progress", "improve", "trend", "over", "last month",
"how have", "compare", "best", "peak", "history"
If triggered: call query_strength(message, n=5) and inject as SEMANTIC_MEMORY block.
Otherwise: skip (saves latency for normal session logs).

Update agents/running.py context assembly:
Same pattern with retrospective keywords → query_runs().

Update agents/nutrition.py:
Cross-domain load already uses structured SQL queries — no RAG needed here.
Nutrition RAG deferred to Arc 5 if needed.
```

---

#### Task D — Observability with Prometheus + Grafana

```
Add Prometheus metrics and Grafana dashboard to the Docker stack.

Step 1 — Instrument service.py with prometheus_client:
Install prometheus-client, add to requirements.txt.
Metrics to expose:
  - fitcrew_requests_total (counter, labels: agent, mode)
  - fitcrew_latency_seconds (histogram, labels: agent)
  - fitcrew_tokens_total (counter, labels: agent, model, type=input|output)
  - fitcrew_cost_usd_total (counter, labels: agent, model)
  - fitcrew_errors_total (counter, labels: agent, error_type)
  - fitcrew_rag_triggered_total (counter, labels: agent)
Expose metrics at /metrics endpoint (Flask route).

Step 2 — Add prometheus and grafana to docker-compose.yml:
  prometheus:
    image: prom/prometheus
    volumes:
      - ./monitoring/prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
    volumes:
      - grafana_data:/var/lib/grafana

Create monitoring/prometheus.yml scraping fitcrew app at port 8000.

Step 3 — Create Grafana dashboard JSON:
Dashboard panels:
  - Requests/day by agent (bar chart)
  - Agent usage distribution (pie chart)
  - Latency p50/p95 by agent (time series)
  - Token cost per day (time series)
  - Error rate (time series)
  - RAG trigger rate (counter)
Save as monitoring/grafana_dashboard.json for import.

Grafana accessible at http://178.156.243.64:3000 (add to .env as GRAFANA_URL).
Lock down with Hetzner firewall rule — only accessible from your IP.
```

---

#### Task E — Voice message support

```
Add WhatsApp voice message handling to service.py.

Step 1 — Detect audio messages in webhook:
Current code only processes type='text'. Add handling for type='audio'.
Audio webhook payload contains: id (media_id), mime_type (audio/ogg; codecs=opus).

Step 2 — Download audio from Meta media API:
Function: async def download_whatsapp_media(media_id: str) -> bytes
GET https://graph.facebook.com/v18.0/{media_id}
→ returns JSON with url field
GET {url} with Authorization: Bearer {token}
→ returns raw audio bytes
Return bytes.

Step 3 — Transcribe with Whisper:
Install openai, add to requirements.txt.
Add OPENAI_API_KEY to .env.
Function: async def transcribe_audio(audio_bytes: bytes) -> str | None
Writes bytes to a temp file as .ogg
Calls openai.Audio.transcribe("whisper-1", file)
Returns transcript string or None on failure.

Step 4 — Route transcript as text:
After transcription, treat the transcript exactly as an incoming text message.
Log it: VOICE TRANSCRIBED: {transcript[:100]}
Pass through normal routing pipeline unchanged.
If transcription fails, post: "⚠️ Couldn't transcribe your voice message. Try typing it out."

Add OPENAI_API_KEY to cost logging — log Whisper usage separately in cost_log.csv
with agent='transcription', model='whisper-1'.
```

---

#### Task F — CI/CD + testing

```
Add basic test coverage and GitHub Actions pipeline.

tests/test_router.py:
Unit tests for router/mention.py and router/classifier.py.
Test cases:
  - @strength prefix is stripped correctly
  - Mid-sentence @mention is ignored
  - classify_message returns correct agent for known message types
  - Empty result returned for off-topic messages
Use pytest with mocked Anthropic API calls (no real API calls in tests).

tests/test_writer.py:
Unit tests for memory/writer.py.
Test cases:
  - load_lbs alias works for load_kg input
  - reps list is normalized to int average
  - Unknown column names are dropped silently
  - list input iterates correctly

.github/workflows/ci.yml:
On push to main:
  - Run pytest
  - Build Docker image (confirm it builds cleanly)
  - No deploy step — manual deploy ritual stays as-is for now

Add pytest and pytest-asyncio to requirements.txt (dev only — can split
into requirements-dev.txt if preferred).
```

---

#### Task G — Shared conversation log across agents

```
Add a cross-agent conversation log so agents can see what other agents have said.

New table in db/init_db.py:
  shared_conversation_log:
    id INTEGER PRIMARY KEY AUTOINCREMENT
    agent TEXT NOT NULL
    role TEXT NOT NULL  (user | assistant)
    content TEXT NOT NULL
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP

After every agent response, write the user message and agent response to
shared_conversation_log in addition to the per-agent conversation_history.
Keep last 20 rows total (not per agent) — prune oldest on insert.

Update context assembly for all three agents:
Add RECENT_ACTIVITY section showing last 10 rows from shared_conversation_log
(all agents combined), formatted as:
  [Strength 2h ago] User: hit 225 bench today
  [Strength 2h ago] Coach: Great session...
  [Running 1h ago] User: ran 5k, knee felt fine
  [Running 1h ago] Coach: Good news on the knee...

This gives agents situational awareness of what happened recently across domains.
```

---

#### Task H — Proactive check-ins

```
Add proactive check-in messages when no activity is logged.

In cron/summarizer.py (already exists), add a daily check alongside the
Sunday summarizer:

Daily check (runs every morning at 08:00 UTC):
  - If no strength_session in last 4 days AND last session wasn't a rest day:
    post to WhatsApp: "💪 Strength: No session logged in 4 days — everything good?"
  - If no run_log in last 5 days AND run_summary indicates active running phase:
    post to WhatsApp: "🏃 Running: Haven't seen a run in 5 days. Intentional rest?"

Function: async def send_whatsapp_proactive(message: str)
Uses same WhatsApp send logic as agents — posts to YOUR_WHATSAPP_NUMBER.

Add proactive check-in toggle to .env:
PROACTIVE_CHECKINS=true|false
Default false — opt in explicitly.
```

---

## Sequence to Follow

```
Before coding (you):
  └── Decide ChromaDB vs pgvector
  └── Get OpenAI API key, add to server .env
  └── Build eval dataset (50+ labeled examples) — do this first, it forces
      you to think about edge cases before building features
  └── Decide Prometheus+Grafana vs lightweight dashboard

Day 1 (delegate):
  └── Task B — eval framework (do this before consultation so you can measure it)
  └── Run evals on current Arc 3 state as baseline

Day 1-2 (delegate):
  └── Task A — agent consultation architecture
  └── Rebuild and test: "should I run or lift tomorrow?" → one unified response
  └── Re-run evals to confirm consultation routing accuracy

Day 2-3 (delegate):
  └── Task C — RAG memory
  └── Test: "how have my squats progressed?" → semantic retrieval in response

Day 3 (delegate):
  └── Task D — Prometheus + Grafana
  └── Confirm dashboard shows real data after a few test messages

Day 3-4 (delegate):
  └── Task E — voice message support
  └── Record a test voice note from phone, confirm transcription + routing

Day 4 (delegate):
  └── Task F — CI/CD + testing
  └── Task G — shared conversation log
  └── Task H — proactive check-ins (toggle off by default)
```

---

## Definition of Done — Arc 4

- [ ] "Should I run or lift tomorrow?" returns one unified synthesizer response grounded in both agents' data
- [ ] Assessment mode prompts exist for all three agents
- [ ] `evals/run_evals.py` runs and prints router accuracy + response quality scores
- [ ] Eval dataset has 50+ labeled examples
- [ ] Router accuracy baseline established from Arc 3 state
- [ ] ChromaDB indexed with all strength_sessions and run_logs
- [ ] Retrospective queries trigger semantic retrieval ("how have my squats progressed?")
- [ ] Prometheus metrics exposed at /metrics
- [ ] Grafana dashboard showing requests, latency, cost, errors
- [ ] Voice messages transcribed via Whisper and routed correctly
- [ ] pytest suite passing in GitHub Actions on every push
- [ ] Shared conversation log active — agents see recent cross-domain activity
- [ ] Proactive check-ins implemented (toggle in .env, default off)

---

## What Arc 5 adds

Postgres migration (enables pgvector natively, better for future multi-user), simple predictive models (injury risk score from run_logs pain_flag trend, 1RM progression model from strength_sessions), structured data model refactor, onboarding flow for a second user.

---

*Based on FitCrew AI PRD v1.1 — Agent Architecture v2 — Arc 3 complete March 2026*
