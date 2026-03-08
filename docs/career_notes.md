# FitCrew AI — Career Leverage Notes

*From career coaching session — March 2026*

-----

## High-Level Assessment

**Transition underway:** "data scientist who builds models" → "engineer who builds AI systems"

That transition is extremely valuable for AI/ML roles and aligns with where the industry is going (AI product + applied ML engineering).

**Strengths already on resume:**

- Strong statistics + modeling foundation (causal inference, forecasting, CV, ML)
- Experience with large data pipelines (Snowflake, PySpark, Databricks)
- Some production ML exposure via cattle CV project
- Product-thinking mindset

**What FitCrew AI adds that the resume currently lacks:**

AI systems engineering — specifically: LLM orchestration, agent architecture, backend infrastructure, production reliability.

**But to maximize career value, the project needs to showcase three missing capabilities:**

1. ML systems engineering
1. LLM evaluation & reliability
1. Data pipelines for AI

Right now the project is strongest in AI architecture, but weaker in ML/LLM engineering rigor.

-----

## What Would Most Improve This Project (Career ROI)

### 1. Evaluation Framework — VERY HIGH ROI

Companies care about: *how do you measure if the AI is good?*

Add an evaluation pipeline:

- Create datasets: `user_prompt | expected_agent | expected_action`
- Run automated tests: router accuracy, response quality, hallucination rate, instruction following
- Tools: Ragas, DeepEval, or a custom LangSmith-style eval harness
- Metrics: router precision/recall per agent, task completion success, hallucination detection

Why it matters: AI companies care deeply about LLM evals. This demonstrates "I understand how to measure AI systems."

-----

### 2. Retrieval-Augmented Memory (RAG)

Current memory: SQLite tables + 30-turn rolling context. Good, but the next step is semantic memory retrieval.

Example: vector store → retrieve relevant workouts → inject into prompt

Add embeddings + a vector DB:

- FAISS, Chroma, or pgvector
- Use case: "how did my squats progress?" → retrieve past squat sessions → summarize trend

Why it matters: Most AI systems now rely on RAG architecture. This is a core expected skill.

-----

### 3. Observability + Monitoring — Huge Engineering Signal

Upgrade from logs to real observability.

Structured logs: `request_id`, `agent`, `latency`, `tokens`, `cost`, `errors`

Dashboards tracking: daily requests, agent usage distribution, token cost, latency, failure rate

Tools: Prometheus, Grafana, OpenTelemetry, or lightweight Postgres analytics

Why it matters: Shows you understand production AI systems, not just prompts.

-----

### 4. Agent Planning

Current architecture: `router → agent`

Advanced: `router → planner → tools → agents`

Example — "Make me a 3-month plan to run a 24-minute 5k":

1. Retrieve run history
1. Compute training zones
1. Generate program
1. Schedule workouts

Implement ReAct-style planning or tool calling. Turns FitCrew into a real agentic system.

-----

### 5. Structured Data Model for Training Data

Current: workouts stored in flat tables.

Upgrade to: `users / workouts / exercises / sets / runs / nutrition_logs / bodyweight / goals`

Analytics queries: progress rate, training load score, fatigue score. Shows ML feature thinking.

-----

### 6. Simple Predictive Models

Leverage the DS background.

Running: predict 5k time progression, injury risk, fatigue
Strength: predict 1RM progression, plateau detection
Nutrition: predict weekly weight change

Simple models are enough — XGBoost, linear regression, time series. Bridges ML background with the product.

-----

### 7. CI/CD + Testing

Add: pytest, GitHub Actions, Docker build pipeline
Automate: lint, unit tests, integration tests

Companies love seeing testing discipline.

-----

### 8. SQLite → Postgres Migration

Easy upgrade. Benefits: production DB, concurrency, better schema evolution, enables pgvector.

-----

## Priority Order for Career Leverage

**Tier 1 — Highest ROI:**

1. LLM evaluation framework
1. Vector memory / RAG
1. Observability (logs + cost tracking dashboard)

**Tier 2:**
4. Agent planning system
5. Structured data model
6. Simple predictive models

**Tier 3:**
7. Postgres migration
8. CI/CD

-----

## Target Resume Bullet

> Built a production multi-agent AI coaching system integrating WhatsApp, Claude APIs, and a containerized Python backend; implemented semantic memory retrieval, automated LLM evaluation pipelines, and observability dashboards tracking latency, cost, and agent performance.

Strong for: Applied AI roles, ML engineer roles, AI product engineering roles.

-----

## Honest Career Take

Current profile: **Strong Data Scientist**

With this project done right: **AI Systems Engineer + Data Scientist**

That hybrid profile is extremely valuable right now.
