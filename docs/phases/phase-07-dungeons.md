# Phase 7 — Dungeons & bosses

**Goal:** two short dungeons and two fair bosses that complete the RF loop: dungeon drops → crafted gear → the next dungeon. Avoid RF4's weak spots (lever puzzles, health-sponge bosses).

**Phase 7 is complete when:**
- Gear crafted from Dungeon 1 drops clears Dungeon 2, which starter gear can't.
- Each dungeon run takes testers ≤20 minutes, and each boss fight 2–3 minutes with intended gear.
- No dungeon has a lever puzzle.
- Dungeon progress and boss flags survive save → quit → load.

**Starts when:** [Phase 6](phase-06-forge-craft.md) is done.

**Steps:**
1. **Dungeon framework.** A dungeon scene template: rooms, gates, doors that open when a room's gates are destroyed; entrance, exit and floor transitions; an escape item that returns you home; saving only at home, so runs are designed for 15–20 minutes.
2. **Dungeon 1.** A KayKit Dungeon layout, ~15 minutes to clear; 3 species (2 reused, 1 new); one non-lever puzzle (push blocks, light torches, or similar); a boss room.
3. **Boss 1.** A boss state machine with 2–3 attack patterns, each with a readable wind-up; a second phase at 50% HP; HP tuned for a 2–3 minute fight with intended gear; a unique material drop; a saved defeat flag.
4. **Dungeon 2 and Boss 2.** Dungeon 2, ~20 minutes, 2 new species that need Phase 6 gear; a new puzzle type; Boss 2 under Boss 1's rules.
5. **Villager party member.** Invite a villager above a friendship threshold; ally AI follows, attacks and retreats at low HP; the ally gains friendship while in the party and leaves in the evening.
6. **Seasonal hidden area.** One small area that opens in a single season, with a material found only there.
7. **Save v8, loop playtest.** Rare dungeon materials used in recipes; save v8 adds dungeon progress and boss flags; testers play the full loop Dungeon 1 → craft → Dungeon 2.

**Checklist:**
- [ ] A 3-room test dungeon can be entered, cleared and exited both ways, and the escape item returns you home
- [ ] A room's doors open when its gates are destroyed
- [ ] A tester clears Dungeon 1 to the boss door in ≤15 minutes
- [ ] Every boss attack shows a wind-up of at least 0.6 s *(default)*, and Boss 1 switches patterns at 50% HP
- [ ] Testers beat Boss 1 in 2–3 minutes and can name its attacks afterwards
- [ ] Starter gear can't clear Dungeon 2; gear crafted from Dungeon 1 drops can
- [ ] A villager above the friendship threshold joins, fights through Dungeon 1, gains friendship and leaves in the evening
- [ ] The seasonal area is closed in 3 seasons and open in 1, and its material drops only there
- [ ] Testers finish Dungeon 1 → craft → Dungeon 2 without being told what to craft
- [ ] A v7 save loads into v8

**Out of scope for this phase:** Dungeon 3 and the post-story dungeon (Phase 9), magic, boss taming.

**Reference:** [research › Dungeons](../rf4-research.md#dungeons), [research › Criticism](../rf4-research.md#criticism-from-critics-and-players).
