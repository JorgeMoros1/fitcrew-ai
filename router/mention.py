import re

_MENTION_RE = re.compile(r"^@(strength|running|nutrition|all)\s+", re.IGNORECASE)


def check_mention(message: str) -> tuple[str | None, str]:
    """
    Check if message starts with @strength, @running, @nutrition, or @all.
    Leading whitespace is stripped before matching — only position-0 @mentions trigger routing.
    Returns (agent_name, cleaned_message) if matched, (None, original_message) if not.
    @all returns 'all' as the agent name to fan out to every agent.
    """
    stripped = message.lstrip()
    match = _MENTION_RE.match(stripped)
    if match:
        agent = match.group(1).lower()
        clean = stripped[match.end():]
        return agent, clean
    return None, message
