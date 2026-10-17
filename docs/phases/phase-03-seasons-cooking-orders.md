# Phase 3 — Seasons, cooking, orders

**Goal:** a full year with seasons, weather, cooking and a town-points menu, so crop levels matter and the town grows with you.
**Estimate:** 2–3 months (~9–13 weeks).
**Starts when:** [Phase 2](phase-02-town-npcs.md) is done.
**Background:** [plan.md › Phase 3](../plan.md#phase-3--calendar-seasons--town-progression-23-months), [research › Calendar, Farming](../rf4-research.md#calendar-and-time), [research › Orders](../rf4-research.md#town-management-orders-prince-points-and-requests), [research › Festivals](../rf4-research.md#festivals).

Every checked item must meet the [definition of done](../endgame.md#definition-of-done).

## Step 1 — Calendar (weeks 1–2)

- [ ] Calendar: season, day (1–30), weekday, year
- [ ] Season change runs inside `DayTick`
- [ ] Calendar UI: month grid with birthdays and festivals
- [ ] NPC schedules can vary by season

**Done when:** sleeping from Spring 30 lands on Summer 1, and the calendar shows every NPC birthday.

## Step 2 — Seasonal farming (weeks 3–4)

- [ ] `CropDef` gets a list of good seasons
- [ ] Growth 1.5x in season, 0.75x out of season (values in data); no crop death
- [ ] Crops wither after N days unwatered
- [ ] 6 new crops, 8 in total (2 per season), each with sprites
- [ ] Seed stock in the shop changes per season

**Done when:** the same crop planted in and out of season ripens at the expected different speeds.

## Step 3 — Visual seasons and weather (weeks 5–6)

- [ ] Per-season terrain texture, tree variants and sky tint
- [ ] Daily weather roll from per-season odds (data): sunny, rainy
- [ ] Rain particles (`GPUParticles3D`)
- [ ] Rain waters every planted tile in `DayTick`
- [ ] NPCs go indoors or change routes on rainy days
- [ ] Write the season and weather lines left as placeholders in Phase 2

**Done when:** every season looks different in a screenshot, and on a rainy day crops are watered and NPCs say rain lines.

## Step 4 — Town points and Orders (week 7)

- [ ] Town points earned from shipping and festivals
- [ ] `OrderDef` data: cost, prerequisites, effect
- [ ] Order board in town with an Orders menu
- [ ] Effects: unlock kitchen, unlock a shop item line, schedule a festival, expand the field
- [ ] Bought orders are saved and stay applied

**Done when:** buying the field-expansion order adds tillable land that survives save and load.

## Step 5 — Cooking (week 8)

- [ ] Kitchen in the farmhouse, unlocked by an Order
- [ ] `RecipeDef` data: ingredients (by item or category), result, RP cost, skill
- [ ] Cooking skill (levels by use)
- [ ] 6–10 recipes
- [ ] Dish level = average ingredient level
- [ ] Dishes restore RP/HP when eaten and appear in gift tastes

**Done when:** cooking with level-5 crops gives a better dish than level-1 crops, and eating it restores more RP.

## Step 6 — Harvest festival (weeks 9–10)

- [ ] Festival day: NPC schedules overridden to the square
- [ ] Harvest contest: submit one crop, score by type and level
- [ ] Results: 1st/2nd/3rd, town points, friendship with every villager (+5/+4/+3)
- [ ] Festival recurs each year once ordered

**Done when:** entering a high-level crop wins the contest and the rewards appear.

## Step 7 — Save v4 and full-year playtest (weeks 11–13)

- [ ] Save v4 adds calendar, weather, orders, recipes known; v3 saves still load
- [ ] Play a full in-game year from a new game, with notes
- [ ] Tune growth, prices, points and recipe values from notes

**Done when:** a v3 save loads into v4, and the year run has no bugs left open.

## Phase done when

- [ ] A full in-game year played from a new game, and the loop still feels good in winter
- [ ] Every season has 2 crops, its own look, and weather
- [ ] Cooking makes crop levels matter (better dishes, better gifts, contest wins)
- [ ] At least 3 Orders bought in one playthrough
- [ ] The harvest festival runs and pays out
- [ ] Calendar, weather and orders survive save → quit → load

## Not in this phase

Combat, more festivals, requests, romance, crafting/forging. See [NOT_IN_SCOPE.md](../../NOT_IN_SCOPE.md).
