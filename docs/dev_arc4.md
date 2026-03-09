# FitCrew AI — Development Arc 4
**Goal:** Agent consultation — agents confer and return one unified response for cross-domain questions
**Builds on:** Arc 3 complete — Nutrition agent live, cross-domain reads, weekly summarizer, cost logging, error handling, dedup guard, schema cleanup
**Timeline:** One focused evening or weekend session
**Definition of Done:** "Should I run or lift tomorrow?" returns one unified response grounded in data from both agents. The synthesizer is visibly referencing specific numbers from memory.

---

## What Arc 4 is NOT

- Not RAG, eval framework, observability, or voice (those are Arc 5)
- Not a new database or schema change
- Not changes to any existing routing paths — fan-out and single-agent paths unchanged

---

## The One Milestone

### Milestone 1 — Agent consultation
**Done when:** A cross-domain synthesis question routes to a new consultation path, calls the relevant agents in assessment mode in parallel, passes both assessments to a Synthesizer (Sonnet), and posts one unified WhatsApp response prefixed with 🤖 FitCrew:.

---

## Before You Write Any Code

Nothing required from you before this one. All the data and infrastructure is already in place from Arc 3. Just start Claude Code with Task A.

---

## Task Breakdown

### 🔴 You must do this

| Task | Why | Est. time |
|------|-----|-----------|
| Test consultation from phone | Only you can send the test | 15 min |
| Evaluate synthesizer response quality | Judgment call on whether it's grounding correctly | Ongoing |

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
"should I push hard this week"

The key distinction from fan-out: consultation questions require ONE unified answer,
not two independent responses. Fan-out is for when both agents have independent
relevant things to say. Consultation is for when the question needs a verdict.

Step 1 — Update router/classifier.py:
Add a third mode alongside existing normal/fanout.
New return type: {"agents": [...], "model": "sonnet", "mode": "consult"}
Consult triggers when:
  - 2+ agents are relevant AND
  - The question is asking for a decision or verdict, not logging data
Update prompts/router_system.md to teach the router the new mode.
Include clear examples of consult vs fanout in the prompt.

Step 2 — Add assessment mode prompts:
Create three new prompt files:
  prompts/strength_assessment.md
  prompts/running_assessment.md
  prompts/nutrition_assessment.md

Assessment mode uses the same context assembly as normal mode (same DB reads,
same memory), but a different instruction block. Instead of responding to the
user via WhatsApp, the agent returns a structured JSON assessment only.

Assessment prompt instruction (same for all three, agent name injected):
"You are the {agent} coach. A head coach has asked for your assessment
to help answer this athlete question: {message}

Review the athlete's data above and return ONLY a JSON object with these fields:
{
  "recommendation": "1-2 sentence concrete recommendation",
  "data_points": ["specific number or fact from memory that informed this"],
  "constraints": ["active injury, flag, or limitation relevant to this question"],
  "confidence": "high" | "medium" | "low"
}

No WhatsApp formatting. No preamble. JSON only."

Step 3 — Add assessment mode parameter to each agent:
agents/strength.py, agents/running.py, agents/nutrition.py

Add optional parameter: mode: str = 'normal'
If mode == 'assessment':
  - Load assessment prompt instead of normal system prompt
  - Inject message into assessment prompt
  - Return raw JSON string only (no memory block, no WhatsApp formatting)
  - Do NOT write conversation history or memory for assessment calls
If mode == 'normal': unchanged behavior

Step 4 — Create agents/synthesizer.py:
Function: async def synthesize(message: str, assessments: dict) -> str

assessments is a dict of agent_name -> parsed JSON assessment:
{
  "strength": {"recommendation": "...", "data_points": [...], ...},
  "running": {"recommendation": "...", "data_points": [...], ...}
}
(nutrition included only if it was called)

Makes one Sonnet call (SONNET_MODEL env var).

System prompt:
"You are the head coach for a multi-agent fitness coaching system.
You have received assessments from your specialist coaches and must
synthesize them into one clear, direct response for the athlete.

Rules:
- Give ONE concrete recommendation, not a list of options
- Reference specific data points from the assessments (weights, distances, dates)
- Acknowledge constraints (injuries, flags) explicitly
- Use WhatsApp formatting only (* for bold, - for lists)
- Be direct — do not hedge or give wishy-washy answers
- Keep it under 150 words"

User message format:
"Athlete question: {message}

Specialist assessments:
{formatted assessments}

Write your unified response."

Returns clean WhatsApp-formatted string (no memory block).

Step 5 — Update service.py:
Add consultation path alongside existing single-agent and fan-out paths:

if mode == "consult":
    # Call relevant agents in parallel in assessment mode
    assessment_tasks = [call_{agent}_agent(text, mode='assessment')
                        for agent in agents]
    raw_assessments = await asyncio.gather(*assessment_tasks)

    # Parse JSON from each assessment
    assessments = {}
    for agent, raw in zip(agents, raw_assessments):
        try:
            assessments[agent] = json.loads(raw)
        except:
            assessments[agent] = {"recommendation": raw,
                                   "data_points": [],
                                   "constraints": [],
                                   "confidence": "low"}

    # Synthesize
    response = await synthesize(text, assessments)
    send_whatsapp_message(sender, "🤖 FitCrew: " + response)

    # Write to shared conversation history only (no per-agent memory)
    write_conversation_turn('synthesizer', text, response)

Log consultation calls: CONSULTATION: agents={agents} message={text[:50]}

Step 6 — Update CLAUDE.md:
Mark Arc 4 complete, Arc 5 next.
Add consultation path to the routing decision tree in the docs.
```

---

## Sequence to Follow

```
Claude Code:
  └── Task A — full consultation implementation
  └── Rebuild: docker-compose down && docker-compose up --build -d
  └── Run init_db.py (synthesizer conversation history)
  └── Verify webhook (Meta dashboard -> Verify and Save)

You:
  └── Send "should I run or lift tomorrow?" from phone
  └── Confirm 🤖 FitCrew: prefix and unified response
  └── Send "am I recovered enough to train?" — confirm it also consults
  └── Send "hit 225 bench today" — confirm still routes to Strength only (no regression)
  └── Send "ran 5k, knee felt tight" — confirm still routes to Running only (no regression)
```

---

## Definition of Done — Arc 4

- [ ] "Should I run or lift tomorrow?" returns one unified 🤖 FitCrew: response
- [ ] Synthesizer response references specific data points (weights, distances, dates)
- [ ] Constraints (active injuries, flags) acknowledged in synthesizer response
- [ ] Assessment mode calls do NOT write to conversation history or memory
- [ ] Existing fan-out and single-agent paths unchanged — no regressions
- [ ] Consultation calls logged at INFO level
- [ ] CLAUDE.md updated

---

## What Arc 5 adds

LLM evaluation framework, RAG / semantic memory (ChromaDB), Prometheus + Grafana observability, voice message support (Whisper), CI/CD + pytest, shared conversation log across agents, proactive check-ins.

---

*Based on FitCrew AI PRD v1.1 — Agent Architecture v2 — Arc 3 complete March 2026*
