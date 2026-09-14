# Console: Voice Clone & Voice Resource

The **Voice Clone** and **Voice Resource** menu headings are the console's voice/timbre management pages.
They control which TTS voices an agent can speak with. Both pages manage records in the **same `voice_clone`
database table**, but they serve two different audiences:

- **Voice Clone** — a *per-user* page. A logged-in user (not admin) sees a card grid of **their own**
  voice records, and can upload a voice sample and clone it into a trained TTS voice.
- **Voice Resource** — a *super-admin* page. A table of **every user's** voice records, with an **Add**
  button that imports voice IDs from a cloud-TTS platform account and assigns them to a user.

There is no "self-registration" of a voice: **every record is created by an admin on the Voice Resource
page** (or via the API) and owned by the user it was assigned to. That is why the Voice Clone page has no
Add button — see [Why Voice Clone has no add button](#why-voice-clone-has-no-add-button) below.

## Relationship at a glance

| | Voice Clone | Voice Resource |
|---|---|---|
| **Who sees it** | Any logged-in user | Super admin only |
| **Header menu** | Regular users: single **Voice Clone** item. Super admin: dropdown with both items | Super admin dropdown item |
| **View** | Card grid of *your* voices | Table of *everyone's* voices |
| **Create entries?** | ❌ No — entries are assigned to you | ✅ **Add** — import platform voices, assign to a user |
| **Per-record actions** | Upload sample, Clone, Play/Stop, Rename | Delete (row or batch select) |

Both pages read/write the `voice_clone` table. A record created via **Voice Resource** appears to its
assigned owner in **Voice Clone**.

## The two pages in detail

### Voice Clone (`/voice-clone-management`)

Card grid showing only the current user's records (`VoiceCloneController GET /` is scoped to the logged-in
user's `userId`). Each card shows the voice name (inline-editable), `voiceId`, `languages`, and a status
badge. Card actions depend on whether the record has an uploaded sample yet:

- **Upload** — always available. Opens a dialog to upload a voice sample (`.mp3`/`.wav`, ≤ 10 MB). Until a
  sample is uploaded the badge reads **"Waiting for upload"**.
- **Play / Stop** — available once a sample exists (fetches it via a one-time UUID stored in Redis).
- **Clone** — available once a sample exists. Sends the sample to the configured clone provider and trains
  it as a new `speaker_id`.
- **Edit** — rename the voice (clears the cached timbre name in Redis).

No "Add" button, no delete button. Empty state text: *"Your account has no voice resources assigned."*

### Voice Resource (`/voice-resource-management`)

Super-admin table (guarded by `@RequiresPermissions("sys:role:superAdmin")`). Columns: voiceId, name,
**Account Owner** (userName), **Platform Name** (modelName), languages, train status, created date.
Toolbar: **Select All / Deselect All**, **Add**, **Delete** (selected).

**Add** opens the Voice Resource dialog:

1. **Platform Name** (`modelId`) — pick a TTS platform. Requires a speech-synthesis model to be configured
   in **Model Configuration → Speech Synthesis** (see the
   [Volcano Engine streaming TTS + voice clone tutorial](./huoshan-streamTTS-voice-cloning.md)). The list
   comes from `GET /voiceResource/ttsPlatforms`.
2. **Voice Resource ID/IDs** (`voiceIds[]`) — one or more voice IDs available on that platform account,
   e.g. Volcano Engine's `S_xxxxx` IDs. For the "Volcano double-stream" model type the backend validates
   that each ID contains `S_`.
3. **Owning Account** (`userId`) — the system user the voice(s) are assigned to (the admin can assign to
   themselves).
4. **Languages** (`languages`) — comma/space-separated languages the voice supports.

On save the backend creates one `voice_clone` record per voice ID, named `MMddHHmm_<index>`, owned by the
selected user, with `trainStatus = 0`. The chosen model/provider and its `appid`/`access_token` config are
bound to the record so the owner can clone against it later.

## Record lifecycle & statuses

A `voice_clone` row carries: `model_id` (which TTS platform), `voice_id`, `name`, `user_id` (owner),
`languages`, a `voice` byte blob (the uploaded sample), and `train_status`:

| trainStatus | Meaning | Shown as |
|---|---|---|
| (no sample) | — | **Waiting for upload** |
| 0 | sample uploaded, not yet cloned | **Waiting for clone** |
| 2 | clone training succeeded | **Training successful** |
| 3 | clone training failed | **Training failed** (hover badge for the reason) |

Cloning (`voiceCloneService.cloneAudio`) currently targets **Volcano Engine / ByteDance** — the
`huoshan_double_stream` model type — and POSTs the sample (base64) to
`openspeech.bytedance.com/api/v1/mega_tts/audio/upload` (resource `seed-icl-1.0`). On success the returned
`speaker_id` is written back as the record's `voiceId` and `trainStatus` becomes `2`. The provider is fixed
at provisioning time (the model chosen on Voice Resource), so cloning uses that model's `appid`/`access_token`.

## How a cloned voice becomes an agent voice

When configuring an agent's TTS voice, the console's voice dropdown
(`TimbreServiceImpl.getVoiceNames`) merges:

1. the platform-provided **standard timbres**, and
2. the current user's **successfully-trained clones** (`trainStatus = 2`), marked as cloned and prefixed
   with the "Cloned Voice" label.

So a voice you clone under **Voice Clone** — or one provisioned to you under **Voice Resource** — is
selectable directly in **Agent Management → set the agent's Speech Synthesis (TTS)** and is what the device
speaks with.

## Why Voice Clone has no add button

This is intentional. New records are **only** created by a super admin (or the API) on the **Voice Resource**
page, which assigns a platform voice ID to a specific user. The Voice Clone page is purely the *use* side:
it lists what has been assigned to you and lets you upload a sample and clone it. There is no "create a voice
from scratch" on that page by design.

So the empty states you may see are normal given the current state of the data:

- **Voice Clone = empty, no buttons** — the admin has not yet assigned you any voice resource. Ask the admin
  to add one on the Voice Resource page (or, as the admin, do it yourself).
- **Voice Resource = empty, but Add present** — no voice resources have been imported yet. Use **Add** to
  import your first voice ID and assign it to an account.

## Enabling the menu

The two menu headings only appear after the **Voice Clone** feature is switched on. This is managed by the
super admin on the console's **Feature Configuration** page (header: "System Feature Management"), which
writes the `voiceClone` flag into the `system-web.menu` parameter. Regular users then see **Voice Clone** in
the header; super admins see a **Voice Clone ▾** dropdown with **Voice Clone** and **Voice Resource**. (Both
routes exist regardless and are reachable by URL; the toggle only controls the header menu.)

## Step-by-step setup

For a complete working walkthrough — getting a Volcano Engine `App ID` / `Access Token` / voice resource ID
(`S_xxxxx`), configuring the model, assigning the voice, cloning it, and assigning it to an agent — follow
[the Volcano Engine streaming TTS + voice clone tutorial](./huoshan-streamTTS-voice-cloning.md). The flow in
that tutorial maps to this page: its "assign the voice resource ID to system accounts" step is the **Voice
Resource** page's **Add** button, and its "cloning stage" is the **Voice Clone** page.
