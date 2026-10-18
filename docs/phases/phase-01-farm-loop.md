# Phase 1 — Farm loop

**Goal:** the smallest playable RF-style day: walk, swing tools, spend RP, level skills, grow and reap levelled crops, sell, sleep, save.
**Estimate:** 3–4 months (~13–17 weeks at 8 hrs/week).
**Starts when:** [Phase 0](../../PHASE_0_CHECKLIST.md) is done and Godot MCP is set up ([plan.md](../plan.md#phase-1-prerequisites--godot-mcp-setup-do-at-the-start-of-phase-1)).
**Background:** [plan.md › Phase 1](../plan.md#phase-1--farming-prototype-3d-34-months), [research › Farming, RP, Skills](../rf4-research.md#2-systems-and-how-they-work).

Every checked item must meet the [definition of done](../endgame.md#definition-of-done).

## Step 1 — Skeleton, player, farm scene (weeks 1–2)

- [x] Folder layout: `scenes/`, `scripts/`, `data/items/`, `data/crops/`, `data/skills/`, `ui/`
- [x] Input map: move, use tool, next/prev hotbar slot, interact, menu (WASD, Space/left click, E/Q or mouse wheel, F, Tab/Esc)
- [x] Farm scene from KayKit/Quaternius: house with bed, ~12×12 field, shipping bin, fences, trees (`scenes/farm.tscn`; the bed stands beside the house until the Step 5 interior)
- [x] Player: `CharacterBody3D` + KayKit model + ~~Mixamo~~ KayKit built-in idle/run
- [x] Camera: `SpringArm3D` + `Camera3D` at the fixed RF4 angle, follows the player (`scenes/camera_rig.tscn`)
- [x] Main scene runs with F5

**Done when:** you walk around the farm at 60 fps and the camera never clips through props.

## Step 2 — Item data, inventory, save v1 (weeks 2–3)

- [ ] `ItemDef` resource: id, name, icon, category, base sell price, max stack
- [ ] `ItemStack`: item id + level (1–10) + count
- [ ] Inventory model (24 slots) + 8-slot hotbar UI; scroll to select
- [ ] Debug command to add any item at any level
- [ ] Save v1 as JSON with a `version` field: inventory, player position, day, gold
- [ ] Load from the title screen or a debug key

**Done when:** you add items at mixed levels, save, quit, relaunch and load, and the inventory is identical, levels included.

## Step 3 — Field grid and tool pipeline (weeks 4–7)

- [ ] `FarmGrid`: per-tile state (untilled, tilled, watered, planted) stored in code, drawn in 3D
- [ ] Target tile = tile in front of the player, highlighted
- [ ] `ToolDef` (extends `ItemDef`): RP cost, linked skill, hitbox shape, effect
- [ ] Swing: animation → hitbox active frames → effect on every tile hit
- [ ] Hoe tills; watering can waters (with a water count, refilled at a pond or well)
- [ ] Hold to charge: wider area, higher RP cost
- [ ] "Pop" feedback on every hit: sound, particle, tiny camera shake

**Done when:** you till and water 20 tiles, charged and uncharged, and every swing shows its hitbox in debug view.

## Step 4 — RP, HP, skills (weeks 8–9)

- [ ] RP and HP bars in the HUD
- [ ] Every tool use spends RP; at 0 RP actions drain HP
- [ ] HP 0 → faint, wake next morning with half RP and a gold penalty
- [ ] `SkillDef` data: id, name, XP curve
- [ ] 4–6 skills: tilling, watering, reaping, walking, sleeping (+1 optional)
- [ ] XP per use; level-up popup
- [ ] Each level lowers that skill's RP cost and raises max RP

**Done when:** at level 1, normal farming empties RP by evening; at tilling level 5 a till visibly costs less.

## Step 5 — Crops, day tick, sleep (weeks 10–12)

- [ ] `CropDef` data: seed item, growth stages, days per stage, harvest item, sell price
- [ ] Plant a seed on a tilled tile; `Sprite3D` billboard per stage
- [ ] Clock: day runs 06:00–24:00; HUD clock; forced faint at midnight
- [ ] House interior scene with the bed, entered through the house door
- [ ] Bed interaction → sleep → next day
- [ ] `DayTick`: one ordered pipeline at 06:00 (crops grow → soil dries → future hooks)
- [ ] Sun: rotating `DirectionalLight3D`, gradient sky
- [ ] Harvest: crop level = seed level
- [ ] Sickle reaping: returns seeds; chance of +1 level (data-tuned)
- [ ] 2 crops: turnip (fast), potato (slow)

**Done when:** a planted turnip grows through its 3 stages over several sleeps; reaping a ripe crop sometimes returns higher-level seeds.

## Step 6 — Selling, save v2 (weeks 13–14)

- [ ] Shipping bin: sold at 06:00, gold added
- [ ] Shop NPC: talk → "sell all" menu
- [ ] Price scales with item level (data-tuned)
- [ ] Save v2 adds: tiles, crops, RP, HP, skill XP, time; v1 saves still load

**Done when:** a v1 save loads into v2 without errors, and a level-5 turnip sells for more than a level-1 turnip.

## Step 7 — Playtest and tune (weeks 15–16)

- [ ] Play 5 in-game days from a new game
- [ ] Tune RP costs, XP curve and reap odds from notes
- [ ] Fix every bug found; anything new goes to [NOT_IN_SCOPE.md](../../NOT_IN_SCOPE.md)

**Done when:** the 5-day run has no bugs left open.

## Phase done when

- [ ] 5 in-game days from a new game: save, quit, reload, continue farming
- [ ] RP runs out by evening at level 1
- [ ] At least one skill levels up in those 5 days
- [ ] At least one reaped seed comes back a level higher
- [ ] No errors in the Godot output during the run
- [ ] Every item, crop and skill lives in `data/`, none in scripts

## Not in this phase

Town, NPC dialogue, seasons, weather, cooking, combat. See [NOT_IN_SCOPE.md](../../NOT_IN_SCOPE.md).
