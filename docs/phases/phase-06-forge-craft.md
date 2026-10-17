# Phase 6 — Forge & craft

**Goal:** gear progression runs on crafting, not on character level, with inherited effects (RF4's most-praised system), kept understandable.
**Estimate:** 3–5 months (~13–22 weeks).
**Starts when:** [Phase 5](phase-05-taming.md) is done.
**Background:** [research › Crafting, forging, cooking, chemistry and upgrades](../rf4-research.md#crafting-forging-cooking-chemistry-and-upgrades).

Every checked item must meet the [definition of done](../endgame.md#definition-of-done).

## Step 1 — Material data (weeks 1–2)

- [ ] Material classes as data (ore, cloth, bone, …)
- [ ] Each material: level, rarity, upgrade effect (stat bonus)
- [ ] Existing monster drops and produce assigned a class

**Done when:** every material item has a class and an effect in data.

## Step 2 — Stations and recipes (weeks 3–5)

- [ ] Forge (weapons, tools) and crafting table (armor, accessories), each unlocked by an Order
- [ ] `RecipeDef` gains a station field; cooking recipes keep working
- [ ] Recipe slots accept a specific item or a material class
- [ ] Recipes learned from recipe items
- [ ] Unknown recipes can be tried at a higher RP cost; failure gives a junk item

**Done when:** a known recipe and an unknown one both craft, and the unknown one costs more RP.

## Step 3 — Gear (weeks 6–8)

- [ ] Equipment slots: weapon, armor, headgear, accessory
- [ ] Gear items are single instances (not stacks)
- [ ] Stats summed from gear and shown in a status screen
- [ ] ~6 weapons (3 per class) and ~8 armor pieces as recipes

**Done when:** equipping each piece changes the status screen by exactly its listed stats.

## Step 4 — Inheritance and upgrades (weeks 9–12)

- [ ] Up to 3 extra materials when crafting pass their effects to the item
- [ ] Inherited items get a marked name colour
- [ ] Upgrade at the forge: +1 material per upgrade, up to 5 upgrades
- [ ] Repeating the same material gives half the effect
- [ ] Each gear instance stores its upgrade history
- [ ] Save v7 adds gear instances and history; v6 saves still load

**Done when:** a sword crafted with 3 extra materials and 2 upgrades shows each effect in its tooltip, and a v6 save loads into v7.

## Step 5 — Tool upgrades (weeks 13–14)

- [ ] Tool tiers crafted at the forge
- [ ] Higher tiers: larger charged area, lower RP cost

**Done when:** an upgraded hoe tills a larger area for less RP than the starter hoe.

## Step 6 — Crafting UI and skills (weeks 15–17)

- [ ] Forging and crafting skills (level by use, lower RP cost)
- [ ] Result stats previewed before you confirm
- [ ] Big text, at most 2 screens deep

**Done when:** a tester crafts an upgraded weapon without help.

## Step 7 — Balance and playtest (weeks 18–20)

- [ ] Shop weapons vs crafted weapons compared in a table
- [ ] Tune material effects and recipe costs

**Done when:** the balance table shows the target below.

## Phase done when

- [ ] A crafted weapon with an inherited effect beats the best shop weapon of its tier
- [ ] The tooltip explains where every stat comes from
- [ ] Gear, upgrades and history survive save → quit → load
- [ ] Every recipe and material lives in `data/`

## Not in this phase

Multiplier materials (2x/8x) and stat-inverting materials (Phase 9), chemistry, shields.
