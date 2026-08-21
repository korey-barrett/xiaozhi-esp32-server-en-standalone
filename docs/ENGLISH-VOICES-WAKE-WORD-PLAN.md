# Voice Language Audit & English Wake-Word Conversion Plan

> Living document for two goals: (1) a repeatable audit of every included voice by language, and
> (2) a careful, phased conversion of the retained Chinese (wake words / exit commands) to English
> without breaking the system.

---

## 1. Voice language audit (repeatable)

Audit all voices in the `ai_tts_voice` table by language. Run against the deployed DB:

```sql
SELECT tts_model_id, languages, COUNT(*) FROM ai_tts_voice
GROUP BY tts_model_id, languages ORDER BY tts_model_id, languages;
```

### Result (240 voices, fresh deploy + English Edge additions)

**Pure English voices** — usable for an English-first setup with no Chinese:
| Provider | English voices |
|---|---|
| Edge TTS | 12 (en-US/en-GB/en-AU — added) |
| Volcengine (Volces) | 7 |
| Huoshan (HSDSTTS_V2) | 3 |
| Xunfei | 2 |
| Alibaba Bailian (AliBL) | 2 |

**Mixed Mandarin + English** (~78) — can speak English but default to Mandarin:
AliBL (10), Aliyun (18), Huoshan (4), HSDSTTS (36), Volces (4), Index (1)

**Chinese-primary** (majority): Mandarin, Cantonese, and Chinese accents (Beijing/Guangdong/Sichuan/Taiwan/etc.) across all providers.

**Other languages:** Japanese, Korean, Spanish.

> Recommendation: for an English-first project, **default the Edge TTS voice to an English voice** (already done:
> `en-US-AriaNeural` in the Edge config) and prefer pure-English voices where available. The mixed
> Mandarin+English voices remain useful (bilingual) but are not English-primary.

---

## 2. Retained Chinese map (functional data)

| Item | Values | Config location | Consumed by |
|---|---|---|---|
| Wake words | 你好小智; 你好小志; 小爱同学; … | `config.yaml` `wakeup_words` (sys_params `wakeup_words`) | `core/handle/helloHandle.py`, `core/handle/textHandler/listenMessageHandler.py` |
| Exit commands | 退出; 关闭 | `config.yaml` `exit_commands` (sys_params) | `core/connection.py:178` (`self.cmd_exit`) |

> These are matched against the **recognized speech text** from the device. They are *not* UI text.

---

## 3. ⚠️ The key constraint for English wake words

Wake words are **detected by the ESP32 firmware's WakeWordNet model**, then sent to the server as text.
The server's `wakeup_words` list must match what the device's wake model actually detects.

So to switch to **English** wake words you must change **both**:
1. **Device firmware** (`xiaozhi-esp32`) — use an **English WakeNet** model (or a custom English wake word), e.g. a model that detects "Hey Xiaozhi" / "Hello Xiaozhi". This is a **separate repo** and requires re-flashing the device.
2. **Server** (`xiaozhi-server`) — add the English wake word string to `wakeup_words` so the recognized text matches.

Doing server-only would not help — the device would still detect "你好小智" and never wake on English.

---

## 4. Phased step-by-step plan (additive first, no breakage)

### Phase 0 — Baseline & backup
- Confirm current `wakeup_words` / `exit_commands` in `config.yaml` and the DB.
- Document the exact recognized values the current device model produces.

### Phase 1 — ADD English wake words (additive, no removal)
- Add English strings to `wakeup_words` (e.g. `"hey xiaozhi"`, `"hello xiaozhi"`) as **additional** entries.
- Keep the existing Chinese entries. Nothing breaks; the Chinese path still works.
- Add English **exit commands** (e.g. `"exit"`, `"goodbye"`) alongside `退出`/`关闭`.
- Test: Chinese still wakes; no regressions.

### Phase 2 — Device-side English wake model (concrete steps) — ✅ DONE (willow working)

The device runs the **`xiaozhi-esp32` firmware** (a separate repo). Configure it to wake on an English word.

**Option A — Custom wake word (Multinet) — recommended.**
In `idf.py menuconfig` → "Xiaozhi Assistant":
1. **Wake Word Implementation Type** → `USE_CUSTOM_WAKE_WORD` (requires ESP32-S3/P4 + PSRAM).
2. **Custom Wake Word** → `hey xiaozhi` (for English, use the words directly; pinyin only applies to Chinese).
3. **Custom Wake Word Display** → `hey xiaozhi` — this exact string is sent to the server and MUST match a
   `wakeup_words` entry (Phase 1 added it).
4. **Custom Wake Word Threshold** → tune sensitivity (lower = more sensitive; start ~20).

**Option B — Preset English WakeNet word.** Some WakeNet models include preset English words (e.g. "Jarvis",
"Alexa"). If you use one, add that exact word to the server's `wakeup_words` (e.g. `jarvis` / `alexa`) so the
server recognizes it — currently the server list has `hey/hello/hi xiaozhi`.

**Flash & verify:**
```bash
idf.py set-target esp32s3 && idf.py menuconfig && idf.py flash monitor
```
Confirm the device now reports the **English** wake text (not `你好小智`) to the server.
- Confirm the device now reports the English wake text to the server.

### Phase 3 — Switch server default to English
- Reorder/prioritize English wake words; optionally set the agent greeting/TTS to English.
- Validate the full path: English wake → ASR (English) → LLM → TTS (English voice).

### Phase 4 — Remove Chinese (only after English fully works)
- Remove the Chinese `wakeup_words` / `exit_commands` entries and the corresponding sys_params.
- Validate no code references break (`helloHandle.py`, `listenMessageHandler.py`, `connection.py` read the config lists dynamically).

---

## 5. Rules to avoid breakage
1. **Never remove a value before its replacement is proven working** (additive-first).
2. **Keep the sys_params seed and `config.yaml` in sync** — the runtime reads both.
3. **The device model and the server list must match exactly** (case / phrasing) — the server does exact `in` matches.
4. Test each phase on a real device before removing Chinese.

---

*Generated 2026-08-22. Re-run the §1 SQL for a fresh voice audit.*
