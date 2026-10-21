# Phase 5 — Taming & barn

**Goal:** combat pays off on the farm. Tamed monsters produce goods and do farm chores.

**Phase 5 is complete when:**
- 3 tamed monsters water and harvest a full field for 7 in-game days while you are in the field area.
- Monster produce cooks into at least one dish.
- A chore monster at 0 HP stops working until it rests in the barn, so chores need rotating.
- Barn and monsters survive save → quit → load.

**Starts when:** [Phase 4](phase-04-combat-core.md) is done.

**Steps:**
1. **Barn.** A "Build barn" Order; a barn scene with a few monster slots; a tamed monster record (species, name, level, HP, friendship, produce state).
2. **Taming.** Give a held item to a wild monster ([Phase 1.3](phase-01-farm-loop.md#phase-13--hands-and-carrying)'s hold from the bag); odds from data (species base, liked item, brushed bonus, level gap, repeat-species penalty); a heart burst or a skull; a brush item that raises the odds; a taming skill that levels by use; the tamed monster goes to the barn and can be renamed.
3. **Care and produce.** Daily brushing and talking raise monster friendship; a feed bin for fodder; produce per species (milk, eggs, wool-equivalents) based on friendship; produce used in at least 2 recipes.
4. **Farm chores.** Assign a monster to a field and a chore (water, harvest or clear debris); chore AI walks the farm grid and uses the player's tile actions; chores cost monster HP and resting in the barn restores it; harvested crops go to the shipping bin or storage; a minimum friendship to accept chores.
5. **Field companion.** One barn monster follows you into the field; companion AI follows, attacks your target and retreats at low HP; barn monsters get 50% of your combat XP.
6. **Expansion, save v6, playtest.** Barn expansion Orders for more slots; save v6 adds the barn, tamed monsters and chores; a 7-day playtest using chores while fighting.

**Checklist:**
- [ ] Buying the barn Order puts an empty barn with monster slots on the farm
- [ ] Every non-boss species from Phase 4 can be tamed; a success shows a heart burst and a failure a skull
- [ ] Brushing a monster first raises its taming odds by the amount in data
- [ ] A tamed monster appears in the barn and can be renamed
- [ ] A monster brushed and talked to every day produces every day
- [ ] 3 assigned monsters water and harvest a full field with you off the farm
- [ ] A monster below the minimum friendship refuses a chore
- [ ] A companion follows you into the field, attacks your target, retreats at low HP and levels up from a cleared gate
- [ ] A bought barn expansion adds slots
- [ ] A v5 save loads into v6

**Out of scope for this phase:** taming bosses, dungeons, crafted gear.

**Reference:** [research › Monster taming and barns](../rf4-research.md#monster-taming-and-barns); monsters on farm duty clear debris at 07:00 and harvest at 15:00 ([RF4 and Farnia research › Game plan](../rf4-farnia-research.md#1-game-plan-how-rf4-paces-its-opening)).
