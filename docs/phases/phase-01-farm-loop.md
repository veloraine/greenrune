# Phase 1 — Farm loop

**Goal:** the smallest playable RF-style day: walk, swing tools, spend RP, level skills, grow and reap levelled crops, sell, sleep, save.
**Estimate:** 3–4 months (~13–17 weeks at 8 hrs/week).
**Starts when:** [Phase 0](../../PHASE_0_CHECKLIST.md) is done and Godot MCP is set up ([plan.md](../plan.md#phase-1-prerequisites--godot-mcp-setup-do-at-the-start-of-phase-1)).
**Background:** [plan.md › Phase 1](../plan.md#phase-1--farming-prototype-3d-34-months), [research › Farming, RP, Skills](../rf4-research.md#2-systems-and-how-they-work).

Every checked item must meet the [definition of done](../endgame.md#definition-of-done).

## Step 1 — Skeleton, player, farm scene (weeks 1–2)

- [x] Folder layout: `scenes/`, `scripts/`, `data/items/`, `data/crops/`, `data/skills/`, `ui/`
- [x] Input map: move, use tool, next/prev hotbar slot, interact, menu (WASD, Space/left click, E/Q or mouse wheel, F, Tab/Esc)
- [x] Farm scene from KayKit/Quaternius: house with bed, ~12×12 field, shipping bin, fences, trees (`scenes/farm.tscn`; the bed is in the house interior from Step 5)
- [x] Player: `CharacterBody3D` + KayKit model + ~~Mixamo~~ KayKit built-in idle/run
- [x] Camera: `SpringArm3D` + `Camera3D` at the fixed RF4 angle, follows the player (`scenes/camera_rig.tscn`)
- [x] Main scene runs with F5

**Done when:** you walk around the farm at 60 fps and the camera never clips through props.

## Step 2 — Item data, inventory, save v1 (weeks 2–3)

- [x] `ItemDef` resource: id, name, icon, category, base sell price, max stack (one `.tres` per item in `data/items/`; icons still to paint)
- [x] `ItemStack`: item id + level (1–10) + count (holds the `ItemDef` in memory, the id in saves)
- [x] Inventory model (24 slots) + 8-slot hotbar UI; scroll to select (the hotbar is slots 0–7; wheel or Q/E)
- [x] Debug command to add any item at any level (backquote opens the console: `add <item> [level] [count]`, `inv`)
- [x] Save v1 as JSON with a `version` field: inventory, player position, day, gold (`user://save.json`)
- [x] Load from the title screen or a debug key (console `save` / `load`; the title screen comes later)

**Done when:** you add items at mixed levels, save, quit, relaunch and load, and the inventory is identical, levels included.

## Step 3 — Field grid and tool pipeline (weeks 4–7)

- [x] `FarmGrid`: per-tile state (untilled, tilled, watered, planted) stored in code, drawn in 3D (state in `Field` on the `Game` autoload, drawn by `FarmGrid`; "planted" arrives with crops in Step 5; tiles are saved from Step 6)
- [x] Target tile = tile in front of the player, highlighted (the tile where the tool lands, `reach` metres ahead)
- [x] `ToolDef` (extends `ItemDef`): RP cost, linked skill, hitbox shape, effect (RP cost and hit area size live per charge level in `ToolCharge`)
- [x] Swing: animation → hitbox active frames → effect on every tile hit
- [x] Hoe tills; watering can waters (with a water count, refilled at a pond or well) (15 uses; the pond is east of the field)
- [x] Hold to charge: wider area, higher RP cost (tap 1 tile, 0.6 s the 2×2 around the player, 1.2 s the 4×4 around the player, like Rune Factory 4; a bigger level waits for tool upgrades at the forge in Phase 6; the cost is data now and is spent from Step 4)
- [x] "Pop" feedback on every hit: sound, particle, tiny camera shake (a thud for the hoe, a splash for the watering can, a slice for the sickle; only the hoe sets hit-stop and shake so far)

**Done when:** you till and water 20 tiles, charged and uncharged, and every swing shows its hitbox in debug view.

## Step 4 — RP, HP, skills (weeks 8–9)

- [x] RP and HP bars in the HUD (bottom left, with the numbers; base values in `data/vitals.tres`; RP, HP and skill XP are saved from Step 6)
- [x] Every tool use that changes the field spends RP, and one that changes nothing is free, like RF4 (the user's RF4 play); a swing that RP can't fully cover empties RP to 0 and costs 5% of max HP (`rp_leftover_hp_cost`), and at 0 RP a swing costs a flat 25% of max HP instead (`rp_short_hp_cost`; both rounded up; 25% is RF4's rule for crafting short of RP; the 5% leftover rule is the user's call, since RF4's sources don't say what happens to leftover RP; refilling the can and swinging it dry are free)
- [x] HP 0 → faint, wake with half HP and a gold penalty; RP stays as it was, like RF4 (`faint_wake_hp`) (the player wakes at `WakePoint` beside the bed indoors, the same day with the clock still running; the faint does not run the `DayTick`, the user's call)
- [x] `SkillDef` data: id, name, XP curve (`data/skills/`; the curve is `level_xp`, the total XP for each level)
- [x] 4–6 skills: tilling, watering, reaping, walking, sleeping (+1 optional) (reaping is data only until the sickle arrives in Step 5; sleeping levels from Step 5)
- [x] XP per use; level-up popup (walking earns XP per metre walked; a tool swing earns `xp_per_use` plus its charge level's `xp_bonus` once, not per tile, and only if it changed the field (soil or crop) on at least one tile; a swing that changes nothing gives no XP and costs no RP, and a watering can keeps its water)
- [x] Each level lowers that skill's RP cost and raises max RP (`rp_cost_cut_per_level` and `max_rp_per_level` on each `SkillDef`)

**Done when:** at level 1, normal farming empties RP by evening; at tilling level 5 a till visibly costs less.

**RP budget until the Step 5 clock.** "By evening" becomes "a morning of tilling and watering most of the 12×12 field". Max RP at level 1 is 300. The hoe costs 5 / 15 / 30 per tap / 2×2 / 4×4 swing and the can 4 / 8 / 16, so tilling and watering one tile costs 9 RP by taps, 5.75 RP with 2×2 charges and 2.9 RP with 4×4 charges. RP runs out after about 33, 52 or 96 of the 144 tiles. Each skill level cuts 5% of the base cost, so at tilling level 5 a tap costs 4 instead of 5. Charge bonuses keep RF4's ratio to the base swing (hoe 3 XP with +30 / +80, can 4 XP with +20 / +40), divided by 5, so a hoe swing gives 1 / 3 / 6 XP and a can swing 1 / 2 / 3. At those values a charged swing earns about the same XP per RP as a tap, so a morning levels tilling to about 3 however you charge. Tilling level 2 takes 10 taps or 2 4×4 swings, and level 5 takes 100 taps or 17 4×4 swings. Unscaled, a morning of 4×4 swings reaches tilling level 6. Re-check in Step 7: once crops arrive, a normal day is mostly watering, which costs less than tilling.

## Step 5 — Crops, day tick, sleep (weeks 10–12)

- [x] `CropDef` data: seed item, growth stages, days per stage, harvest item, sell price (`data/crops/`; `stage_days` holds the days in each stage before ripe, so `[1, 2]` is 3 stages over 3 days; the sell price stays on the harvest `ItemDef`, so it has one home; `Game.crops` is keyed by seed id)
- [x] Plant a seed on a tilled tile; a 3D model per stage (sowing works: like RF4, tapping Space with seeds selected sows one seed on the tilled, empty tile in front, not a 3×3 around the player, and holding it for `charge_hold_seconds` sows one seed on each tilled, empty tile of the 2×2 around the player (`data/sowing.tres`), until the stack runs out; sowing costs no RP and sows on release; the stage models are low-poly FBX models from the CC0 Quaternius LowPoly Crops Pack in `assets/crops/`, one file per stage set in `CropDef.stage_models`, cel-shaded like the other props)
  - Done: `Field.Soil` could not say "planted and watered", so now `Field` keeps a `Plot` per tilled tile with its own `watered` flag and its `Crop` (def, level, days), so an untilled tile can't be watered or sown; `Field.soil()` now only says how the ground looks. Seeds come in through `Field.sow()`.
- [x] Clock: day starts at 06:00 and runs on past midnight, like RF4; HUD clock (`data/clock.tres`: 1 real second per game minute, indoors too; no faint at any hour, and staying up until 06:00 runs the `DayTick` with no HP, RP or gold change; the player yawns at 01:00 (`bedtime_hour`); the clock pauses while the sleep prompt, the bin screen or the debug console is open, a design default; console `time hh:mm`, 25:30 is 01:30 that night; the time is saved from Step 6)
- [x] House interior scene with the bed, entered through the house door (`scenes/house_interior.tscn`, built from boxes; a sub-scene of the farm at x = 100, so one player, HUD and saved position cover both; walk into the barn door to go in, onto the doormat to go out)
- [x] Bed interaction → sleep → next day (F beside the bed asks `sleep_question`; Yes at any hour sleeps until 06:00 the next morning, fully restores RP and HP (`sleep_rp_restore` and `sleep_hp_restore` in `data/vitals.tres`) and gives the sleeping skill's `xp_per_use` only for a bedtime before 01:00; every new morning opens on a black "Day N" screen that fades out, a design default; the Yes and No labels live in the scene; F does nothing while a tool is charging or swinging)
- [x] `DayTick`: one ordered pipeline at 06:00 (crops grow → soil dries → future hooks) (`Game.day_tick()`: day + 1 and the wake hour, then `Field.grow_crops()`, empty until crops arrive, then `Field.dry()`, then the `Game.day_started` signal; sleep and an all-nighter run it)
- [x] Sun: rotating `DirectionalLight3D`, gradient sky (`scripts/sun.gd`; sunrise 05:00, sunset 20:00; light, ambient and sky colours follow gradients on the `Sun` node in `farm.tscn`, kept on the node so they can be tuned by eye in the inspector, an exception to keeping numbers in `data/`; a design default, since no RF4 source gives the lighting phases)
- [x] Harvest: crop level = seed level (F on a ripe crop in front puts `harvest_count` of it in the bag at the crop's level, and the soil stays tilled; RF4 lifts the crop overhead first, which waits for a carry state; a crop stays put unless all of it fits, and a sickled ripe crop stays put when its seed has no room)
- [x] Sickle reaping: returns seeds; chance of +1 level (data-tuned) (`data/items/sickle.tres`, a `ToolDef` with the hoe's charges and RP; like RF4, a ripe crop gives no harvest but one seed, a level higher at `reap_level_up_chance`, 0.5; a sprouted unripe crop is destroyed with no seed; an unsprouted seed is untouched; XP goes to reaping once per swing that changes a crop; held in hand as `scenes/tools/sickle.tscn`; RF4's sickle-tier cap on seed level waits for tool upgrades in Phase 6)
- [x] 2 crops: turnip (fast), potato (slow) (RF4's numbers: turnip 3 days, 2 per crop, 30G; potato 7 days, 3 per crop, 90G; an unwatered day grows a crop by `dry_growth`, half a day, like the Japanese wiki's 0.5x; RF4's level and yield loss for a dry day and withering are left out; console `day [n]` runs the `DayTick` to skip days)

**Done when:** a planted turnip grows through its 3 stages over 3 watered sleeps; reaping a ripe crop sometimes returns higher-level seeds.

## Step 6 — Selling, save v2 (weeks 13–14)

- [x] Shipping bin: sold at 08:00, gold added (08:00, not 06:00, per the [RF4 research](../rf4-research.md#shipping-and-selling-researched); like RF4 the bin is a container: F beside it opens the bag's 24 slots next to the bin's 60, and a click moves a stack to the other side, onto a stack of the same item and level first, then into the first empty slot, and only if all of it fits; items come back out until they sell; an item with no sell price, like a tool, can't go in, as RF4's key items can't be shipped; the tree pauses while it is open, and F or Esc closes it; when the clock passes 08:00 everything in the bin sells and the bin empties, once a day; a load or a console `time` jump past 08:00 sells nothing, and sleeping sells nothing until 08:00 comes; a "+N G" popup shows the gold, a design default since RF4's sources don't say how the game tells you; gold shows under the clock; the bin is saved, and a save without it loads with an empty bin; `sell_hour` and `bin_size` live in `data/shipping.tres`)
- ~~Shop NPC: talk → "sell all" menu~~ Dropped: RF4 shops buy nothing, so the bin is the only way to sell (see the [RF4 research](../rf4-research.md#shipping-and-selling-researched); your own store comes in a later phase)
- [x] Price scales with item level (data-tuned) (RF4's table, rounded down: `level_percent` in `data/shipping.tres` gives each `ItemDef` category a percentage per level; crops and tools 100, 110 … 180, then 200 at level 10; seeds 100, 102 … 116, then 120; a turnip ships for 30G at level 1, 42G at level 5 and 60G at level 10; seed prices are RF4's, turnip 2G and potato 8G)
- [x] Save v2 adds: tiles (tilled, watered), crops (seed id, level, days), RP, HP, skill XP, time (`Game.minute`), watering-can water; v1 saves still load (console `save` / `load`; a value missing from the file loads as a new game has it, so a v1 save wakes at 06:00 with full RP and HP, no skill XP, an empty field and a full can; an unknown item, crop or skill is dropped with a warning; HP loads as at least 1)
  - Load the field in place (one bulk replace that emits `changed`), not by swapping `Game.field`: `FarmGrid` stays connected to the old object.
  - A load mid-swing must reset the player, or the swing spends water from a stack that is no longer in the inventory.

**Done when:** a v1 save loads into v2 without errors, and a level-5 turnip ships for more than a level-1 turnip (42G against 30G).

## Step 7 — Playtest and tune (weeks 15–16)

- [ ] Play 5 in-game days from a new game
- [ ] Tune RP costs, XP curve and reap odds from notes
- [ ] Fix every bug found; anything new goes to [NOT_IN_SCOPE.md](../../NOT_IN_SCOPE.md)

**Done when:** the 5-day run has no bugs left open.

**Later, not needed for Step 7:**

- [x] Stacks of at most 9, like RF4: a bag or bin slot holds up to 9 of one item at one level, and tools don't stack (see the [RF4 research](../rf4-research.md#shipping-and-selling-researched)) (`max_stack` in each item's `.tres`, 9 by default and 1 for tools; console `add turnip 1 50` fills 6 slots; the bin's 60 slots cap a day's sale at 540 items, as in RF4; a save with a stack over the limit loads it capped in its slot with the rest added back to the same bag or bin, and only what doesn't fit is dropped, with a warning)
- [x] Fatigue and Cold from all-nighters, like RF4: staying up through 06:00 has a small chance to cause Fatigue (higher RP costs), and another all-nighter while Fatigued has a small chance to cause Cold (RP drains over time); a bedtime by 05:59 avoids both, and sleep cures them (see [RF4 research](../rf4-research.md#fatigue-and-cold-researched)) (`data/ailments.tres`: a 20% chance for each, Fatigue doubles a tool use's RP cost, Cold takes 1% of max RP every 5 game minutes and stops at 0; no source gives numbers, so the chances and the drain are design defaults and the x2 is read from the Talisman halving RP costs; the name shows beside the RP bar with a popup when one starts or is cured; a faint doesn't cure them; saved in v2; console `ailment cold` toggles one)

## Phase done when

- [ ] 5 in-game days from a new game: save, quit, reload, continue farming
- [ ] RP runs out by evening at level 1
- [ ] At least one skill levels up in those 5 days
- [ ] At least one reaped seed comes back a level higher
- [ ] No errors in the Godot output during the run
- [ ] Every item, crop and skill lives in `data/`, none in scripts

## Not in this phase

Town, NPC dialogue, seasons, weather, cooking, combat. See [NOT_IN_SCOPE.md](../../NOT_IN_SCOPE.md).
