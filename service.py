import asyncio
import json
import logging
import os
import re
import traceback

import requests
from dotenv import load_dotenv
from flask import Flask, jsonify, request

load_dotenv()

from agents.strength import call_strength_agent
from memory.writer import write_memory

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)
log = logging.getLogger("fitcrew")

app = Flask(__name__)

BOT_NUMBER = os.environ.get("WHATSAPP_BOT_NUMBER", "").lstrip("+")
VERIFY_TOKEN = os.environ.get("WHATSAPP_VERIFY_TOKEN", "fitcrew_verify_2026")
_BUSINESS_TOKEN = os.environ.get("WHATSAPP_BUSINESS_TOKEN", "")
_PHONE_NUMBER_ID = os.environ.get("WHATSAPP_PHONE_NUMBER_ID", "")
_META_URL = "https://graph.facebook.com/v21.0/{phone_number_id}/messages"

_MENTION_RE = re.compile(r"^@(strength|running|nutrition)\s+", re.IGNORECASE)


# ---------------------------------------------------------------------------
# WhatsApp I/O
# ---------------------------------------------------------------------------

def post_to_whatsapp(text: str, recipient: str) -> None:
    """Send a text message via the WhatsApp Business API."""
    if not _BUSINESS_TOKEN or not _PHONE_NUMBER_ID:
        print(f"[WARN] Missing Meta credentials — console only:\n[OUT → {recipient}]\n{text}\n")
        return
    resp = requests.post(
        _META_URL.format(phone_number_id=_PHONE_NUMBER_ID),
        headers={
            "Authorization": f"Bearer {_BUSINESS_TOKEN}",
            "Content-Type": "application/json",
        },
        json={
            "messaging_product": "whatsapp",
            "to": recipient,
            "type": "text",
            "text": {"body": text},
        },
        timeout=10,
    )
    if not resp.ok:
        print(f"[ERROR] Meta API {resp.status_code}: {resp.text}")


def receive_from_whatsapp(payload: dict) -> tuple[str, str] | None:
    """
    Parse an inbound Business API webhook payload.
    Returns (sender, message_text) or None if not a plain text message.
    """
    try:
        value = payload["entry"][0]["changes"][0]["value"]
        messages = value.get("messages")
        if not messages:
            # Status update (delivered/read receipt) — expected, not an error
            statuses = value.get("statuses")
            if statuses:
                log.info("STATUS UPDATE: %s", statuses[0].get("status"))
            else:
                log.info("IGNORED: no messages key in payload value: %s", list(value.keys()))
            return None
        msg = messages[0]
        msg_type = msg.get("type")
        if msg_type != "text":
            log.info("IGNORED: unsupported message type '%s'", msg_type)
            return None
        sender = msg["from"]
        text = msg["text"]["body"]
        log.info("RECEIVED: sender=%s text=%r", sender, text)
        return sender, text
    except (KeyError, IndexError, TypeError) as exc:
        log.error("PARSE ERROR: %s — payload: %s", exc, json.dumps(payload))


# ---------------------------------------------------------------------------
# Memory extraction
# ---------------------------------------------------------------------------

def strip_memory_json(raw: str) -> tuple[str, dict | None]:
    """
    Locate and remove the trailing memory JSON block appended by the agent.
    Handles two forms the model may produce:
      1. Wrapped in a markdown code fence: ```json\\n{...}\\n```
      2. Bare JSON on its own line (rfind-based fallback)
    Returns (clean_text, memory_block_or_None).
    """
    # Try code-fence form first (more specific, no ambiguity)
    fence_idx = raw.rfind("```json")
    if fence_idx != -1:
        fence_content = raw[fence_idx + 7:]  # skip the "```json" marker
        close_idx = fence_content.find("```")
        json_str = fence_content[:close_idx].strip() if close_idx != -1 else fence_content.strip()
        try:
            block = json.loads(json_str)
            if isinstance(block, dict) and "store" in block:
                return raw[:fence_idx].strip(), block
        except json.JSONDecodeError:
            pass  # fall through to rfind

    # Fallback: bare JSON appended without a code fence
    decoder = json.JSONDecoder()
    idx = raw.rfind("{")
    while idx >= 0:
        try:
            block, _ = decoder.raw_decode(raw, idx)
            if isinstance(block, dict) and "store" in block:
                return raw[:idx].strip(), block
        except json.JSONDecodeError:
            pass
        idx = raw.rfind("{", 0, idx)
    return raw.strip(), None


# ---------------------------------------------------------------------------
# Core orchestration
# ---------------------------------------------------------------------------

async def handle_message(sender: str, text: str) -> None:
    # Drop own messages
    if BOT_NUMBER and sender.lstrip("+") == BOT_NUMBER:
        log.info("DROPPED: bot echo from %s", sender)
        return

    # @ mention pre-check
    match = _MENTION_RE.match(text)
    if match:
        agent_name = match.group(1).lower()
        if agent_name in ("running", "nutrition"):
            log.info("SKIP: @%s not live in Arc 1", agent_name)
            return
        text = text[match.end():]  # strip @strength prefix

    log.info("CALLING strength agent | sender=%s text=%r", sender, text)
    raw = await call_strength_agent(text)
    log.info("AGENT RESPONSE (%d chars): %r", len(raw), raw[:200])

    clean, memory_block = strip_memory_json(raw)
    log.info("CLEAN RESPONSE (%d chars) | memory_block=%s", len(clean), bool(memory_block))

    if memory_block:
        write_memory(memory_block)

    post_to_whatsapp(f"💪 Strength: {clean}", sender)


# ---------------------------------------------------------------------------
# Webhook endpoints
# ---------------------------------------------------------------------------

@app.route("/webhook", methods=["GET"])
def verify():
    mode = request.args.get("hub.mode")
    token = request.args.get("hub.verify_token")
    challenge = request.args.get("hub.challenge")
    if mode == "subscribe" and token == VERIFY_TOKEN:
        print("Webhook verified!")
        return challenge, 200
    return "Forbidden", 403


@app.route("/webhook", methods=["POST"])
def receive():
    payload = request.json or {}
    log.info("POST /webhook | payload keys: %s", list(payload.keys()))
    result = receive_from_whatsapp(payload)
    if result is None:
        return jsonify({"status": "ignored"}), 200
    sender, text = result
    try:
        asyncio.run(handle_message(sender, text))
    except Exception:
        log.error("handle_message raised an exception:\n%s", traceback.format_exc())
        return jsonify({"status": "error"}), 500
    return jsonify({"status": "ok"}), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
