# Phase 4 — Combat core

**Goal:** weapons are more items on the Phase 1 tool pipeline, and a short field run with them feels good. Feel comes before content.
**Estimate:** 6–8 months (~26–35 weeks). Treat as optimistic: 3D combat feel is where RF clones die.
**Starts when:** [M1](m1-cozy-slice.md) is shipped and the decision was "continue".
**Background:** [research › Combat](../rf4-research.md#combat-magic-and-bosses), [research › Skills](../rf4-research.md#skills-that-level-by-use).

Every checked item must meet the [definition of done](../endgame.md#definition-of-done).

## Step 1 — Weapons on the tool pipeline (weeks 1–4)

- [ ] `WeaponDef` (extends `ToolDef`): attack, attack speed, combo length
- [ ] `Hurtbox` component; tool hitboxes now also hit hurtboxes
- [ ] Damage formula as data (attack vs defense, crit chance)
- [ ] Short sword: 3-hit combo
- [ ] Hit feedback: hit-stop (~50 ms), flash, knockback, sound, damage numbers
- [ ] Training dummy in the farm

**Done when:** hitting the dummy feels good at a steady 60 fps, and the sword still cuts grass on the farm.

## Step 2 — Player in combat (weeks 5–7)

- [ ] Invulnerability frames after being hit
- [ ] Defeat → wake at home next morning, lose a share of gold
- [ ] Defense skill gains XP when hit
- [ ] Weapon skill for the short sword

**Done when:** you can be defeated, wake at home with the penalty applied, and see the defense skill level up.

## Step 3 — Monsters (weeks 8–14)

- [ ] `MonsterDef` data: HP, attack, defense, speed, XP, drop table, level
- [ ] AI state machine: idle, wander, chase, wind-up, attack, hurt, flee, die
- [ ] Every attack has a readable wind-up
- [ ] 4–5 species from asset packs, each with a distinct behaviour
- [ ] Drops spawn as `Sprite3D` billboards with an item level
- [ ] 2 recipes that use monster drops

**Done when:** each species can be told apart by behaviour alone, and its drops feed a recipe.

## Step 4 — Field area and gates (weeks 15–19)

- [ ] Field scene outside town, linked by an exit
- [ ] Monster gate: spawns monsters up to a cap until destroyed
- [ ] Gates come back the next day
- [ ] Monster level set per area

**Done when:** clearing every gate empties the area until the next day.

## Step 5 — Axe/hammer (weeks 20–22)

- [ ] Second weapon class: slow, heavy, its own weapon skill
- [ ] It also clears stumps and rocks on the farm
- [ ] New field expansion Order that comes covered in stumps and rocks

**Done when:** the same weapon kills a monster and clears a stump.

## Step 6 — Weapon skills and difficulty (weeks 23–26)

- [ ] Dash attack at weapon skill level 5
- [ ] Charge attack at weapon skill level 10
- [ ] Difficulty setting: Easy, Normal (multipliers as data)

**Done when:** both weapons unlock dash and charge attacks at the right levels, and Easy is noticeably easier than Normal.

## Step 7 — Save v5, balance, playtest (weeks 27–30)

- [ ] Save v5 adds weapon skills, gates and monster state; v4 saves still load
- [ ] Tune damage, HP and drop rates from playtest notes
- [ ] 2 testers do 10-minute field runs

**Done when:** a v4 save loads into v5, and both testers want to do a second run.

## Phase done when

- [ ] A 10-minute field run with only the short sword feels good to you and 2 testers
- [ ] Steady 60 fps with 10 monsters on screen
- [ ] Drops are worth selling or cooking
- [ ] Weapons use the same pipeline as farm tools (no separate combat code path)
- [ ] Combat state survives save → quit → load

## Not in this phase

Taming, dungeons, bosses, magic, crafting gear, party members.
