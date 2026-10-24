# Crumbo: Daily Checklist (FULL DEV — deadline 24 Nov 2026)

**Deadline:** 24 Nov 2026 — saari development features complete, installable APK.  
**Bahar:** Play Console / soft launch / store listing (baad mein).  
**Pace:** roz ~2–3 tasks; phone USB se test (emulator zaroori nahi).

**Kaise use karna hai:**
1. Aaj ka task is list mein pehla unchecked `[ ]` hai
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

**Rive:** parallel; MCP atke to Plan D — features mat roko.

---

## Week A (24–31 Oct): Foundation + Crumbo core

- [x] A1 (24 Oct): Project rules + `docs/MASTER_PLAN.md` + git init; AGENTS testing rules
- [x] A2: Clean Architecture folders, GetIt, GoRouter, flutter_bloc; Home route
- [x] A3: Theme + Home screen placeholder Crumbo (simple image)
- [ ] A4: Hive storage (boxes: crumbo_state, inventory, economy, settings)
- [ ] A5: Firebase skeleton (Analytics kids, Crashlytics, Remote Config) jab accounts ready; warna stub + skip note
- [ ] A6: `CrumboState` + `CrumboCubit` (hunger, sleep, fun, clean, love)
- [ ] A7: Needs decay (last-seen timestamp) + unit tests
- [ ] A8: Mood calculation + mood icons UI
- [ ] A9: Feed action (drag food to Crumbo)
- [ ] A10: Sleep (light off, lullaby) + Pet/tickle

## Week B (1–7 Nov): Rooms, economy, cards, journey start

- [ ] B1: Bath + Clean actions
- [ ] B2: Room navigation (Kitchen, Bedroom, Bathroom)
- [ ] B3: Coins + Gems (repository + cubit)
- [ ] B4: Shop screen (`assets/data/items.json`)
- [ ] B5: Daily reward calendar (7 din)
- [ ] B6: `cards.json` + card models
- [ ] B7: Card album (locked cards dhundhle)
- [ ] B8: Card flip/reveal animation
- [ ] B9: Unlock methods (task, coins, journey) + duplicates → coins + Hive
- [ ] B10: `journey.json` + models + scrollable map UI

## Week C (8–14 Nov): Journey Zone 2 + 5 games + voice

- [ ] C1: Node types (care, game, card reveal) + Zone 1 content + progress save
- [ ] C2: Chests + Gates (task / coins / ad placeholder); Zone 2 (Bubble Bay)
- [ ] C3: Flame setup + Topping Catch
- [ ] C4: Toaster Pop
- [ ] C5: Bubble Pop
- [ ] C6: Crumb Runner
- [ ] C7: Match the Breakfast + shared result screen (2x coins placeholder)
- [ ] C8: Mic permission + recording
- [ ] C9: Silence detection + pitch/speed playback + presets; delete after play
- [ ] C10: Voice + Crumbo talk/listen state; real phone test

## Week D (15–21 Nov): Ads, polish, Rive

- [ ] D1: AdMob test IDs + `AdService` / `AdmobAdService` (child-directed)
- [ ] D2: Rewarded ads (game 2x, gate, chest, spin)
- [ ] D3: Interstitial rules (natural breaks, min 90s gap)
- [ ] D4: Banner (shop/result) + Remote Config frequencies; fail-safe (no stuck buttons)
- [ ] D5: Parental gate
- [ ] D6: Settings + privacy policy page
- [ ] D7: Onboarding (3 screens)
- [ ] D8: Spin wheel + Daily tasks
- [ ] D9: Sounds + haptics
- [ ] D10: Rive `CrumboView` bind (ya Plan D) — moods, actions, hatId, toastLevel

## Final (22–24 Nov): Bug bash + APK

- [ ] F1: Analytics events (anonymous) + low-end phone pass
- [ ] F2: Full feature walkthrough + master plan Section 16 checklist (dev items)
- [ ] F3 (24 Nov): Release APK; `flutter analyze` + `flutter test` clean; phone install OK

---

## Rive track (parallel, hafte mein 2–3 baar, 45 min)

| Kab | Rive ka kaam |
| --- | --- |
| Week A–B | SVG design + import `CrumboMain` |
| Week C | idle_breathe, blink, sleep_loop, talk |
| Week D | chew, giggle, wake, state machine + data binding → `assets/rive/crumbo.riv` |

**Agar Rive MCP atak jaye:** Plan D (PNG layers + Flutter animations).

---

## Done means (24 Nov)

Sara development loop phone APK par: care, rooms, shop, cards, Journey Zone 1+2, 5 games, voice, ads (test), parental gate, onboarding, spin, daily tasks, sounds, Rive ya Plan D.  
**Nahi:** Play Store upload / soft launch.
