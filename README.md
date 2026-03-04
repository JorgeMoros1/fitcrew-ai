# FitCrew AI

A multi-agent AI fitness coaching platform built with Claude.

## Quickstart

```bash
cp .env.example .env
# fill in your secrets
docker-compose up
```

## Structure

| Directory | Purpose |
|-----------|---------|
| `agents/` | AI coaching agents |
| `router/` | Request routing between agents |
| `memory/` | User memory and context |
| `db/` | Database models and migrations |
| `bridge/` | External API integrations |
| `onboarding/` | User onboarding flows |
| `scripts/` | Utility scripts |
| `prompts/` | Agent system prompts |
| `docs/` | Architecture and product docs |

## Docs

- [PRD](docs/PRD.md)
- [Agent Architecture](docs/agent_architecture.md)
- [Dev Architecture](docs/dev_arc1.md)
