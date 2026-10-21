# Phase 2 — Town & NPCs

**Goal:** a small town one door from the farm, with named people who keep daily routines, say the right thing for the moment, grow closer through talk and gifts, and hand out the first requests.

**Phase 2 is complete when:**
- One NPC reaches max friendship within ~14 in-game days through talk and gifts, and says different things in the morning and in the evening.
- 3–5 named NPCs walk their routines with no stuck or vanished NPC over 14 days.
- The request box has handed out at least 4 requests, one of which gave the sickle.
- Friendship, flags and requests survive save → quit → load, and all NPC data, schedules, tastes, lines and requests live in `data/`.
- The player and every NPC are built from the Phase 2.0 base body and its parts.

**Sub-phases**, worked one at a time in this order:
1. [Phase 2.0 — Character base](#phase-20--character-base): one adult base body on the KayKit skeleton with swappable parts; the player switches to it.
2. [Phase 2.1 — Home, farm and town as one place](#phase-21--home-farm-and-town-as-one-place): town layout, quick transitions, navmesh.
3. [Phase 2.2 — One person, end to end](#phase-22--one-person-end-to-end): one NPC with a schedule, dialogue, talk and gifts.
4. [Phase 2.3 — The shop](#phase-23--the-shop): hours, clerk rule, stock that grows with shipping, bronze tools.
5. [Phase 2.4 — Request box](#phase-24--request-box): one small request a day that unlocks tools and seed stock.
6. [Phase 2.5 — The town fills in](#phase-25--the-town-fills-in): NPCs 2–5, birthdays, the writing pass, save v3, the 14-day playtest.

**Starts when:** [Phase 1](phase-01-farm-loop.md) is done. A placeholder town and shop were built early (commit 125c5e7); their status is under 2.1 and 2.3.

**Out of scope for this phase:** seasons, weather, festivals, cooking, romance, combat. See [NOT_IN_SCOPE.md](../../NOT_IN_SCOPE.md).

**Reference:** [plan.md › Phase 2](../plan.md#phase-2--town--npcs), [research › NPC routines and dialogue](../rf4-research.md#npc-routines-and-dialogue), [research › relationships](../rf4-research.md#npc-relationships-dating-marriage-and-children), [RF4 and Farnia research › Gap analysis, Phase 2](../rf4-farnia-research.md#phase-2-phase-02-town-npcsmd).

**How this phase runs.** Sub-phases follow [plan.md › Phased roadmap](../plan.md#phased-roadmap): a sub-phase ends when its "complete when" outcomes show in the running game and its checklist is checked. Most of the work is writing, not code. Every checked item must meet the [definition of done](../endgame.md#definition-of-done). Numbers marked *(default)* are design defaults. Phase 2's new saved state goes into save v3, created by the first sub-phase that adds state (2.2); v2 saves keep loading.

## Sub-phases

### Phase 2.0 — Character base

**Goal:** one adult base body on the KayKit Adventurers skeleton, with swappable parts, that the player and every Phase 2 NPC are built from.

**Phase 2.0 is complete when:**
- The player walks, runs, swings every tool and carries with the new body, with all its parts on, and every KayKit clip the game uses plays with feet on the ground and no clipping.
- From the gameplay camera the body reads at the chosen proportion (about 2.2–2.7 heads), with painted anime eyes, solid hair with a colour gradient and soft cel shading, in one screenshot beside a KayKit original.
- Changing the head, hair, outfit texture, accessories and palette colours in data makes a visibly different character with no new mesh.

**Steps:**
1. **Proportion test.** In Godot, on a KayKit body, scale the `head` bone between 0.75 and 0.85 and the whole model uniformly. Screenshot each from the gameplay camera beside Farnia's frames ([research › Character style](../rf4-farnia-research.md#5-character-style-farnia-village-vs-blue-archive--stella-sora-chibi)). Pick the heads-tall target and record it here.
2. **Reshape the body** (Blender — Claude: base): on the KayKit body, lengthen the legs and torso and shrink the head toward the target. Keep the 41-joint skeleton and every bone name, so all 76 clips still play ([research › Editing a KayKit or Quaternius model](../rf4-farnia-research.md#editing-a-kaykit-or-quaternius-model)). Export with the [Phase 1.1](phase-01-farm-loop.md#phase-11--the-field) preset. (Blender — user: polish): silhouette, hands and feet.
3. **Fix hips height.** Longer legs leave the clips' hips at the old height. Offset the `hips` track on import in Godot or in Blender, and record which.
4. **Check every clip.** Play all 76 clips on the new body and fix clipping and foot sliding, starting with the clips the game uses (idle, run, the tool swings, carry).
5. **Build the parts** (Blender — Claude: base; Blender — user: polish). Step 2's shrunken head becomes the first head part.
   - a head with a painted anime face texture;
   - a hair mesh on the `head` bone, solid locks with a colour gradient;
   - an outfit mostly painted on the body texture, with a few mesh pieces;
   - accessories attached to bones;
   - colours from the shared palette texture ([Phase 1.1](phase-01-farm-loop.md#phase-11--the-field)).
6. **Re-check every clip with parts on.** Hair, mesh outfit pieces and accessories add new clipping; play all 76 clips again with a full look and fix what shows.
7. **Look data.** One resource in `data/` per character listing its head, hair, outfit texture, accessories and palette colours. A character scene builds itself from it.
8. **Outline test.** Compare the cel shader with and without `assets/shaders/cel/outline.gdshader` side by side from the gameplay camera. Keep the outline only if the test favours it, and record the result here.
9. **The player uses it.** Replace `Rogue.glb` in `scenes/player.tscn` with the base body and a player look. Player recolouring happens here: the player's hair, outfit and palette colours live in the player's look data.
10. **Re-check the hoe grip.** The longer arms and new hands move the hands on the shaft. Re-run [Phase 1.2](phase-01-farm-loop.md#phase-12--tool-feel)'s two-handed grip and straight-swing checks on the new body and fix the grip if either fails.

**Checklist:**
- [ ] The base body keeps every KayKit bone name, and every clip plays on it
- [ ] Idle, run, every tool swing and the carry clips show no clipping or foot sliding from the gameplay camera, with a full look on
- [ ] The hoe passes Phase 1.2's two-handed grip and straight-swing checks on the new body
- [ ] The hips fix is applied once, in one place, and recorded here
- [ ] The heads-tall target and the outline decision are recorded here
- [ ] Two looks built from data differ in head, hair, outfit and colours on the same body
- [ ] Each part uses the shared palette texture and the cel shader, with no import warnings
- [ ] 60 fps on the farm with the player and two other base-body characters on screen

**Out of scope for this phase:** child and elderly bodies (they arrive with the first NPC that needs one, on the same skeleton; see [Phase 2.5](#phase-25--the-town-fills-in)), facial expressions beyond one painted face, final 2D portraits (M1), new animations, custom buildings (Phase 4+).

**Reference:** proportions, faces, hair and outlines of Farnia, Blue Archive and Stella Sora against KayKit, and why Stella Sora's proportions are out ([research › Character style](../rf4-farnia-research.md#5-character-style-farnia-village-vs-blue-archive--stella-sora-chibi)); keeping bone names so the clips play ([research › Editing a KayKit or Quaternius model](../rf4-farnia-research.md#editing-a-kaykit-or-quaternius-model)).

### Phase 2.1 — Home, farm and town as one place

**Goal:** the farm, the house and the town feel one door apart, and moving between them is quick.

**Phase 2.1 is complete when:**
- From the bed, the player reaches the field in one door and the town square in one more transition.
- Every transition is a short fade, and the player arrives facing away from the exit.
- No spot in the town or farm traps the player or the camera, and the navmesh debug view covers every walkable area.

**Built so far:** `scenes/town.tscn` is a placeholder for the user to rearrange in the editor: ground and bounds, a square and a short road to the farm exit, 2 houses, and a market stand as the shop spot. Farm ↔ town exits fade (`fade_seconds` in `data/travel.tres`), the player keeps their facing, and saves store the area. After moving anything in the town, select `NavigationRegion3D` and click **Bake NavigationMesh** in the 3D toolbar.

**Steps:**
1. Lay out the town around one anchor, as RF4 puts the castle at the centre with the farm behind it: shop on a main street, inn, square, 3–5 houses, the path to the farm. Buildings come from the Quaternius Medieval Village and KayKit packs; custom buildings wait for Phase 4+.
2. Keep the farm ↔ town exit a single fade, with a spawn point per entrance.
3. Bake the navmesh and walk every edge.

**Checklist:**
- [x] Farm ↔ town exits fade, the player keeps their facing, and the current area survives save → load
- [ ] Each transition shows under 0.5 s of black *(default)*
- [ ] The navmesh debug view covers every walkable area
- [ ] Walking bed → house door → farm → town square → farm hits no stuck spot

**Out of scope for this phase:** NPC schedules (2.2); fading buildings that hide the player and town building interiors, both waiting until the user has rearranged the town (2.5); custom building models (Phase 4+).

**Reference:** the farm behind the castle at the centre of town, and RF4's "ultra-quick fade to black" ([research › Environment](../rf4-farnia-research.md#facts-rf4s-selphia-and-the-field)); [research › Phase 2.1](../rf4-farnia-research.md#phase-21--home-farm-and-town-as-one-place).

### Phase 2.2 — One person, end to end

**Goal:** one named NPC has a schedule, a portrait, lines that change with the time of day, a talk interaction and gifts.

**Phase 2.2 is complete when:**
- The NPC walks a full-day schedule and is where the schedule says after any sleep, scene change or load.
- Talking in the morning, the afternoon and the evening gives different lines.
- Handing them a carried crop gives a reaction and a point change that depend on their taste.

**Built so far:** a placeholder shopkeeper (KayKit Knight, name in `data/shop.tres`) idles at the market stand. He has no `NPCDef`, schedule, dialogue or walking yet. He becomes this sub-phase's NPC *(default)*, rebuilt on the 2.0 base body.

**Steps:**
1. `NPCDef` data: id, name, look, portrait, birthday, schedule, gift tastes. The NPC scene is `CharacterBody3D` + `NavigationAgent3D` + the [Phase 2.0](#phase-20--character-base) base body built from the NPC's look. The style is set in 2.0; portraits stay placeholders until M1.
2. Add a weekday counter to the clock: data only, saved, no HUD yet (3.1 shows it). `ScheduleDef` data: time → place + activity, per weekday. NPC state machine: idle, walk, work, sleep. Off-screen catch-up: after sleep, a scene change or a load, place the NPC where its schedule says.
3. Custom dialogue box: portrait, name, typewriter text, press interact to advance. Portraits are placeholders rendered from the NPC's own model. Dialogic 2 waits until choices or cutscenes are in scope: it is alpha with breaking changes, and Phase 2 has no branching.
4. `LineDef` data: NPC, conditions (time window, season, weather, min/max friendship, flags), priority, text. The line selector picks the highest-priority line whose conditions match, never repeats a line on the same day, and falls back to a per-NPC line so it never returns nothing.
5. Talk and gift. Face the NPC and press interact to talk; carry an item ([Phase 1.3](phase-01-farm-loop.md#phase-13--hands-and-carrying)) and talk to give it. Friendship points: the first talk of the day with each NPC gives points *(default amount, in data)* and later talks that day give none, as RF4 counts one talk a day; one counted gift per day; a taste table (loved, liked, neutral, disliked, hated); gift value scales with item level; a reaction line and emote for each taste tier.
6. A yellow "not yet talked today" bubble over the NPC.
7. Debug panel: set time, friendship and weather, then preview the chosen line.

**Checklist:**
- [ ] Schedule, tastes and lines live in `data/`
- [ ] Leaving and re-entering town, sleeping or loading puts the NPC where the schedule says
- [ ] The debug panel shows the expected line for any condition you set
- [ ] A loved, a neutral and a hated gift on 3 days give 3 different reactions and point changes
- [ ] The first talk of the day raises friendship, and a second talk that day does not
- [ ] Friendship and today's talk and gift flags survive save → load (save v3; a v2 save still loads)
- [ ] The talk bubble disappears after the first talk of the day and returns at 06:00

**Out of scope for this phase:** more NPCs, birthdays and the friendship page (2.5), season and weather lines (3.2).

**Reference:** gifts are given by holding the item and talking, and the yellow talk bubble ([research › Design](../rf4-farnia-research.md#3-design-art-direction-ui-and-feedback)); [research › Phase 2.2](../rf4-farnia-research.md#phase-22--one-person-end-to-end); [plan.md › Phase 2](../plan.md#phase-2--town--npcs) on line selection.

### Phase 2.3 — The shop

**Goal:** the seed shop opens and closes on a schedule, and its stock grows with the player's shipping.

**Phase 2.3 is complete when:**
- The shop sells only while its clerk is at the counter, within hours set in data, with shorter holiday hours.
- Shipping a higher-level crop raises the level of that seed the shop stocks.
- You can buy seeds, plant them and ship the crop at a profit.

**Built so far:** facing the placeholder shopkeeper and pressing interact opens a shop that sells the stock in `data/shop.tres` (turnip and potato seeds) at each item's `buy_price`.

**Steps:**
1. Shop hours as data (RF4's General Store: 9:00–18:00, holidays 9:00–13:30). One weekday is the holiday *(default)*.
2. The shop opens only while its owner is at the counter.
3. Stocked level = the highest level the player has shipped of that crop, as RF4 does after its "Ship a level 2 Turnip" request.
4. Sell `bronze_hoe`, `bronze_watering_can` and `bronze_sickle` from [Phase 1.2](phase-01-farm-loop.md#phase-12--tool-feel). This is where the player buys a first bronze tool *(default)*; RF4 sells its bronze tools at Bado's for 3,000 G each after the Rafflesia boss. Prices *(default)*.

**Checklist:**
- [ ] Hours, stock and tool prices live in `data/`
- [ ] Outside hours, or with the clerk away, interact gives a "closed" line and no shop screen
- [ ] The highest shipped level per crop survives save → load
- [ ] A bronze tool bought here charges as Phase 1.2 specifies

**Out of scope for this phase:** selling to shops (RF4 shops buy nothing; per-category prices stay on the bin), your own store, seasonal stock (3.2).

**Reference:** shop hours and the clerk rule ([research › Game plan](../rf4-farnia-research.md#1-game-plan-how-rf4-paces-its-opening)); stocked level follows shipped level ([research › Phase 2.3](../rf4-farnia-research.md#phase-23--the-shop)).

### Phase 2.4 — Request box

Pulled forward from [Phase 8](phase-08-town-life.md), which now grows this box into the full request board.

**Goal:** a request box by the house door hands out one small request per day, and its rewards unlock tools and seed stock.

**Phase 2.4 is complete when:**
- On day 2 the box offers one request; finishing it unlocks the next on the following day.
- "Ship a turnip" adds potato seeds to the shop.
- One request rewards the cheap sickle, replacing Phase 1.5's day-2 default.

**Steps:**
1. `RequestDef` data: id, condition (ship X, give Y to Z, till N plots), reward, next request.
2. A request box object by the house door and a notebook page listing the active request. The box itself is a small prop: pack model first, else (Blender — Claude: base) then (Blender — user: polish).
3. Four to six requests modelled on RF4's tutorial chain, minus fishing, mining and combat. RF4's chain also hands out the Cheap Axe and Hammer; Greenrune keeps them in [Phase 4 Step 5](phase-04-combat-core.md).
4. Move potato seeds out of the shop's starting stock; the "ship a turnip" request adds them.

**Checklist:**
- [ ] Requests, conditions and rewards live in `data/`
- [ ] The box offers at most one new request per day (RF4's starting limit)
- [ ] A ship request counts only if the item is in the bin at 08:00
- [ ] Active and finished requests survive save → load

**Out of scope for this phase:** daily repeatable requests, villager personal requests, a request board, points (Phase 3.3 adds points for requests).

**Reference:** Eliza's request box on day 2, one request a day, and the tutorial chain's rewards ([research › Game plan](../rf4-farnia-research.md#1-game-plan-how-rf4-paces-its-opening)); [research › Phase 2.4](../rf4-farnia-research.md#phase-24--request-box-pulled-forward-from-phase-8).

### Phase 2.5 — The town fills in

**Goal:** the rest of Phase 2's NPCs and writing, built on the Phase 2.2 template.

**Phase 2.5 is complete when:**
- 3–5 named NPCs, the shop owner among them, walk their routines for 14 in-game days with no stuck or vanished NPC.
- One NPC reaches max friendship within those 14 days through talk and gifts.
- A birthday gift counts double, and the friendship page lists every NPC with level and birthday.

**Steps:**
1. Add NPCs 2–5 by copying the 2.2 template; each is the 2.0 base body with its own look. A child or elderly NPC gets its body when it is added, on the same skeleton; an elder may be the adult body plus a hunched idle and a slow walk.
2. Fade or dither buildings and trees that hide the player (the farm avoids this by placing them at the north edge and outside the bounds).
3. Building interiors as separate scenes, or doors that hide NPCs inside. House interiors and their props are not buildings ([CLAUDE.md](../../CLAUDE.md)), so they are made in Blender now: (Blender — Claude: base) the room shell and props on the shared palette texture, then (Blender — user: polish). Quaternius furniture fills any gap.
4. Friendship level thresholds as data; birthdays double a gift's value; the friendship page.
5. Writing pass, ~50 lines per NPC: greetings for morning, afternoon and evening; lines for each friendship tier (low, mid, high); gift reactions for each taste tier; birthday lines; placeholder season and weather lines, filled in properly in Phase 3.2. Give each NPC a distinct voice and read all lines aloud once.
6. Save v3 covers per-NPC friendship, today's talk and gift flags, requests and the highest shipped levels; v2 saves still load.
7. 14-day playtest from a new game; fix every bug found.

**Checklist:**
- [ ] Each NPC passes Phase 2.2's checklist
- [ ] A building or tree that hides the player fades or dithers
- [ ] Walking into every interior and back out hits no stuck spot
- [ ] Each NPC has ≥50 lines in data, and no two NPCs share a line
- [ ] A v2 save from the end of Phase 1 loads into v3
- [ ] The 14-day run has no bugs left open

**Out of scope for this phase:** seasons, weather, festivals, romance, more than 5 NPCs (M1 adds 2–3).

**Reference:** [research › Phase 2.5](../rf4-farnia-research.md#phase-25--the-town-fills-in); [research › NPC routines and dialogue](../rf4-research.md#npc-routines-and-dialogue).
