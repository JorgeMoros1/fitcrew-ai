# FitCrew AI — Development Arc 5
**Goal:** LLM evaluation framework + RAG memory + observability dashboards + voice message support + engineering depth
**Builds on:** Arc 4 complete — agent consultation live, synthesizer routing path verified
**Timeline:** 2-3 focused weekends
**Definition of Done:** Router accuracy is measurable. Semantic memory retrieval works. A dashboard shows system health. Voice messages are transcribed and routed. CI passes on every push.

---

## What Arc 5 is NOT

- Not a mobile app or UI
- Not multi-user support
- Not a full Postgres migration (deferred — SQLite + ChromaDB is sufficient)

---

## Career ROI Framing

Arc 5 is the arc that converts FitCrew from a cool personal project into serious AI engineering work on a resume. The three highest-leverage additions per career coaching analysis:

1. **LLM evaluation framework** — most AI candidates can't speak to this at all
2. **RAG / semantic memory** — core expected skill for AI engineer roles
3. **Observability dashboards** — shows production systems thinking

Voice, CI/CD, shared log, and proactive check-ins round out the engineering depth.

---

## The Five Milestones

### Milestone 1 — LLM evaluation framework
**Done when:** You can run `python evals/run_evals.py` and get a printed report showing router accuracy, consultation routing accuracy, response quality scores, and results saved to a dated JSON file.

### Milestone 2 — RAG memory
**Done when:** "How have my squats progressed over the last 3 months?" returns a semantically retrieved summary grounded in actual session data, not just the last 30 turns of conversation history.

### Milestone 3 — Observability dashboard
**Done when:** A Grafana dashboard shows daily requests, agent usage distribution, token cost, latency, and failure rate — updating in real time from the running container.

### Milestone 4 — Voice message support
**Done when:** A WhatsApp voice note saying "ran 5k this morning, knee felt fine" gets transcribed, routed to the Running agent, and logged exactly as if typed.

### Milestone 5 — Engineering hardening
**Done when:** pytest suite passes in GitHub Actions on every push. Shared conversation log active. Proactive check-ins implemented (off by default).

---

## Before You Write Any Code

### Step 1 — Build the eval dataset
50+ labeled examples covering all routing paths. Only you can label ground truth. Do this before any code — it forces edge case thinking upfront.

Format per example:
```json
{
  "message": "hit 225 bench today",
  "expected_agents": ["strength"],
  "expected_mode": "normal",
  "expected_action": "log_session"
}
```

Cover: strength logs, run logs, nutrition questions, consultation questions (`expected_mode: "consult"`), off-topic (`expected_agents: []`), slang/casual phrasing.

Save as `evals/eval_dataset.json` — Claude Code uses this file in Task A.

### Step 2 — Decide on observability stack
Two options:
- **Prometheus + Grafana** — industry standard, more setup, Docker-native, best resume signal
- **Lightweight SQLite dashboard** — simpler, already have cost CSV, Flask route + charts

Recommendation: Prometheus + Grafana. Worth the setup for what it shows on a resume.

### Step 3 — Get OpenAI API key for Whisper
Pricing: ~$0.006/min — negligible for personal use. Add `OPENAI_API_KEY` to server `.env`.

---

## Task Breakdown

### 🔴 You must do this

| Task | Why | Est. time |
|------|-----|-----------|
| Build eval dataset (50+ examples) | Only you can label ground truth | 1-2 hrs |
| Decide Prometheus+Grafana vs lightweight | Architecture decision | 15 min |
| Get OpenAI API key, add to server .env | Credentials | 5 min |
| Test voice message end-to-end from phone | Only you can record the test | 15 min |
| Evaluate RAG response quality | Judgment call on retrieval relevance | Ongoing |

---

### 🟢 Delegate to Claude Code

#### Task A — LLM evaluation framework

```
Create evals/ directory with a router accuracy eval and a response quality eval.

Assumes evals/eval_dataset.json already exists (Jorge builds this manually).

evals/router_eval.py:
Function: async def run_router_eval(dataset_path='evals/eval_dataset.json') -> dict
For each example, calls classify_message() and compares result to expected.
Metrics:
  - overall_accuracy: correct / total
  - precision_per_agent: TP / (TP + FP) per agent label
  - recall_per_agent: TP / (TP + FN) per agent label
  - mode_accuracy: correct mode (normal/fanout/consult) / total
  - false_positive_rate: off-topic messages incorrectly routed
  - false_negative_rate: valid messages incorrectly dropped
Writes results to evals/results/router_YYYYMMDD_HHMMSS.json

evals/response_eval.py:
Function: async def run_response_eval(dataset_path, sample_size=20) -> dict
For a random sample of messages, calls the full agent pipeline and evaluates
the response using a Haiku judge call:
Judge prompt: "Rate this fitness coaching response on a scale of 1-5 for:
  - groundedness: does it reference specific data from the athlete's history?
  - instruction_following: does it follow coaching constraints (injuries, phase)?
  - conciseness: is it appropriately brief for WhatsApp?
Return JSON only: {groundedness: int, instruction_following: int, conciseness: int}"
Writes results to evals/results/response_YYYYMMDD_HHMMSS.json

evals/run_evals.py:
CLI entry point. Runs both evals and prints a summary report:

  === FitCrew AI Eval Report ===
  Router accuracy:  94% (47/50)
  Precision:        strength=0.96  running=0.91  nutrition=0.88
  Recall:           strength=0.95  running=0.93  nutrition=0.85
  Mode accuracy:    88% (normal/fanout/consult)
  Avg response:     groundedness=4.2  instruction_following=4.5  conciseness=3.8
  Results saved to: evals/results/

Add evals/results/ to .gitignore (results are local, not committed).
```

---

#### Task B — RAG memory with ChromaDB

```
Add semantic memory retrieval using ChromaDB.

Install chromadb, add to requirements.txt.

memory/embeddings.py:
Manages ChromaDB collections for strength and running data.
ChromaDB stored at /data/chroma/ — add to docker-compose volumes alongside /data/fitcrew.db.

Functions:
  index_strength_sessions():
    Reads all strength_sessions rows.
    Embeds each as: "{date} {exercise} {load_lbs}lbs {sets}x{reps} {notes}"
    Upserts to collection 'strength_sessions' with row id as document id.

  index_run_logs():
    Reads all run_logs rows.
    Embeds each as: "{date} {distance_km}km {duration_min}min HR {avg_hr} {notes}"
    Upserts to collection 'run_logs'.

  query_strength(query: str, n=5) -> str:
    Semantic search on strength_sessions collection.
    Returns top-n results formatted as text block.

  query_runs(query: str, n=5) -> str:
    Semantic search on run_logs collection.
    Returns top-n results formatted as text block.

  update_index_on_write(table: str, row: dict):
    Called after any new strength_sessions or run_logs insert.
    Adds the new row to the appropriate ChromaDB collection.

Add a one-time indexing script: python memory/embeddings.py --index-all
This seeds ChromaDB from existing DB data on first run.

Update agents/strength.py context assembly:
Add optional SEMANTIC_MEMORY section.
Trigger condition: message contains any of these keywords:
  "progress", "improve", "trend", "over", "last month", "last few months",
  "how have", "compare", "best", "peak", "history", "plateau"
If triggered: call query_strength(message, n=5), inject as SEMANTIC_MEMORY block.
Otherwise: skip (saves latency for normal session logs — do not add RAG to every call).

Update agents/running.py context assembly:
Same trigger pattern with retrospective keywords → query_runs(message, n=5).

Update memory/writer.py:
After writing to strength_sessions or run_logs, call update_index_on_write()
to keep ChromaDB in sync.

agents/nutrition.py: no RAG needed — cross-domain SQL reads already cover it.
```

---

#### Task C — Observability with Prometheus + Grafana

```
Add Prometheus metrics and a Grafana dashboard to the Docker stack.

Step 1 — Instrument service.py:
Install prometheus-client, add to requirements.txt.

Metrics to expose:
  fitcrew_requests_total        counter  labels: agent, mode
  fitcrew_latency_seconds       histogram labels: agent
  fitcrew_tokens_total          counter  labels: agent, model, direction (input|output)
  fitcrew_cost_usd_total        counter  labels: agent, model
  fitcrew_errors_total          counter  labels: agent, error_type
  fitcrew_rag_triggered_total   counter  labels: agent

Expose at GET /metrics (Flask route, prometheus_client multiprocess mode).

Step 2 — Add to docker-compose.yml:
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./monitoring/prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"
    restart: always

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    volumes:
      - grafana_data:/var/lib/grafana
    restart: always

Add grafana_data to volumes section.

Create monitoring/prometheus.yml:
  scrape_configs:
    - job_name: fitcrew
      static_configs:
        - targets: ['fitcrew:8000']

Step 3 — Create Grafana dashboard:
Create monitoring/grafana_dashboard.json with panels:
  - Requests per day by agent (bar chart, 24h window)
  - Agent usage distribution (pie chart, 7d window)
  - Latency p50 + p95 by agent (time series)
  - Token cost per day USD (time series)
  - Error rate (time series)
  - RAG trigger rate (counter)

Add to .env:
  GRAFANA_URL=http://178.156.243.64:3000

Note for Jorge: lock Grafana port 3000 in Hetzner firewall to your home IP only.
```

---

#### Task D — Voice message support

```
Add WhatsApp voice message transcription and routing.

Requires OPENAI_API_KEY in .env (Jorge adds this manually before this task).

Step 1 — Detect audio in webhook:
service.py currently only handles type='text'.
Add handling for type='audio' in the webhook payload parser.
Audio payload structure:
  message['type'] == 'audio'
  message['audio']['id'] == media_id

Step 2 — Download media from Meta API:
Function: async def download_whatsapp_media(media_id: str) -> bytes | None
  GET https://graph.facebook.com/v18.0/{media_id}
  Headers: Authorization: Bearer {WHATSAPP_BUSINESS_TOKEN}
  Response JSON contains 'url' field.
  GET {url} with same auth header → raw audio bytes.
  Return bytes or None on failure.

Step 3 — Transcribe with Whisper:
Install openai, add to requirements.txt.
Function: async def transcribe_audio(audio_bytes: bytes) -> str | None
  Write bytes to a temp file with .ogg extension.
  Call openai.audio.transcriptions.create(model="whisper-1", file=f)
  Return transcript string or None on failure.
  Clean up temp file in finally block.

Step 4 — Route transcript as text:
After transcription, treat the transcript exactly as a text message.
Log: VOICE TRANSCRIBED: sender={sender} transcript={transcript[:100]}
Pass through normal routing pipeline (mention check → classifier → agents).
If transcription fails:
  Post: "⚠️ Couldn't transcribe your voice message. Try typing it out."
  Return 200 to Meta.

Step 5 — Cost logging for Whisper:
Log each transcription to cost_log.csv:
  agent='transcription', model='whisper-1'
  Whisper pricing: $0.006 per minute. Estimate duration from bytes / 16000 (rough).
```

---

#### Task E — CI/CD + testing

```
Add pytest unit tests and a GitHub Actions pipeline.

tests/test_router.py:
Unit tests for router/mention.py and router/classifier.py.
Mock all Anthropic API calls — no real API calls in tests.
Test cases:
  - @strength at position 0 → stripped, agent='strength'
  - @running at position 0 → stripped, agent='running'
  - Mid-sentence @mention → not stripped, agent=None
  - classify_message mock returns correct agents for known messages
  - classify_message mock returns [] for off-topic → None returned

tests/test_writer.py:
Unit tests for memory/writer.py.
Use a temp SQLite DB (tmp file, deleted after test).
Test cases:
  - load_lbs alias: row with load_kg=100 → inserts as load_lbs=100
  - reps as list [12,8,7] → normalized to avg int, breakdown in notes
  - Unknown column name dropped silently
  - list data input → multiple rows inserted

tests/test_embeddings.py:
Unit tests for memory/embeddings.py.
Use a temp ChromaDB dir.
Test cases:
  - index_strength_sessions indexes rows correctly
  - query_strength returns results for a matching query
  - update_index_on_write adds new row to index

.github/workflows/ci.yml:
name: CI
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with: python-version: '3.11'
      - run: pip install -r requirements.txt
      - run: pytest tests/ -v

  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: docker build .

Add pytest, pytest-asyncio to requirements.txt.
```

---

#### Task F — Shared conversation log across agents

```
Add a cross-agent conversation log so agents have situational awareness
of what other agents have said recently.

New table in db/init_db.py (CREATE TABLE IF NOT EXISTS):
  shared_conversation_log:
    id INTEGER PRIMARY KEY AUTOINCREMENT
    agent TEXT NOT NULL
    role TEXT NOT NULL   (user | assistant)
    content TEXT NOT NULL
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP

After every agent response (normal mode only, not assessment mode):
Write user message + agent response to shared_conversation_log,
in addition to the existing per-agent conversation_history write.
Prune to last 20 rows total (not per agent) after each insert.

Update context assembly for all three agents:
Add RECENT_ACTIVITY section — last 10 rows from shared_conversation_log
(all agents combined), formatted as:
  [Strength, 2h ago] You: hit 225 bench today
  [Strength, 2h ago] Coach: Great session — +5 lbs from last week...
  [Running, 1h ago] You: ran 5k, knee felt fine
  [Running, 1h ago] Coach: Good news on the knee...

This gives agents situational awareness without requiring full cross-agent reads.

Add get_shared_conversation_log(limit=10) to memory/reader.py.
Add write_shared_conversation_turn(agent, user_msg, assistant_response) to memory/writer.py.
```

---

#### Task G — Proactive check-ins

```
Add daily proactive check-in messages when no activity is logged.

In cron/summarizer.py, add a daily job alongside the existing Sunday summarizer.

Daily check — runs every morning at 08:00 UTC:
  - If no strength_session logged in last 4 days AND
    shared_context.training_frequency is not null:
    Post: "💪 No session logged in 4 days — everything good?"

  - If no run_log in last 5 days AND
    run_summary indicates an active running phase:
    Post: "🏃 Haven't seen a run in 5 days. Intentional rest?"

Function: async def send_whatsapp_proactive(message: str)
Posts to YOUR_WHATSAPP_NUMBER using the same send_whatsapp_message() function.

Add to .env:
  PROACTIVE_CHECKINS=false
Default off — Jorge opts in by setting to true.
Read this env var before posting — if false, skip silently.
```

---

## Sequence to Follow

```
Before coding (you):
  └── Build eval dataset (evals/eval_dataset.json — 50+ examples)
  └── Get OpenAI API key, add to server .env
  └── Decide Prometheus+Grafana vs lightweight dashboard

Day 1 (delegate):
  └── Task A — eval framework
  └── Run evals on current Arc 4 state as baseline — save results

Day 1-2 (delegate):
  └── Task B — ChromaDB RAG
  └── Run: python memory/embeddings.py --index-all on server
  └── Test: "how have my squats progressed?" → semantic retrieval confirmed

Day 2-3 (delegate):
  └── Task C — Prometheus + Grafana
  └── Confirm dashboard shows real data after a few test messages
  └── Lock Grafana port in Hetzner firewall to your IP

Day 3 (delegate):
  └── Task D — voice message support
  └── Record test voice note from phone, confirm transcription + routing

Day 4 (delegate):
  └── Task E — CI/CD + testing
  └── Task F — shared conversation log
  └── Task G — proactive check-ins (leave PROACTIVE_CHECKINS=false)
```

---

## Definition of Done — Arc 5

- [ ] `evals/run_evals.py` runs and prints router + response quality report
- [ ] Eval dataset has 50+ labeled examples including consult mode
- [ ] Baseline eval results saved from Arc 4 state
- [ ] ChromaDB indexed with all strength_sessions and run_logs
- [ ] Retrospective queries trigger semantic retrieval ("how have my squats progressed?")
- [ ] ChromaDB stays in sync after new writes
- [ ] Prometheus metrics exposed at /metrics
- [ ] Grafana dashboard showing requests, latency, cost, errors
- [ ] Grafana port locked to your IP in Hetzner firewall
- [ ] Voice messages transcribed via Whisper and routed correctly
- [ ] Whisper failures post error message to WhatsApp
- [ ] pytest suite passing in GitHub Actions on every push
- [ ] Shared conversation log active — agents see last 10 cross-domain turns
- [ ] Proactive check-ins implemented (PROACTIVE_CHECKINS=false default)

---

## What Arc 6 adds

Postgres migration (enables pgvector natively, better concurrency, multi-user ready), simple predictive models (injury risk score from run_logs pain_flag trend, 1RM progression from strength_sessions, weekly weight change from nutrition_logs), structured data model refactor, onboarding flow for a second user.

---

*Based on FitCrew AI PRD v1.1 — Agent Architecture v2 — Arc 4 complete March 2026*
