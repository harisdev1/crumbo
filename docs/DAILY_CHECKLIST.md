# Crumbo: Daily Checklist (FULL DEV — deadline 24 Nov 2026)

**Last updated:** 2026-10-25  
**Deadline:** 24 Nov 2026 — saari development features complete, installable APK.  
**Bahar:** Play Console / soft launch / store listing (baad mein).  
**Pace:** roz ~2–3 tasks; phone USB se test (emulator zaroori nahi).

**Product:** App name **Crumbo**; mascot = **owl** (AnggaMotion pack + custom sleep). US kids 4–10, ads-only, no accounts.  
**Canonical docs:** yeh file + [`MASTER_PLAN.md`](MASTER_PLAN.md). Duplicates (`crumbo-daily-checklist.md`) redirect yahan.

**Kaise use karna hai:**
1. Aaj ka task = **Core sprint** mein pehla unchecked `[ ]` (Done / Partial sections skip)
2. Cursor mein yeh template paste karo, `[TASK]` ki jagah wo line daalo:
```
docs/MASTER_PLAN.md padho. Aaj ka task: [TASK].
Pehle 5 line ka plan dikhao, mere approve ke baad code likho.
Har change ke saath tests likho; flutter analyze + flutter test clean hone ke baad hi done.
Aakhir mein batao: kya bana, kaise test karun (3 steps), kya review karna hai.
```
3. Phone par test karo, theek ho to `[x]` kar do aur "commit karo" bolo
4. Agar task ek din mein poora na ho to agle din bhi wahi chalao, aage mat badho

**Active schedule:** yeh 31-din list. Purana 12-hafte plan sirf reference (`docs/MASTER_PLAN.md` Section 15).  
**Rive:** parallel; MCP atke to Plan D — features mat roko. Contract: `AGENTS.md` + `assets/rive/owl.riv`.

**In-flight polish** (core sprint block nahi; jab free ho):
- Splash: one random owl PNG per launch (abhi cross-fade)
- Home: unified currency bar (coins + gems ek row)
- AnggaMotion CC BY credit → Settings / About (home se hide)

---

## Done — UI shell & owl core (Oct 2025)

Foundation + glossy shell already shipped. Purana “A3 placeholder image” is list se replace.

- [x] A1 (24 Oct): Project rules + `docs/MASTER_PLAN.md` + git init; AGENTS testing rules
- [x] A2: Clean Architecture folders, GetIt, GoRouter, flutter_bloc; Home route
- [x] A3: Theme + Lilita One + game colors (`lib/core/theme/app_theme.dart`) — superseded placeholder image
- [x] A-UI1: Glossy UI kit (buttons, glass, progress, particles) + widget tests
- [x] A-UI2: Splash flow + icon list (`splash_icons.dart`)
- [x] A-UI3: Home top bar, exit dialog, themed SVG backgrounds + motion
- [x] A-UI4: Owl stage — Rive `CrumboView`, perch layer, body tap + bonk
- [x] A-UI5: Care bar Sleep / Eat / Play / Moods sheet
- [x] A-UI6: Skins + themes sheets; JSON + SharedPreferences
- [x] A-UI7: Static routes — settings, shop, play hub, profile, rewards, store+gate, my owls, etc.
- [x] A-UI8: Play hub content from `assets/data/play_content.json`

---

## Partial — shells only (wire later; full `[x]` mat do)

Honest status — economy / journey / ads se pehle complete mat samjho:

- [~] B4-partial: Shop **screen** shell — no `items.json` / purchase logic
- [~] B5-partial: Daily rewards **screen** shell — no 7-day streak logic
- [~] D5-partial: Parental math gate on Store — missing privacy URL / all gated surfaces
- [~] D6-partial: Settings page shell — privacy policy content + parent area incomplete
- [~] D10-partial: Owl artboard switching works — not bread-era data-binding VM; journey mood gates still mock

---

## Core sprint — Week A (24–31 Oct): Storage + needs

**Pehla unchecked = A9** (A5 Firebase skipped for now).

- [x] A4: Hive storage (boxes: `crumbo_state`, `inventory`, `economy`, `settings`) + migrate theme/skin prefs where appropriate
- [ ] A5: Firebase skeleton (Analytics kids, Crashlytics, Remote Config) jab accounts ready; warna stub + skip note
- [x] A6: Pet needs (`NeedsCubit` / repo; keep `CrumboCubit` for expressions) — hunger, sleep, fun, clean, love 0–100
- [x] A7: Needs decay (last-seen timestamp) + unit tests
- [x] A8: Computed mood + home need icons (expression hints; Moods sheet duplicate nahi)
- [ ] A9: Feed action (drag food to owl) — single home scene OK until B2
- [ ] A10: Sleep polish (light off, lullaby) + Pet/tickle beyond bonk if needed

---

## Core sprint — Week B (1–7 Nov): Rooms, economy, cards, journey start

- [ ] B1: Bath + Clean actions (owl care)
- [ ] B2: Room navigation (Kitchen, Bedroom, Bathroom) — themed BGs already exist; add nav + room-specific actions
- [ ] B3: Coins + Gems (repository + cubit) — wire home currency bar
- [ ] B4: Shop screen wired to `assets/data/items.json` (replace shell)
- [ ] B5: Daily reward calendar (7 din streak) — replace shell
- [ ] B6: `cards.json` + card models
- [ ] B7: Card album (locked cards dhundhle)
- [ ] B8: Card flip/reveal animation
- [ ] B9: Unlock methods (task, coins, journey) + duplicates → coins + Hive
- [ ] B10: `journey.json` + models + scrollable map UI

---

## Core sprint — Week C (8–14 Nov): Journey Zone 2 + 5 games + voice

- [ ] C1: Node types (care, game, card reveal) + Zone 1 content + progress save
- [ ] C2: Chests + Gates (task / coins / ad placeholder); Zone 2 (Bubble Bay)
- [ ] C3: Flame setup + Topping Catch
- [ ] C4: Toaster Pop
- [ ] C5: Bubble Pop
- [ ] C6: Crumb Runner
- [ ] C7: Match the Breakfast + shared result screen (2x coins placeholder)
- [ ] C8: Mic permission + recording
- [ ] C9: Silence detection + pitch/speed playback + presets; delete after play
- [ ] C10: Voice + owl talk/listen state; real phone test

---

## Core sprint — Week D (15–21 Nov): Ads, polish, Rive

- [ ] D1: AdMob test IDs + `AdService` / `AdmobAdService` (child-directed)
- [ ] D2: Rewarded ads (game 2x, gate, chest, spin)
- [ ] D3: Interstitial rules (natural breaks, min 90s gap)
- [ ] D4: Banner (shop/result) + Remote Config frequencies; fail-safe (no stuck buttons)
- [ ] D5: Parental gate on all sensitive surfaces (extend D5-partial)
- [ ] D6: Settings + privacy policy page (complete D6-partial)
- [ ] D7: Onboarding (3 screens)
- [ ] D8: Spin wheel + Daily tasks
- [ ] D9: Sounds + haptics
- [ ] D10: Owl Rive polish + journey-gated moods (`OwlExpression.isUnlocked`); Plan D if pack limits

---

## Final (22–24 Nov): Bug bash + APK

- [ ] F1: Analytics events (anonymous) + low-end phone pass
- [ ] F2: Full feature walkthrough + master plan Section 16 checklist (dev items)
- [ ] F3 (24 Nov): Release APK; `flutter analyze` + `flutter test` clean; phone install OK

---

## Rive track (parallel, hafte mein 2–3 baar, 45 min)

| Kab | Rive ka kaam |
| --- | --- |
| Done | Marketplace owl pack (`owl.riv`) + custom sleep (`owl_sleep.riv`) integrated |
| Ongoing | Perch tuning per theme (`perchY` in `home_themes.json`) |
| Before C10 | Mic / talk artboard ya placeholder |
| Plan D | PNG layers + Flutter animations agar pack limits hit |

Contract: `AGENTS.md` (artboards `"1"`…`"15"`, idle=`11`, wink=`2`, eat=`10`, etc.).  
**Nahi:** bread-era `CrumboMain` / `assets/rive/crumbo.riv` (deprecated).

**Agar Rive MCP atak jaye:** Plan D (PNG layers + Flutter animations).

---

## Done means (24 Nov)

Sara development loop phone APK par: care, rooms, shop, cards, Journey Zone 1+2, 5 games, voice, ads (test), parental gate, onboarding, spin, daily tasks, sounds, owl Rive ya Plan D.  
**Nahi:** Play Store upload / soft launch.
