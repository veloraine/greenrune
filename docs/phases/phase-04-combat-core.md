# Phase 4 — Combat core

**Goal:** weapons are more items on the Phase 1 tool pipeline, and a short field run with them meets its feel targets before any content is added.

**Phase 4 is complete when:**
- A 10-minute field run with only the short sword holds a steady 60 fps with 10 monsters on screen, and 2 testers each rate it at least 4 of 5 *(default)*.
- Every monster drop either sells through the bin or is an ingredient in at least one recipe.
- The sword cuts grass and the axe/hammer clears a stump on the farm through the same swing as the farm tools.
- Weapon skills, gates and monster state survive save → quit → load.

**Starts when:** [M1](m1-cozy-slice.md) is shipped and the decision was "continue".

**Steps:**
1. **Weapons on the tool pipeline.** `WeaponDef` (extends `ToolDef`) with attack, attack speed and combo length; a `Hurtbox` component that tool hitboxes also hit; the tools' pay-on-effect rule for RP and XP, like RF4 (magic is the exception and pays even on a miss); a damage formula as data (attack vs defense, crit chance); a 3-hit short sword combo; hit feedback (hit-stop, flash, knockback, sound, damage numbers); a training dummy on the farm.
2. **Player in combat.** Invulnerability frames after a hit; defeat runs the Phase 1 faint (wake at home the same day with half HP, lose a share of gold); the defense skill gains XP when hit; a short sword weapon skill.
3. **Monsters.** `MonsterDef` data (HP, attack, defense, speed, XP, drop table, level); an AI state machine (idle, wander, chase, wind-up, attack, hurt, flee, die); 4–5 species from asset packs, each with a distinct behaviour; drops as `Sprite3D` billboards with an item level; 2 recipes that use monster drops.
4. **Field area and gates.** A field scene outside town, linked by an exit; monster gates that spawn monsters up to a cap until destroyed and come back the next day; monster level set per area.
5. **Axe/hammer.** A second weapon class, slow and heavy, with its own weapon skill; it also clears stumps and rocks on the farm (RF4 clears them only with the axe and hammer; the Phase 1 field has none, see [Phase 1.1](phase-01-farm-loop.md#phase-11--the-field)); a new field expansion Order that comes covered in stumps and rocks.
6. **Weapon skills and difficulty.** A dash attack at weapon skill level 5 and a charge attack at level 10; Easy and Normal difficulty as data multipliers.
7. **Save v5, balance, playtest.** Save v5 adds weapon skills, gates and monster state; tune damage, HP and drop rates from notes; 2 testers do 10-minute field runs.

**Checklist:**
- [ ] Hitting the dummy shows hit-stop of 50 ms *(default)*, a flash, knockback, a sound and a damage number on the impact frame, at a steady 60 fps
- [ ] A sword swing that hits nothing costs no RP and gives no XP; one that hits the dummy does both
- [ ] The short sword's 3-hit combo chains with no dropped input
- [ ] After a hit, the player can't be hit again for 0.5 s *(default)*
- [ ] Defeat wakes you at home the same day with half HP and the gold penalty applied
- [ ] Taking hits levels the defense skill
- [ ] Every monster attack shows a wind-up of at least 0.4 s *(default)* before it lands
- [ ] A tester names each species from its behaviour alone
- [ ] Monster drops appear as billboards with a level, and they cook into 2 recipes
- [ ] Clearing every gate in the field empties it until 06:00 the next day
- [ ] The axe/hammer kills a monster and clears a stump on the farm with the same swing
- [ ] Both weapons unlock the dash attack at skill level 5 and the charge attack at 10
- [ ] The same gate takes fewer hits to clear on Easy than on Normal
- [ ] A v4 save loads into v5

**Out of scope for this phase:** taming, dungeons, bosses, magic, crafting gear, party members.

**Reference:** [research › Combat](../rf4-research.md#combat-magic-and-bosses), [research › Skills](../rf4-research.md#skills-that-level-by-use), [RF4 and Farnia research › Clearing debris](../rf4-farnia-research.md#clearing-debris).
