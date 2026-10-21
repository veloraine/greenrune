# Greenrune — Endgame plan (road to 1.0)

The whole project on one page: what Greenrune 1.0 is, what gets built in which phase, and links to each phase's detailed plan in [phases/](phases/). [plan.md](plan.md) stays the detailed guide for Phases 0–3 (tools, tutorials, setup). The reasoning behind every choice is in [rf4-research.md](rf4-research.md). What to work on next, and the current todo list, is in [roadmap.md](roadmap.md).

All content targets below are planning estimates, not sourced facts. How phases are paced is in [plan.md › Phased roadmap](plan.md#phased-roadmap). RF4 numbers are from the research (mostly the community wiki).

## What "done" means

Greenrune 1.0 is a small RF-like. It is not an RF4-sized game. It copies RF4's **structure** at a fraction of its **scale**:

- You farm, fight, tame, craft and befriend, and **every system feeds another**. Crops become dishes, gifts and festival entries. Monster drops become gear. Gear opens deeper dungeons. Tamed monsters work the farm.
- **Every action spends RP and levels a skill.**
- A small town of named people reacts to time, season, weather and events.
- The player chooses the day: there is no forced path, and the story can be ignored.
- Systems unlock through play within the first hour or two. There is no 10-hour tutorial.

### The player's loops at 1.0

- **Daily:** wake at 06:00 → water and harvest → talk and give gifts → pick a request → choose a dungeon run, a crafting session or a festival → sleep before RP and the clock run out.
- **Seasonal:** in-season crops grow faster. Festivals and birthdays mark the calendar, and seasonal areas open.
- **Long-term:** four tracks run side by side:
  - seed level 1→10;
  - skill levels, which raise max RP;
  - gear upgrades with inherited effects;
  - town points, which unlock shops, expansions and festivals.

  Marriage gives the social long-term goal. A post-story dungeon and the upgrade ceiling give the endgame.

## Scope targets

| System | Slice (end of Phase 3) | 1.0 target | RF4 for reference |
|---|---|---|---|
| Calendar | 4 seasons × 30 days | same | 4 × 30 days |
| Crops | 8 (2 per season) | ~16 | — |
| Crop/seed levels | 1–10 | 1–10 | 1–10 |
| Named NPCs | 3–5 | 10–12 | — |
| Skills (level by use) | 4–6 | ~12 | 38 |
| Festivals | 1–2 | 8 (2 per season) | 24 |
| Crafting stations | Kitchen | Kitchen, forge, crafting table | 4 (incl. chemistry) |
| Upgrade inheritance | — | Up to 3 inherited effects, plus late-game multiplier materials | 3 inherited + 9 upgrades, 2x/8x steel, Object X |
| Weapon classes | — | 2 (short sword, axe/hammer that also does farm work) | 6 + staves |
| Magic | — | none (after 1.0) | 7 elements |
| Monster species | — | ~10, incl. 3 bosses | many; 23 gate types |
| Tameable monsters | — | all non-boss species | all, bosses included |
| Dungeons | — | 3 short story dungeons + 1 post-story | several + Dungeon Seeds |
| Requests | — | ~30 board requests + daily repeatables + personal | 92 + repeatables + personal |
| Marriage candidates | — | 2–4 | 12 |
| Children | — | none | 1 |
| Story | — | 1 short arc + post-story dungeon | 3 arcs |

## Milestones

```mermaid
flowchart LR
    P0[P0 Learn] --> P1[P1 Farm loop] --> P2[P2 Town] --> P3[P3 Seasons]
    P3 --> M1([M1: Cozy slice on itch.io])
    M1 --> P4[P4 Combat core] --> P5[P5 Taming] --> P6[P6 Forge and craft] --> P7[P7 Dungeons]
    P7 --> M2([M2: RF-like demo])
    M2 --> P8[P8 Town life depth] --> P9[P9 Story and late game] --> P10[P10 Polish]
    P10 --> M3([M3: Greenrune 1.0])
```

- **M1, Cozy slice:** free on itch.io. It is a Story of Seasons-like game, and should be labelled honestly. This is the polish-and-ship choice in [After Phase 3](plan.md#phase-35--stop-and-re-evaluate). If you stop here, you have shipped a game.
- **M2, RF-like demo:** combat, taming, forging and one or two dungeons work together. This is the first build that is genuinely an RF-like. Public demo or store page.
- **M3, 1.0:** everything in the scope table above.

## Rules for every phase

1. **Fun gate (Hashimoto's rule).** Before starting a phase, cut every item that doesn't pass "will it make the game fun?"
2. **Data, not code.** Items, recipes, crops, monsters, gift tastes, requests and dialogue lines live in `Resource` files or CSV, never in scripts.
3. **Bump the save version** whenever a phase adds saved state, and keep loading old saves.
4. **Every phase ends in a playable build** you'd send to a friend.
5. **Each new system must feed another.** If it doesn't consume another system's output or produce another system's input, it waits.

---

## Definition of done

A checklist item is done only when all of these hold:

1. It works when you run the main scene with F5, not only in a test scene.
2. The Godot output shows no errors or warnings during the test.
3. If it adds state, that state survives save → quit → relaunch → load.
4. Its content (items, numbers, lines) lives in `data/`, not in scripts.
5. You can explain every line of its code without AI.
6. It is committed to git with a message that says what was done.

A sub-phase is complete when every item in its checklist is checked and every outcome under its **Phase X.Y is complete when** shows in the running game. A phase is complete when every sub-phase is complete and every outcome under **Phase X is complete when** shows. Phases 4–10 and the milestones list steps and one checklist until they start; each is complete when that checklist is checked and every outcome under its **is complete when** shows.

## Phase plans

Each file has the phase's goal and a **Phase X is complete when** list. Phases 1–3 split into sub-phases, each with Goal, **Phase X.Y is complete when**, Steps, Checklist, Out of scope and Reference. Phases 4–10 and the milestones list steps and one checklist until they start.

| Plan | Goal | Complete when (short) |
|---|---|---|
| [Phase 0 — Learn](../PHASE_0_CHECKLIST.md) | Skills for Phase 1 | `baseline_scene.tscn` looks RF4-ish, you understand every node, the feel test is done |
| [Phase 1 — Farm loop](phases/phase-01-farm-loop.md) | Smallest RF-style day | 5 days played across a save/reload; RP runs out; a skill and a seed level up |
| [Phase 2 — Town & NPCs](phases/phase-02-town-npcs.md) | Named town with routines | Max friendship with one NPC in ~14 days; lines change with time of day |
| [Phase 3 — Seasons, cooking, orders](phases/phase-03-seasons-cooking-orders.md) | A full year | A full year played; cooking and festival make crop levels matter |
| [M1 — Cozy slice](phases/m1-cozy-slice.md) | First shipped game | On itch.io; 3 testers finish day 1 unaided; continue/stop decided |
| [Phase 4 — Combat core](phases/phase-04-combat-core.md) | Combat that feels good | 10-minute field run feels good; 60 fps with 10 monsters |
| [Phase 5 — Taming & barn](phases/phase-05-taming.md) | Combat pays off on the farm | Monsters run the farm for 7 days while you fight |
| [Phase 6 — Forge & craft](phases/phase-06-forge-craft.md) | Crafting drives gear | Crafted weapon with inherited effect beats the shop |
| [Phase 7 — Dungeons & bosses](phases/phase-07-dungeons.md) | The full RF loop | Dungeon 1 drops → gear → Dungeon 2; runs ≤20 min, bosses ≤3 min |
| [M2 — RF-like demo](phases/m2-rf-like-demo.md) | Public proof | Demo public; 60 fps on low-end; feedback triaged |
| [Phase 8 — Town life depth](phases/phase-08-town-life.md) | Busier town, marriage | Married in a playthrough; 30 requests; 2 festivals per season |
| [Phase 9 — Story & late game](phases/phase-09-story-late-game.md) | Ending + post-credits | Story finishable and optional; tester keeps playing after credits |
| [Phase 10 — Polish & launch](phases/phase-10-polish-launch.md) | Greenrune 1.0 | 1.0 released; no blockers; all old saves load |

---

## Not in 1.0

Possible updates after 1.0, roughly in order of value per effort:

- Magic / staves / spells
- More weapon classes (spear, dual blades, fists)
- Taming bosses
- Chemistry station (medicine)
- Fishing, foraging, mining nodes
- Soil hidden stats, giant crops
- Dungeon Seeds (grow dungeons on the farm)
- Children
- More marriage candidates
- More story arcs, cutscenes

Never planned: online multiplayer, mod support, console ports, 38 skills, 24 festivals, anime cutscenes.
