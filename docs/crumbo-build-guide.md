# Crumbo: Complete Build Guide (Flutter + Rive + LLM Workflow)

Date: 2026-10-20
Owner: Haris
Goal: "Crumbo" naam ki talking toast kids app (US kids 4-10) banana, ads se revenue, Flutter + Rive mein, LLM (Claude Code) ki madad se, **bina animation ka experience ke**.

> Note: Rive/MCP ki details tezi se badalti hain. Jo cheez "verify karo" likhi hai usay kaam shuru karne se pehle official page pe confirm kar lena. Sources aakhir mein hain.

---

## 0. Is guide ko kaise use karna hai

1. Section 1-2 padho aur setup karo (1 din)
2. Section 3 se Rive ka basic concept samjho (1-2 ghante, itna hi kaafi hai)
3. Section 4-5 se decide karo ke animation kaise aayegi (AI se, artist se, ya fallback)
4. Section 7 se LLM ko project par set karo (CLAUDE.md)
5. Section 9 ka week-by-week plan follow karo, har step ka prompt ready hai

---

## 1. Big picture: kaun kya karega

| Kaam | Kaun karega | Tool |
| --- | --- | --- |
| Idea, decisions, testing, store listing | Tum (Haris) | Phone + Play Console |
| Flutter code (UI, logic, ads, storage) | LLM + tumhara review | Claude Code (ya Cursor) |
| Crumbo ki art (character drawing) | Artist ya AI-generated concept + vector cleanup | Figma / Illustrator / freelancer |
| Crumbo ki animation (blink, chew, sleep, react) | Rive file (`.riv`) | Rive editor (+ MCP agar kaam kare) |
| Awaaz repeat (voice) | Flutter packages, device par | `record` + audio player with pitch |
| Ads | AdMob (child-directed settings ke saath) | `google_mobile_ads` |

**Sabse bada risk animation hai.** Code LLM likh dega, lekin ek acchi character animation ke liye ya artist chahiye ya Rive seekhna. Is liye Section 5 mein 3 raaste diye hain aur ek "bina Rive" fallback bhi.

**Order of work (straight run):**
1. Setup + project skeleton (code)
2. Placeholder Crumbo (simple image/emoji-style) ke saath poora game loop banao: needs, shop, coins, mini games, ads
3. Parallel mein art/animation ka kaam chalao
4. Final Rive character ko placeholder ki jagah laga do
5. Test, soft launch, release

Yeh order isliye hai ke animation ka intezar kiye bina app 80% bann jaye.

---

## 2. Setup checklist

### Accounts
- [ ] Google Play Console account (one-time registration fee hoti hai, current amount Play Console pe dekho)
- [ ] AdMob account (Play Console / Google account se)
- [ ] Rive account (rive.app, free plan se shuru)
- [ ] GitHub account (code backup + LLM ke saath kaam)
- [ ] Firebase project (Analytics, Crashlytics, Remote Config)
- [ ] Domain ya GitHub Pages (privacy policy ka public URL ke liye)

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

1. **Artboard**: canvas, jahan Crumbo bana hota hai. Ek file = ek ya zyada artboards (jaise `CrumboMain`, `ToasterScene`).
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
Rive editor se `.riv` file export hoti hai, usay `assets/rive/crumbo.riv` mein rakho aur `pubspec.yaml` mein assets mein add karo.

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

**Mera suggestion (direct):** pehle **D (fallback)** se poora app functional banao taake revenue wala hissa test ho, aur parallel mein **A ya B** se asli Crumbo animation karwao. Phir `.riv` aate hi swap kar do. Is tarah artist ka intezar app ko rokta nahi.

### Copyright aur originality ka dhyan
- Crumbo ka design original rakho (kisi mashhoor character jaisa nahi)
- AI-generated art ko as-is use karne se pehle us tool ki commercial-use policy padho
- Freelancer se **written commercial rights / source files** ka agreement lo
- Rive Community ki free files ki license padho

---

## 6. Crumbo animation spec (artist ko dene ke liye brief)

### Character brief
- Round-square bread slice, golden-brown crust, cream andar
- 2 bade sleepy aankhein, chhota blush, upar crust ka curl
- Chhote haath pair, soft rounded shapes
- Palette: cream, golden brown, butter yellow (accent), 2-3 colors
- Tone: pyara, sleepy, kids-safe (koi daraawna ya gussa wala expression nahi)

### Deliverables
- Artboard: `CrumboMain` (portrait, 1080x1080 base) aur `ToasterScene`
- **Layers alag**: body, crust, eye_L, eye_R, eyelid_L/R, mouth (alag shapes: closed, open, smile, chew), blush, arm_L/R, leg_L/R
- Naming: sab layers ka naam English snake_case
- Format: `.riv` (aur source `.rev` ya SVG bhi do)
- Size target: 1-2 MB se kam

### Animations list

| Animation | Length | Kab chalti hai |
| --- | --- | --- |
| `idle_breathe` | 2-3s loop | Hamesha (halka saans) |
| `blink` | 0.3s | Random har 3-5s |
| `sleep_loop` | 3s loop | Crumbo so raha ho (Zzz) |
| `wake_up` | 1.5s | Tap/shake/alarm par |
| `talk` | loop | Voice repeat ke waqt mooh hilta hai |
| `listen` | loop | Bacha bol raha ho (kaan/aankh bade) |
| `eat_chew` | 1.5s | Khana khate waqt |
| `happy_jump` | 1s | Reward milne par |
| `giggle` | 1s | Tickle/poke |
| `hungry` | loop | Bhook idle (pet par haath) |
| `toast_light/golden/dark` | color states | Toaster mein |
| `sneeze` | 1s | Random surprise |
| `dress_slot_hat / glasses` | static slots | Outfit lagane ke liye |

### State machine (data binding ke saath)
View model properties (names fix karo taake code aur art match karein):

| Property | Type | Values / Kaam |
| --- | --- | --- |
| `mood` | enum | idle, sleepy, hungry, happy, excited |
| `isTalking` | bool | Mooh hilana |
| `isListening` | bool | Sun raha hai |
| `isChewing` | bool | Chew animation |
| `toastLevel` | number | 0 = bread, 1 = golden, 2 = dark |
| `pokeTrigger` | trigger | Tickle/giggle |
| `wakeTrigger` | trigger | Jaagna |
| `hatId` | number | Outfit slot (0 = none) |

> Artist ko yeh table do: Flutter code in exact names par kaam karega.

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

```markdown
# Crumbo (kids talking-toast app)

## Product
- Flutter app for US kids 4-10. Android first.
- Monetization: ads only (AdMob, child-directed). One optional "Remove Ads" purchase behind a parental gate.
- Character: Crumbo the sleepy bread slice (Rive animation `assets/rive/crumbo.riv`).

## Stack and architecture
- Clean Architecture: lib/core, lib/features/<feature>/{data,domain,presentation}
- State: Cubit/BLoC (flutter_bloc). DI: GetIt. Routing: GoRouter.
- Local storage only (Hive). No backend, no accounts, no personal data.
- Games: Flame. Animation: Rive (use Data Binding, NOT deprecated state machine Inputs).

## Hard rules (kids app compliance)
- Never collect personal data. No login, no chat, no social features.
- Ads: only through `AdService`. Child-directed treatment ON, max ad content rating G, non-personalized.
- Never show an ad during gameplay, on app open, or near gameplay buttons.
- Rewarded ads are always opt-in with a clear button.
- External links, purchases, sharing, privacy policy open only behind `ParentalGate`.
- Mic audio is processed on device only; never uploaded or stored beyond the current session.
- No new SDK or permission without asking me first.

## Workflow rules
- Work in small steps. One feature per task. Show the plan first, then code.
- Run `flutter analyze` and `flutter test` after each change and fix issues.
- Commit after each working step with a clear message.
- Before using any package API, read its current docs (Rive docs index: https://rive.app/docs/llms.txt). Do not guess APIs.
- Ask me if something is unclear instead of assuming.
- Keep files small; no giant widgets.

## Rive contract (names must match the artist's file)
Artboard: CrumboMain
View model: mood(enum), isTalking(bool), isListening(bool), isChewing(bool), toastLevel(number), pokeTrigger, wakeTrigger, hatId(number)
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
    di/            (GetIt setup)
    router/        (GoRouter)
    ads/           (AdService interface + admob_ad_service.dart)
    audio/         (VoiceService: record, pitch, play)
    storage/       (Hive boxes)
    theme/
    parental_gate/
    config/        (RemoteConfig keys: ad frequency, rewards)
  features/
    home/          (Crumbo screen, mood UI)
    crumbo/        (character state, needs, rive controller)
    rooms/         (kitchen, bedroom, bath, playroom, ...)
    shop/          (items, outfits, purchases with coins)
    economy/       (coins, gems, daily reward, chests)
    games/         (flame games: topping_catch, toaster_pop, ...)
    settings/      (sound, parent area, privacy policy)
assets/
  rive/crumbo.riv
  audio/
  images/
  fallback/        (PNG layers for Plan D)
```

Har feature mein: `data/` (storage), `domain/` (entities, usecases), `presentation/` (cubit + widgets).

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

> Har step ke aakhir mein: `flutter analyze` clean, commit, phone par test.

### Week 1: Foundation
**Tasks:** project skeleton, DI, routing, theme, storage
**Prompt:**
> CLAUDE.md padho. Clean Architecture folders banao jaise CLAUDE.md mein hain. GetIt, GoRouter, flutter_bloc setup karo. Ek `HomePage` banao jis par placeholder Crumbo (ek simple Image) dikhe. Pehle plan dikhao, phir code. Done = `flutter analyze` clean aur app chale.

### Week 2: Crumbo needs + core actions (placeholder art ke saath)
**Tasks:** `CrumboCubit` (hunger, sleep, fun, clean, love), feed/sleep/pet actions, mood calculation, Hive mein save
**Prompt:**
> `features/crumbo` mein `CrumboState` (needs 0-100) aur `CrumboCubit` banao. Needs time ke saath girein (app band hone par bhi: last-seen timestamp se calculate), lekin zero par koi punishment nahi, sirf mood badle. Hive mein save karo. Unit tests likho for decay logic.

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

### Week 8: Rive integration (jab art ready ho)
**Tasks:** placeholder ko `.riv` se replace karna
**Prompt:**
> Rive ki current Flutter docs (https://rive.app/docs/llms.txt se shuru karo) padho. `assets/rive/crumbo.riv` load karo aur `CrumboView` widget banao jo view model properties (`mood`, `isTalking`, `isListening`, `isChewing`, `toastLevel`, triggers) `CrumboCubit` se bind kare. Purana Inputs API mat use karna. Agar file mein property ka naam alag ho to mujhe batao.

### Week 9: Polish + analytics + test
Sounds, haptics, onboarding (3 screens), Firebase Analytics events (anonymous), Crashlytics, low-end phone testing.

### Week 10: Soft launch
Chhote country mein release, ad frequency aur economy tune karo (Remote Config se bina update ke).

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
- Record \u2192 silence detect \u2192 pitch/speed change \u2192 play, aur Rive mein `isListening` / `isTalking` flip karo
- Audio device par hi process hoga, server par kabhi nahi (COPPA ke liye safe)
- Test real phone par: echo aur speaker feedback ka masla aata hai (playback ke dauran recording band rakho)

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

## 13. Pehle 3 din ka mukhtasar plan

- **Din 1:** accounts + tools install, `flutter create`, `CLAUDE.md`, git
- **Din 2:** Rive free account, 1 tutorial, MCP connection ka chhota test (Section 4), artist ke liye brief (Section 6) post karo
- **Din 3:** Week 1 ka prompt chalao aur placeholder Crumbo home screen par dikhao

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
