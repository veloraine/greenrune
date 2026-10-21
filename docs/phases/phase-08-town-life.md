# Phase 8 — Town life depth

**Goal:** a fuller town with a full request board, more festivals, romance and marriage. The town gets busier every season.

**Phase 8 is complete when:**
- A full playthrough from a new game ends in marriage, and the spouse then lives on the farm and says spouse lines.
- Each of the ~30 board requests can be completed in a test run.
- Every season has 2 festivals, and each one runs and pays out.
- Every NPC says at least one season-specific line in each season, and requests and relationships survive save → quit → load.

**Starts when:** [M2](m2-rf-like-demo.md) is done. This phase is writing-heavy.

**Steps:**
1. **More NPCs.** 5–7 new NPCs, bringing the town to 10–12; each gets a schedule, tastes, a birthday and ~50 lines; interiors or spots for each. Each is the [Phase 2.0](phase-02-town-npcs.md#phase-20--character-base) base body with its own look; the first child or elderly NPC gets its body here if none exists yet, on the same skeleton.
2. **Request board.** The request box and `RequestDef` arrived in [Phase 2.4](phase-02-town-npcs.md#phase-24--request-box); grow them into RF4's full board. Add the defeat and craft types beside ship, give and till, plus target, count and unlock condition; a request board with HUD tracking; a daily limit that rises with progress, as RF4's rises from 1 to 3; ~30 board requests whose rewards are seeds, recipes and tools; daily repeatable requests from a pool; personal requests from villagers that raise friendship.
3. **Festivals to 8.** 6 new festivals, 2 per season in total, each unlocked by an Order; at most 2 minigame festivals, the rest exhibitions (cooking, monster, crop); every festival recurs yearly once ordered.
4. **Romance.** 2–4 marriage candidates chosen from the NPCs; a confession at a high friendship level leads to the lover state; dates (invite, meet at a place and time, short scene), 3 needed; ~3 events per candidate; simple rejection and jealousy rules, one lover at a time.
5. **Marriage.** A ring recipe at the crafting table; a bigger bed through an Order; a proposal and wedding scene; the spouse moves to the farmhouse with a new schedule and lines.
6. **Skills and diary.** Skills to ~12 in total, including XP for sowing and picking up items (RF4 trains Love and Light for them; [research › RP and skills](../rf4-farnia-research.md#rp-and-skills)), which the cozy slice (M1) ships without; a bedside diary listing active events and requests.
7. **Save v9 and playtest.** Save v9 adds the request board, romance and marriage state; a marriage playthrough from a new game.

**Checklist:**
- [ ] 10–12 NPCs walk their routines for a full season with no stuck or vanished NPC
- [ ] Each new NPC has ≥50 lines, a birthday and a taste table
- [ ] The HUD tracks active board requests, and the daily limit rises from 1 to 3
- [ ] Each day offers repeatable requests from the pool, and a personal request raises that villager's friendship
- [ ] At most 2 festivals are minigames, and each festival comes back the next year once ordered
- [ ] Each candidate's confession, 3 dates and events play through in a test run, with only one lover at a time
- [ ] The ring crafts at the table, the bigger bed arrives by Order, and the wedding scene plays
- [ ] The diary shows every active request and the next romance step
- [ ] ~12 skills each level by use in a test run
- [ ] A v8 save loads into v9

**Out of scope for this phase:** children, more candidates, story arc.

**Reference:** [research › Requests](../rf4-research.md#town-management-orders-prince-points-and-requests), [research › Festivals](../rf4-research.md#festivals), [research › relationships](../rf4-research.md#npc-relationships-dating-marriage-and-children), RF4's request pacing ([RF4 and Farnia research › Game plan](../rf4-farnia-research.md#1-game-plan-how-rf4-paces-its-opening)).
