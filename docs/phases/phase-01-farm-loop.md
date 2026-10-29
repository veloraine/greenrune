# Phase 1 — Farm loop

**Goal:** the smallest playable RF-style day, polished one area at a time: walk, swing tools, clear and work the field, spend RP, level skills, grow and reap levelled crops, ship, sleep, save.

**Phase 1 is complete when:**
- Five in-game days from a new game run with a save, quit and reload in the middle, with no errors or warnings in the Godot output.
- At level 1, RP runs out between 15:00 and 18:00 *(default)* doing normal farm work.
- In those five days at least one skill levels up and one reaped seed comes back a level higher.
- Every item, crop, skill, debris type and tuning number lives in `data/`, none in scripts.

**Sub-phases**, worked one at a time in this order:
1. [Phase 1.1 — The field](#phase-11--the-field): Blender setup and the shared palette texture, the 9×12 field in 3×3 blocks, starting debris, soil looks, camera.
2. [Phase 1.2 — Tool feel](#phase-12--tool-feel): cheap and bronze tool items, 3×3 charges centred on the player and snapped to blocks, a straight two-handed hoe swing, water per plot, target marker, charge cues, water gauge.
3. [Phase 1.3 — Hands and carrying](#phase-13--hands-and-carrying): lift, carry, throw and store; debris cleared by hand; debris regrowth.
4. [Phase 1.4 — Crops](#phase-14--crops): stage models, seeded soil, ripe cue, RF4 withering, rune orbs, harvest pop.
5. [Phase 1.5 — The day's frame](#phase-15--the-days-frame): first-morning lesson, starting kit, HUD date, 08:00 and new-day cues, RP budget re-tune.
6. [Phase 1.6 — Five-day gate](#phase-16--five-day-gate): the five-day playtest and tuning.

**Starts when:** [Phase 0](../../PHASE_0_CHECKLIST.md) is done and Godot MCP is set up ([plan.md](../plan.md#phase-1-prerequisites--godot-mcp-setup-do-at-the-start-of-phase-1)). Both are done.

**Out of scope for this phase:** town, NPC dialogue, seasons, weather, cooking, combat. See [NOT_IN_SCOPE.md](../../NOT_IN_SCOPE.md).

**Reference:** [plan.md › Phase 1](../plan.md#phase-1--farming-prototype-3d), [research › Farming, RP, Skills](../rf4-research.md#2-systems-and-how-they-work), [RF4 and Farnia research › Farm mechanics](../rf4-farnia-research.md#4-farm-mechanics-exact-rf4-rules), [› Gap analysis](../rf4-farnia-research.md#gap-analysis).

**How this phase runs.** Sub-phases follow [plan.md › Phased roadmap](../plan.md#phased-roadmap): a sub-phase ends when its "complete when" outcomes show in the running game and its checklist is checked. Every checked item must meet the [definition of done](../endgame.md#definition-of-done). Numbers marked *(default)* are design defaults to tune, not RF4 facts.

**Blender work** follows [CLAUDE.md](../../CLAUDE.md). **(Blender — Claude: base)** is the blockout, proportions, origin on the tile grid and export, done by a Blender Python script or by editing an asset-pack GLB. **(Blender — user: polish)** is the final shaping, colour and texture. Godot import and wiring are Claude's. Phase 1 makes no humanoid or building models: the character base comes in [Phase 2.0](phase-02-town-npcs.md#phase-20--character-base), and custom buildings wait for Phase 4+.

**Saves.** New saved state from these sub-phases (debris, items on the ground, carried items, withering, lesson progress) goes into save v2, and a value missing from an older file loads as a new game has it. Debris is the exception: an older file loads with no debris, so an existing farm isn't suddenly covered. Phase 1 stays on save v2.

## Built so far: Steps 1–6

Steps 1–6 built every Phase 1 system. They stay here as the record of what exists; the sub-phases polish it. Step 7, the playtest, became [Phase 1.6](#phase-16--five-day-gate).

### Step 1 — Skeleton, player, farm scene

- [x] Folder layout: `scenes/`, `scripts/`, `data/items/`, `data/crops/`, `data/skills/`, `ui/`
- [x] Input map: move, use tool, next/prev hotbar slot, interact, menu (WASD, Space/left click, E/Q or mouse wheel, F, Tab/Esc)
- [x] Farm scene from KayKit/Quaternius: house with bed, ~12×12 field, shipping bin, trees (`scenes/farm.tscn`; the fences were removed in Phase 1.1 Step 9; the bed is in the house interior from Step 5)
- [x] Player: `CharacterBody3D` + KayKit model + ~~Mixamo~~ KayKit built-in idle/run
- [x] Camera: `SpringArm3D` + `Camera3D` at the fixed RF4 angle, follows the player (`scenes/camera_rig.tscn`)
- [x] Main scene runs with F5

**Done when:** you walk around the farm at 60 fps and the camera never clips through props.

### Step 2 — Item data, inventory, save v1

- [x] `ItemDef` resource: id, name, icon, category, base sell price, max stack (one `.tres` per item in `data/items/`; icons still to paint)
- [x] `ItemStack`: item id + level (1–10) + count (holds the `ItemDef` in memory, the id in saves)
- [x] Inventory model (24 slots) + 8-slot hotbar UI; scroll to select (the hotbar is slots 0–7; wheel or Q/E)
- [x] Debug command to add any item at any level (backquote opens the console: `add <item> [level] [count]`, `inv`)
- [x] Save v1 as JSON with a `version` field: inventory, player position, day, gold (`user://save.json`)
- [x] Load from the title screen or a debug key (console `save` / `load`; the title screen comes later)

**Done when:** you add items at mixed levels, save, quit, relaunch and load, and the inventory is identical, levels included.

### Step 3 — Field grid and tool pipeline

- [x] `FarmGrid`: per-tile state (untilled, tilled, watered, planted) stored in code, drawn in 3D (state in `Field` on the `Game` autoload, drawn by `FarmGrid`; "planted" arrives with crops in Step 5; tiles are saved from Step 6)
- [x] Target tile = tile in front of the player, highlighted (the tile where the tool lands, `reach` metres ahead)
- [x] `ToolDef` (extends `ItemDef`): RP cost, linked skill, hitbox shape, effect (RP cost and hit area size live per charge level in `ToolCharge`)
- [x] Swing: animation → hitbox active frames → effect on every tile hit
- [x] Hoe tills; watering can waters (with a water count, refilled at a pond or well) (15 uses; the well is at the field's north-east corner)
- [x] Hold to charge: wider area, higher RP cost (tap 1 tile, 0.6 s the 2×2 around the player, 1.2 s the 4×4 around the player; a bigger level waits for tool upgrades at the forge in Phase 6; the cost is data now and is spent from Step 4)
  - **Correction:** this item first said the areas were "like Rune Factory 4". They are not. RF4's starter tools don't charge, a bronze tool charges to 2×2, a silver hoe to 2×4, the only 4×4 is an upgraded platinum 4th charge, and charged areas snap to the field's 2×2 sections ([research › Tools, areas and charge](../rf4-farnia-research.md#tools-areas-and-charge)). Greenrune takes Farnia's 3×3 instead, gated by tier like RF4 and snapped to 3×3 blocks; fixed in [Phase 1.2](#phase-12--tool-feel).
- [x] "Pop" feedback on every hit: sound, particle, tiny camera shake (a thud for the hoe, a splash for the watering can, a slice for the sickle; only the hoe sets hit-stop and shake so far)

**Done when:** you till and water 20 tiles, charged and uncharged, and every swing shows its hitbox in debug view.

<a id="step-4--rp-hp-skills-weeks-89"></a>

### Step 4 — RP, HP, skills

- [x] RP and HP bars in the HUD (bottom left, with the numbers; base values in `data/vitals.tres`; RP, HP and skill XP are saved from Step 6)
- [x] Every tool use that changes the field spends RP, and one that changes nothing is free, like RF4 (the user's RF4 play); a swing that RP can't fully cover empties RP to 0 and costs 5% of max HP (`rp_leftover_hp_cost`), and at 0 RP a swing costs a flat 25% of max HP instead (`rp_short_hp_cost`; both rounded up; 25% is RF4's rule for crafting short of RP; the 5% leftover rule is the user's call, since RF4's sources don't say what happens to leftover RP; refilling the can and swinging it dry are free)
- [x] HP 0 → faint, wake with half HP and a gold penalty; RP stays as it was, like RF4 (`faint_wake_hp`) (the player wakes at `WakePoint` beside the bed indoors, the same day with the clock still running; the faint does not run the `DayTick`, the user's call)
- [x] `SkillDef` data: id, name, XP curve (`data/skills/`; the curve is `level_xp`, the total XP for each level)
- [x] 4–6 skills: tilling, watering, reaping, walking, sleeping (+1 optional) (reaping is data only until the sickle arrives in Step 5; sleeping levels from Step 5)
- [x] XP per use; level-up popup (walking earns XP per metre walked; a tool swing earns `xp_per_use` plus its charge level's `xp_bonus` once, not per tile, and only if it changed the field (soil or crop) on at least one tile; a swing that changes nothing gives no XP and costs no RP, and a watering can keeps its water)
- [x] Each level lowers that skill's RP cost and raises max RP (`rp_cost_cut_per_level` and `max_rp_per_level` on each `SkillDef`)

**Done when:** at level 1, normal farming empties RP by evening; at tilling level 5 a till visibly costs less.

**RP budget until the Step 5 clock (superseded).** This budget assumed a max RP of 300 at level 1. The data now starts at 100 (`base_max_rp` in `data/vitals.tres`), and [Phase 1.2](#phase-12--tool-feel) takes charging away from starter tools, so the numbers below no longer hold. [Phase 1.5](#phase-15--the-days-frame) re-measures a day and replaces this paragraph. The original text, kept as the record:

"By evening" becomes "a morning of tilling and watering most of the 12×12 field". Max RP at level 1 is 300. The hoe costs 5 / 15 / 30 per tap / 2×2 / 4×4 swing and the can 4 / 8 / 16, so tilling and watering one tile costs 9 RP by taps, 5.75 RP with 2×2 charges and 2.9 RP with 4×4 charges. RP runs out after about 33, 52 or 96 of the 144 tiles. Each skill level cuts 5% of the base cost, so at tilling level 5 a tap costs 4 instead of 5. Charge bonuses keep RF4's ratio to the base swing (hoe 3 XP with +30 / +80, can 4 XP with +20 / +40), divided by 5, so a hoe swing gives 1 / 3 / 6 XP and a can swing 1 / 2 / 3. At those values a charged swing earns about the same XP per RP as a tap, so a morning levels tilling to about 3 however you charge. Tilling level 2 takes 10 taps or 2 4×4 swings, and level 5 takes 100 taps or 17 4×4 swings. Unscaled, a morning of 4×4 swings reaches tilling level 6. Re-check in Step 7: once crops arrive, a normal day is mostly watering, which costs less than tilling.

### Step 5 — Crops, day tick, sleep

- [x] `CropDef` data: seed item, growth stages, days per stage, harvest item, sell price (`data/crops/`; `stage_days` holds the days in each stage before ripe, so `[1, 2]` is 3 stages over 3 days; the sell price stays on the harvest `ItemDef`, so it has one home; `Game.crops` is keyed by seed id)
- [x] Plant a seed on a tilled tile; a 3D model per stage (sowing works: like RF4, tapping Space with seeds selected sows one seed on the tilled, empty tile in front, not a 3×3 around the player, and holding it for `charge_hold_seconds` sows one seed on each tilled, empty tile of the 2×2 around the player (`data/sowing.tres`), until the stack runs out; sowing costs no RP and sows on release; the stage models are low-poly FBX models from the CC0 Quaternius LowPoly Crops Pack in `assets/crops/`, one file per stage set in `CropDef.stage_models`, cel-shaded like the other props)
  - Done: `Field.Soil` could not say "planted and watered", so now `Field` keeps a `Plot` per tilled tile with its own `watered` flag and its `Crop` (def, level, days), so an untilled tile can't be watered or sown; `Field.soil()` now only says how the ground looks. Seeds come in through `Field.sow()`.
  - **Correction:** RF4's charged sow covers one 2×2 field section, snapped to the grid, not the 2×2 around the player ([research › Corrections](../rf4-farnia-research.md#corrections-to-the-existing-research-and-plan)). Greenrune's charged sow covers the 3×3 block holding the player's tile, as Farnia's centres on the player; fixed in [Phase 1.2](#phase-12--tool-feel).
- [x] Clock: day starts at 06:00 and runs on past midnight, like RF4; HUD clock (`data/clock.tres`: 1 real second per game minute, indoors too; no faint at any hour, and staying up until 06:00 runs the `DayTick` with no HP, RP or gold change; the player yawns at 01:00 (`bedtime_hour`); the clock pauses while the sleep prompt, the bin screen or the debug console is open, a design default; console `time hh:mm`, 25:30 is 01:30 that night; the time is saved from Step 6)
- [x] House interior scene with the bed, entered through the house door (`scenes/house_interior.tscn`, built from boxes; a sub-scene of the farm at x = 100, so one player, HUD and saved position cover both; walk into the barn door to go in, onto the doormat to go out)
- [x] Bed interaction → sleep → next day (F beside the bed asks `sleep_question`; Yes at any hour sleeps until 06:00 the next morning, fully restores RP and HP (`sleep_rp_restore` and `sleep_hp_restore` in `data/vitals.tres`) and gives the sleeping skill's `xp_per_use` only for a bedtime before 01:00; every new morning opens on a black "Day N" screen that fades out, a design default; the Yes and No labels live in the scene; F does nothing while a tool is charging or swinging)
- [x] `DayTick`: one ordered pipeline at 06:00 (crops grow → soil dries → future hooks) (`Game.day_tick()`: day + 1 and the wake hour, then `Field.grow_crops()`, empty until crops arrive, then `Field.dry()`, then the `Game.day_started` signal; sleep and an all-nighter run it)
- [x] Sun: rotating `DirectionalLight3D`, gradient sky (`scripts/sun.gd`; the light rises at 05:00 and sets at 18:00; the colours turn a light blue sunrise by 06:30, full day 09:00 to 17:00, orange at 19:00 and night by 20:30, settled by the user; light, ambient and sky colours follow gradients on the `Sun` node in `farm.tscn`, kept on the node so they can be tuned by eye in the inspector, an exception to keeping numbers in `data/`; a design default, since no RF4 source gives the lighting phases)
- [x] Harvest: crop level = seed level (F on a ripe crop in front puts `harvest_count` of it in the bag at the crop's level, and the soil stays tilled; RF4 lifts the crop overhead first, which waits for a carry state; a crop stays put unless all of it fits, and a sickled ripe crop stays put when its seed has no room)
- [x] Sickle reaping: returns seeds; chance of +1 level (data-tuned) (`data/items/sickle.tres`, a `ToolDef` with the hoe's charges and RP; like RF4, a ripe crop gives no harvest but one seed, a level higher at `reap_level_up_chance`, 0.5; a sprouted unripe crop is destroyed with no seed; an unsprouted seed is untouched; XP goes to reaping once per swing that changes a crop; held in hand as `scenes/tools/sickle.tscn`; RF4's sickle-tier cap on seed level waits for tool upgrades in Phase 6)
- [x] 2 crops: turnip (fast), potato (slow) (RF4's numbers: turnip 3 days, 2 per crop, 30G; potato 7 days, 3 per crop, 90G; an unwatered day grows a crop by `dry_growth`, half a day, like the Japanese wiki's 0.5x; RF4's level and yield loss for a dry day and withering are left out; console `day [n]` runs the `DayTick` to skip days)

**Done when:** a planted turnip grows through its 3 stages over 3 watered sleeps; reaping a ripe crop sometimes returns higher-level seeds.

### Step 6 — Selling, save v2

- [x] Shipping bin: sold at 08:00, gold added (08:00, not 06:00, per the [RF4 research](../rf4-research.md#shipping-and-selling-researched); like RF4 the bin is a container: F beside it opens the bag's 24 slots next to the bin's 60, and a click moves a stack to the other side, onto a stack of the same item and level first, then into the first empty slot, and only if all of it fits; items come back out until they sell; an item with no sell price, like a tool, can't go in, as RF4's key items can't be shipped; the tree pauses while it is open, and F or Esc closes it; when the clock passes 08:00 everything in the bin sells and the bin empties, once a day; a load or a console `time` jump past 08:00 sells nothing, and sleeping sells nothing until 08:00 comes; a "+N G" popup shows the gold, a design default since RF4's sources don't say how the game tells you; gold shows under the clock; the bin is saved, and a save without it loads with an empty bin; `sell_hour` and `bin_size` live in `data/shipping.tres`)
- ~~Shop NPC: talk → "sell all" menu~~ Dropped: RF4 shops buy nothing, so the bin is the only way to sell (see the [RF4 research](../rf4-research.md#shipping-and-selling-researched); your own store comes in a later phase)
- [x] Price scales with item level (data-tuned) (RF4's table, rounded down: `level_percent` in `data/shipping.tres` gives each `ItemDef` category a percentage per level; crops and tools 100, 110 … 180, then 200 at level 10; seeds 100, 102 … 116, then 120; a turnip ships for 30G at level 1, 42G at level 5 and 60G at level 10; seed prices are RF4's, turnip 2G and potato 8G)
- [x] Save v2 adds: tiles (tilled, watered), crops (seed id, level, days), RP, HP, skill XP, time (`Game.minute`), watering-can water; v1 saves still load (console `save` / `load`; a value missing from the file loads as a new game has it, so a v1 save wakes at 06:00 with full RP and HP, no skill XP, an empty field and a full can; an unknown item, crop or skill is dropped with a warning; HP loads as at least 1)
  - Load the field in place (one bulk replace that emits `changed`), not by swapping `Game.field`: `FarmGrid` stays connected to the old object.
  - A load mid-swing must reset the player, or the swing spends water from a stack that is no longer in the inventory.

**Done when:** a v1 save loads into v2 without errors, and a level-5 turnip ships for more than a level-1 turnip (42G against 30G).

### Built alongside Steps 1–6

- [x] Stacks of at most 9, like RF4: a bag or bin slot holds up to 9 of one item at one level, and tools don't stack (see the [RF4 research](../rf4-research.md#shipping-and-selling-researched)) (`max_stack` in each item's `.tres`, 9 by default and 1 for tools; console `add turnip 1 50` fills 6 slots; the bin's 60 slots cap a day's sale at 540 items, as in RF4; a save with a stack over the limit loads it capped in its slot with the rest added back to the same bag or bin, and only what doesn't fit is dropped, with a warning)
- [x] Fatigue and Cold from all-nighters, like RF4: staying up through 06:00 has a small chance to cause Fatigue (higher RP costs), and another all-nighter while Fatigued has a small chance to cause Cold (RP drains over time); a bedtime by 05:59 avoids both, and sleep cures them (see [RF4 research](../rf4-research.md#fatigue-and-cold-researched)) (`data/ailments.tres`: a 20% chance for each, Fatigue doubles a tool use's RP cost, Cold takes 1% of max RP every 5 game minutes and stops at 0; no source gives numbers, so the chances and the drain are design defaults and the x2 is read from the Talisman halving RP costs; the name shows beside the RP bar with a popup when one starts or is cured; a faint doesn't cure them; saved in v2; console `ailment cold` toggles one)
- **Sun colours (settled).** The morning is light blue instead of orange, so it no longer looks like the dusk, and the light sets at 18:00. The user settled these by eye.

## Sub-phases

### Phase 1.1 — The field

**Goal:** the farm field looks and reads like an RF4 field before any tool touches it.

**Phase 1.1 is complete when:**
- The field is 9×12 plots (108) in twelve 3×3 blocks, 3 across and 4 deep, and each block shows a faint outline. *The size lives in `data/field.tres`; the user has since set it to 18×12 (24 blocks, 6 across and 4 deep).*
- A new game shows weeds, stones and branches scattered on the field.
- Untilled, tilled and watered soil are told apart in a 12:00 screenshot and a 22:00 screenshot.
- The whole field fits on screen from its centre without moving the camera.

**Steps:**
1. **Blender setup** (Blender — Claude: base). Turn the [research's Blender pipeline](../rf4-farnia-research.md#blender-pipeline) into a saved export preset or a Blender Python export script: glTF Binary `.glb` (CLAUDE.md's format), +Y Up, Apply Modifiers, Materials = Viewport (Placeholder writes no material, so Use External has nothing to map), no Draco or Meshopt, backface culling on, 1 unit = 1 m, transforms applied, origin at the base centre. Round-trip one 1×1 m test tile into the farm and map its material to the cel `ShaderMaterial` with Advanced Import Settings → Use External, as the Quaternius FBX files already do. Make the shared palette texture: one small atlas of colour squares that every Blender model UVs onto, mapped to one cel `ShaderMaterial`. Decided: palette atlas, not vertex colour; it matches the KayKit atlas and keeps one material for many models ([research › Vertex colour or palette texture](../rf4-farnia-research.md#vertex-colour-or-palette-texture)). Add `*.blend1` to `.gitignore`.
2. Set the field to 9×12 plots and move field size and block size (3) into `data/`; today the size is `FarmGrid.size = Vector2i(12, 12)` in `scenes/farm.tscn`. 9×12 holds twelve whole 3×3 blocks. `Field` reads the same resource, and `SaveGame.read()` skips out-of-bounds cells with a warning: today it has no bounds check, so an old 12×12 save would load plots off the field.
3. Add blocks to `FarmGrid` (cell → block index) and draw a faint outline per block.
4. **Field ground and soil meshes** (Blender — Claude: base): block out the field ground, its border and one tile-sized mesh each for untilled, tilled and watered soil, origin on the tile grid, UVs on the shared palette texture, exported with the step 1 preset. (Blender — user: polish): furrows, edges and colour.
5. Make the soil states read from the gameplay camera: tilled darker and furrowed, watered darker still with a sheen. They must also read at 22:00 under the current lighting; [Phase 3.2](phase-03-seasons-cooking-orders.md#phase-32--weather-season-looks-and-new-crops) re-checks them under each season's light.
6. Add `DebrisDef` (id, model, how it is cleared, drop) and place a starting set of weeds, stones and branches in a new game. Debris models: try Quaternius nature models first; where none reads well, (Blender — Claude: base) blocks one out on the tile grid and (Blender — user: polish) shapes and colours it.
7. Make tools skip plots that hold debris: a swing there changes nothing, so it costs no RP.
8. Tune the outdoor camera in `data/camera.tres` with side-by-side screenshots of the 9×12 field and commit the chosen pitch, arm and FOV. `data/camera.tres` currently has pitch 45°, arm 20, FOV 35. The user commits or discards their uncommitted edit to that file first.
9. Re-check the props around the field: water source in a corner like RF4's north-east well, bin by the house door, nothing blocking the camera. Small farm props come from the packs first; a missing one is (Blender — Claude: base) then (Blender — user: polish).

**Checklist:**
- [x] Field size and block size live in `data/`, not in `farm_grid.gd` or `farm.tscn`
- [x] A test model exported with the preset sits centred on its tile, cel-shaded through the shared palette texture, with no import warnings
- [x] Block outlines are visible at the gameplay camera distance and hidden under a planted crop's leaves
- [x] A new game places the starting debris, and debris positions survive save → load
- [x] A 12×12 save from before this change loads with no plot outside the 9×12 field and a warning in the output
- [x] A swing on a debris plot changes nothing and costs no RP
- [x] Watered and dry tilled soil differ by at least 25% in brightness at 12:00 and at 22:00 *(default)*, measured from screenshots
- [x] From the field centre the whole field is on screen with no camera move
- [x] Each soil and debris model is under 500 triangles *(default)*
- [x] 60 fps on the farm with every plot tilled and planted (Godot's FPS monitor)

**Out of scope for this phase:** tool feel and charge areas (1.2), clearing debris by hand and debris regrowth (1.3), withered soil (1.4), soil stats and giant crops ([NOT_IN_SCOPE.md](../../NOT_IN_SCOPE.md)). Stumps and rocks stay off the field: RF4 clears them only with the axe and hammer, which its tutorial requests hand out as farm tools ([research › Clearing debris](../rf4-farnia-research.md#clearing-debris)). Greenrune keeps the axe and hammer in [Phase 4 Step 5](phase-04-combat-core.md), so the Phase 1 field has none.

**Reference:** RF4's home field is 18 sections of 2×2 laid out 3×6, with faint section outlines, and starts covered in weeds, stones and branches ([research › Environment](../rf4-farnia-research.md#facts-rf4s-selphia-and-the-field)); RF4's 2×2 stays a reference only. Farnia shows a visible tile grid and charges to 3×3 ([research › Phase 1.1](../rf4-farnia-research.md#phase-11--the-field), [› Farnia Village tool areas](../rf4-farnia-research.md#farnia-village-tool-areas-3x3-question)); export, origin, materials and polycount ([research › Blender pipeline](../rf4-farnia-research.md#blender-pipeline)).

### Phase 1.2 — Tool feel

**Goal:** the hoe, can, sickle and seeds charge to Farnia's 3×3 around the player, gated by tool tier, and every tap and charge gives clear, timed feedback.

**Phase 1.2 is complete when:**
- A cheap hoe, can or sickle taps the one plot in front and never charges.
- A bronze hoe held to charge marks the 3×3 block holding the player's tile before release, then the soil change, a sound, dust and the RP drop land on the same hit. A bronze can and a charged sow cover the same block; a tap with seeds sows one plot.
- The hoe swings two-handed, straight forward in an overhead arc along the facing line, with both hands on the shaft; the can and sickle swing one-handed.
- The can's water gauge shows on the HUD while the can is selected, drops one step per plot watered, refills with a sound, and tapping the can while walking waters each plot passed over.

**Steps:**
1. **Tool data shape.** Keep today's shape. `ToolDef` (`scripts/tool_def.gd`) holds `charges: Array[ToolCharge]`, index 0 the tap. `ToolCharge` (`scripts/tool_charge.gd`) holds `hold_seconds`, `rp_cost` and `xp_bonus`. A tier is a separate item `.tres` with its own `charges` list: `cheap_hoe.tres` has 1 charge (the tap), `bronze_hoe.tres` has 2 (tap, 3×3), and so on. There is no tier class and no tier table. Change these:
   - `ToolCharge.size` goes from a square `int` (tiles per side, `@export_range(1, 8)`) to a `Vector2i` of width × depth in tiles, depth along the facing direction. The old range can't hold 9.
   - Every charged area is centred on the player and snapped to the field's 3×3 blocks: it starts at the block holding the player's tile and runs that many blocks along the facing direction. The tap still hits the plot in front. The axe and hammer follow the same rule in Phase 4. Plots of a line that runs off the field are skipped, as `FarmGrid.cells_hit()` leaves off-field cells out now.
   - `SowingDef` (`data/sowing.tres`, now an `int` `charge_size` of 2 with `@export_range(1, 8)`) follows the same rule and shape: `charge_size` becomes `Vector2i(3, 3)`. A tap sows 1 plot; a charge sows the player's 3×3 block.
2. **Split the tools into tiers.** Today's `data/items/hoe.tres`, `watering_can.tres` and `sickle.tres` each carry a tap, a 2×2 charge and a 4×4 charge. Replace each with a cheap item (tap only) and a bronze item (tap + 3×3). Silver and higher arrive with the [Phase 6](phase-06-forge-craft.md) forge. First update or retire the prototype in `sandbox/prototypes/chibi_hoe/`, which loads `data/items/hoe.tres`.

   | Tier | Charged area (width × depth) | Can capacity | Hold time |
   |---|---|---|---|
   | Cheap (starter) | tap only | 15 | — |
   | Bronze | 3×3: the player's block | 36 | 0.6 s *(default)* |
   | Silver | 3×6: the player's block and the next one ahead | sized to the area *(default)* | 1.2 s *(default)* |
   | Gold | 3×9: three blocks in a line *(default)* | sized to the area *(default)* | 1.8 s *(default)* |
   | Platinum | *(default)*, set when the forge arrives | sized to the area *(default)* | — |

   The same areas apply to the hoe, can and sickle. For reference, RF4's bronze charges to 2×2, its silver hoe to 2×4 and its platinum tools to 3×3 at charge 3, and Farnia shows 3×3 from the first days ([research › Tools, areas and charge](../rf4-farnia-research.md#tools-areas-and-charge), [› Farnia Village tool areas](../rf4-farnia-research.md#farnia-village-tool-areas-3x3-question)).
3. **Bronze items.** Bronze tools are tinted versions of the cheap hand models *(default)*, testable from the console (`add bronze_hoe`). The first bronze tool is bought at the [Phase 2.3](phase-02-town-npcs.md#phase-23--the-shop) shop *(default)*; RF4 sells its bronze tools at Bado's for 3,000 G each after the Rafflesia boss ([research › Game plan](../rf4-farnia-research.md#1-game-plan-how-rf4-paces-its-opening)). The [Phase 6](phase-06-forge-craft.md) forge makes the higher tiers.
4. **Two-handed hoe.** Swing the hoe with KayKit's `2H_Melee_Attack_Chop` (today `1H_Melee_Attack_Chop` in `hoe.tres`); the axe and hammer use it too in Phase 4. The can (`Use_Item`) and sickle (`1H_Melee_Attack_Slice_Horizontal`) stay one-handed. If the left hand misses the shaft, adjust the hoe's grip in Blender (Blender — Claude: base; Blender — user: polish). Add IK only if that fails. Build on the result of the prototype in `sandbox/prototypes/chibi_hoe/`.
5. **Straight swing.** The tool travels in an overhead arc in the vertical plane along the facing direction, never diagonally across the body, as in RF4 and Farnia. Fix a drifting swing with the cheapest fix that works, in this order: pick a straight clip (`2H_Melee_Attack_Chop` or another KayKit clip); rotate the hand attachment or the grip; add a bone-rotation offset during the swing; make a custom clip in Blender. Targeting is unchanged.
6. **Water per plot.** The can spends 1 water per plot it waters, not 1 per swing as `scripts/farm.gd` `_pay()` does now. Already-wet and untilled plots cost nothing, as a swing that changes nothing is free. A charged swing with too little water waters only as many plots as it has water for, in a fixed order *(default)*. Capacity per tier is in the table above; RF4's Cheap Waterpot holds 80 (single source).
7. Add a target marker on the tap plot (RF4: a red marker and a red shadow) and an outline of the charge area while held.
8. Add per-level charge cues: the marker grows, the tool glows, a rising tone plays at each level. Releasing early uses the last level reached.
9. Add the water gauge to the HUD and a refill sound.
10. Add "water as you walk": repeated taps while moving water each new plot in front.
11. Add RP feedback: a popup or bar flash on spend, and a dull "no effect" sound for a swing that changes nothing (it stays free).
12. Tune swing speed, impact time, hit-stop and shake per `ToolDef`; the can and sickle get their own values (only the hoe has hit-stop and shake now).

**Checklist:**
- [x] A cheap tool never enters a charge state, however long the button is held
- [x] A bronze charge covers exactly the 3×3 block holding the player's tile; a silver charge that block and the next one ahead; no charge straddles a block boundary
- [x] A line that runs off the field skips the off-field plots and changes the rest
- [ ] The hoe swing shows both hands on the shaft from the gameplay camera
- [ ] The hoe head's sideways drift from the facing line stays under N cm through the swing *(default; set from the prototype)*
- [x] Every swing that changes a plot plays its sound and particle on the impact frame
- [x] Hit-stop 50 ms *(default, from the Phase 0 feel test)* on hoe hits; the can has none
- [x] Each charge level has a distinct marker size and sound
- [x] The target marker is visible on every soil state and over debris
- [x] The water gauge drops one step per plot watered, does not change on a swing that waters nothing, and a charge with too little water waters only that many plots
- [ ] Tool tiers, charge areas, hold times, RP costs and can capacities live in `data/`
- [ ] Twenty taps in a row at 60 fps with no dropped sound

**Out of scope for this phase:** forging and upgrading tools (Phase 6), the sickle-tier cap on reaped seed level (Phase 6), selling bronze tools (2.3), axe and hammer (Phase 4), combat use of tools, new tool models.

**Reference:** RF4's tool tiers, the "water as you walk" tap and per-stage RP ([research › Tools, areas and charge](../rf4-farnia-research.md#tools-areas-and-charge)); Farnia's 3×3 charges ([› Farnia Village tool areas](../rf4-farnia-research.md#farnia-village-tool-areas-3x3-question)) and its hoe held overhead, then slammed down ([› Character style](../rf4-farnia-research.md#farnia-village-observation)); the red target marker and water meter ([research › Design](../rf4-farnia-research.md#3-design-art-direction-ui-and-feedback)); [research › Phase 1.2](../rf4-farnia-research.md#phase-12--tool-feel).

### Phase 1.3 — Hands and carrying

**Goal:** the player can lift, carry, throw and put away anything small, and clears the field's starting debris by hand.

**Phase 1.3 is complete when:**
- Pressing interact on a weed, stone or branch lifts it over the head; pressing again throws it a short distance. Hands are the only way to clear debris in Phase 1.
- A carried item goes into the bag with one button.
- A harvested crop comes up over the head, and thrown at the shipping bin it lands in the bin.
- Untended, untilled ground grows new weeds within 3 days *(default, in data)*.

**Steps:**
1. Add a carry state to the player: lift animation, held-item anchor above the head, walk while carrying, throw arc. Use the KayKit clips; no new animation.
2. Add the world item: a billboard `Sprite3D` using the item's icon, per the hybrid 2D/3D convention.
3. Hold from the bag: with a bag item selected, interact lifts one of it overhead, and the store button puts it back. Gifting (2.2) and taming (Phase 5) use this hold.
4. Route hand-harvest through the carry state: harvest → crop over the head → throw or store. This is the lift Step 5 left for a carry state.
5. Make the shipping bin accept thrown items.
6. Give each `DebrisDef` its drop when cleared (none for weeds) *(default per debris type)*.
7. Add debris regrowth on untilled, empty plots in the `DayTick`; the rate lives in data *(default; RF4's rate was not found)*.

**Checklist:**
- [ ] Lift, throw and store each play a sound and a short animation
- [ ] A thrown item lands on the ground as a billboard and can be picked up again
- [ ] Carrying blocks tool use until the item is thrown or stored
- [ ] Selecting a bag item and pressing interact holds it overhead; the store button puts it back with the stack count unchanged
- [ ] A crop thrown into the bin appears in the bin's grid and sells at 08:00
- [ ] Items on the ground, a carried item and regrown debris survive save → load
- [ ] Debris regrowth rate lives in data; tilled or planted plots never grow debris

**Out of scope for this phase:** gifting (2.2), stumps and rocks (Phase 4), the sickle cutting weeds (RF4 allows it), XP for sowing and picking up (RF4's Love and Light; [Phase 8](phase-08-town-life.md) step 6, with the skills that grow to ~12), stacking many crops in the hands (Farnia's feature), auto-collecting same-type items.

**Reference:** RF4's lift, throw and store controls and "Toss your turnip into the Shipping Box" ([research › Design](../rf4-farnia-research.md#3-design-art-direction-ui-and-feedback)); debris cleared by hand and regrowth ([research › Clearing debris](../rf4-farnia-research.md#clearing-debris)); element skills for sowing and picking up ([research › RP and skills](../rf4-farnia-research.md#rp-and-skills)); [research › Phase 1.3](../rf4-farnia-research.md#phase-13--hands-and-carrying).

### Phase 1.4 — Crops

**Goal:** every crop stage reads at a glance, and sowing, ripening, withering and harvest each have their own feedback.

**Phase 1.4 is complete when:**
- A sown plot shows seeds on the soil, and each later stage has a different silhouette from the gameplay camera.
- A ripe crop is recognisable as ripe without the debug view.
- A crop that changed colour at 06:00 and goes unwatered that day is Withered Grass at the next 06:00.
- Some harvests release a rune orb that, when touched, refills half of max RP and raises one skill a level.

**Steps:**
1. **Crop stage models** (Blender — Claude: base): open the Quaternius turnip and potato stages, or block out new ones Farnia-style, one low-poly model per stage; set the origin to the base centre on the tile grid, apply transforms, keep the budget, export with the Phase 1.1 preset ([research › Workflow for one crop stage](../rf4-farnia-research.md#workflow-for-one-crop-stage-summary)). (Blender — user: polish): final silhouettes and colours, checked from the gameplay camera. Claude points `CropDef.stage_models` at the new files.
2. **Seeded-soil model** (Blender — Claude: base; Blender — user: polish): RF4 shows "4 little seeds" on a sown plot.
3. Add a ripe cue: a small idle bob or sparkle *(default)*.
4. Add RF4's withering, replacing Step 5's "withering left out": at 06:00 some crops change colour; one left unwatered that day dies at the next 06:00 and becomes Withered Grass, a debris item that can be carried and hoed into the soil. Drive it from crop HP as RF4 does (watered about −3 a day, unwatered −15 to −18, colour change at a threshold *(default)*, death at 0). The withered look is a tint or a (Blender — Claude: base / user: polish) model.
5. Add rune orbs: a spawn chance per harvest *(default; RF4's base chance was not found)*, pickup on touch, 50% of max RP back and +1 level to one skill (RF4's Rune Orb), all in data. Which skill rises is a *(default)*: a random farm skill. The orb is a billboard sprite.
6. Add the harvest pop: sound, a few particles, the crop leaping into the hands.

**Checklist:**
- [ ] Each stage has its own model in `CropDef.stage_models`, and no two stages share a silhouette
- [ ] Each crop stage model is under 500 triangles *(default)*; a fully planted field holds 60 fps
- [ ] Crop HP rules, the colour-change threshold and rune orb odds live in data
- [ ] A withered crop and a pending colour change both survive save → load
- [ ] Touching a rune orb restores half of max RP and shows the level-up popup for one skill
- [ ] Sickle-reaping still returns seeds with the level-up chance

**Out of scope for this phase:** new crop types (3.2), regrowing crops, giant crops, soil stats, fertilizer, seasons, Runeys.

**Reference:** "4 little seeds", colour change then death into Withered Grass, crop HP, Rune Orbs ([research › Crops and growth](../rf4-farnia-research.md#crops-and-growth), [› Harvest, carrying, shipping and runes](../rf4-farnia-research.md#harvest-carrying-shipping-and-runes)); polycount budget ([research › Polycount](../rf4-farnia-research.md#polycount)); [research › Phase 1.4](../rf4-farnia-research.md#phase-14--crops).

### Phase 1.5 — The day's frame

**Goal:** a new game's first morning, the HUD and the day's end feel finished.

**Phase 1.5 is complete when:**
- A new game starts on the field with the cheap hoe, cheap can and turnip seeds, after a short lesson that pauses the clock until one plot is tilled, sown and watered.
- The HUD shows the date, time, gold, HP and RP at all times.
- A fresh level-1 player doing normal farm work runs out of RP between 15:00 and 18:00 *(default)*.
- At 08:00 the bin's gold arrives with a visible and audible cue, and sleeping fades to a new day showing the date.

**Steps:**
1. Build the first-morning lesson: frozen clock, three prompts (till, sow, water), released when all three are done. Text lives in data. A prompt at the start of a new game offers to skip it *(default)*.
2. Set the starting kit in data: `cheap_hoe`, `cheap_watering_can`, 1 turnip seed, then 9 more after the first watering (RF4's kit). Today a new game starts with an empty bag and tools come from the console. The cheap sickle arrives on day 2 *(default)* until the [Phase 2.4](phase-02-town-npcs.md#phase-24--request-box) request box gives it. This settles the open question of starting items.
3. Add the date line to the HUD (Spring and the day number; Phase 2.2 adds a weekday counter and Phase 3.1 shows the weekday). Size all HUD text from one theme value.
4. Polish the 08:00 sale cue and the "Day N" fade.
5. Re-tune the RP budget. `base_max_rp` is 100 in `data/vitals.tres`, while Step 4's budget assumed 300 and charged starter tools; an automated run hit 0 RP on day 1 at 06:53 after 18 tool uses. On the 9×12 field with cheap tools tapping one plot, measure a normal day 1 and set max RP, tap costs and the skill discount so RP runs out between 15:00 and 18:00. Write the measured day here in place of Step 4's superseded budget.

**Checklist:**
- [ ] The lesson's clock freeze ends after the third action, and a save mid-lesson resumes it after load
- [ ] The starting kit and lesson text live in data
- [ ] HUD text size comes from one theme value
- [ ] The 08:00 cue plays once per day, also after a load
- [ ] A fresh day-1 player at level 1 runs out of RP between 15:00 and 18:00 *(default)* doing normal farm work

**Out of scope for this phase:** title screen and options menu (M1), request box (2.4), weekdays (counter in 2.2, shown in 3.1), calendar UI (3.1).

**Reference:** RF4's time-frozen field lesson and starting kit ([research › Game plan](../rf4-farnia-research.md#1-game-plan-how-rf4-paces-its-opening)); the HUD RF4 always shows ([research › Design](../rf4-farnia-research.md#3-design-art-direction-ui-and-feedback)); [research › Phase 1.5](../rf4-farnia-research.md#phase-15--the-days-frame).

### Phase 1.6 — Five-day gate

**Goal:** the old Step 7 playtest, run against the polished farm.

**Phase 1.6 is complete when:**
- Five in-game days from a new game run with a save, quit and reload in the middle.
- Every outcome under "Phase 1 is complete when" at the top of this file shows in that run.

**Steps:**
1. Play five in-game days from a new game, with notes.
2. Tune RP costs, the XP curve, reap odds, can capacity and debris regrowth from the notes.
3. Fix every bug found; anything new goes to [NOT_IN_SCOPE.md](../../NOT_IN_SCOPE.md).

**Checklist:**
- [ ] The values tuned from the notes live in `data/`
- [ ] The five-day run has no bugs left open

**Out of scope for this phase:** anything new.

**Reference:** [research › Phase 1.6](../rf4-farnia-research.md#phase-16--five-day-gate); [endgame.md › Definition of done](../endgame.md#definition-of-done).
