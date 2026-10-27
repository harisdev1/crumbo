# Crumbo (kids talking-owl app)

Read docs/MASTER_PLAN.md first.  
**Active schedule:** docs/DAILY_CHECKLIST.md (FULL DEV deadline **24 Nov 2026**). Play Store soft launch is AFTER that deadline.

## Product
- Flutter, Android first, US kids 4-10. Ads only (AdMob, child-directed). No backend, no accounts.
- Content (journey nodes, cards, shop items) is JSON in assets/data. New content must not need code changes.
- Character: Owl mascot — AnggaMotion Expression Pack (`assets/rive/owl.riv`, CC BY). Home: big owl + bottom care bar (Sleep/Eat/Play/Moods). Day-1 unlocks few moods; rest locked until journey.

## Architecture
- Clean Architecture: lib/core, lib/features/<feature>/{data,domain,presentation}
- Cubit/BLoC, GetIt, GoRouter, Hive, Flame. Rive with Data Binding (NOT deprecated Inputs).
- Local storage only. No personal data collection.

## Kids-app hard rules
- No personal data, login, chat, social. Mic audio on device only; never uploaded or stored beyond the current session.
- Ads only via AdService. Child-directed ON, rating G, non-personalized.
- No ads during gameplay, at app open, or next to gameplay buttons. Rewarded ads always opt-in.
- Every gate/unlock must have a non-ad path.
- Purchases, external links, sharing, privacy policy only behind ParentalGate.
- Kids-app rules (COPPA/Families) kabhi mat todna, chahe shortcut asaan ho.
- No new SDK, package, permission, or ad SDK without asking me first.

## Tests aur auto-check (HAR task — zaroori)
- Har feature / bugfix / refactor ke saath **tests likho** (unit aur/ya widget). Pure UI polish bina logic ke: kam az kam smoke/widget test.
- Task **done nahi** jab tak yeh auto pass na ho:
  1. `flutter analyze` — zero issues
  2. `flutter test` — saare tests green
- Naya domain logic (needs, economy, unlocks, gates, ads rules) → pehle/ya saath unit tests.
- Broken test ya analyze fail → pehle fix, phir aage ka feature.
- Phone USB se manual check ab bhi zaroori (mic/ads); lekin bina analyze+test green ke "done" mat bolo.

## Rive contract (owl pack)
- File: `assets/rive/owl.riv` (marketplace pack; credit AnggaMotion CC BY)
- Pack artboards `"1"`…`"15"` in `owl.riv`; idle=`11` think (no wink); wink=`2`; eat=`10`; dance=`1`; poke=`9`; pack `13`=bubble wand. Sleep = custom `owl_sleep.riv` artboard `sleep` (pack-11 look, closed eyes, breathing bob + floating Zzz; transparent bg). Listen = `owl_listen.riv` artboard `listen` (sound waves). Talk = `owl_talk.riv` artboard `talk` (mouth bob). Bath = `owl_bath.riv` artboard `bath` (front-facing + bubbles). Clean = `owl_clean.riv` artboard `clean` (front-facing + sparkles). Actions auto-return to idle except sleep / listen / talk (voice hold). Oversized boards use `stageScale`.
- Switch artboards from Flutter cubit; pack SMs have no mood inputs
- Rive APIs ke liye https://rive.app/docs/llms.txt padho. Do not guess.

## Workflow (Haris only reviews)
- Haris Rive/animation nahi jaanta. Technical terms ke bajaye simple Hinglish mein explain karo.
- Har task: pehle chhota plan (5 lines), mere approve ke baad code, phir `flutter analyze` + `flutter test`, phir commit.
- Task ke end par likho: "Kya bana", "Kaise test karoon (3 steps)", "Kya review karna hai".
- Rive kaam: har animation ke baad render/preview dikhao aur khud check karo (loop, detached parts, size).
- Agar koi tool/MCP fail ho to chup chaap workaround mat karo: batao aur options do (fallback Plan D: Flutter-only animations with PNG layers).
- Keep files small; no giant widgets. Work in small steps. One feature per task.
