# Rune Factory 4 and Farnia Village research: game plan, environment, design, farm mechanics

Research date: 2026-10-20. Scope: Rune Factory 4 (3DS, 2012) and RF4 Special (Switch 2019/2020, PC/PS4/Xbox 2021), with Farnia Village (ManaGames, in development) as the second reference. This file builds on [rf4-research.md](rf4-research.md) and does not repeat it. Where it corrects that file or the phase plans, it says so.

Source labels follow [rf4-research.md](rf4-research.md):
- **[official]**: Marvelous / XSEED / Steam store pages.
- **[interview]**: developer interviews.
- **[press]**: reviews, previews and news.
- **[community]**: fan wikis and guides (Rune Factory Fandom, wikiwiki.jp/rf4bu, GameFAQs, gameranbu, koryaku-memo, guidestrats, biligame). Numbers from them are fan-documented or datamined. Treat them as approximate.
- **[docs]**: Blender and Godot official documentation.
- **Observation:** what a screenshot shows, described by me. Not a sourced claim.
- **Analysis:** my own reasoning, not a sourced claim.

**Access notes.** Fandom pages were read through the wiki's `api.php` wikitext endpoint because direct fetches return 402. wikiwiki.jp and GameFAQs return 403, so they were read from web.archive.org snapshots. gameranbu and koryaku-memo use identical wording on the tool pages, so I count them as one source family, not two.

## Summary

1. **RF4's first field is half the size of Greenrune's.** The home field is 18 sections of 2x2 plots laid out 3x6, which is 72 plots (about 6x12), not 144 ([Fandom: Farming Mechanics][w-farm], [GameFAQs: Mina walkthrough][gf-mina]). Each section has a faint square outline, and charged sowing, soil stats and giant crops all work per section.
2. **Starter tools cannot charge in RF4.** The Cheap hoe, can, sickle, axe and hammer have no charge. A bronze tool charges once to 2x2, and a silver hoe charges twice to 2x4 ([koryaku-memo: hoe][km-hoe], [gameranbu: tools][gr-tools], [Fandom: Equipment][w-equip]). Phase 1's "tap 1 tile, 2x2, then 4x4 around the player, like Rune Factory 4" is not what RF4 does. The 2x2 is right. RF4's only 4x4 is the upgraded platinum 4th charge, and no source puts any of the areas centred on the player.
3. **RF4 opens with a field covered in debris, and the hands do the first work.** On day 2 Vishnal hands over the Cheap Hoe, Cheap Waterpot and turnip seeds. The field is "covered in weeds… since the last typhoon", time is frozen, and you can't leave until you have tilled, sown and watered once. Weeds, stones and branches are lifted and thrown by hand ([GameFAQs: Mina walkthrough][gf-mina], [Fandom: Farming Mechanics][w-farm]). Greenrune's field has no debris and no carry state.
4. **Tools arrive one per day through the request box, not all at once.** The Request Box (Eliza) allows 1 request a day at first. The tutorial chain hands out the axe ("Make Lumber"), then teaches shipping, then gives the sickle (after giving a turnip) and the hammer, in that order ([Fandom: Requests][w-req], [gameranbu: requests][gr-req], [wikiwiki: 依頼][jp-req]). Greenrune puts requests in Phase 8. *(Superseded by [roadmap.md](roadmap.md): the request box is Phase 2.4.)*
5. **Farm actions also level element skills.** Tilling trains Earth, watering trains Water, reaping with the sickle trains Wind, sowing trains Love, picking up items trains Light and spreading chemicals trains Dark. The general Farming skill covers all field work ([wikiwiki: スキル][jp-skills]). Greenrune's tilling, watering and reaping skills line up with Earth, Water and Wind. Sowing and picking up earn nothing yet.
6. **Withering is a two-step warning, not "N days unwatered".** At 06:00 some crops change colour. If they go unwatered that day, they die and become Withered Grass, which you can till back into the soil for +50 soil health ([Fandom: Farming Mechanics][w-farm], [wikiwiki: 作物数値データ詳細][jp-cropdata]). Phase 3's "wither after N days unwatered" is a different rule.
7. **Turnips are not a spring crop in RF4.** Turnip is good in Summer and Fall and neutral in Spring. Potato is good in Spring and Summer ([Fandom: Crops][w-crops]). The out-of-season factor has three values in three sources: 0.5x (wikiwiki), 2/3 (Fandom, added 2014) and 0.75x (Fandom, added 2026 without a source). The first two are the better supported.
8. **Farnia Village is about object count, not fidelity.** Its director says better graphics must not get in the way of adding gimmicks, because "the quantity of objects is important too", and that background asset costs are kept down ([Automaton interview][automaton]). Its Steam screenshots show a visible tile grid and a distinct low-poly 3D model for each crop at each stage (Observation, [Steam: Farnia Village][fv-steam]). Its director learned modelling and animation himself for the game ([Game*Spark 2026-01-12][gs-0112]).
9. **Farnia Village charges its tools to a 3x3 area.** In the official PV, a tap highlights one tile, and the hoe, hammer/axe, seeds, watering can and harvest each cover a grid-snapped 3x3 block when charged (Observation, [Farnia PV][fv-pv] 0:20, 0:43–0:46, 0:59, 1:16–1:18, 1:59). That is Farnia, not RF4: RF4's bronze tools charge to 2x2; platinum reaches 3x3 on the third charge; gold is unknown ([Fandom: Forging (RF4)][w-forging]).
10. **"Blue Archive / Stella Sora chibi" is two different proportions.** By eye, ±0.3 heads: Blue Archive's battle models are about 2.3–2.5 heads tall, Stella Sora's 3D models about 4–4.5, and Farnia's about 2.5–3. KayKit Adventurers measure about 2.1 (from the GLB). The ratios are Observation. That Farnia shares Stella Sora's face and hair treatment and sits nearer Blue Archive in proportion is **Analysis** (see [section 5](#5-character-style-farnia-village-vs-blue-archive--stella-sora-chibi)).

---

## 1. Game plan: how RF4 paces its opening

### Facts

**Day 1, Spring 1 (a holiday, from 22:00)**
- **Airship fight:** you pick a gender through a dialogue line, then fight two soldiers with the Broadsword. They knock you off the airship onto Ventuswill, and you wake with amnesia ([GameFAQs: Mina walkthrough][gf-mina], [GameFAQs: Zoel walkthrough][gf-zoel], [Fandom: Rune Factory 4][w-rf4]). High confidence.
- **Volkanon's tutorials:** saving at the diary, then sleeping. Because your HP is low after the fall, he lets you sleep until 08:00 instead of 06:00. Time is frozen during these tutorials ([GameFAQs: Mina walkthrough][gf-mina]). Medium confidence.
- **Starting state:** 200 G and 5 Prince Points ([GameFAQs: Mina walkthrough][gf-mina]). Medium confidence.

**Day 2, Spring 2: the real tutorial day**
- **Breakfast:** Clorica gives you an Apple Pie and you must eat it before leaving the room ([GameFAQs: Mina walkthrough][gf-mina]).
- **Field tutorial (Vishnal):** you reach the field through the back door of your room. Vishnal lists what crops are for (shipping, cooking, gifts, monster friendship), mentions runes from harvests, then gives the **Cheap Hoe, Turnip Seeds and Cheap Waterpot**. The steps are gated: till one plot, sow it, fill the pot at the well in the north-east corner of the field, water it. You cannot leave the field until this is done, and the clock is frozen. Watering earns 9 more turnip seeds. You then name the farm ([GameFAQs: Mina walkthrough][gf-mina], [GameFAQs: Zoel walkthrough][gf-zoel]). High confidence. Guidestrats calls the tutorial optional ([guidestrats: walkthrough part 1][gs-walk]), which contradicts the forced gate in the walkthrough transcript.
- **Request Box and Orders:** Eliza, the talking Request Box outside your door, gives the first request, which sends you to the Order Symbol in the Dragon Room. Arthur gives 50 Prince Points. The only available order is the rucksack upgrade (15 to 30 slots). Arthur then makes you schedule one festival. The reward is 4 turnip seeds ([GameFAQs: Mina walkthrough][gf-mina], [Fandom: Prince Points][w-pp], [gameranbu: requests][gr-req]). High confidence.
- **First dungeon the same day:** leaving town, Forte gives you a Claymore, sets the difficulty and joins you. Yokmir Forest opens immediately ([GameFAQs: Mina walkthrough][gf-mina], [wikiwiki: メインシナリオ][jp-story]). High confidence. Out of Greenrune's scope until Phase 4.

**The tutorial request chain**
- **Pacing:** 1 request per day at first. The limit becomes 2 after "Make Lumber" and 3 after "Mine Iron" ([gameranbu: requests][gr-req], [wikiwiki: 依頼][jp-req]). High confidence.
- **Order, with tools in bold** ([Fandom: Requests][w-req], [gameranbu: requests][gr-req], [biligame: requests][bili-req], [guidestrats: axe and hammer][gs-axe]):
  1. First Task! (Order Symbol, backpack, one festival).
  2. How to place furniture! (storage box, calendar).
  3. Make Lumber: **Cheap Axe** and a Lumber/Stone Box. You chop the branches and stumps on your own field.
  4. Make a Shipment!: Vishnal gives you a turnip to ship. Reward: potato and spinach seeds appear in the General Store.
  5. Give an item! (give a turnip to Clorica): **Cheap Sickle**.
  6. Purchase Rice!
  7. Make Material Stone!: **Cheap Hammer**.
  8. Try Fishing (out of Greenrune's scope).
  9. Use a Fertilizer Bin!
  10. Mine Iron!
- **Exact calendar days per request:** not found. Guidestrats places furniture on day 3 and lumber, shipping and gifting around day 4, vaguely ([guidestrats: walkthrough part 1][gs-walk]). Low confidence.
- **Seed stock grows through requests and shipping.** After the request "Ship a level 2 Turnip", shops stock each seed at the highest level you have shipped of it ([Fandom: Crops][w-crops], [wikiwiki: Q&A][jp-qa]).
- **Seed stock does not change by season.** No source says it does. The General Store's seed list gives an unlock condition per seed (turnip "最初から販売", sold from the start), and the wiki says every crop can be planted in any season ([wikiwiki: 町の施設][jp-town], [wikiwiki: 農作業][jp-farm]). The only seasonal seeds are crystal seeds, which drop rather than sell ([wikiwiki: Q&A][jp-qa]). Medium confidence (absence of evidence across two wikis).
- **First bronze-tier farm tools:** Bado's blacksmith sells the Sturdy Hoe, Tin Waterpot and Iron Sickle for 3,000 G each, unlocked after beating the Rafflesia boss and reaching the 頼れる王子 (Reliable, 500 visitors) title. The cheap tools sell from the start: hoe and can 150 G, sickle 300 G. The only other early routes are forging with Bronze at forge level 15 after the forge Order, or a Tin Waterpot dropped by Mammoo ([wikiwiki: 町の施設][jp-town], [wikiwiki: 武器][jp-weapons], [GameFAQs: Zoel walkthrough][gf-zoel]). No calendar day is given. **Analysis:** bronze tools are therefore a mid-game upgrade, not a first-week one.

**How a day runs**
- 06:00: wake, crops grow, watered soil dries ([Fandom: Farming Mechanics][w-farm]).
- 07:00: monsters on farm duty clear debris, then water; 15:00 they harvest ([Fandom: Farming Mechanics][w-farm]). Phase 5 material.
- 08:00: the shipping box sells, and a shipping request counts only if the item is in the box at 08:00 ([wikiwiki: 依頼][jp-req], [rf4-research.md](rf4-research.md#shipping-and-selling-researched)).
- **Shop hours** ([Fandom: Crops][w-crops], [wikiwiki: 町の施設][jp-town]):
  - General Store: weekdays 9:00–18:00, holidays 9:00–13:30.
  - Blacksmith: 9:00–18:00, holidays 9:00–14:00; the building opens at 8:00.
  - Restaurant 12:00–21:00. Inn shop until 22:00. Ordered merchants until 23:00.
  - You can buy before opening time when the clerk is already at the counter ([wikiwiki: 町の施設][jp-town]).
- **Weather** can change every hour. Typhoon, snowstorm and Runey weather last all day, and festival days are always sunny ([Fandom: Farming Mechanics][w-farm]).
- **Clock rate contradiction:** a 2013 preview says "30 minutes equals one day" ([NWR preview][nwr-preview]). That conflicts with 1 real second per game minute in [rf4-research.md](rf4-research.md#time-and-sleep-researched). Single source, low confidence; Greenrune keeps 1 s per minute.

**Prince rank** rises with tourists: Apprentice (0), Struggling (100), Respected (250), Reliable (500), Honorable (1,000), Crown of Crowns (2,500). Some shop orders are gated by rank ([Fandom: Prince Points][w-pp], [biligame: orders][bili-order]).

### What this means for Greenrune

- **The first hour has a known shape.** One gated, time-frozen lesson (till, sow, fill, water), then free play with one new tool or system per day from a request box. That is the "teach fast" pillar done RF4's way. The 10-hour complaint in [rf4-research.md](rf4-research.md#criticism-from-critics-and-players) is about the story gating combat and towns, not the first farm lesson. **Analysis.**
- **Starting kit:** hoe, can and 10 turnip seeds, handed over in a short scripted moment on the field, with the sickle arriving later. A starting chest is the cheapest version of this until Phase 2 has NPCs. Applied in [Phase 1.5](phases/phase-01-farm-loop.md#phase-15--the-days-frame).
- **A minimal request box belongs before Phase 8.** RF4 uses it on day 2 to drip-feed tools and seed stock. A box with 4–6 data-driven requests is small and gives the town a purpose. See the Phase 2.4 proposal below.
- **Shop hours and the clerk-present rule:** RF4's numbers above can seed the data. Applied in [Phase 2.3](phases/phase-02-town-npcs.md#phase-23--the-shop).

---

## 2. Environment

### Facts: RF4's Selphia and the field

- **The castle is home and the farm is behind it.** The castle stands in the centre of town. Its three front doors lead to the butlers' rooms, the Dragon Room (Ventuswill, Order Symbol) and the player's room. Each section has a back door onto the farm ([Fandom: Selphia Castle][w-castle], [XSEED: Land of Selphia][xseed-land] [official], [NWR preview][nwr-preview]). High confidence. The farm is one door from your bed and one screen from the town square.
- **Town layout:** Melody Street (General Store, flower shop) is right of the Town Plaza; the residential area (blacksmith, clinic) is left; Selphia Plain is outside the gate and the dungeons branch off it ([Fandom: Selphia][w-selphia]). Medium confidence.
- **Home field:** 18 sections of 2x2 plots, laid out 3x6, so 72 plots on the standard grid. Free Farming Shoes remove grid snapping and fit up to 76. Each section has a faint square outline ([Fandom: Farming Mechanics][w-farm], [GameFAQs: Mina walkthrough][gf-mina]). High confidence. The 6x12 tile count is inferred from "3x6 sections of 2x2".
- **Field props:** the well is in the north-east corner of the field ([GameFAQs: Mina walkthrough][gf-mina]). The farm also has the shipping box, a fertilizer bin and a lumber/stone box ([Fandom: Selphia Castle][w-castle]). No source mentions fences.
- **The field starts covered in debris:** weeds and withered grass, bamboo shoots, herbs, stones, branches, stumps, clay stones, rocks, minerals and rune flowers ([GameFAQs: Mina walkthrough][gf-mina], [Fandom: Farming Mechanics][w-farm]). If a field is left alone, new debris appears until it covers every spot that isn't tilled or planted, up to 76 entities per field ([Fandom: Farming Mechanics][w-farm]). The daily spawn rate was not found; Fandom says only that new debris "will appear and eventually cover all areas".
- **Expansions:** fields 2–5 open by Order, at 500 / 1,000 / 2,500 / 5,000 PP plus lumber, stone and gold. The first also needs 30,000 G shipped and 5% shipping completion ([Fandom: Prince Points][w-pp], [wikiwiki: オーダーとイベント][jp-orders]). Each seasonal field dungeon is smaller: Spring 8 sections, Summer 4, Autumn 6, Winter 12 ([Fandom: Farming Mechanics][w-farm]).
- **Transitions:** the world is split into screens. "Every room, store, and area seamlessly loads after an ultra-quick fade to black" ([NWR 3DS review][nwr-3ds] [press]). You change screens by walking off a map edge ([GameFAQs: Mina walkthrough][gf-mina]).
- **Time and season visuals:** "The time of day and weather also affects the town's appearance", and seasons change character outfits ([NWR 3DS review][nwr-3ds], [NWR preview][nwr-preview]). Snow covering the town in winter: not found.
- **Camera angle, distance and zoom:** not found for either version. Reviews only say "top-down". The only zoom found is on the party camp screen ([wikiwiki: 小ネタ][jp-tips]). wikiwiki's list of Switch changes names no camera option ([wikiwiki: Switch版の変更点][jp-switch]), and gameranbu's RF4 Special field-controls table maps no button to the camera ([gameranbu: controls][gr-controls]). That points to a fixed field camera. Indirect evidence, low-medium confidence.
- **Scale of player vs. tiles vs. buildings:** not found.

### Facts: Farnia Village

- **Studio and team:** ManaGames (Steam: "MNGS（マナゲームス）"), essentially two people: Shinichi Manabe (RF3 main programmer, RF4 director) and Takanori Tsuji (RF3/RF4 game designer and writer). Manabe does "everything myself, except for graphic design and music" ([Steam app details][fv-api] [official], [Automaton interview][automaton] [interview]).
- **Status:** Steam shows "Coming soon / To be announced", Windows only, no demo. Kickstarter (Oct 28 – Nov 27, 2025) raised ¥31,930,842 from 3,493 backers against a ¥5,000,000 goal ([Steam app details][fv-api], [Kicktraq][fv-kicktraq], [RPG Site][fv-rpgsite-ks]). Automaton infers early access around September 2027 from reward dates; that is not an announced date ([Automaton: Kickstarter news][fv-automaton-ks]).
- **Engine:** not found. The Kickstarter page, Steam page, Game*Spark interview and Automaton interview do not name one. The Kickstarter says it runs on Windows 10+ with controller, keyboard and mouse ([Kickstarter: Farnia Village][fv-ks]).
- **Who builds the 3D:** Manabe does "almost everything—coding, modeling, animating, creating effects, UI, pixel art, SE, and game data". The character illustrations are "provisional sketches for modeling purposes" ([Kickstarter: Farnia Village][fv-ks] [official]). A first-time modeller is building Farnia's characters.
- **The starter field is covered in debris**: weeds, stones, branches and stumps on a large dirt grid next to the house, cleared with tools (Observation, [Farnia PV][fv-pv] 0:20–0:40; [Farnia: Introducing the Protagonist][fv-protag] 0:40–0:55). Same opening as RF4.
- **Calendar:** the HUD reads 1年目 春 3日(水) 08:40 with gold below, so the game has years, named seasons and weekdays (Observation, [Farnia PV][fv-pv] 1:27). Season count: not stated.
- **Hardware target:** "optimized to run comfortably on Nintendo Switch-equivalent hardware" and laptops ([Automaton JP news][fv-automaton-jp], [RPG Site][fv-rpgsite]).
- **Look, from the Steam screenshots** (Observation, [Steam: Farnia Village][fv-steam]):
  - Low-poly 3D with flat or soft shading and a painterly feel. No obvious ink outlines.
  - Soft, saturated palette: grass greens, orange-brown dirt, pastel pink round shrubs, light blue water. Large soft cloud shadows drift over the ground.
  - Seasonal particles (spring petals, autumn leaves, winter snow) and seasonal palette swaps of the town.
  - The field is a dirt plot with visible square tile borders.
  - Interiors are cutaway rooms with the near walls removed.
  - All 8 screenshots use the same fixed, high, north-facing camera, roughly 50–60° by eye. Whether it rotates or zooms: not found. The PV's field footage uses the same north-facing camera, steeper over the field; the Steam "FARMING" clip looks close to straight down (Observation, [Farnia PV][fv-pv] 0:27–1:20, [Steam: Farnia farming clip][fv-farmclip]).
- **Developer statement on graphics** ([Automaton interview][automaton], [Automaton JP interview][fv-automaton-int-jp]): improvements are being considered, but must not make it harder to add gimmicks and variety, because "the quantity of objects is important too", and background costs are kept from rising. Single source.

### What this means for Greenrune

- **Shrink or section the field.** Greenrune's field is 12x12 = 144 tiles (`scenes/farm.tscn`). RF4's first field is 72. A 6x12 field with visible 2x2 section outlines matches RF4, halves the RP cost of a full watering, and gives giant crops and charged sowing a home later. It also bears on the playtest finding that watering the whole 12x12 field at max RP 100 doesn't fit. *(Superseded by [roadmap.md](roadmap.md): the field is 9x12 in 3x3 blocks.)* Applied in [Phase 1.1](phases/phase-01-farm-loop.md#phase-11--the-field) (6x12 in 2x2 sections) and [Phase 1.5](phases/phase-01-farm-loop.md#phase-15--the-days-frame) (RP re-tune).
- **Put the farm one door from the bed and one screen from the town.** The house-door-to-interior link exists. The farm ↔ town exit should stay a single fade, as now.
- **Start the field dirty.** Weeds, stones and branches that the player lifts and throws give the first five minutes something to do and introduce the carry state crops need anyway.
- **The camera is a free choice.** No source gives RF4's numbers. The working tree's outdoor framing is pitch 45°, arm 20, FOV 35 (`data/camera.tres`, uncommitted; HEAD has 50° and 25). Pick by comparing screenshots side by side; Farnia's screenshots sit around 50–60° by eye.
- **Palette and light:** Farnia shows that soft saturated colour, big cloud shadows and seasonal particles carry a low-poly world. Cloud shadows are cheap in Godot (a scrolling noise texture on a light projector or in the ground shader). **Analysis.**

---

## 3. Design: art direction, UI and feedback

### Facts: RF4

- **Art staff:** artists Minako Iwasaki, Takitaro, Masato Yamane and Oyaji ([Wikipedia: RF4][wp-rf4]). Hashimoto names Iwasaki as character designer ([Siliconera: Hashimoto on characters][sil-chars] [interview]).
- **Character proportions (heads tall) and toon-shading details:** not found in any source.
- **3DS HUD** ([GameFAQs: Mina walkthrough][gf-mina], [NWR 3DS review][nwr-3ds]):
  - The lower screen always shows season, day, weekday or holiday, time, gold and Prince Points.
  - A green HP bar (red marks HP just lost) and a blue RP bar.
  - A map of the current area with portrait icons for the people in it.
  - The waterpot's fill meter appears on the lower screen when the pot is equipped.
  - A Notebook icon for requests in the bottom-right corner.
- **RF4 Special's single screen:** the old lower-screen information opens as overlays on L/R. The map moved onto the main screen and can be resized or hidden ([wikiwiki: Switch版の変更点][jp-switch], [Fandom: RF4 Special][w-rf4s]). The developers said that moving "from two screens to one, we've improved the UI substantially", and that the character models and animations were upgraded ([Nintendo Everything interview][ne-interview] [interview]). Exact corner positions of the bars and clock in Special: not found.
- **Reviews of Special's UI:** the HUD is "far too large for its own good" with no scaling option ([GamingTrend][gamingtrend]); the screen feels "a bit cluttered" and some lines still say "find it on your bottom screen" ([Nintendo Everything review][ne-review]); "Models look to be the same from the 3DS", with menus and portraits redrawn ([GameRevolution][gamerev-rf4s]) [press].
- **Inventory:** the rucksack starts at 15 slots, and orders raise it to 30, 45 and 60. Tools live on the "L Pocket", a cross-bar menu with rows for weapon, spells and tools/items ([GameFAQs: Mina walkthrough][gf-mina], [gameranbu: requests][gr-req]).
- **Hands and held items:** A picks up and throws, B uses the tool or eats the held item, X/Y puts the held item into the rucksack ([GameFAQs: Mina walkthrough][gf-mina]). Holding A after a pickup collects every nearby item of the same type ([wikiwiki: 小ネタ][jp-tips]). Gifts are given by holding the item and talking to the person ([GameFAQs: Mina walkthrough][gf-mina]). The tutorial line is "Toss your turnip into the Shipping Box" ([guidestrats: walkthrough part 1][gs-walk]).
- **Targeting and prompts:** a red marker and red shadow show the plot a tool will hit. A yellow speech bubble marks villagers you haven't spoken to today ([GameFAQs: Mina walkthrough][gf-mina]).
- **Sowing visual:** a sown plot shows "4 little seeds over it" ([GameFAQs: Mina walkthrough][gf-mina]).
- **Rune pickups:** Rune Orbs and Runeys, "cartoonish floating elemental spirits", sometimes pop out of harvested crops and must be touched ([Fandom: Farming Mechanics][w-farm], [GameFAQs: Mina walkthrough][gf-mina]).
- **Sound design:** not found. The 60 fps "pop" goal is in [rf4-research.md](rf4-research.md#engine-and-tech).

### Facts: Farnia Village

- **HUD** (Observation, [Steam: Farnia Village][fv-steam]): bottom centre, a numeric HP readout above a teal bar, with a thinner pinkish bar under it (unlabelled). It is probably Mana: food items list "HP回復" and "マナ回復" (Mana recovery) side by side, and the Kickstarter says crops "produce Mana, helping your character grow" (Observation, [Farnia PV][fv-pv] 1:52; [Kickstarter: Farnia Village][fv-ks]). Inference, medium confidence. Bottom left, a ring of four slots arranged like a D-pad, which looks like a quick-select. Dialogue uses a large 2D bust portrait, a name tab and a parchment text box over the 3D scene.
- **Crops** (Observation, [Steam: Farnia Village][fv-steam]): each crop is its own low-poly 3D model at visibly different stages: cabbage, staked tomato, corn, wheat, pumpkin, eggplant, onion, strawberry, melon and a leafy sprout. Polycounts: not found.
- **One control scheme for everything:** farming motions have hitboxes, a sword swing cuts grass, and the director wants magic to work on the field too. The rule is that controls never change by situation: no special farming mode ([Automaton interview][automaton], [Game*Spark 2025-11-23][gs-1123]). You can stack many harvested crops on your hands ([Automaton JP news][fv-automaton-jp], single source). A close friend visiting your field may water dry soil for you ([Automaton interview][automaton]).
- **Characters:** chibi, roughly 2.5–3 heads tall, with painted anime eyes. Close-up frames are described in [section 5](#5-character-style-farnia-village-vs-blue-archive--stella-sora-chibi). Character art is by benitama, kannnu and BOKI simole; the music is by Tomoko Morita, RF4's composer ([Famitsu][fv-famitsu], [RPG Site][fv-rpgsite]).
- **Menus:** the pause menu lists Status, Items, Abilities, Pocket, Everyone, Memo, Diary and Options. Every item has a level ("Lv1×1") and a shipping price. The Memo screen keeps a shipping history with a total per crop and a completion percentage (達成率 1.4%), next to recipe and fishing records (Observation, [Farnia PV][fv-pv] 1:27, 1:52). That is RF4's shipping-list idea.

### What this means for Greenrune

- **HUD:** RF4 shows date, time, gold, HP, RP and the water meter, and Special's single-screen version was criticised for being too big and too small at once. Greenrune's HUD (RP/HP bottom left, clock and gold, hotbar) already covers most of that. Missing: the season/day/weekday line and the water meter. Keep text large and the HUD compact; add a UI scale option in M1's Options step.
- **Water meter:** show the can's water as a small gauge whenever the can is selected, as RF4 does.
- **Visible tile and section grid:** both RF4 (faint section outlines) and Farnia (tile borders) show the grid on the ground. Greenrune's `FarmGrid` draws per-tile boxes; add the 2x2 section outline. *(Superseded by [roadmap.md](roadmap.md): 3x3 block outlines.)*
- **Carry state:** RF4's A-lift-throw and Farnia's crop stacking are the same idea. One carry state serves debris, harvested crops, gifts (Phase 2) and the shipping box.
- **Rune orbs:** a floating pickup after some harvests that refills RP and gives skill XP. Cheap, on-pillar (every action levels something), and missing from every plan file. **Analysis.**
- **Proportions:** KayKit Adventurers measure about 2.1 heads tall. That is shorter than Farnia (about 2.5–3) and in Blue Archive's range. No source gives RF4's ratio. [Section 5](#5-character-style-farnia-village-vs-blue-archive--stella-sora-chibi) compares the styles and gives a path.

---

## 4. Farm mechanics: exact RF4 rules

### Tools, areas and charge

| Tool | Tap | Cheap (starter) | Bronze tier | Silver tier | Gold / Platinum |
|---|---|---|---|---|---|
| Hoe | 1 plot in front | no charge | charge 1: 2x2 | charge 2: 2x4 | Gold: not found. Platinum: 3x3 at charge 3 |
| Watering can | 1 plot in front; "press B repeatedly to water as you walk" | no charge | charge 1: 2x2 | not found | Gold: not found. Platinum: 3x3 at charge 3 |
| Sickle | 1 plot | no charge | charge 1: 2x2 | not found | Gold: not found. Platinum: 3x3 at charge 3 |
| Seeds | 1 plot | charge: one 2x2 section | — | — | — |

Sources: [koryaku-memo: hoe][km-hoe], [koryaku-memo: waterpot][km-pot], [koryaku-memo: sickle][km-sickle], [gameranbu: tools][gr-tools], [Fandom: Equipment][w-equip] (item descriptions: the Sturdy Hoe "Charge to cover a wider area"; the Tin Waterpot "Though heavy, it can be charged"), [Fandom: Forging (RF4)][w-forging] (platinum: a re-forge adds a 4th charge "from nine plots (3x3) to sixteen (4x4)"), [Fandom: Farming Mechanics][w-farm] (seeds), [GameFAQs: Mina walkthrough][gf-mina] ("Doing so will till the field in front of you"). Medium confidence for the tiers (one source family plus item descriptions); high for seeds. The platinum 3x3 is single-source and only stated in passing.

- **Tier names** (Cheap, then forged from Bronze, Silver, Gold and Platinum at forge levels 15, 30, 45 and 80): Hoe: Cheap, Sturdy, Seasoned, Shiny, Blessed. Waterpot: Cheap, Tin, Lion, Rainbow, Joy. Sickle: Cheap, Iron, Quality, Super, Legendary ([wikiwiki: 武器][jp-weapons], [Fandom: Equipment][w-equip]). Search results that give "Seasoned Hoe 3x3, Shiny 5x5" come from RF1/RF2/Frontier pages, not RF4.
- **Charged areas snap to the grid** and keep a fixed arrangement; Free Farming Shoes only remove the snapping ([Fandom: Farming Mechanics][w-farm]). Whether a charged area is centred on the player or set in front: still not stated in any RF4 source (searched JP 前方/主人公の前 and EN "front of player").
- **A 4th charge stage** exists only through an upgrade (Light Ore and Sacred Pole added to a platinum tool's recipe). It costs no RP and gives no XP. Its size is disputed: 4x4 ([Fandom: Forging (RF4)][w-forging]), 8x8 for the can and axe with the hoe unchanged ([wikiwiki: 小ネタ][jp-tips]), or, for tools other than the hoe and can, a further 5th stage of 8x8 "instead of 6x6" (one GameFAQs user, [GameFAQs: charge range thread][gf-charge]). The Blessed Hoe stays at 2x2 on it ([Fandom: Forging (RF4)][w-forging]). Low confidence on the size; all sources agree normal tools top out at stage 3.
- **Water capacity:** Cheap Waterpot 80, Rainbow Waterpot 120 ([Fandom: Cheap Waterpot][w-cheap-pot], [Fandom: Rainbow Waterpot][w-rainbow-pot]). The Tin, Lion and Joy pages leave the field blank. Low confidence, single source, units unclear. The pot starts empty, and you fill it at the well, a Water Source furniture item (水場, 18,000 G) or any body of water ([GameFAQs: Mina walkthrough][gf-mina], [Fandom: Farming Mechanics][w-farm], [wikiwiki: 町の施設][jp-town]). Refill RP cost and water per charge stage: not found.
- **The sickle tier caps reaped seed level:** Cheap Lv3, Bronze 4, Silver 6, Gold 8, Platinum 10 ([wikiwiki: 農作業][jp-farm]).

### Farnia Village tool areas (3x3 question)

No text source describes Farnia's tool areas: not the Steam page, the Kickstarter story, the Automaton or Game*Spark interviews, or the official YouTube channel's video titles (none is a farming devlog). ManaGames' X account was not read. The answer comes from paused frames of the official PV ([Farnia PV][fv-pv], 7:18, posted 2025-10-28 and embedded on the Kickstarter as the "full-length introduction clip"). A third party's re-upload ([LPE mirror][fv-pv-mirror]) is slightly longer (443 s against 438 s); its timestamps are unchecked. All of the following is **Observation**:

| Action | PV time | Tap | Charged | Where the area sits |
|---|---|---|---|---|
| Hammer / axe on debris (採掘 伐採) | 0:20 | one blue tile | 3x3 blue block | in front of the player, starting on the next tile, centred on the facing line |
| Hoe (耕す) | 0:43.4 → 0:43.6, again 0:45.4 | one blue tile beside the player | 3x3 blue block, then the dust and tilled soil cover the same 3x3 (0:46.4) | in front: the player stands outside the block, next to its middle row |
| Seeds (種蒔き) | 0:59.6 → 1:00.1 | — | 3x3 blue block, seed piles land on all nine plots | the block includes the player's own tile, centred on it |
| Watering can | 1:16.5 → 1:18.5 | one blue tile (1:19.5) | 3x3 blue block, splash rings on all nine plots | includes the player's tile, the player in the middle row |
| Harvest | 1:59 | — | spinach pops out of roughly a 3x3 block | in front |

- **Charge steps:** between 0:43.4 and 0:43.55 the marker jumps from one tile to 3x3. No 2x2 step shows in the frames I checked, about 0.15 s apart. Whether there is a hidden middle step or higher steps with better tools: not shown.
- **Grid snap:** every highlight is whole tiles on the field grid.
- **Tool tiers:** the PV doesn't say which tool tier is in use. It is the first in-game days (HUD at 1:27 reads year 1, spring, day 3), so this is probably a starter tool. Inference.
- The Steam "FARMING" clip only shows single-tile tilling with a one-tile blue marker on the tile in front ([Steam: Farnia farming clip][fv-farmclip]).
- The front-versus-centred reading for seeds and the can is my judgment from a tilted camera. A character's feet mark its tile, and the head overlaps the row above. Medium confidence.

**Analysis.** Farnia charges to 3x3, apparently from the first days, with every tool. RF4 charges to 2x2 at bronze and reaches 3x3 only with platinum tools. Farnia's 3x3 has no section grid underneath; RF4's 2x2 matches its 2x2 soil sections. For Greenrune the two fit different field designs. A 2x2 charge belongs with 2x2 sections (giant crops and soil later). A 3x3 charge suits a plain tile grid with no sections and covers 9 plots per RP spend instead of 4, which makes a 72- or 144-plot field cheaper to work. Farnia's split (tilling in front, watering and sowing around the player) reads as a choice that keeps the player out of the soil being swung at; Greenrune can copy that cheaply, since `ToolDef` already holds per-tool charge data.

### Clearing debris

| Debris | Cleared by |
|---|---|
| Branches, stones, grasses, weeds | Hand: A lifts and moves them |
| Rune flowers | Sickle (or any blade) |
| Bamboo shoots | Sickle or hoe |
| Stumps, broken stumps | Axe only |
| Clay stones, rocks, minerals, rune crystals | Hammer only |

Sources: [Fandom: Farming Mechanics][w-farm], [GameFAQs: Mina walkthrough][gf-mina]. High confidence.

- The sickle destroys grasses and weeds with no byproduct. Every other debris type drops something, usually an item ([Fandom: Farming Mechanics][w-farm]).
- Bladed weapons stand in for the sickle, great axes for the axe and great hammers for the hammer, but their charge gives no farming area ([Fandom: Farming Mechanics][w-farm]). This is the "tools are combat-shaped" design already in the plan.
- A hammer removes tilled plots, even seeded ones, until the crop sprouts. After sprouting, a sickle destroys it ([Fandom: Farming Mechanics][w-farm]).

### RP and skills

- **Base RP per tool action, per tier, and the size of the skill discount:** not found in any source (searched Fandom, wikiwiki, GameFAQs boards, gameranbu, koryaku-memo, biligame, Bahamut, a Steam CN guide). Charging spends RP per charge stage ("RPは溜め分消費する") ([wikiwiki: 小ネタ][jp-tips]). The Farming skill's effect is only described as lower RP use ("消費RP↓") ([wikiwiki: スキル][jp-skills], [Fandom: Skills (RF4)][w-skills]). Getting the numbers would need an in-game test or a datamine.
- **Farming XP per charge level** (one user's measurements): hoe charges 1/2/3 give 30/80/100 XP and the waterpot 20/40/60, whatever the number of plots hit; sickling a crop 15; each seed sown 15 ([GameFAQs: farming XP thread][gf-xp]). Single source.
- **Skills from farm work** ([wikiwiki: スキル][jp-skills], [wikiwiki: 武器][jp-weapons]):

| Action | Skills that level |
|---|---|
| Any field work (hoe, can, sickle) | Farming: lower RP cost, more max HP and RP, VIT |
| Tilling | Earth |
| Watering tilled soil | Water |
| Reaping a crop with the sickle | Wind |
| Sowing seeds | Love |
| Picking up items | Light |
| Spreading chemicals | Dark |
| Axe on stumps and branches | Logging |
| Hammer on rocks | Mining |
| Shipping | Bartering (おみせ) |

- **Correction to rf4-research.md** ([line 172](rf4-research.md)): "every farm chore trains one Farming skill" is incomplete. Each chore also trains an element skill, as above.

### Crops and growth

- **Tick:** growth at 06:00, from a hidden day counter. Each day adds the soil's growth multiplier times the season factor ([Fandom: Crops][w-crops], [Fandom: Farming Mechanics][w-farm]). The crop changes look at growth thresholds. **The number of visual stages: not found.** wikiwiki's crop-data page has no stage thresholds, and its Q&A describes only size states (normal, medium, giant). The only per-stage split found is for Rune Factory Frontier (turnip 1/1/1/1 days), not RF4 ([wikiwiki: 作物数値データ詳細][jp-cropdata], [wikiwiki: Q&A][jp-qa]).
- **Spring-relevant crops** ([Fandom: Crops][w-crops]; regrow intervals from [wikiwiki: 作物数値データ詳細][jp-cropdata]):

| Crop | Days | Yield | Regrows (days) | Good seasons | Bad |
|---|---|---|---|---|---|
| Turnip | 3 | 2 | no | Summer, Fall | none |
| Potato | 7 | 3 | no | Spring, Summer | Winter |
| Cucumber | 5 | 5 | yes (2) | Spring, Summer | Winter |
| Strawberry | 16 | 6 | yes (3) | Spring, Fall | none |
| Pink Turnip | 11 | 4 | no | Spring | Winter |
| Cabbage | 8 | 3 | no | Spring, Fall | none |
| Tomato | 7 | 3 | yes (3) | Spring, Summer | Winter |
| Pumpkin | 7 | 3 | yes (3) | Spring, Summer | Winter |
| Spinach | 2 | 2 | no | Fall | none |

  Fandom describes pumpkin's second harvest as "50% grow time"; wikiwiki gives 3 of 7 days. All crops are destroyed by the sickle, regrowing or not ([Fandom: Farming Mechanics][w-farm]).
- **Season factor:** good season 1.5x everywhere. Bad season: three values, all on RF4 pages (none is borrowed from RF3 or RF5), none from a datamine:
  - **0.5x**, [wikiwiki: 農作業][jp-farm] ("適性季節で1.5倍、不適正で0.5倍"). It covers 3DS and Switch, and its day counts assume a neutral season at 1.0x. This wiki's crop data uses internal values (256 = 1.0x), so it is the most data-driven of the three.
  - **2/3**, [Fandom: Crops][w-crops], added on 2014-09-13 (3DS era) and never changed since (page history).
  - **0.75x**, [Fandom: Farming Mechanics][w-farm], added on 2026-04-25 in a large rewrite, with no source for it (page history). The newest and least supported.
  - Use 0.5x or 2/3. Medium confidence. Crops never die at a season change ([wikiwiki: 農作業][jp-farm], [Fandom: Crops][w-crops]). High confidence.
- **Unwatered day:** no growth ([Fandom: Crops][w-crops]); 0.5x growth plus lower level and yield, a smaller crop and HP loss ([wikiwiki: 農作業][jp-farm]); "may be slowed" ([Fandom: Farming Mechanics][w-farm]). Contradiction, as already noted in [rf4-research.md](rf4-research.md#crops-researched).
- **Withering:** at 06:00 some crops turn a different colour. Unwatered that day, they die and become Withered Grass ([Fandom: Farming Mechanics][w-farm]). Behind it is crop HP (0–255): a watered crop loses about 3 HP a day and an unwatered one 15–18; at 0 it dies ([wikiwiki: 作物数値データ詳細][jp-cropdata], [Fandom: Farming Mechanics][w-farm]). Withered Grass is pulled by hand, goes in the fertilizer bin, or is hoed into the soil for +50 soil health ([Fandom: Farming Mechanics][w-farm]).
- **Rain and snow:** any rain or snow waters the field over time; heavy rain or snow covers everything in about 2 hours, light weather takes longer ([Fandom: Farming Mechanics][w-farm]). Single plots can still be missed ([wikiwiki: 農作業][jp-farm]). Typhoons and snowstorms water too, but can turn plots and crops into debris on low-defence sections. Runey weather, about once a season, adds four days of growth at 06:00 ([Fandom: Farming Mechanics][w-farm]).
- **Crop level** starts at the seed level and can rise or fall while growing (blue or red text) ([Fandom: Farming Mechanics][w-farm]). Hand harvests sometimes drop seeds that can be a higher level; the sickle guarantees a seed, often higher ([Fandom: Farming Mechanics][w-farm]).
- **Weekly bumper and poor crops:** each week one crop is set to bumper and one to poor, which changes harvest counts. Arthur's bookshelf shows this week's and next week's ([wikiwiki: 農作業][jp-farm]). Single source.

### Soil (out of Greenrune's scope; listed so the deferral is informed)

`NOT_IN_SCOPE.md` defers "Soil hidden stats, giant crops" indefinitely ([NOT_IN_SCOPE.md line 42](../NOT_IN_SCOPE.md)). For the record:
- **Per 2x2 section:** growth rate (0.30–5.00x), quality, number, size, health (0–255) and typhoon defence (0–63), plus five attribute levels (1–16) that set where those values rest ([Fandom: Farming Mechanics][w-farm]).
- **Degrades:** every harvest lowers that section's values except defence ([Fandom: Farming Mechanics][w-farm]).
- **Recovers:** fallow ground with a non-empty fertilizer bin regains growth +0.2x, health +16 and so on each day ([Fandom: Farming Mechanics][w-farm]). The fertilizer bin eats 3 grasses per field per day and works only for the castle fields ([wikiwiki: 農作業][jp-farm]).
- **Nutrients:** Formula A/B/C (growth +0.5/+1/+2x), Greenifier (quality +0.06), Greenifier+ (+0.5), Giantizer (size +0.31), Minimizer (size −1, health +60), Wettable Powder (defence +32). A second nutrient on one section in one day costs health ([Fandom: Farming Mechanics][w-farm], [wikiwiki: 作物数値データ詳細][jp-cropdata]). Formuade is not a soil nutrient: Fandom's crop table lists it in the recipe column for Hot-Hot Fruit ([Fandom: Crops][w-crops]), and [rf4-research.md](rf4-research.md#tool-rp-and-hp-rules-researched) describes it as a drink that lowers max HP.
- **Giant crops:** four of the same crop in one section with enough size value merge 1–2 days after ripening ([Fandom: Crops][w-crops], [wikiwiki: 農作業][jp-farm]).

### Harvest, carrying, shipping and runes

- **Carrying:** harvested items are lifted (A) and then thrown or put away (X/Y) ([GameFAQs: Mina walkthrough][gf-mina]). No source says outright that a harvested crop is held overhead; the controls imply it. Medium confidence.
- **Shipping box:** price by level and the 08:00 sale are in [rf4-research.md](rf4-research.md#shipping-and-selling-researched). The box grows to at most 300 slots ([wikiwiki: 農作業][jp-farm]). Monsters on farm duty put crops straight into the box ([Fandom: Farming Mechanics][w-farm]).
- **Runes on harvest:** a Rune Orb restores 50% of max RP and raises one skill by 1 level; a Runey restores 80% of max RP and raises one stat. Both are likelier from harder crops ([Fandom: Farming Mechanics][w-farm]). Base chance: not found. The only number is a guess for Runey-weather days ("5-10%程度？") ([wikiwiki: 農作業][jp-farm]). Crops harvested by monsters drop none, and neither do small or unwatered crops ([wikiwiki: 農作業][jp-farm]).

### Corrections to the existing research and plan

| Where | What it says | What the sources say |
|---|---|---|
| phase-01 before the 2026-10-20 restructure | "tap 1 tile, 0.6 s the 2×2 around the player, 1.2 s the 4×4 around the player, like Rune Factory 4" | Starter tools can't charge. Bronze: 2x2. Silver hoe: 2x4. RF4's only 4x4 is the upgraded platinum 4th charge. Areas snap to the grid ([koryaku-memo: hoe][km-hoe], [Fandom: Equipment][w-equip], [Fandom: Forging (RF4)][w-forging]). Applied in [Phase 1.2](phases/phase-01-farm-loop.md#phase-12--tool-feel); its Gold row still defaults to 4x4 |
| phase-01 before the restructure | Can holds 15 | Cheap Waterpot 80, Rainbow 120 (single source). Applied as a decision step in [Phase 1.2](phases/phase-01-farm-loop.md#phase-12--tool-feel) |
| phase-01 before the restructure | Charged sow covers "the 2×2 around the player" | One field section, snapped ([Fandom: Farming Mechanics][w-farm]). Applied in [Phase 1.2](phases/phase-01-farm-loop.md#phase-12--tool-feel) |
| [rf4-research.md line 168](rf4-research.md) | Out of season 0.75x (Fandom) or 0.5x (wikiwiki) | Also 2/3 in Fandom's own crop worked example (2014). The 0.75x was added in 2026 without a source; 0.5x or 2/3 is better supported |
| [rf4-research.md line 172](rf4-research.md) | Every farm chore trains one Farming skill | Also an element skill per chore ([wikiwiki: スキル][jp-skills]) |
| [rf4-research.md line 173](rf4-research.md) | Sickle RP and charge areas unknown | Cheap: no charge; Bronze: 2x2. RP still unknown |
| The research brief | "seed bag scatter pattern 3x3" | RF4 never sows 3x3; that is RF1–3 and Harvest Moon. RF4 sows one plot, or one 2x2 section charged ([Fandom: Farming Mechanics][w-farm]) |

### What this means for Greenrune

- **Charge areas: three sourced options.**
  1. RF4: no charge on starter tools; 2x2 and 2x4 unlocked by tool tier (bronze is a mid-game shop or forge item); 3x3 only at platinum. Snap to 2x2 sections.
  2. Farnia: 3x3 from the start for every tool, grid-snapped, no sections. Tilling sits in front of the player; sowing and watering include the player's tile (Observation).
  3. A deliberate mix, e.g. starter tools charge to 2x2, later tiers to 3x3.
  
  Whichever is picked, fix the "like Rune Factory 4" wording. RF4's only 4x4 is the upgraded platinum 4th charge; Farnia shows none. `ToolDef.charges` is already per tool, so tier-gating is a data change later.
- **Water capacity:** 15 uses makes refills frequent next to RF4's 80. Raise it, or keep it as a deliberate rhythm. Add "water as you walk" (repeated taps while moving) since that is how RF4 waters with a starter can. Refill cost and per-charge water use have no RP source to copy; they are Greenrune's choice.
- **RP numbers are Greenrune's own.** No source gives RF4's RP per action or the skill discount, so Phase 1's RP budget can't be "RF4-accurate". The one sourced pattern is that a charge spends RP per stage reached.
- **Withering and Withered Grass:** a colour change at 06:00, death if unwatered that day, and a useful Withered Grass item. It gives watering stakes without a timer. Applied in [Phase 1.4](phases/phase-01-farm-loop.md#phase-14--crops).
- **Season data for Phase 3:** use RF4's good/bad seasons from the table. For the out-of-season factor use 0.5x (wikiwiki) or 2/3 (Fandom 2014); the 0.75x has no source. RF4's shop seed stock doesn't change by season, so seasonal stock would be Greenrune's own rule.
- **Crop stage count is a free choice.** No RF4 source gives one.
- **XP for sowing and picking up:** RF4 rewards both (Love, Light). Greenrune can route them to existing skills or leave them out; the current "no XP" is a gap, not a sourced rule.

---

## 5. Character style: Farnia Village vs Blue Archive / Stella Sora chibi

**Method.** I paused official videos in a browser and cropped single frames; each observation below cites its video and timestamp. Blue Archive and Stella Sora have no developer write-up on their character models that I could find, so their structure comes from Sketchfab listings (community uploads; some say "Model from Blue Archive", i.e. extracted from the game) and official gameplay video. The Models Resource returned a bot-verification page, which I did not get past. Head counts are by eye from stills, about ±0.3 heads. Everything marked Observation is my reading of a frame, not a sourced claim.

### Farnia Village (Observation)

Frames: [Farnia: Introducing the Protagonist][fv-protag] 0:05 (female protagonist, walking toward the camera), 0:40 and 0:55 (male protagonist on the field and by the house); [Farnia PV][fv-pv] 0:43–0:46 (hoe), 1:39 (carrying turnips).

- **Proportions:** about 2.5–3 heads (the female protagonist's head is about 37% of her height at 0:05). Slim arms and legs, legs roughly one head long, boots. Hands are small and simple; no finger detail reads at the game camera. A character stands about 1.5 tiles tall (0:40).
- **Face:** painted texture. Large anime eyes with highlights, no modelled nose, the mouth too small to see at the game camera. Expressions and emotion live in the 2D bust portraits in dialogue (protagonist video 1:10, Erykah).
- **Hair:** solid mesh in chunky spiky locks, with painted strand lines and a colour gradient (dark grey to white and teal tips at 0:05). Not hair cards.
- **Shading:** soft two-tone cel with soft cast shadows. No thick ink outline shows at 1080p. Soft, saturated pastel palette, matching the world.
- **Animation (from frame sequences):** big readable poses. The hoe is held overhead while charging (PV 0:43.4–0:45.8) and released in a jump-and-slam with a dust burst (0:46.4). Harvested crops stack in a tall column over the head (PV 1:39–1:45). Timing and easing: not judged from stills.
- **Fit with the world:** the world is low-poly, flat-coloured and simple (plain tile field, blocky trees, simple houses). The characters carry the most detail on screen: face, hair gradient, costume. They read at a high camera because they are the busiest thing in view.
- **Who makes them:** one programmer who learned modelling for this game, from illustrators' "provisional sketches for modeling purposes" ([Kickstarter: Farnia Village][fv-ks] [official], [Game*Spark 2026-01-12][gs-0112] [interview]).

### Blue Archive (Observation unless labelled)

Frames and models: Sketchfab [BA Koharu][sf-ba-koharu] (viewer), [BA Azusa][sf-ba-azusa], [BA NPC SD][sf-ba-npc] (full body), in-battle capture [BA combat gameplay][ba-combat] 4:20. Its memorial lobbies are 2D Live2D/Spine, not 3D ([TapTap review][ba-taptap] [community]), so the 3D SD style is the battle/café one.

- **Proportions:** about 2.3–2.5 heads (full-body NPC SD model). The head is wider than the shoulders. Short arms, small simple or gloved hands, slim legs in socks and shoes.
- **Polycount and materials [community]:** listings described as extracted from the game show 15k–19k triangles and 7–8 materials/textures per character (Koharu 14,968, Azusa 19,178), sold as "Default emotion" variants ([BA Koharu][sf-ba-koharu], [BA Azusa][sf-ba-azusa]). That is 2–3x a KayKit character (5.7k–7k).
- **Face:** painted texture. Very large eyes with layered highlights and blush, a tiny painted mouth, no modelled nose. The per-emotion uploads suggest expressions are swapped as a set. Inference.
- **Hair:** solid mesh, many layered locks, painted gradient and soft painted shading.
- **Shading:** close to flat, with soft gradients painted into the texture and thin dark outlines on the silhouette.
- **Fit with the world:** battle maps are detailed stylised streets (cars, barricades) under a high oblique camera. Its 3D background team says it keeps the centre of a battle area, where characters stand, simple and puts detail at the edges, because a busy centre is "visual noise" on a phone screen ([4Gamer: NDC25 BA backgrounds][ba-ndc] [interview]).
- **Animation:** not observed in enough detail to describe.

### Stella Sora (Observation unless labelled)

Frames: [Stella Sora gameplay trailer][ss-trailer] (official) 1:15 (dungeon field model), 2:00 (team select, three 3D models large on screen); Sketchfab [Stella Sora Freesia outfit][sf-ss-freesia] (12,916 triangles, one material, source not stated) [community].

- **Proportions:** about 4–4.5 heads. Long slim legs and adult-like limb lengths: a "mini figure" anime look, not super-deformed. This is the biggest difference from Blue Archive.
- **Face:** painted anime eyes and a small painted mouth, same family as Blue Archive.
- **Hair:** solid mesh, many separate locks, painted gradient.
- **Shading:** cel shading with clear dark outlines (2:00). A fan model of a Stella Sora character is 25k triangles without its outline shell and 45k with it, with vertex colour driving the outline width ([Sketchfab: Stella Sora fan model][sf-ss-fan] [community]). That is the inverted-hull outline method, though it is a fan's, not the studio's.
- **Fit with the world:** detailed stylised dungeon rooms and plazas under a high camera (1:15, 2:25).
- **Animation:** not observed in enough detail to describe.

### Side by side

| Trait | Farnia Village | Blue Archive (battle SD) | Stella Sora (3D) | KayKit Adventurers (Greenrune's base) |
|---|---|---|---|---|
| Heads tall | ~2.5–3 | ~2.3–2.5 | ~4–4.5 | ~2.1 (measured: head 1.10 of 2.32 m on Knight.glb) |
| Limbs | slim, legs ~1 head | short arms, slim short legs | long slim legs | stubby blocks; legs 0.53 m |
| Hands / feet | small, simple; boots | small, simple or gloves; shoes | slim | blocky mitts; boots |
| Face | painted big anime eyes | painted very big eyes, blush | painted anime eyes | painted small dot eyes, Western toy style |
| Hair | solid chunky locks, gradient | solid layered locks, gradient | solid many locks, gradient | solid blocky hair or helmets |
| Shading | soft cel, no visible outline | near-flat, thin outline | cel, clear outline | soft gradient atlas |
| Triangles | not stated | 15k–19k [community] | 13k body [community] | 5.7k–7k (measured) |
| Made by | one learning modeller | studio team | studio team | asset pack, CC0 |

Measurements of KayKit come from the GLB mesh bounds in `assets/characters/kaykit-adventurers/` (Knight: head mesh y 1.22–2.32, body 0.38–1.29, legs 0–0.53; head 1.09 wide, body 0.80). The face is part of the head's texture; the GLBs have no separate eye or mouth mesh. The face style is from the [KayKit Adventurers][kaykit] banner.

### Is Farnia's chibi like Stella Sora's?

Partly. **Close** in the face and hair: both use painted large anime eyes, no modelled nose, solid-mesh hair in separate locks with a painted colour gradient, and soft saturated colour. **Different** in proportion and line: Farnia is about 2.5–3 heads with a big head, Stella Sora about 4–4.5 with long legs; Stella Sora has clear outlines and Farnia shows none. By proportion Farnia sits next to Blue Archive (2.3–2.5), not Stella Sora. A fair one-line summary: Farnia uses Stella Sora's face and hair on a body close to Blue Archive's. **Analysis.**

So the choice is not between two names but between four traits:
1. **Heads tall:** ~2.1 (KayKit), ~2.3–2.5 (Blue Archive), ~2.5–3 (Farnia) or ~4–4.5 (Stella Sora), by eye ±0.3 except KayKit.
2. **Face:** painted anime eyes (all three references) vs KayKit's dot eyes.
3. **Hair:** solid locks with a gradient (all three) vs KayKit's blocks.
4. **Outline:** none (Farnia) or thin (Blue Archive, Stella Sora). The repo's cel shader folder already ships an outline shader (`assets/shaders/cel/outline.gdshader`), so this is a setting, not a cost.

### What this means for Greenrune

Constraints: KayKit base (~2.1 heads, 41-joint skeleton, 76 clips), a community cel shader, a beginner Blender user, a solo dev, and CLAUDE.md's "No custom humanoid or building modeling until at least Phase 4".

**Cost of each trait** (**Analysis**; no source gives hours, so this ranks effort instead of estimating it):

| Change | Method | Allowed before Phase 4? | Effort for a Blender beginner |
|---|---|---|---|
| Recolour clothes and hair | edit the 1024 gradient atlas or swap materials | yes (retexturing) | small |
| Anime eyes on KayKit | paint a face texture onto a small quad or a Godot `Decal` attached to the head bone; or repaint the face area of the atlas if its UVs have room | yes (no mesh edit) | small to medium; the atlas route depends on how much UV space the face has, unchecked |
| Rounder head, new hair locks | edit the KayKit head and hair meshes in Blender, keep bone names and weights | grey area: it edits a humanoid, so ask the user or treat it as Phase 4 | medium to large; hair is the biggest part |
| Farnia proportions (~2.5–3) | lengthen KayKit's legs and torso, re-check every clip for foot sliding and clipping | Phase 4+ | large |
| Blue Archive look in full (~2.4, 15k+ tris, painted face sets) | new head, hair and face textures on the KayKit skeleton, body mostly kept | Phase 4+ | large |
| Stella Sora proportions (~4+) | new bodies; KayKit's limb lengths and animations no longer fit | Phase 4+ | largest; effectively custom modelling and new animation |

**Recommendation (Analysis).** Pick the traits, not a game: **a Blue Archive / Farnia head-to-body ratio of about 2.3–3, painted anime eyes, solid-mesh hair with a colour gradient, soft cel shading, with or without a thin outline after a side-by-side test.** Do not aim for Stella Sora's proportions. They are the furthest from KayKit and would throw away the free skeleton and 76 clips.

- **Now (Phases 1–3):** keep KayKit bodies and animations untouched. Recolour through the atlas. Prototype one anime-eye face on one character with a face quad or Decal on the head bone, and compare it with Farnia's frames at the real game camera. At Greenrune's camera the face is a few dozen pixels, so test before investing. Keep the world flatter and simpler than the characters, as Farnia and Blue Archive both do, and put the detail on the characters. Try the outline shader on and off.
- **Later (Phase 4+):** in Blender, replace the KayKit head and hair on the same 41-joint skeleton, keeping bone names so the clips still work ([Blender pipeline](#editing-a-kaykit-or-quaternius-model)). Aim for about 2.5 heads, a painted face texture with a few swappable expressions, and a budget under Blue Archive's 15k–19k triangles. Lengthen legs toward Farnia's 2.5–3 only if the 2.5 version looks too stubby next to NPCs.

---

<a id="gap-analysis"></a>

## Gap analysis (applied 2026-10-20)

These gaps were found against the phase files before they were restructured on 2026-10-20. Each now links to the section that answers it and says "applied" or "still open". Line numbers are gone because the files changed.

### Project status files

- SCOPE.md called Phase 0 current and Phase 1 future. **Applied:** [SCOPE.md › Phase 1](../SCOPE.md#phase-1--farm-loop-current) is current.
- SCOPE.md listed "Single shop NPC with sell economy" and Mixamo. **Applied:** both are gone from the current scope; the Phase 0 record keeps Mixamo with a note that the KayKit clips replaced it.
- NOT_IN_SCOPE.md defers "Town scene" to Phase 2+ while a placeholder town with a seed shop is committed (commit 125c5e7). **Applied** (both items, see [roadmap.md](roadmap.md)); was still open in [NOT_IN_SCOPE.md](../NOT_IN_SCOPE.md#deferred-to-phase-2-after-farm-prototype-is-solid); [Phase 2.1](phases/phase-02-town-npcs.md#phase-21--home-farm-and-town-as-one-place) records the placeholder's status. Its asset section also still says "Custom rigging (use Mixamo)" ([NOT_IN_SCOPE.md › Asset-related deferrals](../NOT_IN_SCOPE.md#asset-related-deferrals)). Applied.
- plan.md ruled out Blender before Phase 4. **Applied:** [plan.md › Ground rules](plan.md#ground-rules-read-these-first) now allows Blender for crops, terrain, soil, debris and small props from Phase 1, and keeps humanoids and buildings for Phase 4+. Humanoids: superseded by [roadmap.md](roadmap.md); the character base is Phase 2.0.
- plan.md said the crops pack meant "no Blender time". **Applied:** [plan.md › Hybrid 2D/3D — Sprite3D for props and effects](plan.md#hybrid-2d3d--sprite3d-for-props-and-effects) now has crop stages adjusted in Blender in Phase 1.4.

### Phase 1 ([phase-01-farm-loop.md](phases/phase-01-farm-loop.md))

| Gap | Status | Source |
|---|---|---|
| ~12×12 field (144 plots). RF4's first field is 72 plots in 3x6 sections of 2x2, with section outlines. | Applied in [Phase 1.1](phases/phase-01-farm-loop.md#phase-11--the-field) | [Fandom: Farming Mechanics][w-farm], [GameFAQs: Mina][gf-mina] |
| The field starts clean. RF4's starts covered in hand-cleared debris that regrows on untended ground. | Applied in [Phase 1.1](phases/phase-01-farm-loop.md#phase-11--the-field) and [Phase 1.3](phases/phase-01-farm-loop.md#phase-13--hands-and-carrying) | same |
| `FarmGrid` had no 2x2 sections. | Applied in [Phase 1.1](phases/phase-01-farm-loop.md#phase-11--the-field) | [Fandom: Farming Mechanics][w-farm] |
| Can capacity 15 against RF4's 80; no "water as you walk". | Applied in [Phase 1.2](phases/phase-01-farm-loop.md#phase-12--tool-feel) (capacity is a recorded decision) | [Fandom: Cheap Waterpot][w-cheap-pot], [Fandom: Equipment][w-equip] |
| Charge areas attributed to RF4 didn't match RF4. | Applied in [Phase 1.2](phases/phase-01-farm-loop.md#phase-12--tool-feel). Superseded by [roadmap.md](roadmap.md): the ladder is now 3x3, 3x6, 3x9 in blocks; formerly its Gold row defaulted to 4x4, while the only sourced RF4 data are platinum 3x3 at charge 3 and 4x4 only on the upgraded 4th charge | [koryaku-memo: hoe][km-hoe], [Fandom: Forging (RF4)][w-forging] |
| No target marker spec and no charge-level feedback. | Applied in [Phase 1.2](phases/phase-01-farm-loop.md#phase-12--tool-feel) | [GameFAQs: Mina][gf-mina] |
| Sowing and picking up give no XP; RF4 trains Love and Light. | Applied as a decision step in [Phase 1.3](phases/phase-01-farm-loop.md#phase-13--hands-and-carrying) | [wikiwiki: スキル][jp-skills] |
| The RP budget assumed max RP 300; the game starts at 100. | Applied in [Phase 1.5](phases/phase-01-farm-loop.md#phase-15--the-days-frame) | internal |
| Charged sow covered the 2x2 around the player; no "4 little seeds" visual. | Applied in [Phase 1.2](phases/phase-01-farm-loop.md#phase-12--tool-feel) and [Phase 1.4](phases/phase-01-farm-loop.md#phase-14--crops) | [Fandom: Farming Mechanics][w-farm], [GameFAQs: Mina][gf-mina] |
| No carry state. | Applied in [Phase 1.3](phases/phase-01-farm-loop.md#phase-13--hands-and-carrying) | [GameFAQs: Mina][gf-mina] |
| Withering left out; no Withered Grass. | Applied in [Phase 1.4](phases/phase-01-farm-loop.md#phase-14--crops) | [Fandom: Farming Mechanics][w-farm] |
| Turnip treated as the spring starter; RF4 has it neutral in spring. | Applied in [Phase 3.1](phases/phase-03-seasons-cooking-orders.md#phase-31--calendar-and-seasonal-growth) | [Fandom: Crops][w-crops] |
| No rune orbs on harvest. | Applied in [Phase 1.4](phases/phase-01-farm-loop.md#phase-14--crops) | [Fandom: Farming Mechanics][w-farm] |
| HUD had no date line and no water gauge. | Applied in [Phase 1.5](phases/phase-01-farm-loop.md#phase-15--the-days-frame) and [Phase 1.2](phases/phase-01-farm-loop.md#phase-12--tool-feel) | [GameFAQs: Mina][gf-mina] |
| Starting items undecided. | Applied in [Phase 1.5](phases/phase-01-farm-loop.md#phase-15--the-days-frame) | [GameFAQs: Mina][gf-mina], [Fandom: Requests][w-req] |
| Night readability: watered and dry soil look alike. | Applied in [Phase 1.1](phases/phase-01-farm-loop.md#phase-11--the-field); reassessed in [Phase 3.2](phases/phase-03-seasons-cooking-orders.md#phase-32--weather-season-looks-and-new-crops) | — |

### Phase 2 ([phase-02-town-npcs.md](phases/phase-02-town-npcs.md))

| Gap | Status | Source |
|---|---|---|
| Town brief had no anchor building; RF4 puts home in the centre with the farm behind it. | Applied in [Phase 2.1](phases/phase-02-town-npcs.md#phase-21--home-farm-and-town-as-one-place) | [Fandom: Selphia Castle][w-castle] |
| Clerk rule matched RF4; RF4's hours and holiday hours were missing. | Applied in [Phase 2.3](phases/phase-02-town-npcs.md#phase-23--the-shop) | [wikiwiki: 町の施設][jp-town] |
| Seed stock had no unlock path. | Applied in [Phase 2.3](phases/phase-02-town-npcs.md#phase-23--the-shop) (stocked level) and [Phase 2.4](phases/phase-02-town-npcs.md#phase-24--request-box) (request unlocks potato) | [Fandom: Requests][w-req], [Fandom: Crops][w-crops] |
| Requests were Phase 8; RF4 uses a request box from day 2. | Applied in [Phase 2.4](phases/phase-02-town-npcs.md#phase-24--request-box) | [GameFAQs: Mina][gf-mina], [gameranbu: requests][gr-req] |
| No gift-by-holding interaction. | Applied in [Phase 2.2](phases/phase-02-town-npcs.md#phase-22--one-person-end-to-end) | [GameFAQs: Mina][gf-mina] |

### Phase 3 ([phase-03-seasons-cooking-orders.md](phases/phase-03-seasons-cooking-orders.md))

| Gap | Status | Source |
|---|---|---|
| Out-of-season factor 0.75x is one of three values (0.75, 2/3, 0.5) and the least supported. | Applied in [Phase 3.1](phases/phase-03-seasons-cooking-orders.md#phase-31--calendar-and-seasonal-growth): 0.5x *(default)*, 2/3 the alternative | see section 4 |
| "Wither after N days unwatered" was not RF4's rule. | Applied: withering moved to [Phase 1.4](phases/phase-01-farm-loop.md#phase-14--crops) | [Fandom: Farming Mechanics][w-farm] |
| "2 per season" without RF4's per-crop seasons. | Applied in [Phase 3.1](phases/phase-03-seasons-cooking-orders.md#phase-31--calendar-and-seasonal-growth) and [Phase 3.2](phases/phase-03-seasons-cooking-orders.md#phase-32--weather-season-looks-and-new-crops) | [Fandom: Crops][w-crops] |
| Seed stock changing per season is not what RF4 does. | Applied in [Phase 3.2](phases/phase-03-seasons-cooking-orders.md#phase-32--weather-season-looks-and-new-crops): kept as a labelled default with no RF4 source | [wikiwiki: 町の施設][jp-town], [wikiwiki: 農作業][jp-farm] |
| Daily weather roll; RF4 rolls hourly. | Applied in [Phase 3.2](phases/phase-03-seasons-cooking-orders.md#phase-32--weather-season-looks-and-new-crops) (Runey, typhoon and snowstorm days stay out of scope) | [Fandom: Farming Mechanics][w-farm] |
| Rain watered every tile at the DayTick; RF4 waters during the rain. | Applied in [Phase 3.2](phases/phase-03-seasons-cooking-orders.md#phase-32--weather-season-looks-and-new-crops) | [Fandom: Farming Mechanics][w-farm] |
| Points from shipping and festivals; RF4 also pays for requests and daily first chats. | Applied for requests ([Phase 3.3](phases/phase-03-seasons-cooking-orders.md#phase-33--points-and-orders)) and festivals ([Phase 3.5](phases/phase-03-seasons-cooking-orders.md#phase-35--harvest-festival)). Applied: daily first-chat points in [Phase 3.3](phases/phase-03-seasons-cooking-orders.md#phase-33--points-and-orders) | [Fandom: Prince Points][w-pp] |
| Field expansion costs lumber and stone in RF4. | Applied in [Phase 3.3](phases/phase-03-seasons-cooking-orders.md#phase-33--points-and-orders): priced in gold and points | [Fandom: Prince Points][w-pp] |
| Kitchen licence exam. | Applied: [Phase 3.4](phases/phase-03-seasons-cooking-orders.md#phase-34--cooking) unlocks the kitchen by Order; exams are out of scope in [Phase 3.3](phases/phase-03-seasons-cooking-orders.md#phase-33--points-and-orders) | [Fandom: Prince Points][w-pp] |

### Milestones

- M1's intro and first-time hints fit RF4's shape; the time-frozen first farm lesson should be the model. **Applied:** [M1](phases/m1-cozy-slice.md#milestone-m1--cozy-slice) step 2 builds on [Phase 1.5](phases/phase-01-farm-loop.md#phase-15--the-days-frame)'s lesson.
- M2 covers Spring and Summer, while RF4 opens its first dungeon on day 2. **Still open:** [M2](phases/m2-rf-like-demo.md#milestone-m2--rf-like-demo) mentions it only under Reference, not as a requirement. **Analysis.**

---

## Polish-first phase restructure proposal

Superseded by docs/phases/ and docs/roadmap.md; kept as the original proposal.

**The rule.** Work on one area until it is polished, then move on. No week estimates; each sub-phase ends when its "complete when" outcomes are seen in the running game. Every checklist item must meet the [definition of done](endgame.md#definition-of-done): it works from F5 in the main scene, the output has no errors or warnings, its state survives save → quit → load, its numbers live in `data/`, you can explain every line, and it is committed.

**Where numbers come from.** Numbers marked *(default)* are design defaults for the user to tune, not RF4 facts. Numbers with a citation are RF4's.

**Order and why.** Phase 1's Steps 1–6 built every system. The sub-phases below polish them in the order a player meets them on a first morning: the field, then the tools, then the hands, then crops, then the day's end. Phase 2 then follows RF4's day 2: home → town → one person → shop → request box. Scope stays inside [NOT_IN_SCOPE.md](../NOT_IN_SCOPE.md): no combat, monsters, dungeons, fishing, mining, forging or taming before Phase 4; cooking in Phase 3.

### Phase 1.1 — The field

**Goal:** the farm field looks and reads like an RF4 field before any tool touches it.

**Phase 1.1 is complete when:**
- The field is 6x12 plots in 3x6 sections, and each 2x2 section shows a faint outline.
- A new game shows weeds, stones and branches scattered on the field.
- Untilled, tilled, wet and withered soil are told apart in a day screenshot and a 22:00 screenshot.
- The whole field fits on screen from its centre without moving the camera.

**Steps:**
1. Decide the field size: 6x12 (RF4) or keep 12x12 and add sections. Record the choice in the phase file.
2. Add a section concept to `FarmGrid` (cell → section index) and draw a faint outline per section.
3. Add a `DebrisDef` (id, model, how it is cleared, drop) and place a starting set on the field in a new game.
4. Make the soil states read: tilled = darker and furrowed, wet = darker still with a sheen, withered = brown. Adjust the tilled-soil model in Blender if the Quaternius mesh reads poorly from the camera.
5. Tune the outdoor camera (`data/camera.tres`) with side-by-side screenshots against the field; commit the chosen pitch, arm and FOV.
6. Re-check props around the field: well or pond in a corner like RF4's north-east well, bin at the edge, nothing blocking the camera.

**Checklist:**
- [ ] Field size and section size live in data, not in `farm_grid.gd`
- [ ] Section outlines are visible at the gameplay camera distance and invisible under a planted crop's leaves
- [ ] A new game places the starting debris; a save and load keeps cleared debris cleared
- [ ] Wet and dry tilled soil differ by at least 25% in brightness at 12:00 and 22:00 *(default)*, measured from screenshots
- [ ] From the field centre the whole field is on screen with no camera move
- [ ] 60 fps on the farm with every plot tilled and planted (Godot's FPS monitor)

**Out of scope for this phase:** tool feel, crops, debris regrowth, axe/hammer debris (stumps, rocks), soil stats.

**Reference:** RF4's home field is 18 sections of 2x2 laid out 3x6 with faint section outlines ([Fandom: Farming Mechanics][w-farm], [GameFAQs: Mina][gf-mina]); the field starts "covered in weeds" ([GameFAQs: Mina][gf-mina]); Farnia shows a visible tile grid (Observation, [Steam][fv-steam]); 60 fps is Hashimoto's farming-feel target ([rf4-research.md](rf4-research.md#engine-and-tech)).

### Phase 1.2 — Tool feel

**Goal:** the hoe, can and sickle each give clear, timed feedback for every tap and charge level.

**Phase 1.2 is complete when:**
- Tilling a 2x2 section with a charged hoe shows the target area before release, then the soil change, a sound, dust and the RP drop on the same hit.
- Each charge level has its own visible marker and sound cue while held.
- The can's water gauge shows on the HUD while the can is selected, and refilling at the water source fills it with a sound.
- Tapping the can while walking waters each plot passed over.

**Steps:**
1. Decide the charge rule: RF4 tier-gated (starter = no charge) or Greenrune's starter charge. Record it; fix the "like Rune Factory 4" wording in phase-01.
2. Snap charged areas to sections: charge 1 = one 2x2 section, charge 2 = 2x4 (two sections), per RF4's bronze and silver hoes. Which section (the one in front, or the one under the player) is not in any source; pick the one in front *(default)*.
3. Add a target marker (RF4: red marker plus shadow) for the tap plot and the charge area.
4. Add per-level charge cues: marker size, a glow on the tool, a rising tone at each level.
5. Add the water gauge to the HUD; set can capacity in data after deciding between 15 and RF4's 80.
6. Add "water as you walk": repeated taps while moving water each new plot in front.
7. Add an RP popup or bar flash on spend, and a dull "no effect" sound for swings that change nothing (they cost nothing).
8. Tune animation speed, impact time, hit-stop and shake per tool in each `ToolDef`.

**Checklist:**
- [ ] Every swing that changes a plot plays its sound and particle on the impact frame
- [ ] Hit-stop 50 ms *(default, from the Phase 0 feel test)* on hoe hits; the can has none
- [ ] Each charge level has a distinct marker size and sound; releasing early uses the last level reached
- [ ] Charged areas never straddle a section boundary
- [ ] The target marker is visible on every soil state and over debris
- [ ] The water gauge drops by one step per watered plot and does not change on a swing that waters nothing
- [ ] Charge thresholds, RP costs and can capacity live in `data/`
- [ ] Twenty taps in a row at 60 fps with no dropped sound

**Out of scope for this phase:** tool tiers and upgrades (Phase 6), axe and hammer, new tools, combat use of tools.

**Reference:** tap hits the plot "in front of you", with a red marker ([GameFAQs: Mina][gf-mina]); bronze 2x2, silver hoe 2x4, starter tools uncharged ([koryaku-memo: hoe][km-hoe], [gameranbu: tools][gr-tools]); "Press the B Button repeatedly to water as you walk" and a water meter on screen ([Fandom: Equipment][w-equip], [GameFAQs: Mina][gf-mina]); charging spends RP per stage ([wikiwiki: 小ネタ][jp-tips]).

### Phase 1.3 — Hands and carrying

**Goal:** the player can lift, carry, throw and put away anything small, and clears the field's starting debris by hand.

**Phase 1.3 is complete when:**
- Pressing interact on a weed, stone or branch lifts it over the head; pressing again throws it a short distance.
- A carried item can be put into the bag with one button.
- A carried crop thrown at the shipping bin goes into the bin.
- Untended, untilled ground grows new weeds over several days.

**Steps:**
1. Add a carry state to the player: lift animation, held-item anchor above the head, walk with the item, throw arc.
2. Add the world item: a billboard `Sprite3D` using the item's icon, per the hybrid 2D/3D convention.
3. Route hand-harvest through the carry state: harvest → crop over the head → throw or store.
4. Make the shipping bin accept thrown items.
5. Add debris regrowth on untilled, empty plots in the `DayTick` (rate in data).
6. Decide whether sowing and picking up earn XP (RF4: Love and Light); add it to an existing skill or note the decision.

**Checklist:**
- [ ] Lift, throw and store each play a sound and a short animation
- [ ] A thrown item lands on the ground as a billboard and can be picked up again
- [ ] Carrying blocks tool use until the item is thrown or stored
- [ ] A crop thrown into the bin appears in the bin's grid and sells at 08:00
- [ ] Items on the ground, carried items and regrown debris survive save → load
- [ ] Debris regrowth rate lives in data; tilled or planted plots never grow debris

**Out of scope for this phase:** gifting (Phase 2), stumps and rocks (axe and hammer are a separate decision), stacking many crops in the hands (Farnia's feature), auto-collect of same-type items.

**Reference:** A lifts and throws, X/Y stores ([GameFAQs: Mina][gf-mina]); "Toss your turnip into the Shipping Box" ([guidestrats][gs-walk]); weeds, stones and branches cleared by hand, and debris regrows on an untended field ([Fandom: Farming Mechanics][w-farm]); Farnia lets you stack harvests in your hands ([Automaton JP news][fv-automaton-jp]).

### Phase 1.4 — Crops

**Goal:** every crop stage reads at a glance, and the moments of sowing, ripening, withering and harvest each have their own feedback.

**Phase 1.4 is complete when:**
- A sown plot shows seeds on the soil; each later stage is a different silhouette from the gameplay camera.
- A ripe crop is recognisable as ripe without the debug view.
- A crop that changed colour at 06:00 and goes unwatered that day becomes Withered Grass at the next 06:00.
- Some harvests release a rune orb that refills RP and gives skill XP when touched.

**Steps:**
1. Review the Quaternius turnip and potato stages from the camera; in Blender, adjust silhouettes, set the origin to the base centre, and re-export (see [Blender pipeline](#blender-pipeline)).
2. Add a seeded-soil model (RF4 shows "4 little seeds").
3. Add a ripe cue: a small idle bob or sparkle *(default)*.
4. Add withering: a colour-change roll at 06:00, death if unwatered that day, and a Withered Grass item that can be carried, and later tilled in.
5. Add rune orbs: a spawn chance per harvest, pickup on touch, RP refill and skill XP; values in data.
6. Add the harvest pop: sound, a few particles, the crop leaping into the hands.

**Checklist:**
- [ ] Each stage has its own model in `CropDef.stage_models`; no two stages share a silhouette
- [ ] Each crop stage model is under 500 triangles *(default)*; a fully planted field holds 60 fps
- [ ] The colour-change chance, the HP-style rules and rune orb odds live in data
- [ ] A withered crop and a pending colour change both survive save → load
- [ ] Touching a rune orb restores RP and shows the skill XP popup
- [ ] Sickle-reaping still returns seeds with the level-up chance

**Out of scope for this phase:** new crop types (Phase 3), regrowing crops, giant crops, soil stats, fertilizer, seasons.

**Reference:** sown plots show "4 little seeds" ([GameFAQs: Mina][gf-mina]); colour change then death into Withered Grass, crop HP 0–255 ([Fandom: Farming Mechanics][w-farm], [wikiwiki: 作物数値データ詳細][jp-cropdata]); Rune Orbs (50% RP, +1 skill) and Runeys (80% RP, +1 stat) ([Fandom: Farming Mechanics][w-farm]); Farnia uses one low-poly model per crop per stage (Observation, [Steam][fv-steam]).

### Phase 1.5 — The day's frame

**Goal:** a new game's first morning, the HUD and the day's end feel finished.

**Phase 1.5 is complete when:**
- A new game starts on the field with the hoe, can and 10 turnip seeds, after a short lesson that pauses the clock until one plot is tilled, sown and watered.
- The HUD shows season, day, weekday, time, gold, HP and RP at all times.
- At 08:00 the gold from the bin arrives with a visible and audible cue.
- Sleeping fades to a new day with the date.

**Steps:**
1. Build the first-morning lesson: frozen clock, three prompts (till, sow, water), released when all three are done. Text in data.
2. Add the starting kit (RF4: hoe, can, 1 + 9 turnip seeds; sickle later). Until Phase 2's requests, give the sickle on day 2 *(default)*.
3. Add the date line to the HUD; size all HUD text from one theme value.
4. Polish the 08:00 sale cue and the "Day N" fade.
5. Close the RP-budget mismatch (max RP 100 vs. the 300 in Step 4's budget) with a re-measured day.

**Checklist:**
- [ ] The lesson's clock freeze ends after the third action, and skipping it is possible from the options
- [ ] The starting kit and lesson text live in data
- [ ] HUD text size comes from one theme value
- [ ] The 08:00 cue plays once per day even after a load
- [ ] A fresh day-1 player at level 1 runs out of RP before 18:00 doing normal farm work

**Out of scope for this phase:** title screen and options menu (M1), request box (Phase 2.4), calendar UI (Phase 3).

**Reference:** RF4's time-frozen field tutorial and starting kit ([GameFAQs: Mina][gf-mina]); the 3DS HUD always shows date, time, gold, HP and RP ([GameFAQs: Mina][gf-mina], [NWR 3DS review][nwr-3ds]); Special's HUD was faulted as oversized ([GamingTrend][gamingtrend]).

### Phase 1.6 — Five-day gate

**Goal:** the old Step 7 playtest, run against the polished farm.

**Phase 1.6 is complete when:**
- Five in-game days from a new game run with a save, quit and reload in the middle.
- Every line under phase-01's "Phase done when" is checked.

**Steps:**
1. Play five days from a new game, with notes.
2. Tune RP costs, XP curve, reap odds, can capacity and debris regrowth from the notes.
3. Fix every bug; anything new goes to `NOT_IN_SCOPE.md`.

**Checklist:**
- [ ] RP runs out by evening at level 1
- [ ] At least one skill levels up, and one reaped seed comes back a level higher
- [ ] No errors or warnings in the output across the run
- [ ] Every item, crop, skill, debris type and tuning number lives in `data/`

**Out of scope for this phase:** anything new.

**Reference:** [phase-01 "Phase done when"](phases/phase-01-farm-loop.md); [endgame.md › Definition of done](endgame.md#definition-of-done).

### Phase 2.1 — Home, farm and town as one place

**Goal:** the farm, the house and the town feel one door apart, and moving between them is quick.

**Phase 2.1 is complete when:**
- From the bed, the player reaches the field in one door and the town square in one more transition.
- Every transition is a short fade, and the player arrives facing away from the exit.
- No spot in the town or farm traps the player or the camera.

**Steps:**
1. Lay out the town around one anchor (RF4: the castle at the centre). Put the shop on a main street.
2. Keep the farm ↔ town exit a single fade; time the fade.
3. Bake the navmesh and walk every edge.
4. Fade or dither buildings that hide the player (already deferred in phase-02 Step 1).

**Checklist:**
- [ ] Each transition takes under 0.5 s of black *(default)*
- [ ] The navmesh debug view covers every walkable area
- [ ] The current area survives save → load (already in place)

**Out of scope for this phase:** NPC schedules, interiors beyond the existing house and placeholder shop.

**Reference:** the farm sits behind the castle at the centre of town ([Fandom: Selphia Castle][w-castle], [NWR preview][nwr-preview]); RF4 loads areas "after an ultra-quick fade to black" ([NWR 3DS review][nwr-3ds]).

### Phase 2.2 — One person, end to end

**Goal:** a single named NPC has a schedule, a portrait, lines that change with the time of day, a talk interaction and gifts.

**Phase 2.2 is complete when:**
- The NPC walks a full-day schedule and is where the schedule says after any sleep or load.
- Talking in the morning and in the evening gives different lines.
- Handing them a carried crop gives a reaction that depends on their taste.

**Steps:**
1. `NPCDef`, `ScheduleDef` and `LineDef` for one NPC.
2. Dialogue box with portrait, name, typewriter text.
3. Talk and gift interactions; the gift uses Phase 1.3's carry state.
4. A yellow "not yet talked today" bubble over the NPC.

**Checklist:**
- [ ] Schedule, tastes and lines live in `data/`
- [ ] Friendship and today's talk and gift flags survive save → load
- [ ] The talk bubble disappears after the first talk of the day and returns at 06:00

**Out of scope for this phase:** more NPCs, birthdays, seasonal lines.

**Reference:** gifts are given by holding the item and talking ([GameFAQs: Mina][gf-mina]); the yellow talk bubble ([GameFAQs: Mina][gf-mina]); routines and reactive lines are Farnia's and RF4's core ([Automaton interview][automaton]).

### Phase 2.3 — The shop

**Goal:** the seed shop opens and closes on a schedule, and its stock grows with the player's shipping.

**Phase 2.3 is complete when:**
- The shop sells only while its clerk is at the counter, within data-set hours, with shorter holiday hours.
- Shipping a higher-level seed or crop raises the level the shop stocks.

**Steps:**
1. Shop hours as data (RF4 General Store: 9:00–18:00, holidays 9:00–13:30).
2. Clerk-present rule (already planned).
3. Stocked level = highest level shipped of that seed, as RF4 does after its "Ship a level 2 Turnip" request.

**Checklist:**
- [ ] Hours and stock live in data
- [ ] The highest shipped level per item survives save → load

**Out of scope for this phase:** selling to shops (RF4 shops buy nothing), your own store.

**Reference:** shop hours and the clerk rule ([Fandom: Crops][w-crops], [wikiwiki: 町の施設][jp-town]); stocked level follows shipped level ([Fandom: Crops][w-crops], [wikiwiki: Q&A][jp-qa]).

### Phase 2.4 — Request box (pulled forward from Phase 8)

**Goal:** a request box by the house door hands out one small request per day and uses rewards to unlock tools and seed stock.

**Phase 2.4 is complete when:**
- On day 2 the box offers one request; finishing it unlocks the next on the following day.
- "Ship a turnip" adds potato seeds to the shop.
- At least one request rewards a tool (the sickle).

**Steps:**
1. `RequestDef` data: id, condition (ship X, give Y to Z, till N plots), reward, next request.
2. A request box object and a notebook page listing the active request.
3. Four to six requests modelled on RF4's chain, minus fishing, mining and combat.

**Checklist:**
- [ ] Requests, conditions and rewards live in data
- [ ] A ship request counts only if the item is in the bin at 08:00
- [ ] Active and finished requests survive save → load

**Out of scope for this phase:** daily repeatable requests, villager personal requests, points.

**Reference:** Eliza's request box on day 2; 1 request per day at first; tutorial rewards include the axe, sickle and hammer and new seed stock ([GameFAQs: Mina][gf-mina], [gameranbu: requests][gr-req], [Fandom: Requests][w-req]); ship requests count at 08:00 ([wikiwiki: 依頼][jp-req]).

### Phase 2.5 — The town fills in

**Goal:** the rest of Phase 2's NPCs and writing, built on the polished Phase 2.2 template.

**Phase 2.5 is complete when:**
- The existing [phase-02 "Phase done when"](phases/phase-02-town-npcs.md) list is fully checked.

**Steps:**
1. Add NPCs 2–5 by copying the 2.2 template.
2. Friendship levels, birthdays and the friendship page.
3. The ~50-lines-per-NPC writing pass.
4. Save v3 and a 14-day playtest.

**Checklist:**
- [ ] Each NPC passes Phase 2.2's checklist
- [ ] A v2 save loads into v3

**Out of scope for this phase:** seasons, weather, festivals, romance.

**Reference:** [phase-02-town-npcs.md](phases/phase-02-town-npcs.md).

### Phase 3.1 — Calendar and seasonal growth

**Goal:** a 4 × 30-day year in which each crop grows faster or slower by season, with no crop death at a season change.

**Phase 3.1 is complete when:**
- Sleeping from Spring 30 lands on Summer 1, and the HUD and calendar show it.
- The same crop planted in its good season and in its bad season ripens on different, predictable days.
- A crop growing across a season change keeps growing.

**Steps:**
1. Calendar data: season, day, weekday, year; season change inside the `DayTick`.
2. `CropDef` gets good and bad seasons, taken from RF4's table above.
3. Pick one out-of-season factor (0.75, 2/3 or 0.5) and record why.
4. Calendar UI page.

**Checklist:**
- [ ] Season factors and each crop's seasons live in data
- [ ] The date survives save → load
- [ ] Growth with season factors matches a hand calculation for one good-season and one bad-season crop

**Out of scope for this phase:** weather, new crops beyond the existing two, festivals.

**Reference:** 4 × 30-day seasons ([rf4-research.md](rf4-research.md#calendar-and-time)); 1.5x in season, three sourced out-of-season values, no death at season change ([Fandom: Farming Mechanics][w-farm], [Fandom: Crops][w-crops], [wikiwiki: 農作業][jp-farm]).

### Phase 3.2 — Weather and season visuals

**Goal:** each season looks different, and rain waters the field while it falls.

**Phase 3.2 is complete when:**
- Four screenshots of the farm at 12:00, one per season, are told apart at a glance.
- During rain, unwatered plots turn wet over the course of the rain, not at 06:00.
- Spring petals, autumn leaves and winter snow particles appear in their season.

**Steps:**
1. Weather roll per hour from per-season odds in data.
2. Rain particles and a wet-plot pass that waters a share of dry plots each game hour of rain.
3. Per-season ground tint, tree variants, sky tint and particles.
4. New crops for the other seasons, each with Blender-checked stage models (Phase 1.4's checklist).

**Checklist:**
- [ ] Weather odds and rain watering rate live in data
- [ ] Today's weather survives save → load
- [ ] Heavy rain waters every plot within 2 game hours *(RF4's figure)*
- [ ] 60 fps on the farm during rain

**Out of scope for this phase:** typhoons, Runey weather, NPC rain routines (add after the visuals are done).

**Reference:** hourly weather and rain watering over about 2 hours ([Fandom: Farming Mechanics][w-farm]); Farnia's seasonal particles and palette swaps (Observation, [Steam][fv-steam]).

### Phase 3.3 — Points and Orders

**Goal:** town points from shipping and requests buy a small set of Orders that change the game.

**Phase 3.3 is complete when:**
- A day's shipment pays points the next morning, scaled by value.
- Buying the field-expansion Order adds tillable land that survives save → load.

**Steps:**
1. Points from shipping (RF4: 50–125 a day by value) and from requests.
2. `OrderDef` data and an Orders menu at an order board or symbol.
3. Effects: kitchen, a shop line, a festival, the field expansion. Price the expansion in gold and points, since Greenrune has no lumber or stone.

**Checklist:**
- [ ] Point rates and Order costs live in data
- [ ] Bought Orders survive save → load

**Out of scope for this phase:** licences with exams, Prince rank and tourists.

**Reference:** shipping 50–125 points a day, requests 100/200; field expansion costs ([Fandom: Prince Points][w-pp], [wikiwiki: オーダーとイベント][jp-orders]).

### Phase 3.4 — Cooking

**Goal:** crops become dishes whose level follows their ingredients.

**Phase 3.4 is complete when:**
- Cooking with level-5 crops makes a higher-level dish than level-1 crops, and eating it restores more RP.

**Steps:**
1. Kitchen in the house, unlocked by an Order.
2. `RecipeDef` data, a cooking skill, 6–10 recipes.
3. Dishes restore RP and HP and appear in gift tastes.

**Checklist:**
- [ ] Recipes and their values live in data
- [ ] Known recipes survive save → load

**Out of scope for this phase:** chemistry, forging, recipe bread.

**Reference:** [phase-03 Step 5](phases/phase-03-seasons-cooking-orders.md); cooking as the first crop sink ([rf4-research.md](rf4-research.md#implications-for-greenrunes-plan)).

### Phase 3.5 — Harvest festival

**Goal:** one exhibition festival where crop level wins.

**Phase 3.5 is complete when:**
- On festival day the NPCs gather in the square, a high-level crop wins, and the rewards appear.

**Steps:**
1. Festival-day schedule override.
2. Contest: submit one crop, score by type and level.
3. Rewards: points and friendship with every villager (RF4: +5 / +4 / +3).

**Checklist:**
- [ ] Festival date, scoring and rewards live in data
- [ ] The festival recurs each year once ordered
- [ ] Festival day is always sunny

**Out of scope for this phase:** minigame festivals, more festivals.

**Reference:** festivals are always sunny ([Fandom: Farming Mechanics][w-farm]); +5 / +4 / +3 friendship for 1st / 2nd / 3rd ([rf4-research.md](rf4-research.md#festivals)).

---

## Blender pipeline

The user has Blender. The [CLAUDE.md](../CLAUDE.md) rule against custom humanoid and building models before Phase 4 still applies; editing crops, soil, debris and small props is outside it. Claude does not generate models (CLAUDE.md); this is the user's workflow.

### Versions

- The "latest" Blender manual is Blender 5.2 LTS. The glTF add-on page is now at `/manual/en/latest/addons/scene_gltf2.html` ([Blender: glTF 2.0][bl-gltf] [docs]).
- Godot "stable" docs are 4.7, matching `project.godot`.

### Units, axes and origin

- **Units:** Godot uses 1 unit = 1 metre ([Godot: Introduction to 3D][gd-intro3d]); glTF distances are metres ([glTF 2.0 spec][gltf-spec]). Blender's Unit Scale only changes what the UI displays ([Blender: Scene properties][bl-scene]). Keep the default and model a 1 m tile as 1 m.
- **Apply transforms** (Ctrl+A → All Transforms) before export. Godot recommends it to avoid selection problems ([Godot: Model export considerations][gd-export-consid], [Blender: Apply][bl-apply]).
- **Axes:** leave the exporter's **+Y Up** on; it converts Blender's Z-up ([Blender: glTF 2.0][bl-gltf]). A glTF model's front faces +Z ([glTF 2.0 spec][gltf-spec]), which in Godot is the model front (`Vector3.MODEL_FRONT`); in Blender that is −Y ([Godot: Model export considerations][gd-export-consid]).
- **Origin for tile grids:** put the origin at the base centre so a crop sits on its plot. Blender has no "bottom centre" button: snap the 3D cursor to the base and use Set Origin → Origin to 3D Cursor, or model the base at the world origin ([Blender: Origin][bl-origin], [Blender: Snapping][bl-snap]). The method is my inference from the documented tools.
- **If using a GridMap** later: `cell_size` defaults to 2x2x2 and does not scale meshes; set it to the tile size and turn off Center Y for base-origin models ([Godot: GridMap class][gd-gridmap], [Godot: Using GridMaps][gd-gridmap-tut]). Greenrune's `FarmGrid` places models itself, so this matters only if props move to a GridMap.

### Export settings

- **Format:** glTF Binary (.glb) for one file with textures inside; glTF Separate (.gltf + .bin + textures) for text diffs and loose textures ([Blender: glTF 2.0][bl-gltf], [Godot: Available 3D formats][gd-formats]). The repo's `.gitattributes` puts `*.gltf` in LFS, which stops text diffs; prefer .glb.
- **Mesh:** tick Apply Modifiers. Godot suggests a Triangulate modifier for predictable triangulation ([Godot: Model export considerations][gd-export-consid]).
- **Include:** Selected Objects (or Active Collection), no cameras or lights; build lighting in Godot ([Blender: glTF 2.0][bl-gltf], [Godot: Model export considerations][gd-export-consid]).
- **Materials:** "Placeholder" keeps material slots without textures or shader, which suits replacing them with the cel shader in Godot ([Blender: glTF 2.0][bl-gltf]).
- **Vertex colour (Blender 4.2+):** Data → Mesh → Vertex Color → Use Vertex Color. The default "Material" exports colour only if the material uses it; choose **Active** if the toon shader reads `COLOR` but the Blender material doesn't ([Blender: glTF 2.0][bl-gltf], [Blender 4.2: glTF 2.0][bl-gltf-42]).
- **Compression:** leave Draco and Meshopt off. Godot's glTF importer supports neither, and a file that requires them fails to import ([Godot source: gltf_document.cpp][gd-gltf-src]).
- **Material backface culling:** turn it on in Blender, or the imported material gets culling disabled ([Godot: Available 3D formats][gd-formats]).
- **Remember Export Settings** stores these in the .blend ([Blender: glTF 2.0][bl-gltf]).

### Materials and the cel shader

- Godot imports glTF materials as `StandardMaterial3D` ([Godot source: gltf_document.cpp][gd-gltf-src]).
- To swap in the cel shader: **Advanced Import Settings → Materials → Use External** with a path to a `ShaderMaterial` .tres. Godot keeps the mapping on reimport, but renaming the material in Blender breaks it ([Godot: Advanced import settings][gd-adv-import]). This is what the repo already does for the Quaternius FBX files (`*_cel.tres` mapped in each `.import`).
- Alternatives: `material_override` or `set_surface_override_material()` on the node ([Godot: GeometryInstance3D][gd-geom], [Godot: MeshInstance3D][gd-meshinst]); or an `EditorScenePostImport` script that swaps materials on import ([Godot: Import configuration][gd-import-config], [Godot: EditorScenePostImport][gd-postimport]). A MeshLibrary ignores node materials, so GridMap items need "Use External" or an import script ([Godot: Using GridMaps][gd-gridmap-tut]).

### Vertex colour or palette texture

- **KayKit Adventurers** use one 1024x1024 gradient atlas that can be downsampled to 128x128 ([KayKit Adventurers][kaykit]).
- **Quaternius** packs mostly use an atlas of coloured squares; some use separate materials ([Quaternius FAQ][quat-faq]). The repo's Quaternius FBX models map named materials (Wood, Green, DarkGreen) to cel materials.
- **For new crops and props,** either works:
  - *Palette atlas:* UV each face onto a colour square of a shared small texture. Matches KayKit, one material for many models.
  - *Vertex colour:* paint faces, export with Use Vertex Color = Active, and read `COLOR` in the cel shader's `fragment()` ([Godot: Spatial shader][gd-spatial]). `StandardMaterial3D` can also use it via Vertex Color → Use as Albedo, or the `-vcol` name suffix ([Godot: BaseMaterial3D][gd-basemat], [Godot: Name suffixes][gd-suffix]). glTF stores `COLOR_0` as linear ([glTF 2.0 spec][gltf-spec]), so the shader may need to treat it as linear rather than sRGB. Inference; not verified in practice.
- **Analysis:** the palette atlas keeps one cel material for every crop and matches the existing assets; vertex colour needs no UVs and is faster for tiny models. Pick one and stick to it.

### Polycount

- **No official numbers** from KayKit, Quaternius, Farnia or Godot. Godot only notes that skinned meshes may need "considerably" lower counts ([Godot: Optimizing 3D performance][gd-perf]).
- **Measured in this repo** (a script parsing the GLBs, not a published figure): KayKit Adventurer characters 5.7k–7k triangles; hoe 64; sickle 207; watering can 710.
- **Analysis:** a 72-plot field at 500 triangles per crop stage is 36k triangles, under one KayKit character's 6x. That is why Phase 1.4 uses 500 as its *(default)* budget. Check with Godot's FPS and draw-call monitors, not by counting.

### Direct .blend import

- Godot can import `.blend` files directly: it runs Blender's glTF exporter in the background, then its normal glTF import ([Godot: Available 3D formats][gd-formats]).
- **Requirements:** Blender 3.0 or later (3.5+ recommended), the official blender.org build, and the path set in Editor Settings → Filesystem → Import → Blender → Blender Path. Every machine that opens the project needs Blender installed ([Godot: Available 3D formats][gd-formats]).
- **Pros:** save in Blender, switch to Godot, and the change appears; no exported file to commit. **Cons:** ties the project to an installed Blender; Blender-specific import options (modifiers, colours, materials) are set in Godot's import dock ([Godot: Import configuration][gd-import-config]).
- **Analysis:** for a solo project on one Mac, direct `.blend` import is the shortest loop. Export .glb for anything shared or downloaded.

### Editing a KayKit or Quaternius model

- **Rigged KayKit GLBs:** Blender's importer stashes each animation as an NLA track; exporting in Actions mode round-trips them. Keep Bone Direction at its default, reset to rest pose before export, and never rename bones, because Godot's animation tracks address bones by name ([Blender: glTF 2.0][bl-gltf], [Godot: Retargeting 3D skeletons][gd-retarget], [Godot: Model export considerations][gd-export-consid]).
- **Quaternius** ships FBX, OBJ and .blend for many packs, not glTF ([Quaternius: Medieval Village][quat-village]). Open the .blend, edit, export .glb.
- **In Godot:** a "New Inherited Scene" adds nodes on top of an import but can't remove base nodes or edit sub-resources; the docs prefer changing the source ([Godot: Import configuration][gd-import-config]).
- **Name suffixes** for props: `-col` / `-convcol` add static collision, `-colonly` makes collision only, `-noimp` skips a node, and `loop` on an action name loops it ([Godot: Name suffixes][gd-suffix]).
- **Git:** `.gitattributes` already routes `.blend`, `.glb`, `.gltf`, `.fbx` and textures through LFS. `.blend1` files are Blender's save-version backups ([Blender: Save & Load preferences][bl-saveload]); ignoring them is better than storing them. Commit each asset's `.import` file ([Godot: Import process][gd-import-process]).

### Workflow for one crop stage (summary)

1. Open the Quaternius crop .blend (or import the FBX).
2. Edit the silhouette for the gameplay camera; keep the budget.
3. Set the origin to the base centre; apply all transforms.
4. Assign the shared palette material (or paint vertex colours).
5. Export .glb: +Y Up, Apply Modifiers, Materials = Placeholder, no compression. Or save the .blend into the project for direct import.
6. In Godot, map the material to the cel `ShaderMaterial` with Use External.
7. Point the `CropDef.stage_models` entry at the new file and check it from the gameplay camera.

---

## Unverified or not found

- RF4 camera angle, distance and zoom (only indirect evidence that the field camera is fixed); character head-to-body ratio; scale of player vs. tiles vs. buildings; sound design.
- Base RP cost of any farm tool, per tier and per charge level, and the size of the Farming skill discount. Searched EN, JP and CN wikis, guides and boards; would need an in-game test or a datamine.
- Gold-tier charge areas; silver waterpot and sickle areas; whether RF4's charged areas are centred or in front. The 4th-stage size (4x4 vs 8x8) is disputed.
- Water capacity for tin, lion and joy pots; water used per charge stage; whether refilling costs RP.
- Number of visual crop stages in RF4.
- Debris regrowth rate; rune orb base chance (only a 5–10% guess for Runey days).
- The calendar day a player can first buy a bronze tool (only the conditions are known).
- Farnia Village: engine, polycounts, crop levels beyond item "Lv", soil, skills, season count. Whether its 3x3 charge has intermediate steps or grows with tool tier. ManaGames' X devlogs were not read.
- Blue Archive and Stella Sora: no developer source on their character models; proportions and structure come from community model uploads and video frames. The Models Resource was not reachable (bot check).
- Single-source claims flagged above: water capacities (Fandom item boxes); platinum 3x3 (Fandom Forging); farming XP per charge (one GameFAQs user); weekly bumper/poor crops (wikiwiki); crop stacking in Farnia (Automaton JP news, now also seen in the PV); Farnia's graphics rationale (Automaton interview); the "30 minutes per day" clock (NWR preview).

---

## Sources

**Official / store**
- XSEED RF4 site, The Land of Selphia: https://runefactory.com/rf4/land.html
- Steam store, Farnia Village (app 4128600): https://store.steampowered.com/app/4128600/
- Steam app details API, Farnia Village: https://store.steampowered.com/api/appdetails?appids=4128600
- Steam store "FARMING" clip, Farnia Village (4.6 s loop): https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/4128600/extras/d4a479c0027b1d59e7c9c0bed57843c1.mp4
- Kickstarter, Farnia Village (story, rewards, risks): https://www.kickstarter.com/projects/1005170304/farnia-village/description
- Farnia Village official YouTube, ファーニア村で暮らす PV (7:18, 2025-10-28): https://www.youtube.com/watch?v=VES59jhfk3Y
- Farnia Village official YouTube, Introducing the Protagonist: https://www.youtube.com/watch?v=vUy4jHSYw9A
- Stella Sora official YouTube, Stella Sora Gameplay Trailer (2024-12-17): https://www.youtube.com/watch?v=rs40AGfEv60

**Video mirrors and captures (community)**
- LPE, "Farnia Village - Gameplay Teaser" (re-upload of the PV, same timestamps): https://www.youtube.com/watch?v=Tb7o9uyhfiw
- DBC Replays, Blue Archive combat gameplay: https://www.youtube.com/watch?v=03mBkLB3XHs

**Model listings (community, viewed only)**
- Sketchfab, [Blue Archive] Koharu, CB (Default emotion): https://sketchfab.com/3d-models/none-5d97f1aca1494968b4508bae44f88475
- Sketchfab, [Blue Archive] Azusa, Chibi (Default emotion): https://sketchfab.com/3d-models/none-ff2fc15c35984d3ea69b277e02abc2d2
- Sketchfab, Justice Task Force NPC SD, Blue Archive: https://sketchfab.com/3d-models/none-d46c05e9aaa24b638ab50600e583fdf0
- Sketchfab, Cloth Freesia Xmas (Stella Sora): https://sketchfab.com/3d-models/none-c0b7a04d0376407fb31cf9476a0b1e54
- Sketchfab, Female Tyrant, Stella Sora fan model: https://sketchfab.com/3d-models/none-bd4a9fc4bca54e2686f594c5497515a4
- TapTap, Blue Archive review (memorial lobbies are Live2D): https://www.taptap.io/tw/post/10572322

**Interviews**
- Automaton West (2025), Manabe and Tsuji on Farnia Village: https://automaton-media.com/en/interviews/rune-factory-4s-creators-are-doing-everything-they-left-undone-in-their-new-life-sim-rpg-farnia-village-we-ask-them-what-comes-after-the-massively-successful-kickstarter/
- Automaton (Japanese original of the interview): https://automaton-media.com/articles/interviewsjp/fania-20251122-366808/
- Nintendo Everything, RF4 Special developers: https://nintendoeverything.com/rune-factory-4-special-devs-on-the-decision-to-bring-back-the-game-for-switch-and-more-rune-factory-5-talk/
- Siliconera, Hashimoto on characters: https://www.siliconera.com/rune-factory-producer-yoshifumi-hashimoto-on-how-he-comes-up-with-characters/
- 4Gamer (2025), NDC25 talk on Blue Archive's 3D backgrounds: https://www.4gamer.net/games/519/G051983/20250625011/

**Press**
- Nintendo World Report, RF4 3DS review: https://nintendoworldreport.com/review/35673/rune-factory-4-nintendo-3ds
- Nintendo World Report, RF4 hands-on preview: https://nintendoworldreport.com/hands-on-preview/34627
- GamingTrend, RF4 Special PC review: https://gamingtrend.com/reviews/rune-factory-4-special-review-on-pc-i-can-see-everything
- Nintendo Everything, RF4 Special review: https://nintendoeverything.com/review-rune-factory-4-special/
- GameRevolution, RF4 Special review: https://www.gamerevolution.com/?p=634834
- Automaton, Farnia Kickstarter launch: https://automaton-media.com/en/news/rune-factory-4-director-is-making-a-new-fantasy-farming-sim-rpg-in-which-you-can-keep-living-forever-farnia-village-kickstarter-campaign-live-now/
- Automaton (JP), Farnia announcement: https://automaton-media.com/articles/newsjp/20251028-363979/
- RPG Site, Farnia Village announced: https://www.rpgsite.net/news/18845-former-rune-factory-3-4-staff-memberwork-on-developing-farnia-village-for-pc-via-steam
- RPG Site, Farnia Kickstarter ends: https://www.rpgsite.net/news/19033-farnia-village-kickstarter-campaign-concludes-with-over-y31000000-s200000-amassed
- Famitsu, Farnia Village: https://www.famitsu.com/article/202510/56363
- Game*Spark, 2025-11-23: https://www.gamespark.jp/article/2025/11/23/159790.html
- Game*Spark, 2026-01-12: https://www.gamespark.jp/article/2026/01/12/161479.html
- Kicktraq, Farnia Village: https://www.kicktraq.com/projects/1005170304/farnia-village/
- Wikipedia, Rune Factory 4: https://en.wikipedia.org/wiki/Rune_Factory_4

**Community**
- Fandom, Farming Mechanics (RF4): https://runefactory.fandom.com/wiki/Farming_Mechanics_(RF4)
- Fandom, Crops (RF4): https://runefactory.fandom.com/wiki/Crops_(RF4)
- Fandom, Equipment (RF4): https://runefactory.fandom.com/wiki/Equipment_(RF4)
- Fandom, Cheap Waterpot: https://runefactory.fandom.com/wiki/Cheap_Waterpot
- Fandom, Rainbow Waterpot: https://runefactory.fandom.com/wiki/Rainbow_Waterpot
- Fandom, Prince Points: https://runefactory.fandom.com/wiki/Prince_Points
- Fandom, Requests (RF4): https://runefactory.fandom.com/wiki/Requests_(RF4)
- Fandom, Selphia Castle: https://runefactory.fandom.com/wiki/Selphia_Castle
- Fandom, Selphia: https://runefactory.fandom.com/wiki/Selphia
- Fandom, Rune Factory 4: https://runefactory.fandom.com/wiki/Rune_Factory_4
- Fandom, Rune Factory 4 Special: https://runefactory.fandom.com/wiki/Rune_Factory_4_Special
- Fandom, Forging (RF4): https://runefactory.fandom.com/wiki/Forging_(RF4)
- Fandom, Skills (RF4): https://runefactory.fandom.com/wiki/Skills_(RF4)
- GameFAQs board, 4th/5th charge stage thread (archived): https://web.archive.org/web/20250818103838/https://gamefaqs.gamespot.com/boards/635388-rune-factory-4/75348395
- GameFAQs board, farming XP measurements (archived): https://web.archive.org/web/20240214030041/https://gamefaqs.gamespot.com/boards/635388-rune-factory-4/76520117
- gameranbu, RF4 Special controls: https://gameranbu.jp/runefactory4sp/b1ff1040fae1a2506308
- GameFAQs, walkthrough by minakorocket (archived): https://web.archive.org/web/20240117214229/https://gamefaqs.gamespot.com/3ds/635388-rune-factory-4/faqs/68010
- GameFAQs, walkthrough by Zoel (archived): https://web.archive.org/web/20240112160041/https://gamefaqs.gamespot.com/3ds/635388-rune-factory-4/faqs/64785
- wikiwiki.jp RF4, 農作業 (farming): https://wikiwiki.jp/rf4bu/%E8%BE%B2%E4%BD%9C%E6%A5%AD
- wikiwiki.jp RF4, 作物数値データ詳細 (crop data): https://wikiwiki.jp/rf4bu/%E4%BD%9C%E7%89%A9%E6%95%B0%E5%80%A4%E3%83%87%E3%83%BC%E3%82%BF%E8%A9%B3%E7%B4%B0
- wikiwiki.jp RF4, 小ネタ (tips): https://wikiwiki.jp/rf4bu/%E5%B0%8F%E3%83%8D%E3%82%BF
- wikiwiki.jp RF4, スキル (skills): https://wikiwiki.jp/rf4bu/%E3%82%B9%E3%82%AD%E3%83%AB
- wikiwiki.jp RF4, 武器 (weapons and farm tools): https://wikiwiki.jp/rf4bu/%E6%AD%A6%E5%99%A8
- wikiwiki.jp RF4, 依頼 (requests): https://wikiwiki.jp/rf4bu/%E4%BE%9D%E9%A0%BC
- wikiwiki.jp RF4, 町の施設 (town facilities): https://wikiwiki.jp/rf4bu/%E7%94%BA%E3%81%AE%E6%96%BD%E8%A8%AD
- wikiwiki.jp RF4, Q＆A: https://wikiwiki.jp/rf4bu/Q%EF%BC%86A
- wikiwiki.jp RF4, メインシナリオ (main scenario): https://wikiwiki.jp/rf4bu/%E3%83%A1%E3%82%A4%E3%83%B3%E3%82%B7%E3%83%8A%E3%83%AA%E3%82%AA
- wikiwiki.jp RF4, オーダーとイベント (orders): https://wikiwiki.jp/rf4bu/%E3%82%AA%E3%83%BC%E3%83%80%E3%83%BC%E3%81%A8%E3%82%A4%E3%83%99%E3%83%B3%E3%83%88
- wikiwiki.jp RF4, Switch版の変更点 (Switch changes): https://wikiwiki.jp/rf4bu/Switch%E7%89%88%E3%81%AE%E5%A4%89%E6%9B%B4%E7%82%B9
- koryaku-memo, hoe: http://runefactory4.koryaku-memo.com/data02/2-60.html
- koryaku-memo, waterpot: http://runefactory4.koryaku-memo.com/data02/2-61.html
- koryaku-memo, sickle: http://runefactory4.koryaku-memo.com/data02/2-62.html
- gameranbu, farm tools: https://gameranbu.jp/runefactory4sp/9feb86fad4c4793589a4
- gameranbu, requests: https://gameranbu.jp/runefactory4sp/5b05d432c8f1546050ee
- biligame, RF4S requests: https://wiki.biligame.com/runefactory/RF4Smission
- biligame, RF4S orders: https://wiki.biligame.com/runefactory/RF4Sorder
- guidestrats, walkthrough part 1: https://guidestrats.com/rf4-walkthrough-part-1/
- guidestrats, how to get the axe and hammer: https://guidestrats.com/rf4-how-to-get-axe-hammer/

**Docs: Blender**
- glTF 2.0 add-on (latest): https://docs.blender.org/manual/en/latest/addons/scene_gltf2.html
- glTF 2.0 add-on (4.2): https://docs.blender.org/manual/en/4.2/addons/import_export/scene_gltf2.html
- Apply transforms: https://docs.blender.org/manual/en/latest/scene_layout/object/editing/apply.html
- Origin: https://docs.blender.org/manual/en/latest/scene_layout/object/origin.html
- Snapping: https://docs.blender.org/manual/en/latest/editors/3dview/controls/snapping.html
- Scene properties (units): https://docs.blender.org/manual/en/latest/scene_layout/scene/properties.html
- Save & Load preferences: https://docs.blender.org/manual/en/latest/editors/preferences/save_load.html

**Docs: Godot**
- Available 3D formats (incl. .blend import): https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html
- Model export considerations: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/model_export_considerations.html
- Import configuration: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/import_configuration.html
- Advanced import settings: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/advanced_import_settings.html
- Node type customization (name suffixes): https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/node_type_customization.html
- Retargeting 3D skeletons: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/retargeting_3d_skeletons.html
- Import process: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/import_process.html
- Introduction to 3D: https://docs.godotengine.org/en/stable/tutorials/3d/introduction_to_3d.html
- Using GridMaps: https://docs.godotengine.org/en/stable/tutorials/3d/using_gridmaps.html
- Optimizing 3D performance: https://docs.godotengine.org/en/stable/tutorials/performance/optimizing_3d_performance.html
- Spatial shaders: https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html
- GridMap class: https://docs.godotengine.org/en/stable/classes/class_gridmap.html
- BaseMaterial3D class: https://docs.godotengine.org/en/stable/classes/class_basematerial3d.html
- GeometryInstance3D class: https://docs.godotengine.org/en/stable/classes/class_geometryinstance3d.html
- MeshInstance3D class: https://docs.godotengine.org/en/stable/classes/class_meshinstance3d.html
- EditorScenePostImport class: https://docs.godotengine.org/en/stable/classes/class_editorscenepostimport.html
- Godot source, glTF importer: https://github.com/godotengine/godot/blob/master/modules/gltf/gltf_document.cpp
- glTF 2.0 specification: https://github.com/KhronosGroup/glTF/blob/main/specification/2.0/Specification.adoc

**Asset packs**
- KayKit Adventurers: https://kaylousberg.itch.io/kaykit-adventurers
- Quaternius FAQ: https://quaternius.com/faq.html
- Quaternius Medieval Village: https://quaternius.com/packs/medievalvillage.html

[w-farm]: https://runefactory.fandom.com/wiki/Farming_Mechanics_(RF4)
[w-crops]: https://runefactory.fandom.com/wiki/Crops_(RF4)
[w-equip]: https://runefactory.fandom.com/wiki/Equipment_(RF4)
[w-cheap-pot]: https://runefactory.fandom.com/wiki/Cheap_Waterpot
[w-rainbow-pot]: https://runefactory.fandom.com/wiki/Rainbow_Waterpot
[w-pp]: https://runefactory.fandom.com/wiki/Prince_Points
[w-req]: https://runefactory.fandom.com/wiki/Requests_(RF4)
[w-castle]: https://runefactory.fandom.com/wiki/Selphia_Castle
[w-selphia]: https://runefactory.fandom.com/wiki/Selphia
[w-rf4]: https://runefactory.fandom.com/wiki/Rune_Factory_4
[w-rf4s]: https://runefactory.fandom.com/wiki/Rune_Factory_4_Special
[w-forging]: https://runefactory.fandom.com/wiki/Forging_(RF4)
[w-skills]: https://runefactory.fandom.com/wiki/Skills_(RF4)
[gf-charge]: https://web.archive.org/web/20250818103838/https://gamefaqs.gamespot.com/boards/635388-rune-factory-4/75348395
[gf-xp]: https://web.archive.org/web/20240214030041/https://gamefaqs.gamespot.com/boards/635388-rune-factory-4/76520117
[gr-controls]: https://gameranbu.jp/runefactory4sp/b1ff1040fae1a2506308
[fv-ks]: https://www.kickstarter.com/projects/1005170304/farnia-village/description
[fv-pv]: https://www.youtube.com/watch?v=VES59jhfk3Y
[fv-pv-mirror]: https://www.youtube.com/watch?v=Tb7o9uyhfiw
[fv-protag]: https://www.youtube.com/watch?v=vUy4jHSYw9A
[fv-farmclip]: https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/4128600/extras/d4a479c0027b1d59e7c9c0bed57843c1.mp4
[ss-trailer]: https://www.youtube.com/watch?v=rs40AGfEv60
[ba-combat]: https://www.youtube.com/watch?v=03mBkLB3XHs
[ba-ndc]: https://www.4gamer.net/games/519/G051983/20250625011/
[ba-taptap]: https://www.taptap.io/tw/post/10572322
[sf-ba-koharu]: https://sketchfab.com/3d-models/none-5d97f1aca1494968b4508bae44f88475
[sf-ba-azusa]: https://sketchfab.com/3d-models/none-ff2fc15c35984d3ea69b277e02abc2d2
[sf-ba-npc]: https://sketchfab.com/3d-models/none-d46c05e9aaa24b638ab50600e583fdf0
[sf-ss-freesia]: https://sketchfab.com/3d-models/none-c0b7a04d0376407fb31cf9476a0b1e54
[sf-ss-fan]: https://sketchfab.com/3d-models/none-bd4a9fc4bca54e2686f594c5497515a4
[gf-mina]: https://web.archive.org/web/20240117214229/https://gamefaqs.gamespot.com/3ds/635388-rune-factory-4/faqs/68010
[gf-zoel]: https://web.archive.org/web/20240112160041/https://gamefaqs.gamespot.com/3ds/635388-rune-factory-4/faqs/64785
[jp-farm]: https://wikiwiki.jp/rf4bu/%E8%BE%B2%E4%BD%9C%E6%A5%AD
[jp-cropdata]: https://wikiwiki.jp/rf4bu/%E4%BD%9C%E7%89%A9%E6%95%B0%E5%80%A4%E3%83%87%E3%83%BC%E3%82%BF%E8%A9%B3%E7%B4%B0
[jp-tips]: https://wikiwiki.jp/rf4bu/%E5%B0%8F%E3%83%8D%E3%82%BF
[jp-skills]: https://wikiwiki.jp/rf4bu/%E3%82%B9%E3%82%AD%E3%83%AB
[jp-weapons]: https://wikiwiki.jp/rf4bu/%E6%AD%A6%E5%99%A8
[jp-req]: https://wikiwiki.jp/rf4bu/%E4%BE%9D%E9%A0%BC
[jp-town]: https://wikiwiki.jp/rf4bu/%E7%94%BA%E3%81%AE%E6%96%BD%E8%A8%AD
[jp-qa]: https://wikiwiki.jp/rf4bu/Q%EF%BC%86A
[jp-story]: https://wikiwiki.jp/rf4bu/%E3%83%A1%E3%82%A4%E3%83%B3%E3%82%B7%E3%83%8A%E3%83%AA%E3%82%AA
[jp-orders]: https://wikiwiki.jp/rf4bu/%E3%82%AA%E3%83%BC%E3%83%80%E3%83%BC%E3%81%A8%E3%82%A4%E3%83%99%E3%83%B3%E3%83%88
[jp-switch]: https://wikiwiki.jp/rf4bu/Switch%E7%89%88%E3%81%AE%E5%A4%89%E6%9B%B4%E7%82%B9
[km-hoe]: http://runefactory4.koryaku-memo.com/data02/2-60.html
[km-pot]: http://runefactory4.koryaku-memo.com/data02/2-61.html
[km-sickle]: http://runefactory4.koryaku-memo.com/data02/2-62.html
[gr-tools]: https://gameranbu.jp/runefactory4sp/9feb86fad4c4793589a4
[gr-req]: https://gameranbu.jp/runefactory4sp/5b05d432c8f1546050ee
[bili-req]: https://wiki.biligame.com/runefactory/RF4Smission
[bili-order]: https://wiki.biligame.com/runefactory/RF4Sorder
[gs-walk]: https://guidestrats.com/rf4-walkthrough-part-1/
[gs-axe]: https://guidestrats.com/rf4-how-to-get-axe-hammer/
[xseed-land]: https://runefactory.com/rf4/land.html
[wp-rf4]: https://en.wikipedia.org/wiki/Rune_Factory_4
[sil-chars]: https://www.siliconera.com/rune-factory-producer-yoshifumi-hashimoto-on-how-he-comes-up-with-characters/
[ne-interview]: https://nintendoeverything.com/rune-factory-4-special-devs-on-the-decision-to-bring-back-the-game-for-switch-and-more-rune-factory-5-talk/
[ne-review]: https://nintendoeverything.com/review-rune-factory-4-special/
[nwr-3ds]: https://nintendoworldreport.com/review/35673/rune-factory-4-nintendo-3ds
[nwr-preview]: https://nintendoworldreport.com/hands-on-preview/34627
[gamingtrend]: https://gamingtrend.com/reviews/rune-factory-4-special-review-on-pc-i-can-see-everything
[gamerev-rf4s]: https://www.gamerevolution.com/?p=634834
[automaton]: https://automaton-media.com/en/interviews/rune-factory-4s-creators-are-doing-everything-they-left-undone-in-their-new-life-sim-rpg-farnia-village-we-ask-them-what-comes-after-the-massively-successful-kickstarter/
[fv-automaton-int-jp]: https://automaton-media.com/articles/interviewsjp/fania-20251122-366808/
[fv-automaton-ks]: https://automaton-media.com/en/news/rune-factory-4-director-is-making-a-new-fantasy-farming-sim-rpg-in-which-you-can-keep-living-forever-farnia-village-kickstarter-campaign-live-now/
[fv-automaton-jp]: https://automaton-media.com/articles/newsjp/20251028-363979/
[fv-steam]: https://store.steampowered.com/app/4128600/
[fv-api]: https://store.steampowered.com/api/appdetails?appids=4128600
[fv-rpgsite]: https://www.rpgsite.net/news/18845-former-rune-factory-3-4-staff-memberwork-on-developing-farnia-village-for-pc-via-steam
[fv-rpgsite-ks]: https://www.rpgsite.net/news/19033-farnia-village-kickstarter-campaign-concludes-with-over-y31000000-s200000-amassed
[fv-kicktraq]: https://www.kicktraq.com/projects/1005170304/farnia-village/
[fv-famitsu]: https://www.famitsu.com/article/202510/56363
[gs-1123]: https://www.gamespark.jp/article/2025/11/23/159790.html
[gs-0112]: https://www.gamespark.jp/article/2026/01/12/161479.html
[bl-gltf]: https://docs.blender.org/manual/en/latest/addons/scene_gltf2.html
[bl-gltf-42]: https://docs.blender.org/manual/en/4.2/addons/import_export/scene_gltf2.html
[bl-apply]: https://docs.blender.org/manual/en/latest/scene_layout/object/editing/apply.html
[bl-origin]: https://docs.blender.org/manual/en/latest/scene_layout/object/origin.html
[bl-snap]: https://docs.blender.org/manual/en/latest/editors/3dview/controls/snapping.html
[bl-scene]: https://docs.blender.org/manual/en/latest/scene_layout/scene/properties.html
[bl-saveload]: https://docs.blender.org/manual/en/latest/editors/preferences/save_load.html
[gd-formats]: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html
[gd-export-consid]: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/model_export_considerations.html
[gd-import-config]: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/import_configuration.html
[gd-adv-import]: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/advanced_import_settings.html
[gd-suffix]: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/node_type_customization.html
[gd-retarget]: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/retargeting_3d_skeletons.html
[gd-import-process]: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/import_process.html
[gd-intro3d]: https://docs.godotengine.org/en/stable/tutorials/3d/introduction_to_3d.html
[gd-gridmap-tut]: https://docs.godotengine.org/en/stable/tutorials/3d/using_gridmaps.html
[gd-perf]: https://docs.godotengine.org/en/stable/tutorials/performance/optimizing_3d_performance.html
[gd-spatial]: https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html
[gd-gridmap]: https://docs.godotengine.org/en/stable/classes/class_gridmap.html
[gd-basemat]: https://docs.godotengine.org/en/stable/classes/class_basematerial3d.html
[gd-geom]: https://docs.godotengine.org/en/stable/classes/class_geometryinstance3d.html
[gd-meshinst]: https://docs.godotengine.org/en/stable/classes/class_meshinstance3d.html
[gd-postimport]: https://docs.godotengine.org/en/stable/classes/class_editorscenepostimport.html
[gd-gltf-src]: https://github.com/godotengine/godot/blob/master/modules/gltf/gltf_document.cpp
[gltf-spec]: https://github.com/KhronosGroup/glTF/blob/main/specification/2.0/Specification.adoc
[kaykit]: https://kaylousberg.itch.io/kaykit-adventurers
[quat-faq]: https://quaternius.com/faq.html
[quat-village]: https://quaternius.com/packs/medievalvillage.html
