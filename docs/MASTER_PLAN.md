# Crumbo: Final Master Plan (Concept + Features + Journey Map + Cards + Ads + Rive MCP + Cursor Vibe-Coding)

Date: 2026-10-20
Owner: Haris
Yeh ek final file hai jis mein pichli saari baatein aur nayi cheezein (Journey Map, Card unlocks, 40 features) ek jagah hain. Is file ko Cursor ke project mein `docs/MASTER_PLAN.md` ki tarah rakh do aur LLM ko bolo "pehle isay padho".

---

## 1. App ek line mein

**Crumbo** ek sleepy talking bread-slice hai (US kids 4-10). Bacha usay jagata hai, khilata hai, toast karta hai, nehlata hai, sulata hai, saaf karta hai, mini games khelta hai, **Journey Map** par aage badhta hai, aur **cards** unlock karke nayi cheezein (outfits, food, rooms, friends) kholta hai. Revenue **ads** se hai (rewarded main), RevenueCat nahi.

**Haan, is mein sab hai:** sleep, bath, clean, food, toast, journey map, aur card-unlock system. Neeche 40 features ki list hai.

**Platform:** Android pehle, phir iOS. **Market:** US (native English UI). **Tools:** Flutter + Rive (MCP se) + Cursor (vibe-coding).

---

## 2. Character: Crumbo

- Round-square bread slice, golden-brown crust, cream andar, upar crust ka chhota curl
- 2 bade sleepy aankhein, chhota mooh, blush circles, chhote haath-pair
- Colors: cream, golden brown, butter yellow (accent), soft brown (eyes)
- Personality: sleepy, bhookha, thoda clumsy, pyaara. Kabhi gussa ya darawna nahi
- Voice: bachay ki awaaz soft, sleepy, high pitch mein repeat karta hai (presets: Sleepy, Chipmunk, Deep Bread)
- Catchphrase: "Five more minutes..."
- Backstory: Crumbo Bakery ka sabse chhota slice jo toaster mein jaane se pehle jaag gaya. Ab dost aur naye ghar dhoondh raha hai (isi se Journey Map ka bahana milta hai)
- Naam trademark: launch se pehle USPTO aur Play Store par "Crumbo" check karo

---

## 3. 40 Features ki poori list

Phase: **MVP** = pehla launch, **v1.1 / v1.2** = launch ke baad, **Future** = agar app chal gayi.
Ad hook: **R** = rewarded video (bacha khud choose kare), **I** = natural-break interstitial, **-** = koi ad nahi.

### A. Care actions (Crumbo ki dekh-bhaal)

| # | Feature | Kya hota hai | Ad hook | Phase |
| --- | --- | --- | --- | --- |
| 1 | Wake up | Tap, shake ya alarm se Crumbo jaagta hai ("Five more minutes...") | R: double wake-up coins | MVP |
| 2 | Voice repeat | Bacha bolta hai, Crumbo funny voice mein repeat karta hai | R: naye voice presets | MVP |
| 3 | Feed | Butter, jam, egg, honey, fruit drag karke khilao | R: premium food free | MVP |
| 4 | Toast | Toaster mein daalo: bread \u2192 golden \u2192 dark | I: toast complete ke baad | MVP |
| 5 | Sleep / lullaby | Light band, gaana, Zzz | R: naye lullabies | MVP |
| 6 | Bath | Bubbles, sponge, rubber duck | I: bath ke baad | MVP |
| 7 | Clean (crumb cleaning) | Crumbs aur dhool saaf karo, sparkle | R: sparkle effect | MVP |
| 8 | Pet / tickle | Tap-hold se hasna, giggle | - (trust ke liye) | MVP |
| 9 | Dress up | Hats, glasses, pajamas, chef outfit | R: free outfit try/unlock | MVP |
| 10 | Mood & needs | Hunger, Sleep, Fun, Clean, Love icons | - | MVP |

### B. Rooms (alag screens)

| # | Feature | Actions | Unlock | Phase |
| --- | --- | --- | --- | --- |
| 11 | Kitchen | Feed, toast, butter/jam station | Free | MVP |
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
| 35 | Daily tasks | "3 toast banao", "1 game khelo" | MVP |
| 36 | Spin wheel | Roz 1 free, extra spin ad se (R) | MVP |
| 37 | Achievements | "10 toasts", "First card set" | v1.1 |
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
| Character | Rive (view model / data binding) |
| Games | Flame |
| Voice | `record` + pitch/speed playback (`just_audio` ya `flutter_soloud`, package docs verify karo) |
| Ads | `google_mobile_ads` + certified mediation |
| Storage | Hive (offline-first, no backend) |
| Analytics | Firebase Analytics (kids config) + Crashlytics + Remote Config |
| OTA fixes | Shorebird (optional) |

### Folder structure
```
lib/
  core/ (di, router, ads, audio, storage, theme, parental_gate, config)
  features/
    home/ crumbo/ rooms/ shop/ economy/
    journey/   (map, nodes, gates)
    cards/     (album, reveal, unlock rules)
    games/     (topping_catch, toaster_pop, bubble_pop, crumb_runner, match)
    settings/
assets/
  rive/crumbo.riv
  data/ (journey.json, cards.json, items.json)
  audio/ images/ fallback/
```

**JSON-driven design:** journey, cards, shop items sab `assets/data/*.json` mein. Naya content = naya JSON, naya code nahi. Yahi "pehle 30-40 features, baad mein aur" ka asaan raasta hai.

---

## 12. Rive: character aur animations (AI/MCP se)

### Animation list (artist-free, MCP se banwani)
`idle_breathe`, `blink`, `sleep_loop`, `wake_up`, `talk`, `listen`, `eat_chew`, `happy_jump`, `giggle`, `hungry`, `toast_light/golden/dark`, `sneeze`, `bath_splash`, `clean_sparkle`, `card_flip_happy`

### View model contract (naam fix, code aur Rive match karein)

| Property | Type | Kaam |
| --- | --- | --- |
| `mood` | enum | idle, sleepy, hungry, happy, excited |
| `isTalking` | bool | Mooh hilana |
| `isListening` | bool | Sun raha hai |
| `isChewing` | bool | Chew |
| `toastLevel` | number | 0 bread, 1 golden, 2 dark |
| `isBathing` | bool | Bubble/bath |
| `pokeTrigger` | trigger | Giggle |
| `wakeTrigger` | trigger | Jaagna |
| `celebrateTrigger` | trigger | Card/level celebration |
| `hatId` | number | Outfit slot |

**Zaroori:** Rive ke docs ke mutabiq purana "Inputs" system deprecated hai; **Data Binding** use karo. LLM ko hamesha `https://rive.app/docs/llms.txt` do.

### Layers ke naam (SVG/Rive mein)
`body`, `crust`, `curl`, `eye_L`, `eye_R`, `eyelid_L`, `eyelid_R`, `mouth_closed`, `mouth_open`, `mouth_smile`, `blush_L`, `blush_R`, `arm_L`, `arm_R`, `leg_L`, `leg_R`

---

## 13. Rive MCP + Cursor setup (Windows)

### Rive MCP (official, Early Access)
Rive ke latest docs ke mutabiq MCP desktop editor ke **Windows aur macOS** par available hai. Early Access hai, to kabhi kabhi gadbad ho sakti hai.

1. Rive desktop app install karo (rive.app/downloads), account login
2. Rive mein nayi file + ek Artboard (`CrumboMain`, 1080x1080)
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
# Crumbo (kids talking-toast app)

Read docs/MASTER_PLAN.md first.

## Product
- Flutter, Android first, US kids 4-10. Ads only (AdMob, child-directed). No backend, no accounts.
- Content (journey nodes, cards, shop items) is JSON in assets/data. New content must not need code changes.

## Architecture
- Clean Architecture: lib/core, lib/features/<feature>/{data,domain,presentation}
- Cubit/BLoC, GetIt, GoRouter, Hive, Flame. Rive with Data Binding (NOT deprecated Inputs).

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

| Week | Kaam |
| --- | --- |
| 1 | Skeleton, DI, routing, theme, storage, placeholder Crumbo |
| 2 | Needs aur mood, care actions (feed, sleep, bath, clean, pet) |
| 3 | Rooms (kitchen/bedroom/bathroom), shop, coins/gems, daily reward |
| 4 | Cards system (album, reveal, unlock rules, JSON) |
| 5 | Journey Map (nodes, zones 1-2, gates, chests) |
| 6 | Mini games (5) + result screens |
| 7 | Voice repeat |
| 8 | Ads (AdService, rewarded/interstitial/banner, Remote Config) |
| 9 | Parental gate, settings, privacy, onboarding |
| 10 | Rive character (SVG \u2192 animations \u2192 data binding \u2192 integrate) |
| 11 | Polish, analytics, low-end phone test |
| 12 | Soft launch, tuning (AFTER 24 Nov) |

(Rive ka kaam parallel chalao; MCP atke to Plan D.)

### Prompt: Cards (Week 4)
> `docs/MASTER_PLAN.md` ke Section 5 ke mutabiq `features/cards` banao. `assets/data/cards.json` se cards load karo (id, type, rarity, set, unlock methods). Album screen (locked cards dhundhle), card flip animation (Flutter), unlock methods: task, journey, coins, ad (rewarded via AdService, aur ad ke saath hamesha ek non-ad raasta). Duplicate card par coins do. Hive mein collected cards save karo. Pehle plan dikhao.

### Prompt: Journey Map (Week 5)
> Section 4 ke mutabiq `features/journey` banao. `assets/data/journey.json` se zones/nodes load karo. Scrollable path UI, node types (care, game, card_reveal, chest, gate), progress Hive mein. Gate par 3 options (task, coins, ad). Zone 1 (Cozy Kitchen) aur Zone 2 (Bubble Bay) ke 10-10 nodes ka sample JSON bhi banao. Pehle plan.

### Prompt: Ads (Week 8)
> `core/ads` mein `AdService` interface aur `AdmobAdService` banao (Section 8). Child-directed settings init mein. Rewarded: opt-in. Interstitial: sirf natural breaks, min gap 90 sec. Banner: shop/result ke neeche. Frequencies Firebase Remote Config se. Test ad unit IDs.

### Prompt: Rive (Week 10)
> Rive docs (https://rive.app/docs/llms.txt) padho. `assets/rive/crumbo.riv` load karo aur `CrumboView` banao jo Section 12 ke view model properties `CrumboCubit` se bind kare. Placeholder hata do. Property naam alag ho to mujhe batao.

### Rive MCP prompts (Cursor mein, Phase wise)
1. Design: "Crumbo ka original cute SVG banao (Section 2 aur 12 ke layer naamon ke saath), `art/crumbo.svg`." (Browser mein dekh ke approve)
2. Import: "SVG ko Rive Artboard `CrumboMain` mein laao, layer naam wahi rakho."
3. Animations ek ek karke (pehle `idle_breathe`, `blink`, `sleep_loop`, `talk`), har ek ke baad review
4. State machine + data binding: Section 12 ke properties ke saath (Data Binding, Inputs nahi)
5. Export: `assets/rive/crumbo.riv`, size 1-2 MB se kam

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

## 19. Pehle 3 din

- **Din 1:** Cursor + Flutter + Android Studio, `flutter create`, `AGENTS.md`, `docs/MASTER_PLAN.md`, git
- **Din 2:** Rive install, MCP connect, circle test, Crumbo SVG (Phase 1) approve
- **Din 3:** Week 1 prompt, placeholder Crumbo home screen par

---

## Sources
- Rive MCP (Early Access): https://rive.app/docs/editor/mcp/integration aur https://rive.app/docs/editor/ai/mcp
- Rive Flutter inputs (deprecated, Data Binding): https://rive.app/docs/runtimes/flutter/inputs
- Rive pricing: https://rive.app/docs/account-admin/pricing
- Unofficial rive-mcp-server: https://glama.ai/mcp/servers/ODU33104/rive-mcp
- Previous files: `crumbo-build-guide.md`, `crumbo-vibe-coding-with-rive-mcp.md`
