# Phase 3 — Seasons, cooking, orders

**Goal:** a full year with seasons, weather, cooking, town points and one festival, so crop levels matter and the town grows with you.

**Phase 3 is complete when:**
- A full in-game year is played from a new game, and every season has its own look, weather and at least 2 crops in their good season.
- Cooking makes crop levels matter: better dishes, better gifts, contest wins.
- At least 3 Orders are bought in one playthrough, and the harvest festival runs and pays out.
- Calendar, weather and Orders survive save → quit → load.

**Sub-phases**, worked one at a time in this order:
1. [Phase 3.1 — Calendar and seasonal growth](#phase-31--calendar-and-seasonal-growth): 4 × 30 days, RF4's good and bad seasons per crop.
2. [Phase 3.2 — Weather, season looks and new crops](#phase-32--weather-season-looks-and-new-crops): hourly weather, rain that waters, seasonal visuals, 6 new crops, rain and season lines.
3. [Phase 3.3 — Points and Orders](#phase-33--points-and-orders): town points and an Orders menu.
4. [Phase 3.4 — Cooking](#phase-34--cooking): kitchen, recipes, dish level from ingredients.
5. [Phase 3.5 — Harvest festival](#phase-35--harvest-festival): one exhibition festival won on crop level.
6. [Phase 3.6 — Full-year gate](#phase-36--full-year-gate): save v4 and a full-year playtest.

**Starts when:** [Phase 2](phase-02-town-npcs.md) is done.

**Out of scope for this phase:** combat, more festivals, the request board, romance, crafting and forging. See [NOT_IN_SCOPE.md](../../NOT_IN_SCOPE.md).

**Reference:** [plan.md › Phase 3](../plan.md#phase-3--calendar-seasons--town-progression), [research › Calendar, Farming](../rf4-research.md#calendar-and-time), [research › Orders](../rf4-research.md#town-management-orders-prince-points-and-requests), [research › Festivals](../rf4-research.md#festivals), [RF4 and Farnia research › Gap analysis, Phase 3](../rf4-farnia-research.md#phase-3-phase-03-seasons-cooking-ordersmd).

**How this phase runs.** Sub-phases follow [plan.md › Phased roadmap](../plan.md#phased-roadmap): a sub-phase ends when its "complete when" outcomes show in the running game and its checklist is checked. Every checked item must meet the [definition of done](../endgame.md#definition-of-done). Numbers marked *(default)* are design defaults. Phase 3's new saved state goes into save v4, created by the first sub-phase that adds state (3.1); v3 saves keep loading. Withering is RF4's colour-change-then-die rule, built in [Phase 1.4](phase-01-farm-loop.md#phase-14--crops); the old "wither after N days unwatered" item is gone.

### Phase 3.1 — Calendar and seasonal growth

**Goal:** a 4 × 30-day year in which each crop grows faster or slower by season, with no crop death at a season change.

**Phase 3.1 is complete when:**
- Sleeping from Spring 30 lands on Summer 1, and the HUD and calendar show it.
- The same crop planted in its good season and in its bad season ripens on different, predictable days.
- A crop growing across a season change keeps growing.

**Steps:**
1. Calendar data: season, day (1–30), year, plus Phase 2.2's weekday counter; the season change runs inside the `DayTick`. The HUD date line gains the weekday.
2. `CropDef` gets good and bad seasons from RF4's table: turnip is good in Summer and Fall and neutral in Spring; potato is good in Spring and Summer and bad in Winter. Phase 1 ran in Spring, where the turnip grows at 1.0x, so its numbers stand.
3. Growth is 1.5x in a good season (RF4) and 0.5x out of season *(default; the wikiwiki datamine, with Fandom's 2/3 as the alternative)*. Crops never die at a season change.
4. Calendar UI: a month grid with birthdays, and festivals once 3.5 adds them.
5. NPC schedules can vary by season.

**Checklist:**
- [ ] Season factors and each crop's seasons live in `data/`
- [ ] The date survives save → load (save v4; a v3 save still loads)
- [ ] Growth with season factors matches a hand calculation for one good-season and one bad-season crop
- [ ] The calendar shows every NPC birthday

**Out of scope for this phase:** weather, new crops beyond the existing two, festivals.

**Reference:** 4 × 30-day seasons ([research › Calendar](../rf4-research.md#calendar-and-time)); RF4's crop seasons, the three out-of-season values and no death at a season change ([RF4 and Farnia research › Crops and growth](../rf4-farnia-research.md#crops-and-growth)); [research › Phase 3.1](../rf4-farnia-research.md#phase-31--calendar-and-seasonal-growth).

### Phase 3.2 — Weather, season looks and new crops

**Goal:** each season looks different and has its own crops, and rain waters the field while it falls.

**Phase 3.2 is complete when:**
- Four 12:00 screenshots of the farm, one per season, are told apart at a glance, with spring petals, autumn leaves and winter snow in their seasons.
- During rain, unwatered plots turn wet over the course of the rain, not at 06:00.
- Every season has at least 2 crops in their good season, each with its own stage models.
- On a rainy day NPCs keep to rain routes and say rain lines.

**Steps:**
1. Weather rolls each game hour from per-season odds in data: sunny or rainy.
2. Rain particles (`GPUParticles3D`) and a wet-plot pass that waters a share of dry plots each game hour of rain.
3. Per-season ground tint, Quaternius tree variants, sky tint and particles. Seasonal ground meshes only if a tint is not enough: (Blender — Claude: base) then (Blender — user: polish).
4. Re-check night readability: Phase 1.1 made watered and dry soil read at 22:00 under the Phase 1 lighting. Check again under each season's ambient light, and add lights to the farm where they no longer read.
5. 6 new crops, 8 in total, chosen from RF4's crop data so each season has at least 2 good-season crops (the turnip counts for Summer and Fall). **Stage models** per crop (Blender — Claude: base; Blender — user: polish), each passing Phase 1.4's crop checklist.
6. Seed stock in the shop changes per season *(default; no RF4 source, since RF4 grows stock through requests and shipping)*.
7. NPCs go indoors or change routes on rainy days.
8. Write the season and weather lines left as placeholders in Phase 2.5.

**Checklist:**
- [ ] Weather odds and the rain watering rate live in `data/`
- [ ] Today's weather survives save → load
- [ ] Rain waters every plot within 2 game hours *(default; RF4's heavy-rain figure)*
- [ ] Each new crop's stage models are under 500 triangles *(default)* and share no silhouette
- [ ] Watered and dry soil differ by at least 25% in brightness at 22:00 in every season *(default)*
- [ ] 60 fps on the farm during rain

**Out of scope for this phase:** typhoons, snowstorms, Runey weather, weekly bumper and poor crops.

**Reference:** hourly weather and rain watering over about 2 hours ([RF4 and Farnia research › Crops and growth](../rf4-farnia-research.md#crops-and-growth)); Farnia's seasonal particles and palette swaps ([research › Phase 3.2](../rf4-farnia-research.md#phase-32--weather-and-season-visuals)); [research › Blender pipeline](../rf4-farnia-research.md#blender-pipeline).

### Phase 3.3 — Points and Orders

**Goal:** town points from shipping and requests buy the first Orders: a shop line and a field expansion.

**Phase 3.3 is complete when:**
- A day's shipment pays points the next morning, scaled by value.
- Buying the field-expansion Order adds tillable land, in 3×3 blocks, that survives save → load.

**Steps:**
1. Points from shipping (RF4: 50–125 a day by value), from Phase 2.4's requests, and from the first chat of the day with each villager (RF4 pays points for it; amount *(default)*).
2. `OrderDef` data (cost, prerequisites, effect) and an Orders menu at an order board in town.
3. Two Order effects: unlock a shop item line, expand the field. Price the expansion in gold and points: RF4 also asks for lumber and stone, which need the axe and hammer (Phase 4).

**Checklist:**
- [ ] Point rates and Order costs live in `data/`
- [ ] The first chat of the day with a villager pays points once, and a second chat that day pays none
- [ ] Bought Orders survive save → load and stay applied

**Out of scope for this phase:** the kitchen Order (3.4), the festival Order and festival points (3.5), licences with exams, Prince rank and tourists.

**Reference:** shipping and request points and field expansion costs ([research › Phase 3.3](../rf4-farnia-research.md#phase-33--points-and-orders)); [research › Orders](../rf4-research.md#town-management-orders-prince-points-and-requests).

### Phase 3.4 — Cooking

**Goal:** crops become dishes whose level follows their ingredients.

**Phase 3.4 is complete when:**
- Cooking with level-5 crops makes a higher-level dish than cooking with level-1 crops, and eating it restores more RP.
- A dish given as a gift gets the reaction its NPC's taste table sets.

**Steps:**
1. Kitchen in the farmhouse, unlocked by a new kitchen Order with its point cost in data.
2. `RecipeDef` data: ingredients (by item or category), result, RP cost, skill.
3. Cooking skill, levelling by use.
4. 6–10 recipes.
5. Dish level = average ingredient level.
6. Dishes restore RP and HP when eaten and appear in gift tastes.

**Checklist:**
- [ ] Recipes and their values live in `data/`
- [ ] Known recipes survive save → load
- [ ] Cooking spends RP and earns cooking XP

**Out of scope for this phase:** chemistry, forging, recipe bread.

**Reference:** cooking as the first crop sink ([research › Implications](../rf4-research.md#implications-for-greenrunes-plan)); [research › Phase 3.4](../rf4-farnia-research.md#phase-34--cooking).

### Phase 3.5 — Harvest festival

**Goal:** one exhibition festival where crop level wins.

**Phase 3.5 is complete when:**
- On festival day the NPCs gather in the square, a high-level crop wins, and the rewards appear.
- Once ordered, the festival comes back the next year.

**Steps:**
1. A festival Order that schedules the harvest festival, and festival points as a new point source.
2. Festival-day schedule override: every NPC goes to the square.
3. Harvest contest: submit one crop, scored by type and level.
4. Results 1st / 2nd / 3rd: town points and friendship with every villager (+5 / +4 / +3).

**Checklist:**
- [ ] Festival date, scoring and rewards live in `data/`
- [ ] Festival day is always sunny
- [ ] A festival scheduled by Order survives save → load

**Out of scope for this phase:** minigame festivals, more festivals (Phase 8).

**Reference:** festivals are always sunny, +5 / +4 / +3 friendship ([research › Phase 3.5](../rf4-farnia-research.md#phase-35--harvest-festival)); [research › Festivals](../rf4-research.md#festivals).

### Phase 3.6 — Full-year gate

**Goal:** a full-year playtest on save v4, against the polished seasons.

**Phase 3.6 is complete when:**
- A full in-game year from a new game, with a save, quit and reload in the middle, shows every outcome under "Phase 3 is complete when".
- A v3 save from the end of Phase 2 loads into v4 and plays on.

**Steps:**
1. Confirm save v4 holds calendar, weather, Orders, points and known recipes, and that a v3 save loads.
2. Play a full in-game year from a new game, with notes.
3. Tune growth, prices, points and recipe values from the notes; fix every bug found.

**Checklist:**
- [ ] The values tuned from the notes live in `data/`
- [ ] No errors or warnings in the output across the run
- [ ] The year run has no bugs left open

**Out of scope for this phase:** anything new.

**Reference:** [endgame.md › Definition of done](../endgame.md#definition-of-done).
