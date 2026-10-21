# Phase 6 — Forge & craft

**Goal:** gear progression runs on crafting, not on character level, with inherited effects (RF4's most-praised system), kept understandable.

**Phase 6 is complete when:**
- A crafted weapon with an inherited effect deals more damage than the best shop weapon of its tier.
- Every stat in a gear tooltip names its source: base, material or upgrade.
- A gold hoe charges to a larger block-snapped area than a bronze hoe (3×9 against 3×3 *(default)*).
- Gear, upgrades and their history survive save → quit → load.

**Starts when:** [Phase 5](phase-05-taming.md) is done.

**Steps:**
1. **Material data.** Material classes as data (ore, cloth, bone, …); each material has a level, a rarity and an upgrade effect (stat bonus); existing monster drops and produce get a class.
2. **Stations and recipes.** A forge (weapons, tools) and a crafting table (armor, accessories), each unlocked by an Order; `RecipeDef` gains a station field and cooking recipes keep working; recipe slots accept a specific item or a material class; recipes are learned from recipe items; unknown recipes can be tried at a higher RP cost, and failure gives a junk item.
3. **Gear.** Equipment slots (weapon, armor, headgear, accessory); gear items are single instances, not stacks; stats summed from gear and shown in a status screen; ~6 weapons (3 per class) and ~8 armor pieces as recipes.
4. **Inheritance and upgrades.** Up to 3 extra materials when crafting pass their effects to the item; inherited items get a marked name colour; forge upgrades add 1 material each, up to 5; repeating a material gives half the effect; each gear instance stores its upgrade history; save v7 adds gear instances and history.
5. **Tool upgrades.** Tool tiers crafted at the forge, bronze → silver → gold → platinum, with the charge areas set in [Phase 1.2](phase-01-farm-loop.md#phase-12--tool-feel); the shop's bronze tools ([Phase 2.3](phase-02-town-npcs.md#phase-23--the-shop)) stay on sale; higher tiers charge larger areas for less RP; the sickle's tier caps the reaped seed level (RF4: Cheap 3, Bronze 4, Silver 6, Gold 8, Platinum 10).
6. **Crafting UI and skills.** Forging and crafting skills that level by use and lower RP cost; result stats previewed before you confirm; menu text at least 24 px at 1080p *(default)*, at most 2 screens deep.
7. **Balance and playtest.** Compare shop and crafted weapons in a table; tune material effects and recipe costs.

**Checklist:**
- [ ] Every material item shows its class and effect in its tooltip
- [ ] A known recipe and an unknown one both craft, and the unknown one costs more RP; a failed attempt gives a junk item
- [ ] A slot that takes a material class accepts any item of that class
- [ ] Equipping each piece changes the status screen by exactly its listed stats
- [ ] A sword crafted with 3 extra materials and 2 upgrades shows each effect in its tooltip, and a repeated material shows half its effect
- [ ] An inherited item's name shows in the marked colour
- [ ] Each tool tier can be forged, and a higher tier costs less RP per charge than the one below
- [ ] A silver sickle reaps seeds above the bronze sickle's level cap
- [ ] The crafting screen previews result stats before you confirm, with text at least 24 px at 1080p *(default)* and no menu deeper than 2 screens
- [ ] A tester crafts an upgraded weapon without asking you anything
- [ ] A v6 save loads into v7

**Out of scope for this phase:** multiplier materials (2x/8x) and stat-inverting materials (Phase 9), chemistry, shields.

**Reference:** [research › Crafting, forging, cooking, chemistry and upgrades](../rf4-research.md#crafting-forging-cooking-chemistry-and-upgrades); tool tiers and the sickle-tier seed cap ([RF4 and Farnia research › Tools, areas and charge](../rf4-farnia-research.md#tools-areas-and-charge)).
