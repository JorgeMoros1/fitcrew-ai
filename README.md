# FitCrew AI

A personal, WhatsApp-native multi-agent fitness coaching system. Three specialized Claude-powered agents — Strength, Running, and Nutrition — live in a single WhatsApp group chat and respond based on message relevance. No app. No dashboard. Just WhatsApp.

Built for personal use. Runs locally. Costs ~$4-7/month.

---

## How it works

You message a WhatsApp group. The right agent responds.

```
You:         hit 225 bench 3x5 today
💪 Strength: PR on bench — previous best was 220x5. Next session target: 227.5kg for 3x5.
             Current weekly volume is up 12% from last month, recovery looks solid.

You:         @nutrition should I be eating more given my training load?
🥗 Nutrition: Based on your last 4 weeks — avg 4 lifting sessions/week, ~25km running —
              your TDEE is closer to 3,200. At 2,800 calories you're in a deficit.
              Is that intentional given your current cut?

You:         ran 8k this morning, knee got tight around mile 3
🏃 Running:  Logged. That's the third time this month knee tightness has appeared
             sub-30min. Flagging as a pattern — recommend keeping next run under 6k
             and monitoring. Hold off on the mileage increase this week.
```

Each agent has persistent memory. They remember your history, track your numbers, and give advice grounded in your actual data — not generic rules.

---

## Agents

| Agent | Role |
|-------|------|
| 💪 Strength | Load management, progressive overload tracking, injury-constrained programming |
| 🏃 Running | Mileage progression, injury risk, NLP parsing of natural language run logs |
| 🥗 Nutrition | Bulk/cut decisions, caloric adequacy, cross-references training load from other agents |
| 🔀 Router | Classifies each message and routes to the right agent(s) — runs silently |

### Routing

Prefix a message with `@strength`, `@running`, or `@nutrition` to route directly to one agent, skipping the classifier entirely.

```
@nutrition should I cut?     → only Nutrition responds, classifier skipped
ran 8k this morning          → classifier runs, routes to Running (and Nutrition if relevant)
@strength design me a block  → only Strength responds, upgraded to Sonnet automatically
```

---

## Architecture

```
WhatsApp (your phone)
      ↓
WhatsApp Bridge (whatsapp-mcp or Business API)
      ↓
Python Service (service.py)
  ├── @ mention check → direct route if matched
  ├── Router (Haiku) → classify message if no @ mention
  ├── Agent calls (parallel via asyncio)
  │   ├── 💪 Strength (Haiku / Sonnet*)
  │   ├── 🏃 Running  (Haiku / Sonnet*) + NLP extraction sub-call
  │   └── 🥗 Nutrition (Haiku / Sonnet*) — reads all agent data
  ├── Memory strip → remove JSON block from response
  ├── SQLite write → persist structured memory
  └── Post to WhatsApp → prefixed with agent emoji label
      ↓
SQLite (~/fitcrew-workspace/fitcrew.db)
```

*Sonnet used only when a complex request is explicitly triggered (full programs, bulk/cut analysis, multi-week plans). Haiku handles everything else.*

### Memory

Each agent maintains:
- **Rolling window** — last 30 exchanges
- **Long-term summary** — compressed narrative, updated weekly via cron
- **Structured event log** — lifts, runs, body weight as queryable SQLite rows
- **Shared context** — phase, goal, active injuries, body weight; readable by all agents

Agents decide what to store themselves. If a message has no bearing on an agent's domain, nothing is written.

---

## Stack

- **Language:** Python 3.11, asyncio
- **AI:** Anthropic Claude API (`claude-haiku-4-5` / `claude-sonnet-4-6`)
- **Database:** SQLite
- **WhatsApp:** whatsapp-mcp or WhatsApp Business API
- **Container:** Docker, bound to `127.0.0.1`
- **Remote access:** Tailscale VPN

---

## Security

- Docker container bound to `127.0.0.1` — never reachable from LAN or internet
- Tailscale for phone access — no open ports, no port forwarding
- All health data stays local — SQLite lives in `~/fitcrew-workspace/`, never committed to the repo
- No third-party agent frameworks — all code is reviewed and owned
- API key via environment variable only

---

## Cost

~$4-7/month at heavy daily use. Haiku handles all routing and daily Q&A. Sonnet is only invoked for explicitly complex requests.

---

## Setup

### Prerequisites

- Docker
- Tailscale (on your machine and phone)
- Anthropic API key
- WhatsApp bridge: [whatsapp-mcp](https://github.com/lharries/whatsapp-mcp) or WhatsApp Business API

### Install

```bash
git clone https://github.com/your-username/fitcrew-ai
cd fitcrew-ai
cp .env.example .env
# add your ANTHROPIC_API_KEY and other values to .env
```

### Initialize the database

```bash
python db/init_db.py
```

### Run onboarding (first time only)

```bash
python onboarding/onboard.py
```

### Start

```bash
docker-compose up
```

---

## Project Status

**Arc 1 (active):** Strength agent end-to-end with memory writes.

**Arc 2 (next):** Router/classifier, Running agent + NLP extraction, @ mention routing for all agents.

**Arc 3 (planned):** Nutrition agent with cross-domain reads, weekly summarizer cron, full production hardening.

---

## Personal use only

This is a single-user personal tool. It is not designed for multi-user deployments and has no authentication layer beyond Tailscale network-level access. Don't expose it to the internet.