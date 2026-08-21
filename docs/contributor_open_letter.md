# An Open Letter to Developers

> **About this document:** This letter explains *why* this project exists — an **English-first, standalone
> fork** of the `xiaozhi-esp32-server` open-source project. The original upstream letter is preserved in full
> below under ["Reference: Original Letter"](#reference-original-letter) for context.

---

Dear developer,

Before anything else, we honor the work that made this possible. This project is built on the shoulders of the
Chinese developers of `xiaozhi-esp32-server` — 承前启后 (chéng qián qǐ hòu), *"carry on the past, open the way
for the future."* We hold that principle close: we do not claim their work as ours; we carry it forward with
gratitude and open a new path in our own words.

This project exists for one simple reason: the most capable open-source voice-AI backend we know of —
`xiaozhi-esp32-server` — was written entirely in Chinese. Its code, comments, documentation, admin console,
and user-facing strings all assume a Chinese-speaking audience, and its default providers send data to
Chinese cloud services.

That's a brilliant project we respect and build upon (MIT licensed). But it left a whole world of developers
out: anyone who doesn't read Chinese, and anyone who wants a voice assistant that doesn't phone home to
Chinese infrastructure.

**So we created this English-first, standalone fork.** Not to clone it, but to *unlock* it — to make a
genuinely low-cost consumer "Jarvis" something that an English-speaking hobbyist, student, or tinkerer can
pick up, read, run, and extend without translation friction and without worrying about where their data goes.

## Why "standalone", not a fork?

Because a fork has an upstream that can overwrite it. This repo is **standalone** — a fresh repository with
no upstream link — so nothing can silently clobber the English work we've done. The full history of the
original project is preserved locally, and the original project remains our reference and source of truth
for upstream features. But *our* code, *our* docs, and *our* defaults are ours to control.

## English-first, by default

We made **EN-US** the canonical language, and we re-pointed the default providers to **non-Chinese**
services so nothing is sent to Chinese cloud services out of the box:

- **LLM / Vision:** Google Gemini (free tier)
- **ASR / VAD:** local FunASR / Silero
- **TTS:** Microsoft Edge (English voice)
- **Weather:** Open-Meteo
- **Web search:** Tavily (US)
- **News:** BBC RSS

Our longer-term goal is to fully English the repo and then release it in **the same 6 languages as the
official version** — English, Simplified Chinese, Traditional Chinese, German, Vietnamese, and Brazilian
Portuguese.

## What we've already built together

This isn't just a translation. In this fork we've also added real features and hardened the stack:

- **SSO login** (Google / Apple / Microsoft / GitHub) with a **passcode** second factor.
- **Headless device onboarding** over serial — a clean way to add screen-less ESP32 boards.
- **Updated all third-party dependencies** to current stable versions (reducing old, vulnerable packages).
- **Audited every install method** and documented it in `docs/INSTALLATION.md`, so new users aren't led
  down broken or unaudited paths.

## A low-cost consumer Jarvis — together

The original letter ends with a hope that "someone will completely replicate the Xiaoge team's features and
realize a low-cost consumer Jarvis." We believe the same — and we believe the path runs *through* an
English-first, privacy-respecting, well-documented community build.

If you love AI, voice assistants, and ESP32 hardware, and you want to help make this project truly global —
an English-first Jarvis anyone can run — we'd love to have you.

Fork the repo, submit a PR, translate a doc, add a feature, fix a bug. The project is only as good as the
community that builds it.

承前启后 — carry on the past, open the way for the future. We carry forward what the original contributors
began, and together we open the way for what comes next.

Let's create the future together.

— The maintainer of `xiaozhi-esp32-server-en-standalone`

Korey B, 22 August 2026 ('Add Lunar date here')
New South Wales, Australia

---

# Reference: Original Letter

*The following is the original open letter from the upstream project, preserved verbatim for context.*

# An Open Letter to Developers

"The duck is the first to know when the spring river warms, and it's just the season for pufferfish to swim upstream!"

Dear friend, I am John, a Java programmer at an ordinary company. Today, with the utmost sincerity, I am writing this open letter to you, who love AI technology and innovation.

Half a year ago I came across many excellent projects, such as `Dify`, `Chat2DB`, and other AI-related projects. I kept thinking how wonderful it would be to participate in these projects, but alas, "no path to serve the cause, only ten years of writing code to show for it."

In early 2025 I stumbled upon the Xiaoge team's videos, and I was extremely curious about how they did it. I wanted to recreate their backend service to build a low-cost consumer Jarvis. Unfortunately, what I have built so far is still just an "artificial idiot"—it has low concurrency, no soul, slow responses, and plenty of bugs.

The Xiaoge team is our role model, and I really want a Xiaozhi backend service as intelligent as theirs. But I can also understand their decision not to open-source it. "A single flower does not make spring; a hundred flowers blooming brings spring to the garden." The era of AI flourishing everywhere may well be realized in our generation. With our own hands, we can build a low-cost consumer Jarvis. Personally, I believe that what they can achieve, we can achieve too—it is only a matter of time. I call this "our pilgrimage to the West."

So on this pilgrimage, what difficulties will we face? I imagine no fewer than the eighty-one trials. Along the way there are bound to be all kinds of demons, though there will also be immortals quietly helping us, and people who join the pilgrimage party.

If you find the content above amusing, then I consider myself very fortunate. If I can earn five seconds of your laughter out of the thirty-odd thousand days of your life, that counts as a small contribution I've made to you.

Will the idea of a low-cost consumer Jarvis fail? I don't know. But for ordinary people like us, isn't this kind of failure quite common in a lifetime?

In the future, one thing is certain: someone will completely replicate the Xiaoge team's features and realize a low-cost consumer Jarvis. Could that project be ours?

I look forward to walking hand in hand with you to create the future together.

John, 2025.3.11, Guangzhou

# Appendix: Developer Contribution Guide
## Project Goals

1. **A low-cost consumer Jarvis solution**  

2. **A solution for intelligently linking surrounding hardware**  

## Join Us

We warmly welcome like-minded friends to join and contribute to the project. You can check the features we plan to implement in the near future in the project roadmap. The features in the list that have not yet been assigned to anyone are exactly where your participation is urgently needed. Ways to participate are as follows:

### 1. Become a Regular Contributor

Fork the project and submit a PR; a developer will review it and merge it into the main branch.

### 2. Become a Developer

After you have submitted 3 valid PRs in total, you can contact the group owner to apply to become a developer. The group owner will invite you to join the dedicated developer group to discuss the project's future together.

## Developer Workflow

1. **Create a new branch**  
   Develop each feature on a new branch. The branch name should be concise and clear, so the implemented feature is obvious at a glance and features do not collide.

2. **Submit a PR for review**  
   After the feature is developed, submit a PR on GitHub. Other developers will review it, and once approved it is merged into the main branch.
