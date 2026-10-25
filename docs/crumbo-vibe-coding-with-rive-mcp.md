# Crumbo: Full Vibe-Coding Plan (Rive MCP + LLM, tum sirf review karoge)

Date: 2026-10-20  
**SUPERSEDED for character path (2026-10-25):** App ab **owl** pack use karti hai (`AGENTS.md` + `owl.riv` / `owl_sleep.riv`). Neeche bread-slice SVG / `CrumboMain` prompts **historical** hain — naye kaam ke liye mat follow. Roz ka schedule: [`DAILY_CHECKLIST.md`](DAILY_CHECKLIST.md).

Yeh file `crumbo-build-guide.md` ka purana "AI-only" version hai.

---

## 1. Seedhi baat: kya chalega aur kya nahi

**Kaam karne ki ummeed (achhi):**
- Simple, cute, geometric character (round bread slice, 2 aankhein, mooh, blush) **Claude SVG code mein bana sakta hai**. Yeh Crumbo ke liye perfect hai kyunke design simple shapes ka hai
- Basic animations: breathe, blink, bounce, wobble, mooh khulna/band hona, color change (toast hona)
- State machine / view model ka kaam (jo repetitive hota hai) AI se acha hota hai, Rive khud isi liye MCP la raha hai

**Risk (ghalat ummeed mat rakhna):**
- MCP tools naye aur kuch Early Access / unofficial hain, kabhi kabhi galat ya adhoora kaam karte hain
- "Pixar jaisi" character animation AI se nahi banegi. Crumbo ka style **flat, simple, cute vector** rakhna hai, wohi AI ke liye mumkin hai
- Tumhe har step ke baad **dekhna** padega ke result theek hai (review loop neeche hai)

**Isi liye plan:** Crumbo ka design jaan boojh kar simple rakha hai, aur har animation chhote step mein banwayenge.

---

## 2. Pipeline (ek nazar mein)

1. **Design:** Claude se Crumbo ka SVG banwao (layers ke naam fix)
2. **Import:** SVG ko Rive mein laao (MCP se)
3. **Animations:** ek ek karke (idle, blink, sleep, talk, chew, giggle, ...)
4. **State machine + data binding:** mood, isTalking, triggers
5. **Review:** tum preview dekho, checklist se verify karo
6. **Export:** `crumbo.riv`
7. **Flutter integration:** Claude Code app mein laga de
8. **App ke baaki features:** vibe coding (ads, economy, games) jaisa pehle guide mein hai

---

## 3. MCP connect karna (tumhare computer ke hisaab se)

### Pehle ek sawal: tumhare paas Mac hai ya Windows?
- **Mac ya Windows:** Path 1 (official) pehle try karo. Rive ke latest docs ke mutabiq MCP ab desktop editor ke **Windows aur macOS dono** par available hai (purane page par sirf Mac likha tha, is liye agar app mein option na dikhe to Rive Early Access ka latest version download karo)
- **Linux, ya official kaam na kare:** Path 2 (unofficial, editor ke bina)

### Path 1: Official Rive MCP (Early Access, Mac)
Rive ke docs ke mutabiq:
- Rive **Early Access** Mac app install karo aur **khuli rakho** (server tabhi chalta hai)
- MCP address: `http://127.0.0.1:9791/mcp`
- Docs filhal **Cursor** ko recommend karte hain; Claude Code mein bhi add karke dekh sakte ho:
```bash
claude mcp add --transport http rive http://127.0.0.1:9791/mcp
```
(Agar yeh command na chale to `~/.cursor/mcp.json` mein ya Rive ke "Add Custom MCP" mein yeh daalo:)
```json
{ "mcpServers": { "rive": { "url": "http://127.0.0.1:9791/mcp" } } }
```
- Rive mein file aur ek Artboard khol ke rakho, phir AI se prompt do
- Docs mein likha hai ke yeh "production ke liye abhi nahi", is liye final file ko khud editor mein kholo aur check karo

### Path 2: Unofficial `rive-mcp-server` (editor ke bina, kisi bhi OS)
```bash
npm install -g rive-mcp-server
claude mcp add --scope user rive -- rive-mcp
claude mcp list
```
- Yeh `.riv` file seedha bana/edit/preview/render kar sakta hai, aur **SVG import** karta hai
- Third-party hai, Rive se affiliated nahi. Safety: apne secrets/keys us folder mein na rakho jahan yeh chalta hai

### Connection test (dono paths ke liye)
Claude Code mein yeh prompt do:
> Rive MCP ke available tools list karo. Phir ek chhota bouncing circle `art/rive/test.riv` mein banao aur preview/render dikhao.

Agar yeh ban gaya to connection theek hai. Agar nahi chala to error mujhe (ya Claude Code ko) copy paste karo.

### Docs MCP (bonus, helpful)
`rive-docs-mcp` jaisa server Claude ko Rive docs search karne deta hai. Aur Rive docs ka index `https://rive.app/docs/llms.txt` hai, har Rive prompt mein yeh URL de do.

---

## 4. Step by step prompts (copy paste)

> Rule: ek prompt = ek chhota result. Har prompt ke baad **review checklist** (Section 5) chalao, phir agla.

### Phase 1: Crumbo ka design (SVG)
**Prompt:**
> Crumbo ke liye ek original, cute kids-friendly character ka SVG banao. Crumbo ek round-square bread slice hai: golden-brown crust, cream andar, upar crust ka chhota curl, 2 bade sleepy aankhein, chhota mooh, blush circles, chhote haath aur pair. Flat vector style, sirf simple shapes aur 3-4 colors (cream, golden brown, butter yellow, soft brown for eyes). Koi mashhoor character jaisa nahi. **Har part alag group ho aur naam ye ho:** `body`, `crust`, `curl`, `eye_L`, `eye_R`, `eyelid_L`, `eyelid_R`, `mouth_closed`, `mouth_open`, `mouth_smile`, `blush_L`, `blush_R`, `arm_L`, `arm_R`, `leg_L`, `leg_R`. Canvas 1080x1080. File `art/crumbo.svg` mein save karo.

**Tum kya dekho:** SVG ko browser mein kholo. Pyara lag raha hai? Agar nahi, bolo: "aankhein aur bade karo", "crust patla karo", "zyada cute".
Jab tak design pasand na aaye animation mat shuru karna.

### Phase 2: Rive mein import
> `art/crumbo.svg` ko Rive file `art/rive/crumbo.riv` mein import karo (artboard `CrumboMain`, 1080x1080). Saare layers ke naam wahi rakho. Preview dikhao.

### Phase 3: Animations (ek ek karke)
Har animation alag prompt mein. Pehle isme se 4 banao (MVP), baaki baad mein.

**3.1 idle_breathe**
> `CrumboMain` mein `idle_breathe` loop animation banao (2.5 second): `body` aur `crust` halka sa scale up/down (1.0 se 1.03), `arm_L/R` halka sa hilein. Smooth easing, seamless loop. Render karke dikhao.

**3.2 blink**
> `blink` animation (0.3s): `eyelid_L` aur `eyelid_R` neeche aayein aur wapas jayein. Aankhein band hoti dikhein.

**3.3 sleep_loop**
> `sleep_loop` (3s loop): aankhein band, body dheere upar neeche, 3 chhote "Z" shapes upar uthte hue fade hon.

**3.4 talk**
> `talk` loop: `mouth_open` aur `mouth_closed` tezi se alternate hon (bolne jaisa), body halka bounce kare.

Phir baaki: `wake_up`, `eat_chew`, `happy_jump`, `giggle`, `hungry`, `listen`, `toast_light/golden/dark`, `sneeze`.

**Har animation ke baad tum dekho:** loop jhatke se to nahi toot raha, koi part alag to nahi ho raha, speed natural hai.

### Phase 4: State machine + data binding
> Rive ke current docs (https://rive.app/docs/llms.txt) padho. **Data Binding use karo, purane Inputs nahi.** `CrumboMain` ka state machine banao: view model properties: `mood` (enum: idle, sleepy, hungry, happy, excited), `isTalking` (bool), `isListening` (bool), `isChewing` (bool), `toastLevel` (number), `pokeTrigger`, `wakeTrigger`, `hatId` (number). Rules: mood=sleepy par `sleep_loop`, mood=hungry par `hungry`, isTalking true par `talk`, isChewing par `eat_chew`, pokeTrigger par `giggle` phir wapas idle, wakeTrigger par `wake_up` phir idle. `blink` random timer par idle ke upar chalta rahe. Poora structure text mein likh ke dikhao.

**Tum kya dekho:** Rive editor/preview mein property badal ke dekho (mood=sleepy karo, so jaye?).

### Phase 5: Export
> `crumbo.riv` ko export/save karo `assets/rive/crumbo.riv` mein aur file ki size batao (1-2 MB se kam chahiye).

### Phase 6: Flutter mein laga do
> Rive ki current Flutter docs (https://rive.app/docs/llms.txt) padho. `assets/rive/crumbo.riv` load karo aur `CrumboView` widget banao jo `CrumboCubit` ki state se view model properties bind kare (`mood`, `isTalking`, `isListening`, `isChewing`, `toastLevel`, triggers). Placeholder image hata do. `flutter analyze` clean karo aur emulator par chalao.

---

## 5. Review checklist (bina Rive aaye kaise check karein)

Har animation ke baad 30 second yeh dekho:

- [ ] Preview mein animation chal rahi hai aur **loop jhatka nahi deta**
- [ ] Koi part (haath, aankh, mooh) body se **alag nahi ho raha**
- [ ] Rang/outline wahi hain jo design mein the
- [ ] Mooh aur aankhein bachon ko **daraawni nahi** lag rahi
- [ ] Speed natural hai (na bohot tez, na bohot sust)
- [ ] File ka size 1-2 MB se kam hai
- [ ] Layer/property ke naam wahi hain jo `CLAUDE.md` mein contract hain
- [ ] Flutter mein phone par chala ke dekha (emulator se zyada sahi)

Agar kuch ghalat lage, plain Hinglish mein bolo, jaise: "blink bohot slow hai, tez karo" ya "left haath body se alag lag raha hai". Technical Rive words ki zaroorat nahi.

---

## 6. Agar MCP kaam na kare ya quality kam ho (fallback ladder)

1. **MCP + SVG import** (Path 1/2): pehli koshish
2. **Doosra MCP try karo:** official se unofficial, ya `RiveMCP` / `OpenRive`
3. **Bina Rive (Plan D):** Claude SVG ko alag PNG layers mein export karwao, aur Flutter ki apni animations se blink/bounce/sleep banwao (`AnimationController`, scale, rotate, swap images). Quality simple hogi lekin app chal jayegi aur revenue ka kaam rukega nahi
4. **Sasta paid option:** Rive ka ek mahine ka plan (docs ke mutabiq Cadet jaisa entry plan hai, `rive.app/pricing` par current price dekho) sirf export ke liye, ya Fiverr par sirf "rig + 5 animations" ka chhota quote

> Ek cheez **verify karo:** Rive ka free plan kya export allow karta hai. Pricing aur limits badalte rehte hain, isliye `rive.app/pricing` dekho. Official MCP use karte waqt bhi editor ka plan matter kar sakta hai.

Is liye mera suggestion: **Plan D ko pehle din se ready rakho** taake kabhi bhi blocked na ho.

---

## 7. Poora app vibe-code kaise karein (autonomy rules)

### `CLAUDE.md` mein yeh section add karo
```markdown
## Vibe-coding rules (Haris sirf review karega)
- Haris Rive/animation nahi jaanta. Technical terms ke bajaye simple Hinglish mein explain karo.
- Har task: pehle chhota plan (5 lines), phir code, phir `flutter analyze`/tests, phir commit.
- Task ke end par likho: "Kya bana", "Kaise test karoon (3 steps)", "Kya review karna hai".
- Rive kaam: har animation ke baad render/preview dikhao aur khud check karo (loop, detached parts, size).
- Rive APIs ke liye https://rive.app/docs/llms.txt padho; Data Binding use karo, deprecated Inputs nahi.
- Agar koi tool/MCP fail ho to chup chaap workaround mat karo: batao aur options do (fallback Plan D).
- Naya package, permission, ya ad SDK sirf mere puchne ke baad.
- Kids-app rules (COPPA/Families) kabhi mat todna, chahe shortcut asaan ho.
```

### Roz ka routine (tumhara kaam sirf yeh)
1. Claude Code kholo, aaj ka ek task prompt do (guide ke Week prompts se)
2. Claude ka "Kaise test karoon" padho
3. Phone par 5 minute test karo
4. Theek hai to "commit karo, agla task", warna feedback do
5. Din ke end par `git push` (backup)

### Kickoff prompt (pehle din Claude Code mein paste karo)
> `crumbo-build-guide.md` aur `crumbo-vibe-coding-with-rive-mcp.md` dono padho. In files ke mutabiq `CLAUDE.md` banao (vibe-coding rules ke saath). Phir check karo ke Rive MCP connected hai (`claude mcp list`) aur ek test bouncing circle banao. Uske baad Phase 1 (Crumbo SVG) shuru karo, aur mujhe SVG dikhane ke baad hi aage badho.

---

## 8. Time aur effort ka andaza (approximate)

| Kaam | Tumhara effort | AI ka kaam |
| --- | --- | --- |
| Crumbo design (SVG) | 1-3 iterations, 30-60 min review | Design banana |
| Rive setup + 4 MVP animations | 2-4 din (trial-error ke saath) | Rig + animate |
| State machine + data binding | 1-2 din review | Poora structure |
| Flutter app (needs, rooms, shop, games, ads) | Roz 30-60 min review, 8-10 hafte | Saara code |

Yeh andaza hai, MCP ki stability par bohot depend karta hai.

---

## 9. Sources
- Rive MCP (Early Access): https://rive.app/docs/editor/mcp/integration aur https://rive.app/docs/editor/ai/mcp
- Rive Flutter inputs (deprecated, Data Binding): https://rive.app/docs/runtimes/flutter/inputs
- Rive pricing: https://rive.app/docs/account-admin/pricing
- Unofficial rive-mcp-server: https://glama.ai/mcp/servers/ODU33104/rive-mcp
- RiveMCP: https://glama.ai/mcp/servers/paradoxsyn/rivemcp-releases/tree
- OpenRive MCP: https://github.com/UpstandPlatform/OpenRive/wiki/MCP-Server
