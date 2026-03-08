import asyncio
import datetime
import json
import logging
import os
import traceback
from collections import deque

import requests
from dotenv import load_dotenv
from flask import Flask, jsonify, request

load_dotenv()

from agents.running import call_running_agent
from agents.strength import call_strength_agent
from memory.run_extractor import extract_run_log
from memory.writer import (
    merge_active_injury,
    update_shared_context,
    write_conversation_turn,
    write_memory,
    write_run_log,
)
from router.classifier import classify_message
from router.mention import check_mention

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

_NUTRITION_STUB = "Coming in Arc 3. Tag @strength or @running for now."

# Dedup guard — stores last 10 message IDs to drop Meta retries on 500s
_seen_message_ids: deque = deque(maxlen=10)


# ---------------------------------------------------------------------------
# WhatsApp I/O
# ---------------------------------------------------------------------------

def post_to_whatsapp(text: str, recipient: str) -> None:
    """Send a text message via the WhatsApp Business API."""
    if not _BUSINESS_TOKEN or not _PHONE_NUMBER_ID:
        print(f"[WARN] Missing Meta credentials — console only:\n[OUT -> {recipient}]\n{text}\n")
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
        log.error("Meta API %s: %s", resp.status_code, resp.text)


def receive_from_whatsapp(payload: dict) -> tuple[str, str] | None:
    """
    Parse an inbound Business API webhook payload.
    Returns (sender, message_text) or None if not a plain text message.
    """
    try:
        value = payload["entry"][0]["changes"][0]["value"]
        messages = value.get("messages")
        if not messages:
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
        message_id = msg.get("id", "")
        log.info("RECEIVED: sender=%s id=%s text=%r", sender, message_id, text)
        return sender, text, message_id
    except (KeyError, IndexError, TypeError) as exc:
        log.error("PARSE ERROR: %s — payload: %s", exc, json.dumps(payload))


# ---------------------------------------------------------------------------
# Memory extraction
# ---------------------------------------------------------------------------

def strip_memory_json(raw: str) -> tuple[str, dict | None]:
    """
    Locate and remove the trailing memory JSON block appended by an agent.
    Handles two forms:
      1. Wrapped in a markdown code fence: ```json\\n{...}\\n```
      2. Bare JSON on its own line (rfind-based fallback)
    Recognises both strength blocks ("store" key) and running blocks ("store_run" key).
    Returns (clean_text, memory_block_or_None).
    """
    def _is_memory_block(block: dict) -> bool:
        return "store" in block or "store_run" in block or "store_log" in block

    # Try code-fence form first
    fence_idx = raw.rfind("```json")
    if fence_idx != -1:
        fence_content = raw[fence_idx + 7:]
        close_idx = fence_content.find("```")
        json_str = fence_content[:close_idx].strip() if close_idx != -1 else fence_content.strip()
        try:
            block = json.loads(json_str)
            if isinstance(block, dict) and _is_memory_block(block):
                return _clean_trailing_separator(raw[:fence_idx]), block
        except json.JSONDecodeError:
            pass

    # Fallback: bare JSON appended without a code fence
    decoder = json.JSONDecoder()
    idx = raw.rfind("{")
    while idx >= 0:
        try:
            block, _ = decoder.raw_decode(raw, idx)
            if isinstance(block, dict) and _is_memory_block(block):
                return _clean_trailing_separator(raw[:idx]), block
        except json.JSONDecodeError:
            pass
        idx = raw.rfind("{", 0, idx)
    return raw.strip(), None


def _clean_trailing_separator(text: str) -> str:
    """Strip trailing --- or *** horizontal rule the model may insert before the JSON block."""
    cleaned = text.strip()
    if cleaned.endswith("---") or cleaned.endswith("***"):
        cleaned = cleaned[:-3].strip()
    return cleaned


# ---------------------------------------------------------------------------
# Running memory handler
# ---------------------------------------------------------------------------

async def _handle_running_memory(mem: dict, original_msg: str) -> None:
    """Process the memory block from a Running agent response."""
    store_run = mem.get("store_run", False)
    injury_update = mem.get("injury_update")
    shared_update = mem.get("shared_context_update")

    if store_run:
        run_data = await extract_run_log(original_msg)
        if run_data:
            run_data["date"] = run_data.get("date") or datetime.date.today().isoformat()
            write_run_log(run_data)
            log.info("RUN LOG written: %s", run_data)

    if injury_update:
        merge_active_injury(injury_update)
        log.info("INJURY MERGED: %s", injury_update)

    if shared_update:
        update_shared_context(shared_update)
        log.info("SHARED CONTEXT updated: %s", shared_update)


# ---------------------------------------------------------------------------
# Core orchestration
# ---------------------------------------------------------------------------

async def handle_message(sender: str, text: str) -> None:
    # Drop own messages
    if BOT_NUMBER and sender.lstrip("+") == BOT_NUMBER:
        log.info("DROPPED: bot echo from %s", sender)
        return

    # @ mention pre-check — skip classifier if direct tag found
    agent_name, clean_text = check_mention(text)

    if agent_name == "nutrition":
        log.info("@ MENTION: @nutrition stub")
        post_to_whatsapp(f"Nutrition: {_NUTRITION_STUB}", sender)
        return

    if agent_name in ("strength", "running"):
        agents_to_call = [agent_name]
        msg = clean_text
        log.info("@ MENTION: @%s | msg=%r", agent_name, msg)
    else:
        # No @ mention — run classifier
        try:
            result = await classify_message(text)
        except Exception:
            log.error("CLASSIFIER ERROR:\n%s", traceback.format_exc())
            post_to_whatsapp("⚠️ Router hit an error. Try again or check logs.", sender)
            return
        agents_to_call = result.get("agents", [])
        msg = text
        log.info("CLASSIFIER: agents=%s | msg=%r", agents_to_call, msg[:80])

        if not agents_to_call:
            log.info("DROPPED: classifier returned no agents")
            return

    # Fan out to agents — build coroutine list
    coros = []
    agent_list = []
    for a in agents_to_call:
        if a == "strength":
            coros.append(call_strength_agent(msg))
            agent_list.append("strength")
        elif a == "running":
            coros.append(call_running_agent(msg))
            agent_list.append("running")
        elif a == "nutrition":
            post_to_whatsapp(f"Nutrition: {_NUTRITION_STUB}", sender)

    if not coros:
        return

    results = await asyncio.gather(*coros, return_exceptions=True)

    for agent, raw in zip(agent_list, results):
        if isinstance(raw, Exception):
            log.error("AGENT ERROR [%s]: %s\n%s", agent, raw, traceback.format_exc())
            post_to_whatsapp(f"⚠️ {agent.capitalize()} hit an error. Try again or check logs.", sender)
            continue

        clean, mem = strip_memory_json(raw)
        log.info(
            "AGENT [%s]: clean=%d chars | memory_block=%s",
            agent, len(clean), bool(mem),
        )

        if agent == "strength":
            if mem:
                write_memory(mem)
            post_to_whatsapp(f"Strength: {clean}", sender)
            try:
                write_conversation_turn("strength", msg, clean)
            except Exception:
                log.error("write_conversation_turn [strength] failed:\n%s", traceback.format_exc())

        elif agent == "running":
            if mem:
                await _handle_running_memory(mem, msg)
            post_to_whatsapp(f"Running: {clean}", sender)
            try:
                write_conversation_turn("running", msg, clean)
            except Exception:
                log.error("write_conversation_turn [running] failed:\n%s", traceback.format_exc())


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
    sender, text, message_id = result

    # Dedup: drop if we've seen this message ID recently (Meta retries on 500)
    if message_id and message_id in _seen_message_ids:
        log.info("DEDUP: dropped duplicate message_id=%s", message_id)
        return jsonify({"status": "ignored"}), 200
    if message_id:
        _seen_message_ids.append(message_id)

    try:
        asyncio.run(handle_message(sender, text))
    except Exception:
        log.error("handle_message raised an exception:\n%s", traceback.format_exc())
        try:
            post_to_whatsapp("⚠️ Something went wrong. Try again or check logs.", sender)
        except Exception:
            pass
    return jsonify({"status": "ok"}), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
