# Greenrune roadmap

The agent's todo list: what to work on next and what counts as done. The phase files in [phases/](phases/) hold the full steps; this file orders them.

## How to use this file

1. Work the first unchecked item in [Current todo](#current-todo). Read its phase file section before starting.
2. A sub-phase is done only when all of these hold:
   - every checklist item in its phase file is checked;
   - each item meets the [definition of done](endgame.md#definition-of-done);
   - the user has seen its "complete when" outcomes in the running game. The user tests each sub-phase.
3. Start the next sub-phase only after the current one is done. Then move its status here, and replace [Current todo](#current-todo) with the next sub-phase's steps and checklist.
4. Blender steps: Claude builds the base with Blender Python or by editing pack GLBs (blockout, proportions, origin on the tile grid, shared palette texture, export). The user polishes. Blender is not on `PATH`; run scripts with `/Applications/Blender.app/Contents/MacOS/Blender --background --python <script>`.
5. On a user step (Blender polish, testing), hand off, keep working on steps that don't need it, and leave the sub-phase open until it lands.
6. After each piece of work, in order: deslop; an independent review by a separate agent; commit; a short test script for the user (what to run, what to press, what they should see).
7. Numbers marked *(default)* are design defaults: build them as written, and list them in the test script so the user can tune them.

## Phases at a glance

Status: **done**, **current**, **next**, **later**.

| Phase | Goal | Complete when (condensed) | Status |
|---|---|---|---|
| [0 Learn](../PHASE_0_CHECKLIST.md) | Skills for Phase 1 | Baseline toon scene and feel test | **done** |
| [1 Farm loop](phases/phase-01-farm-loop.md) | Smallest polished RF-style day | 5 days across a save/reload; RP runs out 15:00–18:00; a skill and a reaped seed level up; all data in `data/` | **current** (Steps 1–6 **done**; 1.1 **done**) |
| [2 Town & NPCs](phases/phase-02-town-npcs.md) | Named town one door from the farm | One NPC at max friendship in ~14 days; 3–5 NPCs keep routines; 4+ requests, one gives the sickle; everyone on the 2.0 body; save v3 | **later** |
| [3 Seasons, cooking, orders](phases/phase-03-seasons-cooking-orders.md) | A full year where crop levels matter | Full year played; seasons look and grow differently; cooking and the festival reward crop level; 3+ Orders; save v4 | **later** |
| [M1 Cozy slice](phases/m1-cozy-slice.md) | First shipped game | On itch.io; 3 new testers finish day 1 unaided; continue/stop written down | **later** |
| [4 Combat core](phases/phase-04-combat-core.md) | Weapons on the tool pipeline that feel good | 10-minute field run at 60 fps rated 4/5; drops feed the bin or recipes; axe/hammer clear stumps | **later** |
| [5 Taming & barn](phases/phase-05-taming.md) | Combat pays off on the farm | 3 tamed monsters work the field for 7 days | **later** |
| [6 Forge & craft](phases/phase-06-forge-craft.md) | Gear from crafting with inheritance | Crafted weapon beats the shop; silver to platinum tools forged | **later** |
| [7 Dungeons & bosses](phases/phase-07-dungeons.md) | The full RF loop | Dungeon 1 drops → gear → Dungeon 2; runs ≤20 min; no lever puzzles | **later** |
| [M2 RF-like demo](phases/m2-rf-like-demo.md) | Public proof | Spring–Summer demo public; Dungeon 1 in week 1; 60 fps low-end | **later** |
| [8 Town life depth](phases/phase-08-town-life.md) | Busier town and marriage | Married in a run; ~30 requests; 2 festivals a season | **later** |
| [9 Story & late game](phases/phase-09-story-late-game.md) | Optional story and post-credits play | Story finishable and ignorable; post-story dungeon; tester keeps playing | **later** |
| [10 Polish & launch](phases/phase-10-polish-launch.md) | Greenrune 1.0 | Released; no blockers; every old save loads | **later** |

Sub-phases of Phases 1–3, each with its done bar (the full list is under "complete when" in the phase file):

- [1.1 The field](phases/phase-01-farm-loop.md#phase-11--the-field) **done**: a 9×12 field in outlined 3×3 blocks, starting debris, soil states readable at 12:00 and 22:00, the whole field on screen.
- [1.2 Tool feel](phases/phase-01-farm-loop.md#phase-12--tool-feel) **current**: cheap tools tap only; a bronze charge covers the player's 3×3 block with feedback on one hit; water spent per plot. The two-handed hoe swing (Steps 4–5) waits for the user's base body.
- [1.3 Hands and carrying](phases/phase-01-farm-loop.md#phase-13--hands-and-carrying) **later**: debris and crops lift, throw and store by hand; a thrown crop lands in the bin; weeds regrow on untended ground.
- [1.4 Crops](phases/phase-01-farm-loop.md#phase-14--crops) **later**: every stage reads at a glance; ripe crops look ripe; a warned crop left dry withers; rune orbs refill RP and level a skill.
- [1.5 The day's frame](phases/phase-01-farm-loop.md#phase-15--the-days-frame) **later**: a new game opens on the lesson with the cheap kit; the HUD shows date, time, gold, HP and RP; RP runs out 15:00–18:00.
- [1.6 Five-day gate](phases/phase-01-farm-loop.md#phase-16--five-day-gate) **later**: five days with a mid-run save and reload show every Phase 1 outcome.
- [2.0 Character base](phases/phase-02-town-npcs.md#phase-20--character-base) **later**: the player plays every used clip on the base body with parts on; looks swap in data.
- [2.1 Home, farm and town](phases/phase-02-town-npcs.md#phase-21--home-farm-and-town-as-one-place) **later**: bed to field in one door, to town in one more fade; no stuck spot; navmesh covers every walkable area.
- [2.2 One person](phases/phase-02-town-npcs.md#phase-22--one-person-end-to-end) **later**: one NPC keeps its schedule across sleep and load, says time-of-day lines and reacts to gifts by taste.
- [2.3 The shop](phases/phase-02-town-npcs.md#phase-23--the-shop) **later**: the shop sells only in hours with its clerk present; stocked seed level follows shipped level.
- [2.4 Request box](phases/phase-02-town-npcs.md#phase-24--request-box) **later**: one request a day from day 2; "ship a turnip" unlocks potato seeds; one request gives the sickle.
- [2.5 The town fills in](phases/phase-02-town-npcs.md#phase-25--the-town-fills-in) **later**: 3–5 NPCs walk 14 days with no stuck NPC; one reaches max friendship; birthdays and the friendship page work.
- [3.1 Calendar](phases/phase-03-seasons-cooking-orders.md#phase-31--calendar-and-seasonal-growth) **later**: Spring 30 sleeps into Summer 1; good- and bad-season crops ripen on predictable days.
- [3.2 Weather and crops](phases/phase-03-seasons-cooking-orders.md#phase-32--weather-season-looks-and-new-crops) **later**: four seasons tell apart at 12:00; rain waters while it falls; 2+ good-season crops per season.
- [3.3 Points and Orders](phases/phase-03-seasons-cooking-orders.md#phase-33--points-and-orders) **later**: shipments pay points next morning; the expansion Order adds 3×3 blocks.
- [3.4 Cooking](phases/phase-03-seasons-cooking-orders.md#phase-34--cooking) **later**: higher-level ingredients make a higher-level dish that restores more RP.
- [3.5 Harvest festival](phases/phase-03-seasons-cooking-orders.md#phase-35--harvest-festival) **later**: the festival gathers the town, a high-level crop wins, and it recurs next year.
- [3.6 Full-year gate](phases/phase-03-seasons-cooking-orders.md#phase-36--full-year-gate) **later**: a full year with a mid-run save and reload shows every Phase 3 outcome; a v3 save loads into v4.

## Migration: existing project → new plan

What changes in the current code, in build order. Each item names the sub-phase that does it. **Save** marks a change to the save format; **breaks saves** marks one that loses data from an existing save unless handled as written. Phase 1 stays on save v2 (`SaveGame.VERSION = 2`): new keys load with the default given; v3 starts in 2.2.

### Phase 1.1

1. `scenes/farm.tscn` `Field` (`FarmGrid`): `size = Vector2i(12, 12)` → 9×12 (`Vector2i(9, 12)`), moved into a new field resource in `data/` with block size 3; drop the `size` export from `scripts/farm_grid.gd`. **Breaks saves:** `SaveGame.read()` has no bounds check and `Field` doesn't know the field size, so plots in columns 9–11 of an old save would load off the field. `Field` reads the new resource, and `read()` skips out-of-bounds cells with a warning.
2. `scripts/farm_grid.gd`: add cell → block index and one faint outline per 3×3 block.
3. New: a Blender export script or preset, the shared palette texture and its cel `ShaderMaterial`; `.gitignore` gains `*.blend1`.
4. `scripts/farm_grid.gd` tile `BoxMesh` and the three soil materials → Blender soil meshes for untilled, tilled and watered.
5. New: `DebrisDef` script and `data/` debris resources; `Field` holds debris per cell; `Field.apply()` and `scripts/farm.gd` `_on_tool_used()` change nothing on a debris plot, so no RP is paid. **Save:** v2 gains a debris key; a save without it loads with no debris.
6. `data/camera.tres` outdoor pitch 45, arm 20, FOV 35 → tuned for the 9×12 field. The working tree holds the user's uncommitted edit to this file; the user commits or discards it before this step.

### Phase 1.2

7. `scripts/tool_charge.gd` `@export_range(1, 8) var size: int` (square, sizes above 1 centred on the player, unsnapped) → `size: Vector2i`, width × depth in tiles with depth along the facing direction, and no 1–8 cap (gold's 3×9 needs 9). `scripts/sowing_def.gd` `@export_range(1, 8) var charge_size: int` → `Vector2i` the same way.
8. `scripts/farm_grid.gd` `cells_hit(player, point, size, out)` → a tap hits the plot at `point`; a charge starts at the 3×3 block holding the player's tile and runs `size.y / 3` blocks along the facing direction, skipping off-field plots. `scripts/farm.gd` `_process()`, `_on_tool_used()` and `_sow()` pass the facing.
9. `data/sowing.tres` `charge_size = 2` → `Vector2i(3, 3)`.
10. `data/items/hoe.tres` (id `hoe`; tap 5 RP, 0.6 s 2×2 15 RP, 1.2 s 4×4 30 RP) → `cheap_hoe.tres` (tap only) + `bronze_hoe.tres` (tap + 0.6 s 3×3). Update or retire the prototype first: `sandbox/prototypes/chibi_hoe/chibi_hoe.gd` loads `data/items/hoe.tres`. **Breaks saves:** the `hoe` id disappears; map `hoe` → `cheap_hoe` in `SaveGame._load_stacks()`.
11. `data/items/watering_can.tres` (tap 4, 2×2 8, 4×4 16; capacity 15) → `cheap_watering_can.tres` (capacity 15) + `bronze_watering_can.tres` (tap + 3×3, capacity 36). **Breaks saves:** map `watering_can` → `cheap_watering_can`, keeping the stack's `water`.
12. `data/items/sickle.tres` (tap 5, 2×2 15, 4×4 30; no icon) → `cheap_sickle.tres` + `bronze_sickle.tres` (tap + 3×3), each with an icon. **Breaks saves:** map `sickle` → `cheap_sickle`.
13. Hoe `swing_animation`: `1H_Melee_Attack_Chop` → `2H_Melee_Attack_Chop`, with `impact_time` retuned. Make the swing travel straight along the facing line (clip, then hand attachment or grip, then a bone-rotation offset, then a Blender clip). Build on the result of `sandbox/prototypes/chibi_hoe/`.
14. `scripts/farm.gd` `_pay()`: `stack.water -= 1` per swing → 1 water per plot watered; `_on_tool_used()` waters plots in a fixed order and stops when the can is empty.
15. New: target marker and charge-area outline (replacing the plain `target_material` quad), per-level charge cues, the HUD water gauge and refill sound, water-as-you-walk in `scripts/player.gd`.
16. `watering_can`/`sickle` `hit_stop` and `shake` 0 → their own values.

### Phase 1.3

17. `scripts/player.gd`: add a carry state (lift, carry, throw, store) beside idle, charge and swing. New world item: a billboard `Sprite3D` scene. **Save:** v2 gains the carried item and items on the ground, both empty by default.
18. `scripts/farm.gd` `_harvest()`: crop straight into the bag → crop over the head, then thrown or stored; the shipping bin accepts thrown items.
19. `scripts/game.gd` `day_tick()`: add debris regrowth on untilled, empty plots after `field.dry()`.

### Phase 1.4

20. `CropDef.stage_models`: Quaternius FBX in `assets/crops/` → Blender GLBs on the shared palette, plus a seeded-soil model.
21. `scripts/field.gd` `Crop`: add crop HP for withering, and a Withered Grass item and debris type; add rune orbs. **Save:** v2 gains crop HP and the pending colour change; a save without them loads every crop at full HP.

### Phase 1.5

22. Starting kit: none (a new game's bag is empty; tools come from the console `add`) → a kit in `data/`: `cheap_hoe`, `cheap_watering_can`, 1 `turnip_seed` and 9 more after the first watering; `cheap_sickle` on day 2. **Save:** v2 gains lesson progress and the day-2 sickle flag.
23. RP retune for 9×12 with cheap tools: `data/vitals.tres` `base_max_rp = 100`, tap costs (hoe 5, can 4, sickle 5) and each skill's `rp_cost_cut_per_level = 0.05` → measured values that empty RP between 15:00 and 18:00.
24. New: HUD date line and one theme value for HUD text size.

### Phase 2.0

25. `scenes/player.tscn`: `Rogue.glb` and its `Rogue_*` part nodes → the base body GLB built from a player look resource; the `hips` offset applied on import. No save change: the look comes from data.

### Phases 2.2–2.4

26. `scenes/shopkeeper.tscn`: `Knight.glb` → the base body with his own look, under an `NPCDef` (2.2).
27. `scripts/save_game.gd` `VERSION = 2` → 3, with friendship, talk and gift flags, requests and highest shipped levels; v2 saves keep loading (2.2). **Save.**
28. `data/shop.tres` `stock` [`turnip_seed`, `potato_seed`] → add `bronze_hoe`, `bronze_watering_can`, `bronze_sickle` with a `buy_price` each (2.3); move `potato_seed` out of the starting stock and into a request reward (2.4).

## Current todo

[Phase 1.2 — Tool feel](phases/phase-01-farm-loop.md#phase-12--tool-feel). Migration items 7–12 and 14–16. Item 13 (the two-handed hoe swing) waits for the user's base body: decided 2026-10-27, so the swing isn't built twice; the hoe keeps today's straight `1H_Melee_Attack_Chop` until then.

**Done when** (Phase 1.2 is complete when, minus the swing outcome):
- A cheap hoe, can or sickle taps the one plot in front and never charges.
- A bronze hoe held to charge marks the 3×3 block holding the player's tile before release, then the soil change, a sound, dust and the RP drop land on the same hit. A bronze can and a charged sow cover the same block; a tap with seeds sows one plot.
- The can's water gauge shows on the HUD while the can is selected, drops one step per plot watered, refills with a sound, and tapping the can while walking waters each plot passed over.

**Steps:**
- [x] 1. Tool data shape: `ToolCharge.size` and `SowingDef.charge_size` → `Vector2i` (width × depth along the facing); charged areas start at the 3×3 block holding the player's tile and run along the facing; off-field plots skipped.
- [x] 2. Split hoe, can and sickle into cheap (tap only) and bronze (tap + 3×3) items; map old save ids (`hoe` → `cheap_hoe`, etc., keeping the can's water). Update or retire `sandbox/prototypes/chibi_hoe/` first (it loads `data/items/hoe.tres`). *Sandbox prototype left untouched (user's untracked folder); it no longer loads `hoe.tres`.*
- [x] 3. Bronze items as tinted cheap models, testable with `add bronze_hoe`.
- [ ] 4–5. *Deferred to the base body:* two-handed hoe, straight overhead swing.
- [x] 6. Water per plot: 1 water per plot watered; a short can waters only what it has, in a fixed order.
- [x] 7. Target marker on the tap plot and an outline of the charge area while held.
- [x] 8. Per-level charge cues: marker grows, tool glows, rising tone; early release uses the last level reached.
- [x] 9. HUD water gauge and refill sound.
- [x] 10. Water as you walk.
- [x] 11. RP feedback: popup or bar flash on spend; a dull "no effect" sound for a swing that changes nothing.
- [x] 12. Tune swing speed, impact time, hit-stop and shake per `ToolDef`.

**Checklist:** as in the [phase file](phases/phase-01-farm-loop.md#phase-12--tool-feel), except the two swing items (both hands on the shaft; sideways drift), which move with Steps 4–5.
