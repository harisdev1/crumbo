# Crumbo: Final Master Plan (Concept + Features + Journey Map + Cards + Ads + Rive MCP + Cursor Vibe-Coding)

Date: 2026-10-20 (status refresh 2026-10-25)  
Owner: Haris  
Canonical file: `docs/MASTER_PLAN.md`. LLM ko bolo "pehle isay padho". Roz ka schedule: [`DAILY_CHECKLIST.md`](DAILY_CHECKLIST.md).

---

## 0. Implementation status (2026-10-25)

| Area | Status | Notes / checklist IDs |
| --- | --- | --- |
| Foundation (DI, router, theme) | Done | A1–A3 |
| Glossy UI shell + static routes | Done | A-UI1–A-UI8 |
| Character Rive (owl pack + sleep) | Done / Partial | A-UI4; D10 polish + journey gates later |
| Storage (Hive) | Done | A4 — four boxes + theme/skin in `settings` |
| Needs meters + decay | Done | A6–A8 (`NeedsCubit` + home meters; `CrumboCubit` = expressions) |
| Economy / shop / daily | Done (MVP) | B3–B5 wallet, shop, daily streak |
| Journey / cards | Partial | B6–B10 album/flip/unlock + map UI; C1–C2 node completion next |
| Mini games (Flame) | Not started | C3–C7 (Play hub shell + JSON only) |
| Voice | Done (C8–C10) — mic on-device, listen/talk rivs, presets; phone USB verify | — |
| Ads | Not started | D1–D4 |
| Parental / settings / onboarding | Partial | D5–D7 shells |

**Aaj ka pehla core task:** checklist **C1** (journey node completion). B5–B10 done. A5 Firebase still skipped.

---

## 1. App ek line mein

**Crumbo** ek sleepy talking **owl** kids app hai (US kids 4-10). Brand name Crumbo; mascot AnggaMotion Expression Pack (`assets/rive/owl.riv`, CC BY) + custom sleep riv. Bacha usay jagata hai, khilata hai, nehlata hai, sulata hai, saaf karta hai, mini games khelta hai, **Journey Map** par aage badhta hai, aur **cards** unlock karke nayi cheezein (skins, food, rooms, friends) kholta hai. Revenue **ads** se hai (rewarded main), RevenueCat nahi.

**Haan, is mein sab hai:** sleep, bath, clean, food, play hub, journey map, aur card-unlock system. Neeche 40 features ki list hai.  
*(Bread-slice / toast toaster pehle concept tha — ab core mascot owl hai. Toaster Pop etc. mini-game theme / v1.1 slot.)*

**Platform:** Android pehle, phir iOS. **Market:** US (native English UI). **Tools:** Flutter + Rive + Cursor (vibe-coding).

---

## 2. Character: Crumbo (owl)

- Cute owl mascot — marketplace pack artboards; home pe bada owl + perch / branch scene
- Soft brown / cream skins (JSON `owl_skins.json`); themes SVG backgrounds
- Personality: sleepy, bhookha, thoda clumsy, pyaara. Care actions se mood expressions
- Voice (future): bachay ki awaaz soft, sleepy, high pitch mein repeat (presets: Sleepy, Chipmunk, Deep Hoot)
- Catchphrase (sleepy): "Five more minutes..."
- Backstory: Crumbo ek chhota owl jo jungle / cozy nest se nikal kar dost aur naye ghar dhoondhta hai (Journey Map ka bahana)
- Credit: AnggaMotion Expression Pack (CC BY) — Settings / About mein dikhana; launch se pehle USPTO / Play Store par "Crumbo" check

---

## 3. 40 Features ki poori list

Phase: **MVP** = pehla launch, **v1.1 / v1.2** = launch ke baad, **Future** = agar app chal gayi.
Ad hook: **R** = rewarded video (bacha khud choose kare), **I** = natural-break interstitial, **-** = koi ad nahi.

### A. Care actions (Crumbo ki dekh-bhaal)

| # | Feature | Kya hota hai | Ad hook | Phase |
| --- | --- | --- | --- | --- |
| 1 | Wake up | Tap, shake ya alarm se Crumbo jaagta hai ("Five more minutes...") | R: double wake-up coins | MVP |
| 2 | Voice repeat | Bacha bolta hai, Crumbo funny voice mein repeat karta hai | R: naye voice presets | MVP |
| 3 | Feed | Food drag karke owl ko khilao | R: premium food free | MVP |
| 4 | Toaster Pop (mini-game) | Timing game — Play hub slot (purana “toast Crumbo” core nahi) | I: game complete ke baad | MVP game / was bread care |
| 5 | Sleep / lullaby | Light band, gaana, Zzz (`owl_sleep.riv`) | R: naye lullabies | MVP |
| 6 | Bath | Bubbles, sponge, rubber duck | I: bath ke baad | MVP |
| 7 | Clean | Dhool / crumbs saaf, sparkle | R: sparkle effect | MVP |
| 8 | Pet / tickle | Tap-hold / bonk → giggle / angry / dizzy | - (trust ke liye) | MVP (bonk partial) |
| 9 | Skins & themes | Owl color skins + home theme backgrounds | R: free unlock | MVP (UI shipped) |
| 10a | Expressions | Moods sheet — Rive artboards (idle, wink, eat, dance…) | - | MVP (shipped) |
| 10b | Needs meters | Hunger, Sleep, Fun, Clean, Love icons + decay | - | MVP (A6–A8) |

### B. Rooms (alag screens)

| # | Feature | Actions | Unlock | Phase |
| --- | --- | --- | --- | --- |
| 11 | Kitchen | Feed, food station | Free | MVP |
| 12 | Bedroom | Sleep, lullaby, night-light | Free | MVP |
| 13 | Bathroom | Bubble bath, shower, duck | Free | MVP |
| 14 | Playroom | Toys, games arcade | Journey Level 3 | v1.1 |
| 15 | Garden | Pani dena, flowers, butterflies | Journey Level 5 | v1.1 |
| 16 | Mini Mall / Shop | Outfits, food, furniture coins se | Level 6 | MVP (basic) |
| 17 | Room decorate | Wallpaper, furniture, lights | Cards ya coins | v1.1 |

### C. Journey Map (progress ka raasta, Section 4 mein detail)

| # | Feature | Kya hota hai | Ad hook | Phase |
| --- | --- | --- | --- | --- |
| 18 | Journey Map | Zones aur nodes ka raasta, har node ek task ya game | R: node skip/double | MVP |
| 19 | Map zones | 5 themed zones (Section 4) | - | MVP (2 zones), baaki baad |
| 20 | Milestone chests | Har 5th node par chest | R: chest double | MVP |
| 21 | Big Toast events | Zone ka "boss" mini-challenge | R: retry | v1.1 |

### D. Cards aur unlocks (Section 5 mein detail)

| # | Feature | Kya hota hai | Ad hook | Phase |
| --- | --- | --- | --- | --- |
| 22 | Card album | Saare cards ek jagah, locked cards dhundhle | - | MVP |
| 23 | Card types | Outfit, Food, Friend, Room, Sticker, Surprise | - | MVP |
| 24 | Card rarities | Common, Rare, Super Rare, Golden | - | MVP |
| 25 | Card unlock methods | Task, ad, level, coins (Section 5) | R | MVP |
| 26 | Card packs | Chest se 1-3 random cards | R: extra card | MVP |
| 27 | Set rewards | Poora set complete karo to bada inaam | - | v1.1 |

### E. Mini games

| # | Feature | Phase |
| --- | --- | --- |
| 28 | Topping Catch | MVP |
| 29 | Toaster Pop (timing) | MVP |
| 30 | Bubble Pop | MVP |
| 31 | Crumb Runner (endless runner) | MVP |
| 32 | Match the Breakfast (memory) | MVP |

Har game ke end par: coins + "Watch ad for 2x coins" (R); 3 games ke baad ek interstitial (I).

### F. Economy aur retention

| # | Feature | Kya hota hai | Phase |
| --- | --- | --- | --- |
| 33 | Coins aur Gems | Soft aur premium-feel currency (sirf gameplay/ads se) | MVP |
| 34 | Daily reward calendar | 7-din cycle, 7th din bada gift | MVP |
| 35 | Daily tasks | "Owl ko khilao", "1 game khelo" | MVP |
| 36 | Spin wheel | Roz 1 free, extra spin ad se (R) | MVP |
| 37 | Achievements | "10 feeds", "First card set" | v1.1 |
| 38 | Streaks | 3/7/14/30 din ke rewards | v1.1 |
| 39 | Record & replay video | Funny video record, save/share (parental gate) | v1.2 |
| 40 | Events (Halloween, Xmas, Summer) | Limited-time outfits aur map zone | v1.2 |

### G. Future (agar app chal gayi, abhi mat banao)
- Crumbo Hotel (guests serve karna, time-management) aur Crumbo Bakery
- Guest/friend characters: Butter, Jam, Egg, Milk, Waffle (naye cards + naye games)
- Beach / Snow / Space travel zones
- Dance Floor + Rhythm Tap, Cake Stack, Hiccup Dash, Puzzle Slice games
- Birthday Party room, Sticker photo booth
- iOS, Spanish localization, cross-promo, plush/merch ideas
- Optional "Remove Ads" one-time purchase (parental gate ke peeche)

**Rule:** MVP mein sirf wahi features jo "MVP" likhe hain. Baaki sab architecture mein jagah rakhen (JSON-driven) taake baad mein jodna asaan ho.

---

## 4. Journey Map (progress ka raasta)

### Idea
Crumbo ko apna ghar dhoondhna hai. Map ek lamba raasta hai (Candy Crush jaisa path) jis par nodes hain. Har node ek chhota kaam hai. Bacha aage badhta hai, zones khulte hain, rewards aur cards milte hain.

### Zones (5 zone x ~10 nodes = 50 nodes, MVP mein 2 zones)

| Zone | Theme | Kis par focus | Unlock |
| --- | --- | --- | --- |
| 1. Cozy Kitchen | Khana aur toast | Feed, toast, topping catch | Start |
| 2. Bubble Bay | Nehlana aur saaf-safai | Bath, clean, bubble pop | Zone 1 poora |
| 3. Dreamy Hills | Neend aur lullabies | Sleep, lullaby, stars | 15 cards ya level 8 |
| 4. Jam Jungle | Adventure aur runner | Crumb Runner, garden | Level 12 |
| 5. Toast Town | Dost aur party | Friend cards, party | Level 16 |

### Node types

| Node | Kya hota hai |
| --- | --- |
| Care task | "Crumbo ko 2 toast khilao" |
| Mini game | Score ya coins target |
| Card reveal | Ek card kholo |
| Chest | 1-3 cards + coins |
| Big Toast | Zone ka special challenge |
| Gate | Aage jaane ke liye shart (neeche) |

### Gates (rukawat) ke 3 tareeke, bacha chune
1. **Kuch karo:** jaise "5 cards collect karo" ya "3 games khelo"
2. **Coins do:** collected coins se
3. **Ad dekho:** ek rewarded ad se gate khul jata hai

**Zaroori UX rule:** har gate par **kam se kam ek bina-ad raasta** ho. Journey ko sirf ad dekhne par rokna bachon ke liye frustrating hota hai aur policy/rating ke liye risky.

### Technical
Map ka data JSON mein rakho (nodes badalna app update ke bina bhi mumkin ho, Remote Config ya local asset). Example:
```json
{
  "zone": "cozy_kitchen",
  "nodes": [
    {"id": "k1", "type": "care", "task": "feed", "count": 2, "reward": {"coins": 20}},
    {"id": "k2", "type": "game", "game": "topping_catch", "target": 30, "reward": {"coins": 30}},
    {"id": "k3", "type": "card_reveal", "card": "outfit_chef_hat"},
    {"id": "k4", "type": "chest", "cards": 2, "reward": {"coins": 50}},
    {"id": "k5", "type": "gate", "options": [
      {"method": "task", "need": {"cards": 5}},
      {"method": "coins", "need": 100},
      {"method": "ad", "placement": "gate_k5"}
    ]}
  ]
}
```

---

## 5. Card system (unlock ka dil)

### Card kya hai
Ek collectible: ya to Crumbo ka outfit, ya khana, ya room item, ya friend character, ya sticker, ya surprise. Album mein locked cards dhundhle ("?") dikhte hain, jis se bacha unhein kholna chahta hai.

### Rarity
Common (60%), Rare (28%), Super Rare (10%), Golden (2%): yeh sirf starting numbers hain, Remote Config se tune karo.

### 4 unlock methods (mix)

| Method | Kaise | Kitna hissa (approx target) |
| --- | --- | --- |
| Kuch karo (task) | "5 toast banao", "bath do" | ~40% |
| Level / Journey | Map ke nodes aur chests se | ~30% |
| Coins | Shop mein coins se | ~15% |
| Ad dekho (rewarded) | "Watch ad to flip this card" | ~15% (sirf extra, kabhi sirf-ad nahi) |

### Card reveal ka maza
- Card ulta rakha hota hai, bacha tap kare, flip animation, sparkle, sound
- Naya card ho to "NEW!" tag, duplicate ho to chhote coins mein convert
- Set (jaise "Chef Set": hat, apron, spoon) poora karne par bada inaam (v1.1)

### Rewarded ad ke natural moments
- Chest kholne ke baad "Extra card?"
- Gate kholna
- Card flip ke liye "free flip"
- Duplicate ko "rare mein badlo"

### Data example
```json
{
  "id": "outfit_chef_hat",
  "type": "outfit",
  "rarity": "common",
  "set": "chef",
  "unlock": [
    {"method": "journey", "node": "k3"},
    {"method": "coins", "price": 80},
    {"method": "ad", "placement": "card_chef_hat"}
  ]
}
```
Naye cards bas JSON mein add hote hain, code nahi badalna padta. Isi se "agar successful hui to aur add karenge" asaan hota hai.

---

## 6. Needs aur Mood

| Need | Icon | Kaise bharti hai |
| --- | --- | --- |
| Hunger | Butter/jam | Feed |
| Sleep | Moon | Bedroom, lullaby |
| Fun | Balloon | Games, tickle |
| Clean | Bubble | Bath, clean |
| Love | Heart | Pet, hug |

- Moods: Happy, Sleepy, Hungry, Excited, Silly, Cozy (har ka alag animation aur voice)
- Needs time se girti hain (app band ho tab bhi: last-seen timestamp se calculate)
- **Zero par koi saza ya "sad crying" nahi**, sirf cute sleepy/hungry animation (kids-safe)
- Excited mood mein games mein extra coins

---

## 7. Economy

- **Coins:** games, feed, tasks se. Shop aur cards ke liye
- **Gems:** sirf rewarded ads, streaks, achievements se. Rare cards/outfits ke liye
- **Daily reward:** 7-din calendar, 7th din bada gift; miss hone par "ad dekho streak bachao" (R)
- **Chests:** Bronze (free, timer), Silver (ad se), Gold (gems se); timer skip rewarded ad se
- **Balance rule:** ek rewarded ad = ek chhota upgrade. Itna generous na ho ke bacha ads ignore kare, itna tight na ho ke frustration ho
- Sab numbers Remote Config mein, taake soft launch mein tune ho sakein
- Real-money: sirf optional "Remove Ads", parental gate ke peeche

---

## 8. Ads plan (final)

| Ad type | Kahan | Frequency | Note |
| --- | --- | --- | --- |
| Rewarded video | Game-end 2x, chest/extra card, gate, spin, streak save, timer skip, voice presets | 100% opt-in | Main earner |
| Interstitial | 3 games ke baad, toast/bath ke baad, room-change (har 4-5th) | Min 90-120 sec gap | Kabhi gameplay ke beech ya app-open par nahi |
| Banner | Shop aur result screen ke neeche | Always-on, chhota | Gameplay/buttons ke paas nahi |
| House/cross-promo | Settings/menu | Kam | Parental gate ke peeche |
| App-open ad | **Nahi lagana** | - | Kids app mein risky |

### Kids-safe rules (zaroori)
- Sirf **Google Play Families-certified** ad SDKs/mediation (list Google ki current policy page se check karo)
- Child-directed treatment ON, ad content rating G, non-personalized
- Rewarded ke pehle clear button ("Watch a short video for 2x coins"), koi dhoka nahi
- Close button asani se dikhe
- Ad load na ho to button chhup jaye ya "abhi available nahi" dikhaye (bacha stuck na ho)

### AdMob init (code)
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
Development mein sirf **test ad unit IDs**. Live ads par khud click mat karna.

### Revenue formula (illustrative)
```
Daily revenue = DAU x (rewarded views x eCPM_r + interstitials x eCPM_i + banner impr. x eCPM_b) / 1000
```
Kids-directed non-personalized ads ka eCPM normal apps se kam hota hai; asli numbers soft-launch mein pata chalenge. Growth ke 3 lever: DAU, session length, rewarded opt-in rate.

### `AdService` interface (network baad mein badalne ke liye)
```dart
abstract class AdService {
  Future<void> init();
  Future<bool> showRewarded({required String placement});
  Future<void> maybeShowInterstitial({required String placement});
  Widget banner({required String placement});
}
```

---

## 9. Retention hooks

- Daily calendar, streaks, daily tasks
- Journey ka "agla node sirf 1 game door" progress bar
- Card album ka "kitne cards baqi" counter
- Limited-time events (Halloween, Xmas, Summer) ke naye cards/outfits
- Random surprise animations (sneeze, funny line)
- Parent-allowed reminders ("Crumbo is sleepy"), sirf parental gate ke baad on
- Voice presets aur video record (organic sharing, parental gate ke saath)

---

## 10. Compliance (COPPA / Google Play Families)

General information hai, legal advice nahi. Launch se pehle ek expert se review karwa lo.

- 13 se kam bachon ka personal data collect nahi karna (login, chat, social bilkul nahi)
- Play Console: target audience mein bachon ke age groups + Families declaration
- Mic audio **sirf device par process**, kabhi upload ya store nahi
- Parental gate (random math) in jagahon par: purchases, external links, sharing, notifications settings, privacy policy
- Privacy policy ka public URL (Play Console aur app dono mein)
- Firebase Analytics kids-safe config, advertising ID off, anonymous events
- Data Safety form sach bharo
- "Crumbo" naam ka trademark check, aur art original rakho

---

## 11. Tech stack aur architecture

| Area | Choice |
| --- | --- |
| Framework | Flutter (Dart), Android first |
| Architecture | Clean Architecture + Cubit/BLoC |
| DI / routing | GetIt + GoRouter |
| Character | Rive owl pack (`owl.riv`) + custom sleep (`owl_sleep.riv`); Flutter switches artboards via cubit |
| Games | Flame (target) |
| Voice | `record` + pitch/speed playback (`just_audio` ya `flutter_soloud`, package docs verify karo) |
| Ads | `google_mobile_ads` + certified mediation |
| Storage | Hive (`hive_ce`; theme/skin in `settings`; SP one-shot migrate) |
| Analytics | Firebase Analytics (kids config) + Crashlytics + Remote Config (A5) |
| OTA fixes | Shorebird (optional) |

### Folder structure (current + target)
```
lib/
  core/ (di, router, theme, ui/, … later: ads, audio, storage, parental_gate, config)
  features/
    splash/ home/ crumbo/ play/ shop/ store/ settings/
    rewards/ profile/ level/ owls/
    # target:
    rooms/ economy/ journey/ cards/ games/
assets/
  rive/owl.riv
  rive/owl_sleep.riv
  data/ (home_themes.json, owl_skins.json, play_content.json;
         target: journey.json, cards.json, items.json)
  backgrounds/ images/ fonts/
```

**JSON-driven design:** journey, cards, shop items sab `assets/data/*.json` mein. Naya content = naya JSON, naya code nahi.

---

## 12. Rive: owl contract (primary)

**Source of truth:** [`AGENTS.md`](../AGENTS.md) Rive contract. Do not guess APIs — `https://rive.app/docs/llms.txt`.

### Pack files
- `assets/rive/owl.riv` — marketplace Expression Pack (AnggaMotion, CC BY); artboards `"1"`…`"15"`
- `assets/rive/owl_sleep.riv` — custom sleep artboard `sleep` (closed eyes, breathe + Zzz)

### Flutter mapping (examples)
| Expression / action | Artboard / file |
| --- | --- |
| Idle (think) | `11` |
| Wink | `2` |
| Eat | `10` |
| Dance / happy | `1` |
| Poke / wave | `9` |
| Bubbles | `13` |
| Sleep | `owl_sleep.riv` → `sleep` |

Pack state machines have **no mood Inputs**; Flutter `CrumboCubit` switches artboards. Actions auto-return to idle except sleep / listen / talk. Oversized boards use `stageScale`. Listen = `owl_listen.riv`; Talk = `owl_talk.riv` (C8–C10).

### Appendix: bread-era contract (DEPRECATED)

Purana bread-slice plan — **use mat karo** for new work. Historical only:

- File was `assets/rive/crumbo.riv`, artboard `CrumboMain`
- View model: `mood`, `isTalking`, `isListening`, `isChewing`, `toastLevel`, `hatId`, poke/wake triggers
- Layers: `body`, `crust`, `curl`, eyes, mouth shapes, blush, arms, legs

---

## 13. Rive MCP + Cursor setup (Windows)

### Rive MCP (official, Early Access)
Rive ke latest docs ke mutabiq MCP desktop editor ke **Windows aur macOS** par available hai. Early Access hai, to kabhi kabhi gadbad ho sakti hai.

1. Rive desktop app install karo (rive.app/downloads), account login
2. Owl pack already in repo (`owl.riv`); nayi custom work ke liye alag artboard / file (e.g. sleep already `owl_sleep.riv`)
3. **Rive app khuli rakho** (server tabhi chalta hai)
4. Cursor mein MCP add karo: `~/.cursor/mcp.json` (Windows: `C:\Users\<name>\.cursor\mcp.json`) ya Cursor Settings > Tools & MCP > Add Custom MCP:
```json
{ "mcpServers": { "rive": { "url": "http://127.0.0.1:9791/mcp" } } }
```
5. MCP ko `On` karo, "rive" server dikhna chahiye
6. Test prompt: "Rive MCP ke tools list karo aur Artboard mein ek simple circle banao"
7. Rive ke docs ke mutabiq prompt ke baad kabhi "End Prompt" likhna padta hai taake AI changes apply kare (docs dekho)

(Agar Claude Code bhi use karo: `claude mcp add --transport http rive http://127.0.0.1:9791/mcp`)

### Backup: unofficial `rive-mcp-server` (editor ke bina)
```bash
npm install -g rive-mcp-server
```
Cursor ke `mcp.json` mein `rive-mcp` command add karo (README ke mutabiq). Third-party hai, Rive se affiliated nahi; secrets us folder mein na rakho.

### Cursor ke andar kya, bahar kya
- **Cursor ke andar:** saara code, terminal, git, Rive MCP se design/animation, SVG preview
- **Bahar (kam se kam):** Rive desktop app (background mein khuli + review), ek-baar ke web setups (Rive, AdMob, Firebase, Play Console), phone par USB test, release ke din Play Console upload

### Rive plan ka dhyan
Free plan ki limits (export waghera) verify karo `rive.app/pricing` par; zaroorat par sirf export ke liye ek mahine ka sasta plan.

---

## 14. Cursor rules (`AGENTS.md` ya `.cursor/rules`)

Project root mein `AGENTS.md` banao:
```markdown
# Crumbo (kids talking-owl app)

Read docs/MASTER_PLAN.md first.
**Active schedule:** docs/DAILY_CHECKLIST.md

## Product
- Flutter, Android first, US kids 4-10. Ads only (AdMob, child-directed). No backend, no accounts.
- Content (journey nodes, cards, shop items) is JSON in assets/data. New content must not need code changes.
- Character: Owl mascot — AnggaMotion pack (`assets/rive/owl.riv`, CC BY). See AGENTS.md Rive contract.

## Architecture
- Clean Architecture: lib/core, lib/features/<feature>/{data,domain,presentation}
- Cubit/BLoC, GetIt, GoRouter, Hive, Flame. Rive artboard switch from Flutter (pack has no mood Inputs).

## Kids-app hard rules
- No personal data, login, chat, social. Mic audio on device only.
- Ads only via AdService. Child-directed ON, rating G, non-personalized.
- No ads during gameplay, at app open, or next to gameplay buttons. Rewarded ads always opt-in.
- Every gate/unlock must have a non-ad path.
- Purchases, external links, sharing, privacy policy only behind ParentalGate.
- No new SDK/permission without asking me.

## Workflow (Haris only reviews)
- Haris does not know Rive/animation. Explain in simple Hinglish.
- Each task: 5-line plan -> code -> flutter analyze + tests -> commit.
- End each task with: "Kya bana", "Kaise test karoon (3 steps)", "Kya review karna hai".
- Read current docs before using an API (Rive: https://rive.app/docs/llms.txt). Do not guess.
- If an MCP/tool fails, stop and offer options (fallback: Flutter-only animations with PNG layers).
```

### Vibe-coding ka roz ka routine
1. Aaj ka ek task prompt do
2. "Kaise test karoon" padho
3. Phone par 5 minute test
4. Theek to "commit karo, agla task", warna feedback
5. Din ke end par `git push`

---

## 15. Build plan (week by week) aur prompts

### ACTIVE SPRINT (24 Oct – 24 Nov 2026)
**Deadline:** 24 Nov 2026 — **FULL development** (Weeks 1–11 features), installable APK.  
**Bahar is deadline se:** Play Console / soft launch (Week 12 baad mein).  
**Roz ka source of truth:** [`docs/DAILY_CHECKLIST.md`](DAILY_CHECKLIST.md) (31-din full-dev list).  
Har step: tests likho, `flutter analyze` + `flutter test` clean, phone par test, phir commit.

Neeche 12-hafte table **reference** hai; active schedule checklist wali hai.

| Week | Kaam | UI shell (Oct 2025) |
| --- | --- | --- |
| 1 | Skeleton, DI, routing, theme, **Hive (A4)** | Done except Hive |
| 2 | Needs + care actions (feed, sleep, bath, clean, pet) | Owl expressions / care bar shipped |
| 3 | Rooms, shop, coins/gems, daily reward | Static shop/daily shells; themes exist |
| 4 | Cards system (album, reveal, unlock rules, JSON) | — |
| 5 | Journey Map (nodes, zones 1-2, gates, chests) | — |
| 6 | Mini games (5) + result screens | Play hub shell + `play_content.json` |
| 7 | Voice repeat | — |
| 8 | Ads (AdService, rewarded/interstitial/banner, Remote Config) | — |
| 9 | Parental gate, settings, privacy, onboarding | Partial gate + settings shell |
| 10 | Owl Rive polish + journey-gated moods (D10) | Pack + sleep already integrated |
| 11 | Polish, analytics, low-end phone test | Glossy UI largely done |
| 12 | Soft launch, tuning (AFTER 24 Nov) | — |

(Rive parallel; MCP atke to Plan D. **Next core:** A5.)

### Prompt: Cards (Week 4)
> `docs/MASTER_PLAN.md` ke Section 5 ke mutabiq `features/cards` banao. `assets/data/cards.json` se cards load karo (id, type, rarity, set, unlock methods). Album screen (locked cards dhundhle), card flip animation (Flutter), unlock methods: task, journey, coins, ad (rewarded via AdService, aur ad ke saath hamesha ek non-ad raasta). Duplicate card par coins do. Hive mein collected cards save karo. Pehle plan dikhao.

### Prompt: Journey Map (Week 5)
> Section 4 ke mutabiq `features/journey` banao. `assets/data/journey.json` se zones/nodes load karo. Scrollable path UI, node types (care, game, card_reveal, chest, gate), progress Hive mein. Gate par 3 options (task, coins, ad). Zone 1 (Cozy Kitchen) aur Zone 2 (Bubble Bay) ke 10-10 nodes ka sample JSON bhi banao. Pehle plan.

### Prompt: Ads (Week 8)
> `core/ads` mein `AdService` interface aur `AdmobAdService` banao (Section 8). Child-directed settings init mein. Rewarded: opt-in. Interstitial: sirf natural breaks, min gap 90 sec. Banner: shop/result ke neeche. Frequencies Firebase Remote Config se. Test ad unit IDs.

### Prompt: Owl Rive polish (Week 10 / D10)
> `AGENTS.md` Rive contract aur https://rive.app/docs/llms.txt padho. `CrumboView` pehle se `owl.riv` / `owl_sleep.riv` use karta hai. Journey-gated moods (`OwlExpression.isUnlocked`), perch tuning, talk placeholder — bread-era `crumbo.riv` / `CrumboMain` mat banao.

### Rive MCP prompts (optional custom work)
1. Perch / scene polish ya custom talk artboard — pack artboards break mat karo
2. Plan D: PNG layers agar MCP / pack limit atke
3. Export custom pieces under `assets/rive/`; size chhota rakho

### Review checklist (animation)
- [ ] Loop jhatka nahi deta
- [ ] Koi part body se alag nahi
- [ ] Rang/design wahi
- [ ] Bachon ko daraawna nahi
- [ ] Speed natural
- [ ] File size 1-2 MB se kam
- [ ] Naam contract se match
- [ ] Phone par Flutter mein chala ke dekha

### Fallback ladder (agar MCP atke)
1. Official MCP \u2192 2. unofficial `rive-mcp-server` / dusra MCP \u2192 3. **Plan D:** PNG layers + Flutter ki apni animations (app phir bhi chalti hai) \u2192 4. sasta paid option: Rive ka ek mahina ya Fiverr se sirf rig + 5 animations

**Plan D ko din 1 se ready rakho** taake kabhi blocked na ho.

---

## 16. Testing aur release checklist

- [ ] Low-end Android par smooth chale
- [ ] Bina internet ke chale (ads sirf internet par)
- [ ] Ad load na ho to koi button stuck na ho
- [ ] Mic permission deny par crash nahi
- [ ] Parental gate har sensitive jagah
- [ ] Koi ad gameplay ke beech/buttons ke paas nahi
- [ ] Har gate/unlock ka non-ad raasta
- [ ] Background/foreground par audio aur Rive theek
- [ ] 24+ ghante ka needs decay test
- [ ] Play Console: Families declaration, ads declaration, Data Safety, content rating, privacy policy URL
- [ ] Store listing native English, screenshots, icon
- [ ] Internal/closed testing phir production (naye personal accounts ke liye closed-testing requirements Play Console mein check karo)

---

## 17. KPIs

- D1 / D7 / D30 retention (starting target: D1 40%+, D7 15%+)
- Session length aur sessions/day
- Rewarded opt-in rate (target 30-40% users)
- Ad impressions per DAU, ARPDAU
- Journey drop-off (kis node par bachay chhod dete hain)
- Card album completion %
- Crash-free sessions 99%+

---

## 18. Aam galtiyan

1. Pehle din 40 features banana. **MVP wale hi banao**, baaki JSON se baad mein
2. Journey ko sirf ads se rokna (bina-ad raasta zaroor rakho)
3. Purane Rive "Inputs" ka code (ab Data Binding)
4. Artist/Rive ka intezar karna (placeholder se aage badho)
5. Live ads par khud click karna
6. App-open ya gameplay ke beech ads
7. Mic audio server par bhejna
8. Unofficial MCP ka kaam bina review ke ship karna
9. Remote Config na rakhna (ad/economy baad mein badalna mushkil)
10. Trademark check bhoolna

---

## 19. Where we are now (2026-10-25)

- Foundation + glossy owl home + static feature shells **done** (checklist A1–A3, A-UI1–A-UI8)
- **Next core task:** [`DAILY_CHECKLIST.md`](DAILY_CHECKLIST.md) **A5** — Firebase skeleton ya stub + skip note
- Phir A5 stub/Firebase, A6–A10 needs + feed/sleep polish
- Soft launch / Play Console **after** 24 Nov full-dev deadline

---

## Sources
- Rive MCP (Early Access): https://rive.app/docs/editor/mcp/integration aur https://rive.app/docs/editor/ai/mcp
- Rive Flutter inputs (deprecated, Data Binding): https://rive.app/docs/runtimes/flutter/inputs
- Rive pricing: https://rive.app/docs/account-admin/pricing
- Unofficial rive-mcp-server: https://glama.ai/mcp/servers/ODU33104/rive-mcp
- Previous files: `crumbo-build-guide.md`, `crumbo-vibe-coding-with-rive-mcp.md`
