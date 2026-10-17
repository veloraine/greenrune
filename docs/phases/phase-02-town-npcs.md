# Phase 2 — Town & NPCs

**Goal:** a small town of named people who keep daily routines, say the right thing for the moment, and grow closer through talk and gifts.
**Estimate:** 4–5 months (~17–22 weeks). Most of it is writing, not code.
**Starts when:** [Phase 1](phase-01-farm-loop.md) is done.
**Background:** [plan.md › Phase 2](../plan.md#phase-2--town--npcs-45-months), [research › NPC routines and dialogue](../rf4-research.md#npc-routines-and-dialogue), [research › relationships](../rf4-research.md#npc-relationships-dating-marriage-and-children).

Every checked item must meet the [definition of done](../endgame.md#definition-of-done).

## Step 1 — Town scene and transitions (weeks 1–3)

- [ ] Town from asset packs: shop, inn, square, 3–5 houses, path to the farm
- [ ] Farm ↔ town exits with a fade; spawn points per entrance
- [ ] Baked navmesh covering every walkable area
- [ ] Building interiors as separate scenes, or doors that hide NPCs inside

**Done when:** you walk farm → town → every interior → farm with no stuck spots, and the navmesh debug view covers every walkable area.

## Step 2 — NPC base and schedules (weeks 4–7)

- [ ] `NPCDef` data: id, name, model/texture, portrait, birthday, schedule, gift tastes
- [ ] NPC scene: `CharacterBody3D` + `NavigationAgent3D` + model
- [ ] `ScheduleDef` data: time → place + activity, per weekday
- [ ] NPC state machine: idle, walk, work, sleep
- [ ] Off-screen catch-up: after sleep or a scene change, place each NPC where its schedule says
- [ ] 3 NPCs on schedules (the shop owner is one of them)
- [ ] Shop opens only while its owner is at the counter

**Done when:** 3 NPCs follow their schedules for a full day, and leaving and re-entering town puts each one where it should be.

## Step 3 — Dialogue with line selection (weeks 8–11)

- [ ] Install Dialogic 2; portrait frame and text box styled
- [ ] Talk interaction (face the NPC, press interact)
- [ ] `LineDef` data: NPC, conditions (time window, season, weather, min/max friendship, flags), priority, text
- [ ] Line selector: highest-priority line whose conditions match; no repeat on the same day
- [ ] Fallback line per NPC so the selector never returns nothing
- [ ] Debug panel: set time, friendship and weather, then preview the chosen line

**Done when:** each NPC gives different lines in the morning, afternoon and evening, and the debug panel shows the expected line for any condition you set.

## Step 4 — Friendship and gifts (weeks 12–14)

- [ ] Friendship points per NPC; level thresholds as data
- [ ] Daily talk: + points once per day
- [ ] Gift: one counted gift per NPC per day
- [ ] Taste table per NPC as data: loved, liked, neutral, disliked, hated
- [ ] Gift value scales with item level; birthdays double it
- [ ] Reaction line + emote for each taste tier
- [ ] Friendship page listing every NPC, level and birthday

**Done when:** giving the same NPC a loved, a neutral and a hated item on 3 days gives 3 different reactions and point changes, and a birthday gift counts double.

## Step 5 — Shop upgrade (week 15)

- [ ] Buy seeds (stock as data)
- [ ] Sell prices per item category

**Done when:** you can buy seeds, plant them and sell the crop back at a profit.

## Step 6 — Writing pass (weeks 16–19)

Target ~50 lines per NPC:

- [ ] Greetings for morning, afternoon and evening
- [ ] Lines for each friendship tier (low, mid, high)
- [ ] Gift reactions for each taste tier
- [ ] Birthday lines
- [ ] Placeholder season and weather lines, filled in properly in Phase 3
- [ ] Each NPC has a distinct voice: read all lines aloud once

**Done when:** each NPC has ≥50 lines in data and no two NPCs share a line.

## Step 7 — Save v3 and playtest (weeks 20–22)

- [ ] Save v3 adds per-NPC friendship, today's talk and gift flags; v2 saves still load
- [ ] 14-day playtest from a new game
- [ ] Fix every bug found

**Done when:** a v2 save loads into v3, and the 14-day run has no bugs left open.

## Phase done when

- [ ] One NPC reaches max friendship within ~14 in-game days through talk and gifts
- [ ] That NPC says different things in the morning and in the evening
- [ ] 3–5 named NPCs walk their routines with no stuck or vanished NPCs over 14 days
- [ ] Friendship and flags survive save → quit → load
- [ ] All NPC data, schedules, tastes and lines live in `data/`

## Not in this phase

Seasons, weather, festivals, cooking, requests, romance. See [NOT_IN_SCOPE.md](../../NOT_IN_SCOPE.md).
