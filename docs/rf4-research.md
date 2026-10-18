# Rune Factory 4 research for Greenrune

Research date: 2026-10-15. Scope: Rune Factory 4 (3DS, 2012) and Rune Factory 4 Special (Switch 2019/2020, PC/PS4/Xbox 2021).

Source labels used below:
- **[official]**: Marvelous / XSEED / store pages.
- **[interview]**: developer interviews.
- **[press]**: reviews and news.
- **[aggregate]**: Metacritic / OpenCritic / Steam.
- **[community]**: Rune Factory Fandom wiki (`runefactory.fandom.com`). Numbers from it are fan-documented or datamined. Treat them as approximate.
- **Analysis:** my own reasoning, not a sourced claim.

## TL;DR

- **What RF4 is.** RF4 was built by Neverland, a studio with 36 staff when it closed in 2013. Marvelous published it in Japan and XSEED in the West. It is a Harvest Moon spin-off that adds action combat, dungeons and monster taming to a farm-and-town life sim ([ANN][ann-closure], [Wikipedia][wp-rf4]).
- **Why it works.** Critics praise how the systems feed each other: dungeon drops become crafting materials, crafted gear clears dungeons, tamed monsters work the farm, and crops feed cooking and gifts ([Guardian][guardian], [Game Informer][gi]). Wikipedia's summary of the game says crafted gear drives progression more than character levels do ([Wikipedia][wp-rf4]).
- **Reception.** Metacritic 78 on 3DS and 81 on Switch, OpenCritic 82 ([Wikipedia][wp-rf4], [OpenCritic][oc-rf4s]). Critics consistently fault the roughly 10-hour tutorial, repetitive dungeons, long boss fights and thin plot ([GamesRadar][gr], [Game Informer][gi], [IGN][ign]).
- **The plan defers some RF4 glue.** Greenrune's plan pushes back several cheap systems that hold RF4 together:
  - RP is the farming stamina bar, not only a combat resource.
  - Skills level up through use.
  - Crops and items carry an item level.
  - Festivals and shops unlock by spending Prince Points.

  Each is small to build, and each changes how the farming loop feels.
- **Scale.** Stardew Valley took one person 4.5 years, reportedly at 10–12-hour days ([Stardew FAQ][sdv-faq], [Cheatsheet][sdv-schedule]). RF4's own director and writer told Automaton (Nov 2025) that without funding their two-person RF-like could take 10–20 years ([Automaton][automaton]). A full RF4-scale game at 8 hrs/week is not realistic. The plan's vertical-slice framing is correct.
- **Biggest structural advice (analysis).** Build Phase 1 tool use the way a weapon would work: a swing with a hitbox, an RP cost and skill XP. Combat can then reuse that pipeline later instead of being bolted on. The RF4 director describes this approach for his new game ([Automaton][automaton]).

---

## 1. How the game was built

### Companies, platforms, dates

| Item | Fact | Source |
|---|---|---|
| Developer (3DS) | Neverland Co. (founded 1993; 36 staff when it announced closure in Nov 2013) | [Wikipedia][wp-rf4], [ANN][ann-closure] |
| Developer (Special) | Hakama Inc. (a Marvelous studio led by series producer Yoshifumi Hashimoto) | [Wikipedia][wp-rf4], [GoNintendo][gon-rf4s] |
| Publishers | Marvelous AQL (JP), XSEED Games (NA, plus PAL eShop for 3DS), Marvelous Europe (Special in EU) | [Wikipedia][wp-rf4] |
| 3DS release | JP 2012-07-19, NA 2013-10-01, PAL 2014-12-11 (eShop only) | [Wikipedia][wp-rf4] |
| Special release | Switch JP 2019-07-25, NA 2020-02-25, EU 2020-02-28. PC/PS4/Xbox One 2021-12-07 | [Wikipedia][wp-rf4] |
| Key staff | Directors Masahide Miyata and Shinichi Manabe. Producer/writer Yoshifumi Hashimoto. Composer Tomoko Morita. Manabe was main programmer on RF3 and director of RF4. Takanori Tsuji was game designer and scenario writer on RF3/RF4 | [Wikipedia][wp-rf4], [Automaton][automaton] |
| Sales | Over 150,000 in Japan by Sep 2012, the series' best seller at the time. It contributed to a Marvelous AQL profit upgrade. Special passed 100,000 in North America in under five months | [Wikipedia][wp-rf4], [Nintendo Everything][ne-sales] |

### Engine and tech

- **Engine: not publicly documented.** I found no first-party statement about RF4's engine on 3DS, or about the engine of the Special port. RF5, made by Hakama, uses Unity ([Wikipedia: RF5][wp-rf5]). Do not assume RF4 Special does.
- **Constraints the developers named:**
  - The team targeted 60 fps so that every button press produces an immediate, satisfying action. Hashimoto cites Pikmin's "pop" when plucking as the inspiration for making farm actions feel good ([Siliconera 2012][sil-origins] [interview]).
  - Hashimoto decided against leaning on the 3DS's stereoscopic 3D. He argued the series "wasn't about impact or impressive 3D graphics". Instead, an outside 3D animation studio made the 10+ anime cutscenes ([Siliconera 2012][sil-origins]).
  - RF3's wireless features were dropped for RF4 ([Siliconera 2012][sil-origins]).
  - Manabe built the villager daily-routine system under tight DS memory limits on earlier titles. He says hardware limits left many RF4 ideas unimplemented ([Automaton][automaton] [interview]).
- **Special port changes:**
  - Updated character art and animation, a single-screen UI rework, HD output and dual audio ([GoNintendo][gon-rf4s], [XSEED][xseed-new] [official]).
  - Live2D animated portraits for Newlywed Mode ([Wikipedia][wp-rf4]).
  - Critics still found the UI unsuited to a TV, with very small text and an awkward zoom button ([Guardian][guardian]).

### Team size and timeline

- **Team size:** the studio had 36 staff at closure ([ANN][ann-closure]). Manabe says RF4 was "developed by a small team" with "more artists", but "otherwise the scale wasn't that different" from his current two-person team ([Automaton][automaton]). I found no official headcount or schedule for RF4 itself.
- **Timeline:** RF4 was announced in Famitsu on 2011-06-29 and released about 13 months later ([Fandom: RF4][w-rf4] [community]). Total development time is not documented.
- **Process (Hashimoto):**
  - Each game starts with a hard three-month window in which staff pitch anything.
  - Planning then stops, and the team keeps only ideas that pass "will it make the game fun?". Features from earlier entries can be dropped this way.
  - Each game gets a theme and a goal. RF4's were "a prince (or princess) who falls from the sky" and "experience a new fantasy on a new system" ([Siliconera 2012][sil-origins]).
  - The relationship theme was "passionate love, sweet marriage". That led to dating before marriage and adventuring with your spouse and child ([Siliconera 2012][sil-dq]).

### Series lineage

- **Parent series.**
  - *Bokujō Monogatari* was created by Yasuhiro Wada and started in 1996 on the Super Famicom/SNES.
  - It was sold in the West as *Harvest Moon* by Natsume.
  - After Marvelous ended Natsume's license, it was renamed *Story of Seasons* in the West in 2014. Natsume kept the "Harvest Moon" name ([Wikipedia: Story of Seasons][wp-sos]).
- **Rune Factory origins.**
  - *Rune Factory: A Fantasy Harvest Moon* (DS, 2006) began as a 10th-anniversary Harvest Moon project ([Siliconera 2012][sil-dq], [Wikipedia: RF1][wp-rf1]).
  - Hashimoto added combat over internal resistance. Fans of the peaceful-life feel were the concern ([Siliconera 2012][sil-origins]).
  - The open-world idea came from Dragon Quest: his favorite part was wandering and talking to NPCs after the final boss ([Siliconera 2012][sil-dq]).
- **Main entries.** RF1 (2006), RF2 (2008), Frontier (Wii, 2009), RF3 (2010), RF4 (2012). Tides of Destiny is a side entry. All are Neverland ([Wikipedia: RF1][wp-rf1]).
- **After Neverland.** Neverland filed for bankruptcy on 2013-11-29 despite RF4's sales, citing loan burden and failed refinancing ([ANN][ann-closure]). The series returned with Hakama:
  - RF4 Special (2019).
  - RF5 (2021, Unity, Metacritic 68 on Switch) ([Wikipedia: RF5][wp-rf5]).
  - Guardians of Azuma (2025, Metacritic about 80–85) ([Wikipedia: Azuma][wp-azuma]).
- **Farnia Village.** RF4's director Manabe and writer Tsuji now make *Farnia Village*, an RF-like built by two people and funded on Kickstarter ([Automaton][automaton]).

---

## 2. Systems and how they work

Details come from the community wiki unless marked otherwise. The official XSEED pages confirm the broad strokes: farming, taming, Prince Points, dating, weapons and spells, four crafting stations, and hidden areas ([XSEED: Farming & Fighting][xseed-farm], [XSEED: Features][xseed-feat] [official]).

### Calendar and time
- **Calendar:** 4 seasons of 30 days each ([Fandom: Calendar][w-cal] [community]). The plan's "28 days, RF standard" is the Stardew/Story of Seasons convention, not RF4's.
- **Daily tick:** crops grow and watered soil dries at 06:00, the time the player wakes ([Fandom: Farming Mechanics][w-farm]).
- **Day pressure:** the Guardian describes the day as a clock "slowly counting down to midnight", which pushes constant micro-optimization ([Guardian][guardian] [press]).
- **Not verified:** the real-time length of an in-game minute.

### Farming
- **Fields:** up to 5 fields on the farm, plus 4 "field dungeons" elsewhere. Each field is split into 2x2 sections and holds at most 76 entities. New fields start covered in debris: branches, rocks, stumps and weeds, each cleared by a specific tool. Charging a tool widens its area ([Fandom: Farming Mechanics][w-farm]).
- **Weapons and tools overlap:** bladed weapons can cut grass, and great axes can fell stumps ([Fandom: Farming Mechanics][w-farm]). Combat and farming share one action set.
- **Seasons:** crops get a growth bonus, not a restriction. Planting in season gives 1.5x growth, out of season 0.75x, and "there are no season restrictions" ([Fandom: Farming Mechanics][w-farm], [Fandom: Crops][w-crops]). This differs from Phase 3's "some die out of season". Unwatered crops can wither, and rain or snow waters them.
- **Item level:** crops and seeds carry a level from 1 to 10. Reaping with a sickle trades the harvest for seeds that are often a higher level. Over time you breed up from level-1 to level-10 seeds ([Fandom: Farming Mechanics][w-farm]). Shipping more crops expands shop stock ([XSEED: Farming & Fighting][xseed-farm]).
- **Soil (hidden stats):** each section has hidden soil values (growth, quality, number, size, health, defense) and attribute levels.
  - A Magnifying Glass reveals them.
  - Nutrients change them, and a filled fertilizer bin restores them over time.
  - Rotating many crop types raises the attributes ([Fandom: Farming Mechanics][w-farm]).
- **Giant crops:** plant 4 of the same crop in one 2x2 section and apply Giantizer, and they merge into one giant crop ([Fandom: Crops][w-crops]).
- **Runeys and rune orbs:** these sometimes pop out on harvest. They restore 50–80% of RP and give a skill or stat point ([Fandom: Farming Mechanics][w-farm]). This ties farming into stamina and skills.
- **Unusual crops:** you can grow weapons, shields, and Dungeon Seeds, which grow into small dungeons with a boss ([XSEED: Farming & Fighting][xseed-farm], [Fandom: Dungeon Seed][w-dseed]).

### RP and HP
- **RP (Rune Points)** pays for farming, crafting, combat skills and spells. When RP is empty, actions drain HP instead ([Fandom: Runes][w-runes] [community]; this page is series-general).
- **Skill levels lower RP cost:** crafting an item well below your skill level costs less RP. Crafting without the learned recipe costs much more ([Fandom: Skills][w-skills], [Fandom: Forging][w-forge]).
- **Refill:** sleep, food, baths, rune orbs and runeys.
- **Analysis:** RP is the single resource that links every loop. A farming day and a dungeon day spend the same bar.

### Skills that level by use
- **38 skills** in 7 groups ([Fandom: Skills][w-skills]):
  - Weapons (6): short sword, long sword, spear, axe/hammer, dual blades, fist.
  - Magic (7): fire, water, earth, wind, light, dark, love.
  - Farming (4): farming, logging, mining, fishing.
  - Recipe (4): cooking, forging, chemistry, crafting.
  - Life (4): searching, walking, sleeping, eating.
  - Defense (8): defense plus 7 status resistances.
  - Other (5): bathing, taming, throwing, leadership, bartering.
- **Each level** raises base stats and max HP/RP and lowers that skill's RP cost.
- **Weapon unlocks:** dash attack at level 5, charge attack at 10, ultimate at 20 ([Fandom: Skills][w-skills]).
- **Leveling exploits:** the bed is unbreakable, so hitting it levels weapon skills. Eating Object X levels every resistance at once ([Fandom: Skills][w-skills], [TheGamer via search][tg-combat] [community/press]).
- **Character level:** a separate overall level also exists ([Guardian][guardian]).
- **How it plays:** "every action" fills a bar, giving "a tiny dopamine rush of progress" ([Guardian][guardian] [press]).

### Tool, RP and HP rules (researched)
- **Short on RP:** crafting with too little RP costs 1/4 of max HP, whatever the RP cost ([wikiwiki: 小ネタ][jp-tips] [community]). Medium confidence: one fan wiki, stated plainly.
- **Fainting:** you wake at the clinic with 50% HP. A treatment fee comes out of the money you carry and can drop it to 0G. Friendship is not lost ([wikiwiki: 小ネタ][jp-tips], [Guidestrats: clinic][gs-clinic] [community]). Medium-high confidence: two sources agree.
- **4th charge stage:** costs 0 RP and gives no XP ([wikiwiki: 小ネタ][jp-tips]). Medium confidence.
- **Skill XP per action, not per tile:** the hoe gives 3 XP per action, with charge bonuses of 30 / 80 / 100. The watering can gives 4 XP per action, with charge bonuses of 20 / 40 / 60 ([GameFAQs: skill XP][gf-xp] [community]). Medium confidence: memory-read values from one player, not cross-checked.
- **Watering XP:** only watering cultivated soil gives XP ([GameFAQs: skill XP][gf-xp]). Medium confidence.
- **RP regen:** standing still slowly regenerates RP. A bath or sleep restores it fully ([GameFAQs: RP][gf-rp] [community]). Medium confidence.
- **Unknown:** the base RP cost of each farm tool, and the exact HP rule for tools. A Neoseeker walkthrough line claims 50% HP per action at 0 RP. Low confidence: one unsourced line.
- **Analysis:** Greenrune applies the crafting rule (1/4 of max HP) to tools too. Its charge bonuses keep RF4's ratio to the base swing, divided by 5, so XP per RP spent stays close to a tap's (see [Phase 1, Step 4](phases/phase-01-farm-loop.md#step-4--rp-hp-skills-weeks-89)).

### Combat, magic and bosses
- **Weapon classes:** short sword, long sword, spear, axe/hammer, dual blades, fists, and staves for magic ([XSEED: Farming & Fighting][xseed-farm], [Fandom: Skills][w-skills]).
- **Rune Abilities:** weapon skills and elemental, healing and "music" spells, used from equip slots ([Fandom: Rune Abilities][w-rabil]).
- **Spell upgrades:** pay Leon in gold or rare items to raise a spell's level ([Fandom: Rune Abilities][w-rabil]).
- **Party:** up to 2 villagers (from friendship level 3) or tamed monsters. Villagers gain friendship while in your party ([Fandom: Relationships][w-rel]).
- **Monster gates:** glowing gates keep spawning monsters until you destroy them. RF4 has 23 gate types ([Fandom: Monsters][w-mon]).
- **Difficulty:** Easy, Normal and Hard. Special adds Hell mode ([XSEED: What's New][xseed-new]).
- **Critics on combat:**
  - Game Informer called it clunky, with bosses that "drag on" behind big health bars and multiple forms ([Game Informer][gi]).
  - GamesRadar said bosses "feel like a grind" ([GamesRadar][gr] [press]).

### Dungeons
- **Story dungeons:** handcrafted themed areas: Yokmir Forest, Water Ruins, Obsidian Mansion, Leon Karnak and others. Each has gates, switch or lever puzzles, and a boss ([XSEED: Land of Selphia][xseed-land], [Fandom: RF4][w-rf4]).
- **Hidden areas:** some open only on certain days or seasons ([XSEED: Farming & Fighting][xseed-farm]).
- **Field dungeons:** areas locked to one season where you can farm ([Fandom: Farming Mechanics][w-farm]).
- **Dungeon Seeds:** grow on your farm into dungeons. Seed level sets the floor count (4–20) and the boss ([Fandom: Dungeon Seed][w-dseed]).
- **Critics on dungeons:** they were the most-criticized part, called "go-here-pull-this-lever" and "poorly paced" ([GamesRadar][gr]), and "repetitive" with "predictable puzzles" ([Game Informer][gi]).

### Monster taming and barns
- **How taming works:**
  - Taming requires a monster barn.
  - Give a monster an item, and a heart either bursts (tamed) or turns into a skull (failed).
  - Brushing a monster first raises the odds.
  - Bosses accept only one specific item, such as Rockfish Stew for Bane Dragon.
  - Taming gets harder for monsters above your level and for repeats of the same species ([Fandom: Monsters][w-mon]).
- **What tamed monsters do:**
  - Fight in your party. Barn monsters get 50% of the XP you earn in combat.
  - Produce goods: milk, eggs, wool and rare drops.
  - Once their friendship is high enough, do farm chores (clear debris, water, harvest). Chores drain their HP, so you rotate workers ([Fandom: Monsters][w-mon], [Fandom: Farming Mechanics][w-farm]).
- **Scale:** each "Build Monster Barn" order adds a room. The maximum is 200 monsters across 50 orders ([Fandom: Prince Points][w-pp]).
- **Critics:** GamesRadar called taming "a riot" ([GamesRadar][gr]).
- **Analysis:** taming is the bridge that makes combat pay off on the farm.

### Crafting, forging, cooking, chemistry and upgrades
- **Four stations:** forge (weapons and tools), crafting table (armor, shields, headgear, shoes, accessories), chemistry set (medicine), and kitchen tools (dishes). Each needs a license bought with Prince Points ([XSEED: Farming & Fighting][xseed-farm], [Fandom: Forging][w-forge], [Fandom: Prince Points][w-pp]).
- **Recipes:**
  - You learn them by eating "recipe bread". It only teaches recipes within about 10 levels of your skill.
  - You can attempt unknown recipes, but they cost more RP.
  - Failures produce junk items such as Object X ([Fandom: Forging][w-forge], [TheGamer: Chemistry][tg-chem]).
- **Material classes:** RF4 introduced them. Any item in a class (for example "cloth/skin") satisfies a recipe slot ([Fandom: Forging][w-forge]).
- **Inheritance:**
  - Extra materials added during crafting pass their upgrade effects onto the item. Up to 3 are inherited, and the item name turns blue.
  - Up to 9 more upgrades can follow, each repeat of the same material at half strength.
  - The total level and rarity of all 15 materials grant large bonus stats ([Fandom: Upgrading][w-upg]).
- **Stat overrides:** a same-class weapon added as a material, or Light Ore for a different class, transfers base stats ([Fandom: Upgrading][w-upg]).
- **Multiplier materials:**
  - 10-Fold Steel applies the previous upgrade effect again at 8x.
  - Double Steel applies it at 2x.
  - Object X flips the sign of later upgrades, so stat penalties become bonuses ([Fandom: Upgrading][w-upg], [Fandom: Object X][w-objx]).
- **Endgame recipe stacking:** players nest items, crafting a small shield with Object X and Mealy Apples and then using it inside the Rune Shield recipe. The results depend on RNG and on inheritance order ([Reddit r/runefactory mirror][reddit-endgame] [community]).
- **Critics:**
  - Crafting is the most-praised system: "a completionist's dream" ([GamesRadar][gr]), "its main selling point" ([TechRaptor via search][techraptor]).
  - Prima Games says that by the third dungeon you must craft your own gear to progress ([Prima][prima]).
  - The downside: gathering specific materials "can get to be a bit of a chore" ([NWR][nwr-rf4s]).
- **Analysis:** the multiplier and inversion materials let dedicated players reach stats far beyond the intended curve. Many players treat that as a feature, an optional "break the game" ceiling, rather than a bug. I found no critic who frames it as a flaw.

### Town management: Orders, Prince Points and Requests
- **Earning Prince Points:** shipping, festivals, requests, fighting alongside villagers, and story arcs, which give thousands of points each. The cap is 99,999 ([Fandom: Prince Points][w-pp], [XSEED: Farming & Fighting][xseed-farm]).
- **Prince Rank:** rises with tourism and gates which Orders are available ([Fandom: Prince Points][w-pp]).
- **Orders (spent at the Order Symbol):**
  - Licenses: cooking, crafting, airship. Each needs an exam first.
  - Festivals: 1,000 points to schedule or cancel; once scheduled, a festival recurs yearly.
  - Shops.
  - Development: farm, barn, storage and room expansion. These also consume Lumber and Material Stone.
  - Others: advertising, weather protection, and similar ([Fandom: Prince Points][w-pp], [Wikipedia][wp-rf4]).
- **Requests** come in three kinds ([Fandom: Requests][w-req]):
  - 92 unlockable requests from the box by your door. They reward tools and recipes and expand seed stock, and finishing all 92 unlocks New Game+.
  - Repeatable daily requests, a points faucet.
  - Personal requests from villagers, worth +10 friendship.
- **Critics:** IGN called the monarchy system "under-utilized" ([IGN][ign]). Game Informer disliked one currency serving both town growth and character upgrades ([Game Informer][gi]).

### Festivals
- **24 festivals,** 6 per season, in five types ([Fandom: Festivals][w-fest]):
  - Minigames: bean toss, eating contest, Buddy Battle and others.
  - Exhibitions: harvest and cooking contests, where crop quality and level score points.
  - Fishing contests.
  - Dating festivals: Firefly, Christmas.
  - Holidays.
- **Scheduling:** most festivals must be ordered with Prince Points ([Fandom: Festivals][w-fest]).
- **Rewards:** wins give friendship with every villager (+5/+4/+3 for 1st/2nd/3rd), and festival days give an extra chance to talk to each villager ([Fandom: Relationships][w-rel]).
- **Replay:** minigame festivals can be replayed from trophies ([Fandom: Festivals][w-fest]).

### NPC relationships, dating, marriage and children
- **Friendship (FP):** level 1 at 16 FP, level 10 at 1,345, then 336 FP per level up to level 10,000 ([Fandom: Relationships][w-rel]). How you gain it:
  - Daily talk: +4.
  - Gifts: one counted per day, from +15 to −10 depending on taste. Birthdays double the value.
  - Dates: +55.
  - Being in your party: up to +10 per day.
  - Requests and festival wins.
- **Story gates:** some characters' friendship caps until a story arc is done. Doug stays at level 3 until arc 2 ([Fandom: Relationships][w-rel]).
- **Dating and marriage:** RF4 added a "lovers" stage before marriage because Hashimoto felt going straight to marriage was "too sudden" ([Wikipedia][wp-rf4], [Siliconera 2012][sil-dq]). The path ([Fandom: Relationships][w-rel]):
  - Confess at friendship level 7 or higher.
  - Multiple partners are allowed, but each one makes the next confession harder.
  - Marriage needs 3 dates, a candidate-specific sub-event, level 10 or higher, a double bed and a crafted engagement ring.
- **Candidates:** 12 (6 per protagonist gender) ([Wikipedia][wp-rf4]).
- **Events:** 38 random town sub-events: 19 small, 12 marriage-candidate "main" events and 7 post-marriage events. Main events run roughly 500–1,500 lines of dialogue each ([Fandom: Town Events][w-events]).
- **Child:** one child (Noel or Luna). Your spouse raises it 19 days after the wedding, and the child can later join adventures ([Fandom: Noel][w-noel]).
- **Special additions:** Newlywed Mode and 12–13 "Another Episode" DLC vignettes ([XSEED: What's New][xseed-new]).
- **Critics:** GamesRadar found marriage "fun distractions" but not "as organic as they could've been" ([GamesRadar][gr]). The Guardian noted marriage was opposite-sex only ([Guardian][guardian]).

### NPC routines and dialogue
- **Design intent:** Hashimoto wanted no nameless shop clerk. Every NPC is named and reacts to recent events, and time, seasons and weather change what characters do ([Siliconera 2012][sil-dq]). His goal was "a small but rich microcosm... where every single person's lives shine" ([Siliconera 2012][sil-dq]).
- **Implementation:** Manabe built the daily-routine system. Tsuji writes "dialogue that serves as an extension of the game's mechanics": if routines change but lines don't, "the village will feel lifeless" ([Automaton][automaton] [interview]).

### Story structure
- **Three arcs** ([Wikipedia][wp-rf4], [Fandom: RF4][w-rf4]):
  - Arc 1: defeat bosses that turn out to be cursed guardians, who then join the town.
  - Arc 2: the Sechs Empire conflict and the credits.
  - Arc 3: a post-credits bonus arc with an extra dungeon.
- **Ignoring the plot:** you can skip the plot and just farm ([Siliconera 2012][sil-dq]).
- **Critics:** the plot was called "paper-thin" ([IGN][ign]) and "rote" ([Guardian][guardian]). The cast and XSEED's localization were praised ([GamesRadar][gr], [Game Informer][gi]).

### Quality-of-life features (documented)
- Monsters do farm chores ([Fandom: Monsters][w-mon]).
- Charged tools hit an area, and Free Farming Shoes remove grid snapping ([Fandom: Farming Mechanics][w-farm]).
- A bedside diary lists active events ([Fandom: Town Events][w-events]).
- Special made the arc-3 "Memories" event trigger reliably. In the 3DS version it was random and could block progress ([Fandom: Town Events][w-events]).
- Difficulty modes ([XSEED: What's New][xseed-new]).
- New Game+ ([Fandom: Requests][w-req]).
- Festival minigame replays ([Fandom: Festivals][w-fest]).
- Text zoom on Switch ([Guardian][guardian]).

### Core loops (analysis, grounded in the sources above)

**Daily loop.** Wake at 06:00 and water, since crops tick at 06:00. Talk to villagers and give gifts, which earns friendship and Prince Points. Take a request. Then choose:
- a dungeon run: drops, taming, combat skill XP;
- a crafting or cooking session;
- a festival.

Throughout, RP is the budget and the midnight clock is the pressure ([Fandom: Farming Mechanics][w-farm], [Guardian][guardian]).

**Seasonal loop.** Season bonuses change which crops are efficient. Festivals and birthdays mark the calendar. Harvest festivals reward high-level crops, and seasonal hidden areas open ([Fandom: Festivals][w-fest], [XSEED: Farming & Fighting][xseed-farm]).

**Long-term loop.** Three tracks run side by side:
- Seed level 1→10, which feeds cooking and gift quality and wins festivals.
- Skill levels, which raise max RP so you can do more each day.
- Gear crafting with inheritance, which lets you reach deeper dungeons, which drop better materials.

Prince Points turn all of this into town growth. Story arcs gate characters and areas. Marriage and a child give a social endgame.

**Feedback structure.** The Guardian sums it up: you need top armor for hard dungeons, which needs good crops, which needs better tools, which needs dungeon loot. The systems "fold into one another" ([Guardian][guardian]).

---

## 3. What makes it good

### Scores

| Version | Metacritic | Other | Source |
|---|---|---|---|
| 3DS (2012/13) | 78 | Famitsu 34/40. IGN 8/10. Destructoid 8/10. Game Informer 7/10 | [Wikipedia][wp-rf4] |
| Switch (Special) | 81 | OpenCritic top-critic average 82, 86% recommend, 59 reviews | [Wikipedia][wp-rf4], [OpenCritic][oc-rf4s] |
| PC / PS4 / Xbox One (Special) | 81 / 74 / 83 | Steam: "Very Positive", 2,097 of 2,372 positive (about 88%) as of 2026-10-15 | [Wikipedia][wp-rf4], [Steam API][steam-rf4s] |
| RF5 (comparison) | 68 Switch, 74 PC | Steam: "Mostly Positive", 1,634 of 2,139 (about 76%) | [Wikipedia: RF5][wp-rf5], [Steam API][steam-rf5] |
| Guardians of Azuma (comparison) | about 80–85 by platform | OpenCritic 81 | [Wikipedia: Azuma][wp-azuma] |

Playtime: about 38–40 h for the main story and 157–173 h for completionists, per HowLongToBeat figures quoted by Deku Deals. These are snapshots and are not verified directly ([Deku Deals][deku]).

### Why it is called the series high point (documented)
- Hardcore Gamer's review of Special calls it the series' current high point ([OpenCritic][oc-rf4s]).
- RF4 was the best-selling entry when it launched ([Wikipedia][wp-rf4]).
- RF5's reviews keep using RF4 as the benchmark and find RF5 lacking:
  - Siliconera said the developers didn't grasp what makes the series special ([Siliconera RF5 review][sil-rf5]).
  - Ladies Gamers recommended RF4 Special over RF5 for newcomers ([Ladies Gamers][lg-rf5]).

### Praise from critics and players
- Systems that interlock and give a steady routine to plan around ([Game Informer][gi], [Guardian][guardian]).
- Crafting depth ([GamesRadar][gr], [Prima][prima]).
- Leveling by doing anything ([GamesRadar][gr], [Guardian][guardian]).
- A quirky, likeable cast and strong localization ([GamesRadar][gr], [Game Informer][gi]).
- Monster taming ([GamesRadar][gr]).
- Lots to do and freedom of choice ([IGN][ign]).
- The most newcomer-friendly entry ([Game Informer][gi]).

### Criticism from critics and players
- **Very long tutorial and gating:** about 10 hours ([GamesRadar][gr]), described as "a tutorial for hours on end" ([Game Informer][gi]).
- **Dungeons:** repetitive, with lever puzzles and poor pacing ([GamesRadar][gr], [Game Informer][gi]).
- **Bosses:** health-bar sponges ([Game Informer][gi], [GamesRadar][gr]).
- **Plot:** thin, with uneven pacing ([IGN][ign]).
- **Late game:** the loop weakens after the credits ([Guardian][guardian]).
- **Material grind** ([NWR][nwr-rf4s]).
- **Presentation:** dated, with a UI built for handheld ([Game Informer][gi], [Guardian][guardian]).
- **Prince system** under-used ([IGN][ign]).
- **Bugs:** random-event triggers could block progress on 3DS ([Fandom: Town Events][w-events]). There were also save-breaking event glitches, such as Vishnal's proposal event soft-locking a save ([Fandom: Glitches][w-glitch] [community]).

### My analysis (not sourced)
- **Systems are the main thing it does well.** No single system is best-in-class. The combat is middling and the dungeons are weak. Its strength is that almost every action produces something another system consumes, and every action also levels a skill. That is why critics praise it while knocking each individual part.
- **Item level on everything is the hidden spine.** Crops, seeds, materials and dishes all carry a level and a rarity. This lets one set of item IDs serve hundreds of hours of progression. It is the most reusable idea for a small team: content stays fixed while quality scales.
- **Breakable crafting is a design choice.** The stat multipliers let committed players break the curve, which suits a cozy game with no competitive balance. The intended path is still the story pace.
- **Cast and routines carry the town.** With no story pressure, a named cast with routines and situational lines does the work. That writing cost is the real price of an RF-like, more than code.

---

## 4. Solo-dev effort and risks

Ratings assume Greenrune's setup: Godot 4, asset packs, about 8 hrs/week, a first 3D game. **S** = weeks. **M** = 1–2 months. **L** = 3–6 months. **XL** = 6+ months, or never at RF4 scale. All ratings are my estimates.

### Systems table

| System | How it works in RF4 | Why it matters | Solo effort | Risks |
|---|---|---|---|---|
| Calendar and time | 4×30-day seasons, 06:00 daily tick, midnight pressure | Drives every loop; festivals and birthdays hang off it | S | Many systems depend on the day-tick order (crops, NPCs, requests, monsters). Define one ordered end-of-day pipeline early |
| Farming core | Clear debris, till a grid of 2x2 sections, water, 06:00 growth, harvest | Base loop | M | 3D tile picking and hitbox feel. Making it feel good is Hashimoto's 60 fps / "pop" point |
| Crop and seed item levels | Crops and seeds have levels 1–10; sickle-reaping gives higher-level seeds | Long-term farming goal that doesn't need new content | S | Needs item *instances* (id + level), not plain stack counts. Retrofitting into inventory and saves is painful |
| Soil hidden stats, nutrients, giant crops | Per-section soil values, fertilizer bin, Giantizer merging 2x2 crops | Depth for farming enthusiasts | M | Balancing and opacity. RF4 hides it behind a Magnifying Glass item. Easy to over-build |
| RP / HP economy | One bar for farm, craft, fight and spells; empty RP drains HP | Links every activity | S | Tuning costs vs. refill so days feel full but not punishing |
| Skills by use | 38 skills; each raises stats and max RP and cuts RP cost | Constant small progress feedback | S (system) / M (tuning) | 38 is too many to balance. Exploits like hitting the bed are cheap to allow but cheapen the system |
| Inventory and item database | Hundreds of items with level, rarity, category class, gift tastes, upgrade effects | Everything reads from it | M | Needs to be data-driven from day 1 (Godot `Resource` or CSV). Hard-coding items is the classic RF-clone killer |
| Cooking and chemistry | Station + recipe + materials; recipes learned by eating recipe bread | Turns crops into buffs, gifts and festival entries | M | Recipe data volume; UI |
| Forging and crafting with inheritance | 6 craft + 9 upgrade slots, 3 inherited effects, rarity/level bonuses, 2x/8x steel, Object X | The most-praised system; drives combat progression | L–XL | Combinations explode; exploits; UI complexity; save format for per-item upgrade history |
| NPC schedules | Per-NPC daily/seasonal/weather routines; Manabe built the system | Makes the town feel alive | L | Navmesh in 3D, schedule data per NPC×season×weather, festival overrides, save/load mid-walk |
| Dialogue (context-sensitive) | Lines keyed to time, season, weather, friendship, events; main events run 500–1,500 lines | The "microcosm" pillar | L–XL (content) | Writing volume. Dialogic 2 handles presentation, not line selection by condition |
| Friendship and gifts | FP levels, daily talk, 1 counted gift per day, birthday 2x, taste tables | Social core | S–M | Taste table per NPC × item is a data-entry job |
| Romance, marriage, child | Confession at level 7, dates, sub-events, ring + bed, one child | Hashimoto's stated theme for RF4 | L (content-bound) | Each candidate needs a unique event chain. Scale with candidate count |
| Requests | 92 unlockable + daily repeatable + personal | Short-term goals; unlocks seeds and tools | M | Condition-checking framework ("ship X", "give Y to Z") plus data |
| Orders / Prince Points | Spend points to unlock licenses, shops, festivals, farm and storage expansion | Town progression spine | S–M | Mostly data plus one menu; cheap for what it gives |
| Festivals | 24; minigames, exhibitions, fishing, dating | Calendar texture, friendship, Prince Points | S per exhibition, M per minigame | Each minigame is a small game. Exhibition-style festivals (judge crop level) are cheap |
| Combat | 6 weapon classes + staves, charge/dash/ultimate, spells, 2-member party AI | What makes RF different from Stardew | XL | 3D action feel, animation (Mixamo helps), party AI, hit reactions |
| Dungeons and bosses | Handcrafted themed areas, gates, lever puzzles, bosses | Material source; story gates | XL | Content cost per dungeon; the most-criticized system even in RF4 |
| Monster taming and barns | Gift to tame; barns; produce; farm chores; party members | Bridges combat back to the farm | L (needs combat first) | Per-monster data; chore AI on fields |
| Story arcs and cutscenes | 3 arcs; anime cutscenes; bosses become villagers | Gives the first ~40 h direction | L–XL | Writing and staging cost. Critics rated it low anyway |
| Save system | Everything above, per field, per NPC, per item instance | Prerequisite for all of it | M (ongoing) | Schema versioning. The plan already says to build saves early; add item instances and NPC state |
| UI / menus | Many menus: crafting, upgrade, orders, requests, relationships | Daily friction | L | RF4's UI is a known weak spot. Keep it few and big-text from the start |

### Comparable efforts

| Project | Team / time | Outcome | Lesson for Greenrune (analysis) |
|---|---|---|---|
| Stardew Valley (2016) | One person, 4.5 years, C# ([Stardew FAQ][sdv-faq]); reportedly 10–12-hour days ([Cheatsheet][sdv-schedule]) | Steam "Overwhelmingly Positive", 1.04M reviews ([Steam API][steam-sdv]) | 2D, no 3D pipeline, light combat. At 50–70 h/week that is roughly 11,700–16,400 hours. At 8 h/week the same hours take about 28–39 years. My arithmetic; schedule reports vary |
| Farnia Village (in development) | RF4 director + RF3/4 writer, 2 people full-time; Kickstarter raised over 22M yen. Without funding they estimated 10–20 years ([Automaton][automaton]) | Not released yet | Even RF4's own leads treat content volume as the bottleneck. Their stated priority is systems that intersect, not graphics |
| Rune Factory 5 (2021) | Hakama, a Marvelous studio; Unity ([Wikipedia: RF5][wp-rf5]) | Metacritic 68 on Switch; faulted for performance, visuals and no new ideas | A funded studio moving the formula to full 3D still got the feel and performance wrong. 3D adds risk to an RF-like |
| Fae Farm (2023) | Phoenix Labs, a studio; Unreal ([Wikipedia: Fae Farm][wp-fae]) | Metacritic 75; OpenCritic 59% recommend. Criticized for barebones combat, repetition and weak social dynamics. Studio later cut most of its staff ([VGC][vgc-fae]) | A studio-made farm+combat game still gets judged on depth of interlock and social writing, not on polish |
| Rune Factory 4 | Neverland, 36 staff at closure ([ANN][ann-closure]); about 13 months from Famitsu announcement to release | The series benchmark | The RF4 bar needs a studio. A solo project should copy its structure, not its scale |

### Must-have to feel like RF4 vs nice-to-have (analysis)

**Must-have, in priority order:**
1. **Tool actions that feel good and cost RP.** One RP bar shared by farming and, later, everything else. Charged tools hit an area. Treat tool use as a swing with a hitbox so weapons reuse it later.
2. **Skills that level by use.** Start with about 6 (farming, watering, logging, mining, cooking, walking or sleeping). Each lowers its RP cost and raises max RP.
3. **Item level on crops and seeds,** with level-ups through harvesting or reaping. It gives the farm a long-term goal with no new content.
4. **Named NPCs** with routines, situational lines, friendship, gifts and birthdays.
5. **A calendar** with seasonal growth bonuses (not hard crop death), festivals and birthdays.
6. **A town progression spine** (Orders and points) that unlocks shops, festivals and farm expansion.
7. **Cooking** as the first "make things from crops" system: buffs, RP restore, gifts, festival entries.
8. **Later: combat, dungeons and taming** with monsters as farmhands. Without them, Greenrune is a Story of Seasons-like, not an RF-like. That is a fine first game, but name it honestly.

**Nice-to-have:**
- Soil hidden stats and the Magnifying Glass.
- Giant crops.
- Field dungeons and Dungeon Seeds.
- Forge/craft inheritance with multiplier materials.
- Chemistry.
- Romance, marriage and a child.
- 24 festivals and their minigames.
- 38 skills.
- Spells and the party system.
- Multi-arc story with cutscenes.
- 92 unlockable requests.
- Newlywed mode.

### Design pillars (analysis, drawn from the interviews)
1. **Every action is satisfying and every action levels something.** This is Hashimoto's 60 fps / Pikmin-pop rule plus use-based skills ([Siliconera 2012][sil-origins]).
2. **Systems intersect.** Each activity's output is another activity's input. This is Manabe's stated priority for Farnia Village ([Automaton][automaton]).
3. **A small microcosm where each named person reacts to time, weather and events** ([Siliconera 2012][sil-dq], [Automaton][automaton]).
4. **The player chooses the day.** Farm, fight, romance or govern, with no forced path. The story can be ignored ([Siliconera 2012][sil-dq], [XSEED: Features][xseed-feat]).
5. **Teach fast.** RF4's 10-hour tutorial is its most-cited flaw ([GamesRadar][gr], [Game Informer][gi]).

---

## Implications for Greenrune's plan

Applied to `docs/plan.md`, `SCOPE.md`, `NOT_IN_SCOPE.md` and `README.md` on 2026-10-15. References below to "the plan" describe it before that change. Choices made where the research left an option open: 30-day seasons (not 28), and the Orders menu lands in Phase 3 alongside festivals.

1. **Move "Stamina / RP" out of the Phase 4 combat era into Phase 1.** In RF4, RP is the farming energy bar first ([Fandom: Skills][w-skills], [Fandom: Farming Mechanics][w-farm]). It is S-size and gives the day loop its budget. Today `NOT_IN_SCOPE.md` lists it under combat.
2. **Add a minimal use-based skill system in Phase 1 or 2.** It is not mentioned anywhere in the plan, yet it is the most-mentioned "feel" feature in reviews ([GamesRadar][gr], [Guardian][guardian]). It is S-size with about 4–6 skills.
3. **Design inventory around item instances with a level, in Phase 1.** The Phase 1 save list ("tile states, inventory, time, gold") should store item id + level per stack from the first save version. Adding crop levels later means a save migration. Also make items data-driven from the start: one Godot `Resource` type per item definition, or a CSV.
4. **Phase 3 crop seasons: consider RF4's multiplier model** (1.5x in season, 0.75x out, no death) instead of "some die out of season" ([Fandom: Farming Mechanics][w-farm]). It is simpler to build and test, and it is what RF4 does. Also note RF4 uses 30-day seasons, not 28 ([Fandom: Calendar][w-cal]). Either works; pick deliberately.
5. **Pull a light "Orders" menu into Phase 2 or 3.** Spending points to unlock a shop, a festival or farm expansion gives progression before combat exists. In RF4 festivals are mostly *ordered* ([Fandom: Festivals][w-fest]), so Phase 3 festivals plug straight into it. It is mostly data plus one menu.
6. **Phase 2 underestimates dialogue.** Dialogic 2 covers display and branching, but RF4-style NPCs need line selection by time, season, weather, friendship and event state ([Automaton][automaton]). Budget a small "pick the best matching line" layer and, above all, writing time. Expect Phase 2's 3–4 months to be content-bound, not code-bound.
7. **Cooking is mislabeled "deferred indefinitely".** It is the cheapest way to make crop levels matter (dishes, gifts, festival entries) before combat. It fits Phase 3 alongside festivals. Forging and crafting with inheritance can stay deferred until combat exists.
8. **Phase 1 tool code should be combat-shaped.** Implement hoe, axe and sickle as swings with hitboxes, an RP cost and skill XP. Then Phase 4 adds weapons as more items on the same pipeline. RF4 already lets weapons do farm work ([Fandom: Farming Mechanics][w-farm]), and Manabe calls this the key idea of his RF successor ([Automaton][automaton]). It costs little now and avoids the "bolt combat on later" rewrite the plan warns about.
9. **Phase 3.5 Path A is the right default, with the label fixed.** Without combat, dungeons and taming, the result is a Harvest Moon / Story of Seasons-like. The RF identity is combat plus taming feeding the farm. If Path B is chosen, follow RF4's weak spots in reverse:
   - Keep dungeons few and short.
   - Avoid health-sponge bosses.
   - Make taming the first combat feature that pays off, because monsters doing farm chores ties it back to Phase 1.
10. **The 18–24 month estimate for Phase 4 looks plausible, possibly optimistic.** RF4's combat, dungeons and story arcs were built by a studio. RF5's move to full 3D drew performance and feel complaints even with a funded team ([Wikipedia: RF5][wp-rf5]).
11. **Avoid the 10-hour tutorial.** RF4's most consistent criticism ([GamesRadar][gr], [Game Informer][gi]). Unlock systems through play (requests and orders), not long guided sequences.

---

## Unverified or not found

- RF4's engine (3DS) and the engine of the Special ports: no first-party source found.
- RF4 team headcount and development duration: only the studio's 36-person size at closure and Manabe's "small team" remark.
- Worldwide lifetime sales of RF4 or RF4 Special. A GameRevolution article states 300,000 for 3DS with no attribution ([GameRevolution][gamerev]), so I left it out.
- Real-time length of an RF4 day.
- Polygon and Destructoid review texts were not retrievable. Their scores are taken from Wikipedia.
- Metacritic pages blocked direct fetch. Scores come from Wikipedia's reception table, which cites Metacritic.

---

## Sources

**Official / store**
- XSEED RF4 Special site, What's New: https://runefactory.com/rf4/whats-new.html
- XSEED RF4 site, Features: https://runefactory.com/rf4/feat.html
- XSEED RF4 site, Farming & Fighting: https://runefactory.com/rf4/farm.html
- XSEED RF4 site, The Land of Selphia: https://runefactory.com/rf4/land.html
- Stardew Valley official FAQ: https://stardewvalley.net/faq
- Steam review summary API, RF4 Special (1580240): https://store.steampowered.com/appreviews/1580240?json=1&language=all&num_per_page=0
- Steam review summary API, RF5 (1702330): https://store.steampowered.com/appreviews/1702330?json=1&language=all&num_per_page=0
- Steam review summary API, Stardew Valley (413150): https://store.steampowered.com/appreviews/413150?json=1&language=all&num_per_page=0

**Interviews**
- Siliconera (2012), "The Origins Of Rune Factory Revealed By Series Producer Hashimoto": https://www.siliconera.com/the-origins-of-rune-factory-revealed-by-series-producer-hashimoto/
- Siliconera (2012), "Rune Factory Was Inspired By Dragon Quest, Says Producer" (Iwata Asks-based): https://www.siliconera.com/rune-factory-was-inspired-by-dragon-quest-says-producer/
- Automaton West (2025), interview with Shinichi Manabe and Takanori Tsuji on Farnia Village: https://automaton-media.com/en/interviews/rune-factory-4s-creators-are-doing-everything-they-left-undone-in-their-new-life-sim-rpg-farnia-village-we-ask-them-what-comes-after-the-massively-successful-kickstarter/
- GoNintendo, dev team on why RF4 Special: https://www.gonintendo.com/stories/334644-rune-factory-dev-team-reveals-why-they-re-bringing-rune-factory-4

**Press / reviews / news**
- Anime News Network (2013), Neverland closure: https://www.animenewsnetwork.com/news/2013-11-29/rune-factory-neverland-company-suspends-operations-files-for-bankruptcy
- GamesRadar, RF4 review (2013): https://www.gamesradar.com/rune-factory-4-review/
- Game Informer, RF4 review (2013): https://www.gameinformer.com/games/rune_factory_4/b/3ds/archive/2013/10/01/royalty-isn-t-all-it-s-cracked-up-to-be.aspx
- IGN, RF4 review (2013): https://www.ign.com/articles/2013/10/19/rune-factory-4-review
- The Guardian, RF4 Special review (2020): https://www.theguardian.com/games/2020/feb/27/rune-factory-4-special-review-nintendo-switch
- Prima Games, RF4 Special review: https://primagames.com/reviews/rune-factory-4-special-review
- TechRaptor, RF4 Special review: https://techraptor.net/gaming/reviews/rune-factory-4-special-review
- Nintendo World Report, RF4 Special review: https://nintendoworldreport.com/review/52965/rune-factory-4-special-switch-review
- Nintendo Everything (2020), RF4 Special 100k NA: https://nintendoeverything.com/story-of-seasons-friends-of-mineral-town-fastest-selling-xseed-game-to-sell-100000-copies-rune-factory-4-special-also-at-100000-units/
- Siliconera, RF5 review: https://www.siliconera.com/review-rune-factory-5-does-the-series-a-disservice/
- Ladies Gamers, RF5 review: https://ladiesgamers.com/rune-factory-5-review/
- VGC, Phoenix Labs layoffs: https://www.videogameschronicle.com/news/dauntless-and-fae-farm-studio-phoenix-labs-is-laying-off-the-majority-of-its-staff
- Cheatsheet, Stardew development schedule: https://www.cheatsheet.com/entertainment/how-long-did-it-take-to-make-make-stardew-valley.html
- TheGamer, RF4 Special combat tips: https://www.thegamer.com/rune-factory-4-special-combat-tips/
- TheGamer, RF4 Special chemistry recipes: https://www.thegamer.com/rune-factory-4-special-medicine-chemistry-set-recipes/
- GameRevolution, RF4 Special release/DLC article (unattributed 300k figure): https://www.gamerevolution.com/?p=629763

**Aggregates / encyclopedic**
- Wikipedia, Rune Factory 4 (Metacritic table, staff, dates, sales, interview citations): https://en.wikipedia.org/wiki/Rune_Factory_4
- Wikipedia, Rune Factory 5: https://en.wikipedia.org/wiki/Rune_Factory_5
- Wikipedia, Rune Factory: Guardians of Azuma: https://en.wikipedia.org/wiki/Rune_Factory:_Guardians_of_Azuma
- Wikipedia, Rune Factory: A Fantasy Harvest Moon: https://en.wikipedia.org/wiki/Rune_Factory:_A_Fantasy_Harvest_Moon
- Wikipedia, Story of Seasons: https://en.wikipedia.org/wiki/Story_of_Seasons
- Wikipedia, Fae Farm: https://en.wikipedia.org/wiki/Fae_Farm
- OpenCritic, RF4 Special: https://opencritic.com/game/9052/rune-factory-4-special
- Deku Deals, RF4 Special (HowLongToBeat figures): https://www.dekudeals.com/items/rune-factory-4-special

**Community (Rune Factory Fandom wiki; fan-documented and datamined)**
- Skills (RF4): https://runefactory.fandom.com/wiki/Skills_%28RF4%29
- Farming Mechanics (RF4): https://runefactory.fandom.com/wiki/Farming_Mechanics_%28RF4%29
- Crops (RF4): https://runefactory.fandom.com/wiki/Crops_%28RF4%29
- Upgrading Items (RF4): https://runefactory.fandom.com/wiki/Upgrading_Items_%28RF4%29
- Forging (RF4): https://runefactory.fandom.com/wiki/Forging_%28RF4%29
- Crafting (RF4): https://runefactory.fandom.com/wiki/Crafting_%28RF4%29
- Object X: https://runefactory.fandom.com/wiki/Object_X
- Prince Points: https://runefactory.fandom.com/wiki/Prince_Points
- Requests (RF4): https://runefactory.fandom.com/wiki/Requests_%28RF4%29
- Festivals (RF4): https://runefactory.fandom.com/wiki/Festivals_%28RF4%29
- Relationships (RF4): https://runefactory.fandom.com/wiki/Relationships_%28RF4%29
- Town Events (RF4): https://runefactory.fandom.com/wiki/Town_Events_%28RF4%29
- Monsters (RF4): https://runefactory.fandom.com/wiki/Monsters_%28RF4%29
- Rune Abilities (RF4): https://runefactory.fandom.com/wiki/Rune_Abilities_%28RF4%29
- Dungeon Seed: https://runefactory.fandom.com/wiki/Dungeon_Seed
- Calendar (RF4): https://runefactory.fandom.com/wiki/Calendar_%28RF4%29
- Noel: https://runefactory.fandom.com/wiki/Noel
- Runes: https://runefactory.fandom.com/wiki/Runes
- Glitches (RF4): https://runefactory.fandom.com/wiki/Glitches_%28RF4%29
- Rune Factory 4: https://runefactory.fandom.com/wiki/Rune_Factory_4
- r/runefactory "endgame crafting" thread (mirror): https://reddit.sudovanilla.org/r/runefactory/comments/1jqjdc1/endgame_crafting
- wikiwiki.jp RF4 wiki, 小ネタ (tips): https://wikiwiki.jp/rf4bu/%E5%B0%8F%E3%83%8D%E3%82%BF
- Guidestrats, RF4 clinic: https://guidestrats.com/rf4-clinic/
- GameFAQs RF4 board, skill XP per action thread (archived): https://web.archive.org/web/20240214030041/https://gamefaqs.gamespot.com/boards/635388-rune-factory-4/76520117
- GameFAQs RF4 board, RP regeneration thread (archived): https://web.archive.org/web/20241214131830/https://gamefaqs.gamespot.com/boards/635388-rune-factory-4/68247636

[xseed-new]: https://runefactory.com/rf4/whats-new.html
[xseed-feat]: https://runefactory.com/rf4/feat.html
[xseed-farm]: https://runefactory.com/rf4/farm.html
[xseed-land]: https://runefactory.com/rf4/land.html
[sdv-faq]: https://stardewvalley.net/faq
[steam-rf4s]: https://store.steampowered.com/appreviews/1580240?json=1&language=all&num_per_page=0
[steam-rf5]: https://store.steampowered.com/appreviews/1702330?json=1&language=all&num_per_page=0
[steam-sdv]: https://store.steampowered.com/appreviews/413150?json=1&language=all&num_per_page=0
[sil-origins]: https://www.siliconera.com/the-origins-of-rune-factory-revealed-by-series-producer-hashimoto/
[sil-dq]: https://www.siliconera.com/rune-factory-was-inspired-by-dragon-quest-says-producer/
[automaton]: https://automaton-media.com/en/interviews/rune-factory-4s-creators-are-doing-everything-they-left-undone-in-their-new-life-sim-rpg-farnia-village-we-ask-them-what-comes-after-the-massively-successful-kickstarter/
[gon-rf4s]: https://www.gonintendo.com/stories/334644-rune-factory-dev-team-reveals-why-they-re-bringing-rune-factory-4
[ann-closure]: https://www.animenewsnetwork.com/news/2013-11-29/rune-factory-neverland-company-suspends-operations-files-for-bankruptcy
[gr]: https://www.gamesradar.com/rune-factory-4-review/
[gi]: https://www.gameinformer.com/games/rune_factory_4/b/3ds/archive/2013/10/01/royalty-isn-t-all-it-s-cracked-up-to-be.aspx
[ign]: https://www.ign.com/articles/2013/10/19/rune-factory-4-review
[guardian]: https://www.theguardian.com/games/2020/feb/27/rune-factory-4-special-review-nintendo-switch
[prima]: https://primagames.com/reviews/rune-factory-4-special-review
[techraptor]: https://techraptor.net/gaming/reviews/rune-factory-4-special-review
[nwr-rf4s]: https://nintendoworldreport.com/review/52965/rune-factory-4-special-switch-review
[ne-sales]: https://nintendoeverything.com/story-of-seasons-friends-of-mineral-town-fastest-selling-xseed-game-to-sell-100000-copies-rune-factory-4-special-also-at-100000-units/
[sil-rf5]: https://www.siliconera.com/review-rune-factory-5-does-the-series-a-disservice/
[lg-rf5]: https://ladiesgamers.com/rune-factory-5-review/
[vgc-fae]: https://www.videogameschronicle.com/news/dauntless-and-fae-farm-studio-phoenix-labs-is-laying-off-the-majority-of-its-staff
[sdv-schedule]: https://www.cheatsheet.com/entertainment/how-long-did-it-take-to-make-make-stardew-valley.html
[tg-combat]: https://www.thegamer.com/rune-factory-4-special-combat-tips/
[tg-chem]: https://www.thegamer.com/rune-factory-4-special-medicine-chemistry-set-recipes/
[gamerev]: https://www.gamerevolution.com/?p=629763
[wp-rf4]: https://en.wikipedia.org/wiki/Rune_Factory_4
[wp-rf5]: https://en.wikipedia.org/wiki/Rune_Factory_5
[wp-azuma]: https://en.wikipedia.org/wiki/Rune_Factory:_Guardians_of_Azuma
[wp-rf1]: https://en.wikipedia.org/wiki/Rune_Factory:_A_Fantasy_Harvest_Moon
[wp-sos]: https://en.wikipedia.org/wiki/Story_of_Seasons
[wp-fae]: https://en.wikipedia.org/wiki/Fae_Farm
[oc-rf4s]: https://opencritic.com/game/9052/rune-factory-4-special
[deku]: https://www.dekudeals.com/items/rune-factory-4-special
[w-skills]: https://runefactory.fandom.com/wiki/Skills_%28RF4%29
[w-farm]: https://runefactory.fandom.com/wiki/Farming_Mechanics_%28RF4%29
[w-crops]: https://runefactory.fandom.com/wiki/Crops_%28RF4%29
[w-upg]: https://runefactory.fandom.com/wiki/Upgrading_Items_%28RF4%29
[w-forge]: https://runefactory.fandom.com/wiki/Forging_%28RF4%29
[w-objx]: https://runefactory.fandom.com/wiki/Object_X
[w-pp]: https://runefactory.fandom.com/wiki/Prince_Points
[w-req]: https://runefactory.fandom.com/wiki/Requests_%28RF4%29
[w-fest]: https://runefactory.fandom.com/wiki/Festivals_%28RF4%29
[w-rel]: https://runefactory.fandom.com/wiki/Relationships_%28RF4%29
[w-events]: https://runefactory.fandom.com/wiki/Town_Events_%28RF4%29
[w-mon]: https://runefactory.fandom.com/wiki/Monsters_%28RF4%29
[w-rabil]: https://runefactory.fandom.com/wiki/Rune_Abilities_%28RF4%29
[w-dseed]: https://runefactory.fandom.com/wiki/Dungeon_Seed
[w-cal]: https://runefactory.fandom.com/wiki/Calendar_%28RF4%29
[w-noel]: https://runefactory.fandom.com/wiki/Noel
[w-runes]: https://runefactory.fandom.com/wiki/Runes
[w-glitch]: https://runefactory.fandom.com/wiki/Glitches_%28RF4%29
[w-rf4]: https://runefactory.fandom.com/wiki/Rune_Factory_4
[reddit-endgame]: https://reddit.sudovanilla.org/r/runefactory/comments/1jqjdc1/endgame_crafting
[jp-tips]: https://wikiwiki.jp/rf4bu/%E5%B0%8F%E3%83%8D%E3%82%BF
[gs-clinic]: https://guidestrats.com/rf4-clinic/
[gf-xp]: https://web.archive.org/web/20240214030041/https://gamefaqs.gamespot.com/boards/635388-rune-factory-4/76520117
[gf-rp]: https://web.archive.org/web/20241214131830/https://gamefaqs.gamespot.com/boards/635388-rune-factory-4/68247636
