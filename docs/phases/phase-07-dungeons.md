# Phase 7 — Dungeons & bosses

**Goal:** two short dungeons and two fair bosses that complete the RF loop: dungeon drops → crafted gear → the next dungeon. Avoid RF4's weak spots (lever puzzles, health-sponge bosses).
**Estimate:** 6–9 months (~26–39 weeks).
**Starts when:** [Phase 6](phase-06-forge-craft.md) is done.
**Background:** [research › Dungeons](../rf4-research.md#dungeons), [research › Criticism](../rf4-research.md#criticism-from-critics-and-players).

Every checked item must meet the [definition of done](../endgame.md#definition-of-done).

## Step 1 — Dungeon framework (weeks 1–4)

- [ ] Dungeon scene template: rooms, gates, doors that open when a room's gates are destroyed
- [ ] Entrance and exit; floor transitions
- [ ] Escape item that returns you home
- [ ] Saving only at home, so runs are designed for 15–20 minutes

**Done when:** a 3-room test dungeon can be entered, cleared, and exited both ways.

## Step 2 — Dungeon 1 (weeks 5–10)

- [ ] Layout from KayKit Dungeon, ~15 minutes to clear
- [ ] 3 species (2 reused, 1 new)
- [ ] One non-lever puzzle (push blocks, light torches, or similar)
- [ ] Boss room

**Done when:** a tester clears Dungeon 1 up to the boss door in ≤15 minutes.

## Step 3 — Boss 1 (weeks 11–15)

- [ ] Boss state machine with 2–3 attack patterns, each with a readable wind-up
- [ ] Second phase at 50% HP
- [ ] HP tuned so the fight takes 2–3 minutes with intended gear
- [ ] Unique material drop; defeat flag saved

**Done when:** testers beat Boss 1 in 2–3 minutes and can describe its attacks afterwards.

## Step 4 — Dungeon 2 and Boss 2 (weeks 16–26)

- [ ] Dungeon 2, ~20 minutes, 2 new species
- [ ] Monsters that need Phase 6 gear (starter gear can't win)
- [ ] A new puzzle type
- [ ] Boss 2 with the same rules as Boss 1

**Done when:** Dungeon 2 can't be cleared in starter gear and can be cleared in gear crafted from Dungeon 1 drops.

## Step 5 — Villager party member (weeks 27–30)

- [ ] Invite a villager above a friendship threshold
- [ ] Ally AI: follow, attack, retreat at low HP
- [ ] Ally gains friendship while in the party; leaves in the evening

**Done when:** a villager joins, fights through Dungeon 1, and gains friendship.

## Step 6 — Seasonal hidden area (weeks 31–32)

- [ ] One small area that opens in a single season
- [ ] A unique material found only there

**Done when:** the area is closed in 3 seasons and open in 1.

## Step 7 — Save v8, loop playtest (weeks 33–36)

- [ ] Rare dungeon materials used in recipes
- [ ] Save v8 adds dungeon progress and boss flags; v7 saves still load
- [ ] Testers play the full loop: Dungeon 1 → craft → Dungeon 2

**Done when:** a v7 save loads into v8, and testers finish the loop without being told what to craft.

## Phase done when

- [ ] Loop works: Dungeon 1 drops → crafted gear → Dungeon 2 cleared
- [ ] Each dungeon run takes ≤20 minutes for testers
- [ ] Each boss fight takes ≤3 minutes with intended gear
- [ ] No lever puzzles
- [ ] Dungeon progress survives save → quit → load

## Not in this phase

Dungeon 3 and the post-story dungeon (Phase 9), magic, boss taming.
