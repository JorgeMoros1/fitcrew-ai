# FitCrew AI — Product Requirements Document v1.1

> WhatsApp-native multi-agent strength, running, and nutrition coaching system

| Field | Value |
|-------|-------|
| Product | FitCrew AI |
| Version | 1.1 |
| Author | Jorge |
| Date | March 2026 |
| Status | Draft |
| Priority | Personal / MVP |

---

## 1. Overview

FitCrew AI is a personal, WhatsApp-native multi-agent coaching system giving Jorge access to three specialized Claude-powered agents — Strength, Running, and Nutrition — through a single WhatsApp group chat. Each agent has a distinct persona, persistent structured memory, and responds only when a message is relevant to its domain.

The system runs locally inside a Docker container on Jorge's personal machine, with Tailscale for secure phone access. There is no cloud dependency, no third-party agent framework, and no UI beyond WhatsApp itself.

---

## 2. Problem Statement

Existing fitness tools are fragmented and stateless. Strength trackers don't inform nutrition decisions. Running apps don't know about injuries from the gym. AI assistants forget everything between sessions and give generic advice without accumulated context.

Jorge wants one conversational interface — WhatsApp — where three specialized agents know his full history, reason within their domain expertise, and challenge lazy or emotionally-driven thinking rather than validating it.

---

## 3. Goals & Non-Goals

### 3.1 Goals

- Three specialized agents accessible through one WhatsApp group chat
- Agents respond based on message relevance — no tagging or manual routing required
- Each agent stores only what is relevant to its domain; relevance decided by the agent itself post-response
- Nutrition agent has full read access to Strength and Running data for cross-domain reasoning
- All personal data stays local — no cloud storage of health information
- System costs under $10/month at heavy daily use
- Secure by design — Docker isolation, localhost binding, Tailscale-only access

### 3.2 Non-Goals (MVP)

| Out of Scope (MVP) | Rationale |
|-------------------|-----------|
| OpenClaw / third-party agent frameworks | Custom stack = full control, lower cost, smaller attack surface |
| Web dashboard or mobile app UI | WhatsApp IS the UI — no frontend needed |
| Vector DB / semantic search | SQLite structured tables + narrative summaries sufficient for personal use |
| Wearable / GPS auto-import (Garmin, Apple) | Manual chat logging for MVP; can add post-MVP |
| Voice note transcription | Text-only MVP; Whisper integration is post-MVP |
| Multi-user support | Single-user personal tool only |
| Agent-to-agent messaging | Nutrition reads from DB directly — no inter-agent API calls needed |

---

## 4. Agent Definitions

Each agent is a Claude API call with a dedicated system prompt, its own SQLite memory partition, and a clearly scoped domain. The router determines which agents receive each message. Multiple agents can respond in parallel when a message spans domains.

| Agent | Persona & Role | Memory Scope | DB Access |
|-------|---------------|--------------|-----------|
| 💪 Strength | Unified, stateful, adaptive load-management system optimizing hypertrophy under injury constraints. Programs sets, reps, and load; adjusts for active injuries; tracks progressive overload over time. | All lifts + loads + dates, active injuries + affected movements, program phase, PRs, deload history | Private partition + read from shared_context |
| 🏃 Running | Performance and injury-management coach. Uses manually logged run data (distance, pace, HR, pain level, notes) to guide gradual progression and risk control. Proactively parses structured data from natural language logs. | All run logs (structured), injury flags + body part, pain trend, weekly mileage, pace progression | Private partition + read from shared_context |
| 🥗 Nutrition | Evidence-based fitness reasoning partner. Analyzes training load, bodyweight, and physique trends to guide bulking and cutting decisions. Actively challenges emotional reactions and anchoring bias. Never gives advice without data. | Body weight log, physique notes, calorie/macro targets, bulk/cut phase + rationale, emotional flags | Private partition + full read across ALL agents |

---

## 5. Memory Relevance Filtering

Each agent independently decides what to persist from a message after generating its response. The agent evaluates whether any information meaningfully affects its future reasoning. Information with no bearing on the agent's domain is discarded and never written to memory.

This decision is made via a post-response memory prompt embedded in each agent's system prompt: given this exchange, what (if anything) should be stored? The agent returns a structured JSON object or null. A null response means nothing is written. The agent never stores information just because it was mentioned — only because it will change future advice.

### 5.1 Relevance Decision Examples

| Message / Signal | 💪 Strength | 🏃 Running | 🥗 Nutrition |
|-----------------|-------------|------------|--------------|
| "I'm bulking" | Store — affects load targets | Store — affects risk tolerance | Store — core to decision-making |
| "My strength numbers are increasing" | Store — progressive overload log | Not relevant | Store — informs cut/bulk timing |
| "My left knee has been sore" | Store — injury constraint | Store — injury flag | Not relevant |
| "I've been sleeping 5hrs a night" | Store — affects load mgmt | Store — recovery/injury risk | Not relevant |
| "My dog is brown" | Discard | Discard | Discard |
| "Ran 8km, HR 158 avg, knee tight mile 3" | Not relevant | Store — full structured log | Store — training volume + injury |
| "Hit 225 bench 3x5 today" | Store — lift log + PR check | Not relevant | Store — training volume |
| "I feel like I'm getting fat" | Not relevant | Not relevant | Store — emotional signal to challenge |

**Shared context propagation:** any agent can write to the shared_context table when it receives new ground-truth information. If Jorge tells the Strength agent he started a bulk, Strength writes that to shared_context so Nutrition and Running read it on their next invocation — Jorge never needs to repeat himself across agents.

---

## 6. Data Model

### 6.1 SQLite Schema

All data is stored in a single SQLite file inside the Docker volume at `~/fitcrew-workspace/fitcrew.db`. Tables are partitioned by agent. Nutrition has read access to all tables. Strength and Running have read/write access only to their own partition plus shared_context.

| Table | Scope | Key Fields |
|-------|-------|------------|
| strength_sessions | Strength (private) | date, exercise, sets, reps, load_kg, rpe, notes |
| strength_injuries | Strength (private) | date_onset, body_part, affected_movements, severity (1-5), status (active/resolved) |
| strength_summary | Strength (private) | Long-term narrative summary, updated weekly |
| run_logs | Running (private) | date, distance_km, duration_min, avg_hr, max_hr, pain_flag (bool), pain_body_part, pain_level (1-5), notes |
| run_summary | Running (private) | Long-term narrative summary, updated weekly |
| nutrition_log | Nutrition (private) | date, body_weight_kg, physique_notes, calorie_target, macro_split, phase (bulk/cut/maintain), emotional_flags |
| nutrition_summary | Nutrition (private) | Long-term narrative summary, updated weekly |
| shared_context | Read/write ALL | current_phase, goal, body_weight_kg (latest), active_injuries (JSON array), training_frequency |

### 6.2 Run Log NLP Extraction

Since Jorge logs runs in natural language via WhatsApp, the Running agent includes a secondary Haiku call after each run-related message to parse free text into a structured run_logs row. Fields that cannot be resolved from the message are stored as null — the agent never fabricates values.

| Natural language log | Parsed structured output |
|---------------------|--------------------------|
| "ran 8k this morning, knee got tight around mile 3, HR felt high" | distance_km=8, pain_flag=true, pain_body_part=knee, pain_level=2 (inferred), notes='tight around mile 3', avg_hr=null |
| "easy 5k, felt great, no issues, finished in 28 mins" | distance_km=5, duration_min=28, pain_flag=false, notes='easy effort, felt great' |
| "skipped run, knee still bad" | No run_log entry. Running agent appends injury reinforcement to run_summary. shared_context injury array updated. |

---

## 7. System Architecture

| Layer | Technology | Role |
|-------|-----------|------|
| WhatsApp Interface | whatsapp-mcp (personal) or WhatsApp Business API | Message ingestion and response delivery |
| Router / Classifier | Python service — single Haiku call per message | Returns list of relevant agent IDs (1-3) |
| Agent Layer | 3 Claude API agents with dedicated system prompts | Parallel responses to WhatsApp group |
| Memory — Write | Each agent decides what to store post-response | Writes to its own SQLite partition; updates shared_context if applicable |
| Memory — Read | SQLite: private partitions + shared_context | Nutrition reads all tables; Strength + Running read own + shared |
| Run NLP Extraction | Haiku call inside Running agent post-response | Parses free-text run logs into structured run_logs rows |
| Container | Docker, bound to 127.0.0.1 | Isolation; only ~/fitcrew-workspace volume mounted |
| Remote Access | Tailscale VPN | Secure phone to local machine tunnel; no open ports |

### 7.1 Message Flow

1. Jorge sends a message to the WhatsApp group
2. Python router makes one Haiku classifier call and receives a list of relevant agent IDs, e.g. `["strength", "nutrition"]`
3. Each selected agent is called in parallel with: system prompt + long-term summary + rolling window (30 msgs) + shared_context snapshot + new message
4. Each agent generates its response and posts it to the WhatsApp group prefixed with its label (e.g. 💪 Strength:)
5. Post-response: each agent evaluates what to store, writes to its SQLite partition, and updates shared_context if applicable
6. Running agent additionally runs NLP extraction if the message contained a run log

### 7.2 Nutrition Cross-Agent Read

When Nutrition is invoked, its context includes its private partition (nutrition_log, nutrition_summary) plus a structured snapshot from strength_sessions (last 4 weeks of volume) and run_logs (last 4 weeks of mileage and injury flags), plus the full shared_context row. This gives Nutrition the complete training load context it needs to reason about caloric needs and phase timing without Jorge having to re-explain his training.

---

## 8. Memory Architecture

| Memory Type | Contents | Trigger | Purpose |
|------------|----------|---------|---------|
| Rolling Window | Last 30 exchanges per agent | Always-on per message | Immediate conversational context |
| Long-term Summary | Compressed narrative per agent | Weekly Haiku cron job | Persistent persona and history |
| Structured Event Log | Lifts, runs, body weight as typed rows | Post-response extraction | Queryable history for trends |
| Shared Context | Phase, goal, weight, active injuries | Updated when any agent writes it | Cross-agent consistency |
| Onboarding Seed | One-time intake per agent at first run | Manual setup | Cold-start memory |

### 8.1 Onboarding

On first run, a setup script conducts a structured intake conversation per agent to seed initial memory. Each agent asks only what it needs:

- **Strength:** current program, training days per week, recent PRs (squat/bench/deadlift), any active injuries
- **Running:** recent weekly mileage, any active injuries, current goal (base building, race prep, casual)
- **Nutrition:** current body weight, goal, current phase (bulk/cut/maintain), calorie target if known

### 8.2 Weekly Summarization

A cron job runs every Sunday night. For each agent, it passes the last 7 days of exchanges plus the structured event log to Haiku with a compression prompt. The resulting narrative replaces the previous long-term summary. The rolling window is cleared post-summarization. This keeps token counts stable indefinitely regardless of how long the system has been running.

---

## 9. Security Model

- Docker container with explicit volume mount to `~/fitcrew-workspace` only — no home directory access
- Bound to `127.0.0.1` — never reachable from LAN or internet directly
- Tailscale for phone access — no port forwarding, no publicly exposed endpoints
- No third-party skills or plugins — all code is Jorge's own and reviewed
- Agents have no exec, shell, or filesystem tool access — SQLite read/write only, scoped to their partition
- Claude API calls are the only outbound internet traffic — all prompts are explicitly constructed in code
- SQLite file lives inside the Docker volume, not in ~/Documents or any cloud-synced folder

---

## 10. Cost Model

| Task | Volume | Est. Cost | Notes |
|------|--------|-----------|-------|
| Routing classifier (Haiku) | ~20 msgs/day | ~$0.03/day | One call per inbound message |
| Agent responses (Haiku) | ~20 msgs x 1-3 agents | ~$0.08/day | Parallel agent calls |
| Run NLP extraction (Haiku) | ~5 runs/week | ~$0.01/week | Structured parse of run logs |
| Weekly summaries (Haiku) | 3 agents x weekly | ~$0.02/week | Memory compression |
| Complex responses (Sonnet) | 2-3x/month | ~$0.15-0.30/use | Full programs, bulk/cut analysis |
| **Total (heavy daily use)** | — | **~$4-7/month** | Well within personal budget |

**Model strategy:** `claude-haiku-4-5` handles all routing, daily Q&A, run extraction, and weekly summaries. `claude-sonnet-4-6` is used only when Jorge explicitly asks for something complex — a new training block, a full bulk/cut analysis, or a multi-week running plan. A keyword flag or explicit trigger phrase in the router upgrades the model for those calls only.

---

## 11. User Stories

### Strength Agent
- "My left shoulder has been clicking on overhead press — what do I do?" → injury-constrained movement swap with load guidance
- "Hit 225 bench 3x5 today" → logged, progressive overload assessed, next session target suggested
- "Design me a 4-day hypertrophy block, I can't do anything overhead right now" → full program respecting active injury constraint
- "Should I deload this week?" → decision grounded in actual training log, not generic rule of thumb

### Running Agent
- "Ran 8k this morning, HR around 160, left knee got tight at mile 3" → structured log stored, injury flagged, next run guidance adjusted
- "Is it safe to increase mileage this week?" → answer based on logged progression over prior weeks, not the 10% rule in isolation
- "I haven't run in 10 days, how do I ease back in?" → return-to-run protocol grounded in last logged state and injury history

### Nutrition Agent
- "I feel like I'm getting fat" → agent challenges the emotional read, requests body weight data before drawing any conclusion
- "Should I start cutting?" → analyzes 4 weeks of training volume, body weight trend, and current phase before responding
- "I've been eating 2200 calories, is that enough?" → cross-references training load from Strength and Running logs to assess adequacy
- "I want to bulk aggressively" → pushes back with trajectory data, proposes a specific rate-of-gain target with rationale

---

## 12. Implementation Milestones

| Timeline | Phase | Work | Exit Criteria |
|----------|-------|------|---------------|
| Week 1 | Foundation | Docker + whatsapp-mcp bridge + single Claude API call from WhatsApp working end-to-end | Working echo bot in WhatsApp |
| Week 2 | Agents | Router/classifier, 3 agents with system prompts, SQLite rolling window, parallel responses posted to group | Multi-agent group chat |
| Week 3 | Memory | Onboarding flow, per-agent relevance filtering, structured event logging, shared_context table, run NLP extraction | Persistent stateful memory |
| Week 4 | Polish | Weekly summarizer cron, Nutrition cross-agent read layer, error handling, cost monitoring, README | Production-ready personal use |

---

## 13. Risks & Mitigations

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| WhatsApp ToS ban (personal MCP) | Medium | Business API as fallback; personal use ban risk is low in practice |
| Running agent quality degrades without logging | High | Agent prompts encourage consistent logging; proactively asks if no run log in 5 days |
| Nutrition challenges without sufficient data | Medium | Nutrition refuses directional advice until body weight + training data exists in DB |
| Shared context staleness (injuries, phase) | Medium | Any agent can update shared_context; weekly summary cron validates consistency |
| API cost overrun | Low | Haiku default; Sonnet only on explicit complex requests; monthly cap in Anthropic dashboard |
| Local machine downtime | Medium | Acceptable for personal use MVP; Raspberry Pi or Mac Mini migration is post-MVP option |

---

## 14. Success Metrics

- Jorge messages the group daily for 30+ consecutive days
- Agents reference stored history accurately in 80%+ of responses (spot-checked manually)
- Running agent successfully parses 90%+ of natural language run logs into structured rows
- Nutrition agent challenges at least one emotionally-driven statement per week with objective data
- Monthly API cost stays under $10
- Zero security incidents — no exposed endpoints, no unauthorized access to personal data

---

## 15. Open Questions

- Personal WhatsApp MCP vs. WhatsApp Business API — what is Jorge's tolerance for the ToS grey area on the personal account path?
- Should any agent send proactive messages? E.g. Running flags if no run log in 5 days; Nutrition flags if no body weight logged in a week.
- Long-term hosting: laptop works for MVP but introduces downtime. Raspberry Pi or Mac Mini post-MVP?
- Post-MVP: Garmin or Apple Health auto-import to remove run logging friction once the habit is established.
- Post-MVP: agent prompt workshopping — initial system prompts will need iteration based on real response quality over first 2-4 weeks.
- Post-MVP: image input via WhatsApp — progress photos parsed by Nutrition agent as physique notes, handwritten lift logs parsed by Strength agent into strength_sessions rows. Requires media download handling in the bridge layer and base64 image passing in agent calls. Vision support already native in Claude API.