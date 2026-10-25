# Crumbo: Complete Build Guide (Flutter + Rive + LLM Workflow)

Date: 2026-10-20 (refresh 2026-10-25)  
Owner: Haris  
Goal: **Crumbo** (owl mascot) kids app (US kids 4-10) banana, ads se revenue, Flutter + Rive mein, LLM (Cursor / Claude Code) ki madad se.

> **Day-to-day tasks:** [`DAILY_CHECKLIST.md`](DAILY_CHECKLIST.md) — pehla unchecked Core sprint item.  
> **Product / features:** [`MASTER_PLAN.md`](MASTER_PLAN.md). **Agent rules:** [`../AGENTS.md`](../AGENTS.md).  
> Note: Rive/MCP details badalti hain — pehle official docs verify karo.

---

## 0. Is guide ko kaise use karna hai

1. Section 1-2 padho (setup reference; project pehle se live hai)
2. Section 3 se Rive concept (optional; owl pack already integrated)
3. Section 5–6 = historical art brief — **primary contract ab AGENTS.md + owl.riv**
4. Root `AGENTS.md` use karo (CLAUDE.md template Section 7.2 outdated bread text — sync AGENTS)
5. **Roz ka kaam = DAILY_CHECKLIST**, not Section 9 alone (Section 9 = reference prompts)

---

## 1. Big picture: kaun kya karega

| Kaam | Kaun karega | Tool |
| --- | --- | --- |
| Idea, decisions, testing, store listing | Tum (Haris) | Phone + Play Console |
| Flutter code (UI, logic, ads, storage) | LLM + tumhara review | Cursor (ya Claude Code) |
| Owl character animation | Marketplace pack + custom sleep riv | `assets/rive/owl.riv`, `owl_sleep.riv` (+ MCP for extras) |
| Awaaz repeat (voice) | Flutter packages, device par | `record` + audio player with pitch |
| Ads | AdMob (child-directed) — Week D | `google_mobile_ads` |

**Status (Oct 2025):** Owl home + glossy UI + Hive (A4) shipped. Next core: A5 Firebase stub → needs → economy → journey/games/ads.

**Order of work (remaining):**
1. Hive + needs decay (checklist A4–A8)
2. Care actions + rooms + economy (A9–B5)
3. Cards + journey + Flame games + voice (B6–C10)
4. Ads, parental, polish (D1–D10)
5. Bug bash + APK (F1–F3); soft launch AFTER 24 Nov

---

## 2. Setup checklist

### Accounts
- [ ] Google Play Console account (release / soft launch ke baad — **not** Day-1 blocker)
- [ ] AdMob account — **Week D** (checklist D1+)
- [ ] Rive account (optional; pack pehle se repo mein)
- [ ] GitHub account (code backup + LLM ke saath kaam)
- [ ] Firebase project — **A5** jab accounts ready; warna stub + skip note
- [ ] Domain ya GitHub Pages (privacy policy URL — D6 / pre-store)

### Tools install
- [ ] Flutter SDK (latest stable), Android Studio (Android SDK + emulator)
- [ ] Claude Code (terminal) ya Cursor
- [ ] Node.js (agar npm wala Rive MCP use karna hai)
- [ ] Git
- [ ] Rive desktop editor ya browser editor
- [ ] Ek real Android phone (emulator mein audio/mic ka test bharosemand nahi hota)

### Flutter packages (shuru ke)
```yaml
dependencies:
  flutter_bloc:
  get_it:
  go_router:
  rive:            # Rive Flutter runtime (0.14.x, rive_native par based)
  flame:           # mini games ke liye
  google_mobile_ads:
  record:          # mic recording
  just_audio:      # ya flutter_soloud, playback + pitch/speed (verify)
  hive_ce:         # ya isar, local storage
  firebase_core:
  firebase_analytics:
  firebase_crashlytics:
  firebase_remote_config:
  permission_handler:
  shared_preferences:
```
Versions pub.dev se latest lo; LLM ko bolo "pubspec mein latest compatible versions daalo aur `flutter pub get` chala ke check karo".

---

## 3. Rive for beginners (sirf 6 concepts)

Rive ek animation tool hai jo ek chhoti `.riv` file banata hai, aur Flutter mein wo file interactive character ki tarah chalti hai (tap karo to hans de, bhooka ho to mooh khole, etc).

Tumhe animator banne ki zaroorat nahi. Sirf yeh 6 cheezein samjho:

1. **Artboard**: canvas / scene. Owl pack mein artboards `"1"`…`"15"`; custom sleep alag file. (Purana bread example: `CrumboMain` — deprecated.)
2. **Shapes / Layers**: Crumbo ke parts alag alag: body, left eye, right eye, mouth, crust-curl, blush, haath, pair. **Har part alag layer** hona chahiye warna animate nahi hoga.
3. **Bones / Constraints (optional)**: haath-pair ko hilane ka tareeka. Beginners ke liye zaroori nahi, simple scale/rotate/position se kaam chal jata hai.
4. **Animations (timeline)**: chhoti loops jaise `idle_breathe`, `blink`, `chew`, `sleep_loop`, `giggle`. Har ek 1-3 second ki.
5. **State Machine**: ek "dimaag" jo decide karta hai ab kaunsi animation chale: Idle \u2192 Chewing \u2192 Idle, ya Sleepy \u2192 Awake. Flutter code is state machine ko control karta hai.
6. **Data Binding (view model)**: code se Rive ko values bhejne ka naya tareeka (jaise `mood = hungry`, `isTalking = true`).
   - **Zaroori:** Rive ke docs ke mutabiq purana "Inputs" system **deprecated** hai aur naye projects ko **Data Binding** use karna chahiye. LLM ko yeh baat bata dena warna wo purane tutorials ka code likh dega.

### Crumbo ke liye state machine ka simple idea
- Layer 1 (body mood): `Idle`, `Sleepy`, `Hungry`, `Happy`, `Excited`
- Layer 2 (eyes): `Open`, `Blink`, `Closed`
- Layer 3 (mouth): `Closed`, `Talking`, `Chewing`, `Giggle`
- Triggers (ek baar chalne wale): `poke`, `eat`, `toastPop`, `wake`

### Export
Rive se export: project mein pehle se `assets/rive/owl.riv` + `owl_sleep.riv` hain (`pubspec.yaml` assets). Naya custom riv add karo to AGENTS contract follow karo — `crumbo.riv` mat banao.

### Free plan ki limits (verify karo)
Rive ki free plan mein files ki limit aur kuch export/feature limits hain, aur paid plans (Cadet waghera) production export ke liye hote hain. Plans aur prices badalte rehte hain, is liye `rive.app/pricing` dekho. Planning ke liye: shuru mein free plan par seekho, jab final character ready ho tab ek mahine ka paid plan lena sasta rasta ho sakta hai.

### Seekhne ke liye (2-3 ghante kaafi)
- Rive ka official "Getting Started" aur "State Machine" tutorials
- Rive Community (rive.app/community) mein free files kholo aur dekho unka state machine kaise bana hai (copy mat karna, sirf seekhna aur license check karna)
- LLM ke liye: Rive docs ka index `https://rive.app/docs/llms.txt` hai, LLM ko yeh URL do taake wo sahi aur current docs padhe

---

## 4. Rive + AI (MCP) kaise connect karein

MCP (Model Context Protocol) ek tareeka hai jis se Claude jaisi LLM kisi tool ko control kar sakti hai. Rive ke liye abhi 3 tarah ke options hain. **Sab ko pehle chhote test par try karo, bharosa mat karo ke wo poora Crumbo bana denge.**

### Option A: Official Rive MCP (Early Access)
- Rive ke official docs ke mutabiq yeh **Early Access** hai aur "production ke liye abhi available nahi" bataya gaya hai
- Pehle **Mac desktop** app mein aaya, Windows support "coming" likha tha (verify karo)
- **Rive Early Access app khuli honi chahiye** warna server nahi chalta
- Local address: `http://127.0.0.1:9791/mcp`
- Docs abhi **Cursor** ko recommend karte hain
- Kaam: state machines, view models, layouts, shapes jaise repetitive kaam AI se karwana

Setup (docs ke mutabiq):
1. Rive Early Access Mac app install karo aur kholo
2. Tools & MCPs tab mein "Add Custom MCP" par jao, ya `mcp.json` mein yeh daalo:
```json
{
  "mcpServers": {
    "rive": { "url": "http://127.0.0.1:9791/mcp" }
  }
}
```
3. Cursor (ya MCP-supporting client) mein MCP on karo, Rive server dikhna chahiye
4. Rive mein file aur ek Artboard kholo, phir AI ko prompt do

Agar tumhare paas Mac nahi hai to Option B/C dekho.

### Option B: Unofficial `rive-mcp-server` (editor ke bina)
- Third-party, **Rive se affiliated nahi**
- Claim: `.riv` files bana/edit/preview kar sakta hai, bina Rive editor ke; SVG ko Rive shapes mein import kar sakta hai
- Install aur Claude Code mein add:
```bash
npm install -g rive-mcp-server
claude mcp add --scope user rive -- rive-mcp
```
- Isme **SVG import** feature kaam ka hai: tum character ko SVG (vector) mein banwao, phir AI usay Rive shapes bana kar animate kare

### Option C: Dusre third-party servers
- **RiveMCP** (139 tools ka claim): `claude mcp add rivemcp -- npx -y rivemcp`
- **OpenRive**: open-source Rive-jaisa editor + MCP (self-host)
- **rive-docs-mcp**: sirf Rive ki documentation Claude ko search karne deta hai. Code likhte waqt bohot kaam ka (animation banata nahi, sirf docs padhta hai)

### Safety rules (third-party MCP ke liye)
- Unofficial server ka code/README pehle dekho, star/updates check karo
- Apne Google/Firebase/Play keys ya secrets us folder mein na rakho jis par MCP chal raha ho
- Server ko sirf animation folder (`/art/rive/`) tak limited rakho
- Har change ke baad file khud Rive editor mein kholo aur dekho; AI ka kaam final nahi

### Realistic expectation
- AI se **simple shapes aur basic animations** (bounce, blink, wobble) acche ban sakte hain
- **Pyara, polished character** ke liye abhi bhi human artist ka design behtar hota hai
- Sabse mazboot tareeka: **artist/designer se character ka vector (SVG) banwao, AI se usay rig/animate karwao, tum khud review karo**

### Claude Code mein MCP check karne ka tareeka
```bash
claude mcp list          # kaun kaun se servers connected hain
```
Phir Claude Code mein bolo: "rive MCP ke tools list karo aur ek chhota bouncing circle bana ke `art/rive/test.riv` mein save karo." Agar yeh chal gaya to connection theek hai.

---

## 5. Crumbo ki art aur animation bina animator ke: 4 raaste

| Raasta | Kya hota hai | Fayda | Nuksan | Andaza |
| --- | --- | --- | --- | --- |
| **A. Freelance artist (Rive-ready)** | Fiverr/Upwork par "Rive character animator" hire karo | Best quality, tumhe seekhna nahi | Budget lagta hai | Quote lo, brief Section 6 mein hai |
| **B. Artist design + AI/MCP animate** | Artist sirf SVG character banaye (sasta), animation tum AI se | Kam budget | Time aur trial-error | Design ka chhota quote |
| **C. AI concept + khud cleanup** | AI image tools se concept, phir vector mein redraw/trace | Sasta | Quality mixed, copyright aur originality check zaroori | Time heavy |
| **D. Bina Rive (fallback)** | Crumbo ki alag alag PNG layers (body, eyes, mouth) aur Flutter ki apni animations (`AnimationController`, scale/rotate/swap) | Bilkul simple, sirf Flutter | Kam smooth, kam "wow" | Sabse sasta aur sabse tez |

**Ab (Oct 2025):** Owl marketplace pack + custom sleep pehle se integrated — bread SVG path zaroori nahi. Nayi custom animation ke liye MCP / Plan D; contract **AGENTS.md** verify karo (`owl.riv`, artboard switch).

### Copyright aur originality ka dhyan
- Crumbo ka design original rakho (kisi mashhoor character jaisa nahi)
- AI-generated art ko as-is use karne se pehle us tool ki commercial-use policy padho
- Freelancer se **written commercial rights / source files** ka agreement lo
- Rive Community ki free files ki license padho

---

## 6. Owl Rive contract (primary) + deprecated bread brief

### Primary (use this)
Verify against **`AGENTS.md`** + files on disk:

| Item | Value |
| --- | --- |
| Pack | `assets/rive/owl.riv` (AnggaMotion, CC BY) |
| Sleep | `assets/rive/owl_sleep.riv` artboard `sleep` |
| Control | Flutter `CrumboCubit` switches artboards (`"1"`…`"15"`); pack SMs have no mood Inputs |
| Idle | `11` (think); wink=`2`; eat=`10`; dance=`1`; poke=`9`; bubbles=`13` |

Extras / MCP: perch polish, talk placeholder before C10. Plan D = PNG layers.

### Deprecated (bread-era — do not implement)
Old brief used artboard `CrumboMain`, `toastLevel`, `hatId`, bread layers (`crust`, `curl`, …). See `MASTER_PLAN.md` Section 12 appendix.

---

## 7. LLM ke saath is project par kaam kaise karein

### 7.1 Setup
1. Folder banao aur git init karo:
```bash
flutter create crumbo --org com.yourname --platforms android
cd crumbo && git init && git add . && git commit -m "init"
```
2. Claude Code kholo (`claude`) aur project root par chalao
3. Root mein `CLAUDE.md` banao (neeche template) taake har session mein LLM ko rules yaad rahein

### 7.2 `CLAUDE.md` template (copy karo)

> **Prefer root [`AGENTS.md`](../AGENTS.md)** — yeh template sync rakho; bread `CrumboMain` contract **mat** copy karo.

```markdown
# Crumbo (kids talking-owl app)

## Product
- Flutter app for US kids 4-10. Android first. Ads only (AdMob, child-directed).
- Character: Owl — `assets/rive/owl.riv` + `owl_sleep.riv` (see AGENTS.md artboard map).
- Active schedule: docs/DAILY_CHECKLIST.md. Master: docs/MASTER_PLAN.md.

## Stack
- Clean Architecture; Cubit/BLoC; GetIt; GoRouter; Hive (A4); Flame (games); Rive artboard switch from Flutter.

## Hard rules
- No personal data / login / chat. Ads only via AdService. ParentalGate for purchases/links/privacy.
- Mic on-device only. No new SDK without asking.

## Workflow
- 5-line plan → approve → code → flutter analyze + flutter test → commit when asked.
- End with: Kya bana / Kaise test (3 steps) / Kya review.
```

### 7.3 Prompt likhne ke rules
- **Chhota kaam:** "Home screen par Crumbo placeholder dikhao aur tap par giggle trigger bhejo" (achha) vs "poora app bana do" (bura)
- **Pehle plan, phir code:** "Pehle plan likho, mere approve karne ke baad code likhna"
- **Acceptance criteria do:** "Done tab hai jab `flutter analyze` clean ho aur app emulator par chale"
- **Har step ke baad commit**, taake galti par wapas ja sako
- **LLM ko docs do**, memory par chhodo mat (Rive/AdMob APIs badalti rehti hain)
- **Khud review karo:** khaaskar ads, permissions aur parental gate ka code

### 7.4 Parallel kaam (advanced, optional)
Claude Code mein subagents hote hain: ek agent UI banaye, doosra tests. Shuru mein ek hi agent se simple rakho.

---

## 8. Project structure (Clean Architecture)

```
lib/
  main.dart
  app.dart
  core/
    di/ router/ theme/ ui/
    # target: ads/ audio/ storage/ parental_gate/ config/
  features/
    splash/ home/ crumbo/ play/ shop/ store/ settings/
    rewards/ profile/ level/ owls/
    # target: rooms/ economy/ journey/ cards/ games/
assets/
  rive/owl.riv
  rive/owl_sleep.riv
  data/ (home_themes, owl_skins, play_content; target journey/cards/items)
  backgrounds/ images/ fonts/
```

Har feature mein: `data/` / `domain/` / `presentation/` (cubit + widgets).

**Zaroori interface:** `AdService` (abstract) taake AdMob/mediation baad mein badal sako:
```dart
abstract class AdService {
  Future<void> init();
  Future<bool> showRewarded({required String placement});
  Future<void> maybeShowInterstitial({required String placement});
  Widget banner({required String placement});
}
```

---

## 9. Week-by-week build plan (LLM prompts ke saath)

> **Roz ka source of truth:** [`DAILY_CHECKLIST.md`](DAILY_CHECKLIST.md) (A4 pehle unchecked).  
> Neeche prompts **reference** hain; owl home + glossy UI pehle se maujood — placeholder / bread riv mat dobara banao.  
> Har step: tests, `flutter analyze` + `flutter test` clean, phone test, commit jab bolo.

### Week 1: Foundation → Hive (A4)
**Tasks:** (skeleton DONE) Hive boxes + theme/skin prefs migrate
**Prompt:**
> `AGENTS.md` aur `docs/DAILY_CHECKLIST.md` padho. Aaj ka task A4: Hive boxes `crumbo_state`, `inventory`, `economy`, `settings`. Owl home pehle se hai — UI mat toodo. Pehle 5-line plan, phir code + tests.

### Week 2: Needs + care (A6–A10)
**Tasks:** `NeedsCubit` / pet needs 0–100 (keep `CrumboCubit` for owl expressions), decay, feed/sleep polish
**Prompt:**
> Needs entity + cubit banao (hunger, sleep, fun, clean, love). Decay last-seen timestamp se. Hive save. Unit tests. Expression Moods sheet already hai — need icons alag.

### Week 3: Rooms + shop + economy
**Tasks:** Bedroom/Kitchen/Bathroom screens, coins/gems, shop (food, outfits), daily reward
**Prompt:**
> `features/economy` mein coins aur gems ka repository + cubit banao. `features/shop` mein items ki JSON list (assets) se shop banao. Daily reward calendar (7 din, streak) banao. Sab Hive mein. Koi network call nahi.

### Week 4: Voice repeat
**Tasks:** mic permission, record, silence detect, pitch-shifted playback
**Prompt:**
> `core/audio/VoiceService` banao: mic record (`record` package), jab bacha chup ho jaye (silence threshold) to recording rok do, phir pitch/speed badal kar playback. Presets: Sleepy, Chipmunk, Deep. Audio sirf device par, file playback ke baad delete. Pehle current package docs padho aur plan dikhao.

### Week 5: Ads (AdMob)
**Tasks:** AdService, rewarded/interstitial/banner, frequency rules, Remote Config
**Prompt:**
> `core/ads` mein `AdService` interface aur `AdmobAdService` banao. Init mein child-directed settings lagao (code Section 10 jaisa). Rewarded: opt-in button ke saath. Interstitial: sirf natural breaks, minimum 90 second gap, 3 games ke baad. Banner: sirf shop aur result screen ke neeche. App-open ad nahi. Frequencies Firebase Remote Config se aayein. Test ad unit IDs use karo.

### Week 6: Mini games (Flame)
**Tasks:** Topping Catch, Toaster Pop, Bubble Pop, Crumb Runner, Match
**Prompt (ek ek game ke liye):**
> `features/games/topping_catch` Flame se banao: toppings upar se girein, Crumbo ki plate left-right drag se move ho. 45 second ka round. End par coins calculate karo aur result screen par "Watch ad for 2x coins" button (rewarded) dikhao. Koi violence/scary cheez nahi.

### Week 7: Parental gate + settings + privacy
**Tasks:** parental gate, settings, privacy policy page, "Remove Ads" (optional)
**Prompt:**
> `core/parental_gate` banao: random math sawal (bade numbers, bachon ke liye mushkil). Isse purchases, external links, sharing, notification settings, aur privacy policy khulne se pehle guzarna hoga.

### Week 8: Owl Rive polish (D10 — pack already integrated)
**Tasks:** journey-gated moods, perch tuning, talk placeholder; Plan D if needed
**Prompt:**
> `AGENTS.md` Rive contract + https://rive.app/docs/llms.txt. `CrumboView` pehle se `owl.riv` / `owl_sleep.riv` use karta hai. Bread-era `crumbo.riv` / `CrumboMain` / `toastLevel` mat banao.

### Week 9: Polish + analytics + test
Sounds, haptics, onboarding (3 screens), Firebase Analytics events (anonymous), Crashlytics, low-end phone testing. (Checklist D7–D9, F1.)

### Week 10: Soft launch (AFTER 24 Nov full-dev deadline)
Chhote country mein release, ad frequency aur economy tune (Remote Config).

---

## 10. Feature implementation notes

### 10.1 AdMob (kids settings)
Init ke time sabse pehle:
```dart
await MobileAds.instance.updateRequestConfiguration(
  RequestConfiguration(
    tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
    tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.yes,
    maxAdContentRating: MaxAdContentRating.g,
  ),
);
await MobileAds.instance.initialize();
```
- Sirf Google Play ki Families-certified ad SDKs/mediation networks (abhi Google ki current list se check karo)
- Development mein **test ad unit IDs** hi use karo; apne live ads par khud click karna account ban karwa sakta hai
- Interstitial gap: Remote Config `interstitial_min_gap_seconds` (default 120)

### 10.2 Voice repeat
- Mic permission ek baar, simple parent-friendly explanation ke saath
- Record → silence detect → pitch/speed change → play; owl talk/listen expression (C10) — bread `isTalking` VM nahi
- Audio device par hi process; server par kabhi nahi (COPPA)
- Test real phone par: echo / speaker feedback (playback ke dauran recording band)

### 10.3 Economy tuning (Remote Config se)
```
reward_ad_coin_multiplier = 2
daily_reward_coins = [50,50,75,75,100,100,250]
interstitial_every_n_games = 3
interstitial_min_gap_seconds = 120
```
Taake bina app update ke balance badal sako.

### 10.4 Parental gate
Math question, random har dafa, 2 attempts ke baad lock 30 second. Jin jagahon par lagana hai woh Section 7.2 ke rules mein hain.

### 10.5 Storage
Hive boxes: `crumbo_state`, `inventory`, `economy`, `settings`. Koi personal data nahi, koi user ID nahi.

---

## 11. Testing aur Play Store release

### Testing checklist
- [ ] Low-end Android phone par 60 fps (ya kam se kam smooth)
- [ ] Bina internet ke app chale (ads sirf internet par)
- [ ] Ads na load ho to rewarded button chhup jaye ya "abhi available nahi" dikhaye (bacha stuck na ho)
- [ ] Mic permission deny karne par app crash na kare
- [ ] Parental gate har sensitive jagah par
- [ ] Koi ad gameplay ke beech ya buttons ke bilkul paas nahi
- [ ] App background/foreground switch par audio aur Rive theek
- [ ] 24+ ghante ki needs decay test (device time badal kar)

### Play Console release
- [ ] Target audience: bachon ka age group select + Families declaration
- [ ] Ads declaration: haan, ads hain
- [ ] Data Safety form: sach bharo (analytics ka anonymous data, mic data device par hi)
- [ ] Privacy policy ka public URL (app ke andar bhi link, parental gate ke peeche)
- [ ] Content rating questionnaire
- [ ] Store listing native English mein, screenshots, icon, short/long description
- [ ] Naam trademark check (USPTO + Play Store search)
- [ ] Pehle internal testing / closed testing, phir production
- [ ] Naye personal developer accounts ke liye closed-testing ki requirements ho sakti hain, Play Console ki current requirement check karo

> Compliance general information hai, legal advice nahi. Launch se pehle COPPA/Families policy ek expert se review karwa lo.

---

## 12. Aam galtiyan (jo bachni hain)

1. Poora app ek saath bolna ("sab bana do"). Chhote steps lo
2. Purane Rive "Inputs" tutorials ka code lena (ab Data Binding)
3. Artist ke aane ka intezar karna. Placeholder se aage badho
4. Live ads par khud click karna (account risk)
5. App-open ya gameplay ke beech ads lagana
6. Mic audio server par bhejna
7. Unofficial MCP par bharosa kar ke final art ship karna bina review ke
8. Rive layers merged chhodna (animate nahi ho payegi)
9. Remote Config na rakhna (ad frequency ko baad mein badalna mushkil)
10. Trademark check bhoolna

---

## 13. Where we are now (2026-10-25)

- Owl glossy home + static shells **done** — see checklist Done / A-UI block
- **Next:** [`DAILY_CHECKLIST.md`](DAILY_CHECKLIST.md) **A5** (Firebase stub / skeleton)
- Soft launch / Play Console **after** 24 Nov full-dev deadline

---

## Sources (jahan se verify kiya)
- Rive official: MCP integration (Early Access) https://rive.app/docs/editor/mcp/integration aur https://rive.app/docs/editor/ai/mcp
- Rive official: Flutter inputs (deprecated, Data Binding use karo) https://rive.app/docs/runtimes/flutter/inputs
- Rive Flutter package changelog https://pub.dev/packages/rive/changelog
- Rive pricing https://rive.app/docs/account-admin/pricing (aur rive.app/pricing; prices badalte hain, wahan dekho)
- Unofficial rive-mcp-server: https://glama.ai/mcp/servers/ODU33104/rive-mcp
- RiveMCP: https://glama.ai/mcp/servers/paradoxsyn/rivemcp-releases/tree
- OpenRive MCP: https://github.com/UpstandPlatform/OpenRive/wiki/MCP-Server
- rive-docs-mcp: https://glama.ai/mcp/servers/StormXX/rive-docs-mcp
