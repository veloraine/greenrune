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
- [ ] "Pop" feedback on every hit: sound, particle, tiny camera shake (hoe done; the watering can still needs a splash sound)

**Done when:** you till and water 20 tiles, charged and uncharged, and every swing shows its hitbox in debug view.

## Step 4 — RP, HP, skills (weeks 8–9)

- [x] RP and HP bars in the HUD (bottom left, with the numbers; base values in `data/vitals.tres`; RP, HP and skill XP are saved from Step 6)
- [x] Every tool use spends RP; when RP can't cover a swing, it costs a flat 25% of max HP instead, rounded up, and RP is left alone (`rp_short_hp_cost`; RF4's rule for crafting short of RP; refilling the can and swinging it dry are free)
- [x] HP 0 → faint, wake next morning with half HP and a gold penalty; RP stays as it was, like RF4 (`faint_wake_hp`) (until the Step 5 day tick, `farm.gd` does day + 1 and wakes the player at `WakePoint` beside the bed)
- [x] `SkillDef` data: id, name, XP curve (`data/skills/`; the curve is `level_xp`, the total XP for each level)
- [x] 4–6 skills: tilling, watering, reaping, walking, sleeping (+1 optional) (reaping and sleeping are data only until the sickle and sleep arrive in Step 5)
- [x] XP per use; level-up popup (walking earns XP per metre walked; a tool swing earns `xp_per_use` plus its charge level's `xp_bonus` once, not per tile, and only if it changed at least one tile's soil; a swing that changes nothing still costs RP and water)
- [x] Each level lowers that skill's RP cost and raises max RP (`rp_cost_cut_per_level` and `max_rp_per_level` on each `SkillDef`)

**Done when:** at level 1, normal farming empties RP by evening; at tilling level 5 a till visibly costs less.

**RP budget until the Step 5 clock.** "By evening" becomes "a morning of tilling and watering most of the 12×12 field". Max RP at level 1 is 300. The hoe costs 5 / 15 / 30 per tap / 2×2 / 4×4 swing and the can 4 / 8 / 16, so tilling and watering one tile costs 9 RP by taps, 5.75 RP with 2×2 charges and 2.9 RP with 4×4 charges. RP runs out after about 33, 52 or 96 of the 144 tiles. Each skill level cuts 5% of the base cost, so at tilling level 5 a tap costs 4 instead of 5. Charge bonuses keep RF4's ratio to the base swing (hoe 3 XP with +30 / +80, can 4 XP with +20 / +40), divided by 5, so a hoe swing gives 1 / 3 / 6 XP and a can swing 1 / 2 / 3. At those values a charged swing earns about the same XP per RP as a tap, so a morning levels tilling to about 3 however you charge. Tilling level 2 takes 10 taps or 2 4×4 swings, and level 5 takes 100 taps or 17 4×4 swings. Unscaled, a morning of 4×4 swings reaches tilling level 6. Re-check in Step 7: once crops arrive, a normal day is mostly watering, which costs less than tilling.

## Step 5 — Crops, day tick, sleep (weeks 10–12)

- [ ] `CropDef` data: seed item, growth stages, days per stage, harvest item, sell price
- [ ] Plant a seed on a tilled tile; `Sprite3D` billboard per stage
  - `Field.Soil` is one value per tile and can't say "planted and watered". Store watered as its own flag, with the crop beside it, and give seeds a way in that isn't `ToolDef.Effect`.
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
- [ ] Save v2 adds: tiles, crops, RP, HP, skill XP, time, watering-can water; v1 saves still load
  - Load the field in place (one bulk replace that emits `changed`), not by swapping `Game.field`: `FarmGrid` stays connected to the old object.
  - A load mid-swing must reset the player, or the swing spends water from a stack that is no longer in the inventory.

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
