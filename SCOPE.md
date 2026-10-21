# Current scope

This document lists ONLY what is in scope for the current phase. If a feature is not on this list, it is not in scope.

When you have a "wouldn't it be cool if..." idea, write it in [NOT_IN_SCOPE.md](NOT_IN_SCOPE.md), not in the code.

## Phase 1 — Farm loop (current)

Steps 1–6 built the systems: player and RF4-angle camera, data-driven items and inventory, field grid and tool pipeline, RP, HP and use-based skills, crops with levels, clock, sleep and the 06:00 day tick, the shipping bin, save v2. Phase 1 is now polished one sub-phase at a time, with no schedule:

- **1.1 The field:** Blender export setup and the shared palette texture; a 9×12 field in 3×3 blocks with faint outlines; weeds, stones and branches on a new field; soil states that read by day and night; the camera.
- **1.2 Tool feel:** Farnia's 3×3 gated by tool tier (cheap tools tap one plot; bronze charges to the player's 3×3 block; silver and up a line of blocks *(default)*), charges centred on the player and snapped to blocks, a straight two-handed hoe swing, water spent per plot, target marker, charge cues, water gauge, water as you walk.
- **1.3 Hands and carrying:** lift, carry, throw and store; debris cleared by hand; harvests carried; debris regrowth.
- **1.4 Crops:** crop stage models adjusted in Blender, seeded soil, ripe cue, RF4 withering into Withered Grass, rune orbs, harvest pop.
- **1.5 The day's frame:** time-frozen first-morning lesson, starting kit, HUD date, 08:00 and new-day cues, RP budget re-tuned.
- **1.6 Five-day gate:** five days played, tuned and bug-free.

Selling is through the shipping bin only; RF4 shops buy nothing. Blender work in this phase is crops, terrain, soil, debris and small farm props: Claude builds the base, the user polishes. No custom humanoids or buildings: the character base comes in Phase 2.0, custom buildings in Phase 4+.

Step-by-step checklist: [docs/phases/phase-01-farm-loop.md](docs/phases/phase-01-farm-loop.md). See [docs/rf4-research.md](docs/rf4-research.md) and [docs/rf4-farnia-research.md](docs/rf4-farnia-research.md) for why each of these is here.

## Phase 0 — Learning (done)

Phase 0 is done; [PHASE_0_CHECKLIST.md](PHASE_0_CHECKLIST.md) is the record. The list below is kept as it was written.

- [x] Install Godot 4 stable
- [ ] Set up Claude Code + Godot (script auto-reload, `CLAUDE.md`)
- [x] Complete Godot Docs "Your First 3D Game"
- [ ] Complete GDQuest "Survivor Arena FPS"
- [ ] Complete Coding Quests "3D Action RPG Remastered" (8 hours, spread across weeks)
- [ ] Apply community cel shader to a test scene
- [ ] Import a KayKit character + Mixamo animation
- [ ] Build `baseline_scene.tscn` as visual proof
- [ ] Feel test: a throwaway hoe swing that feels good

**Exit criterion:** a KayKit chibi character with Mixamo idle animation, toon-shaded, standing on a Quaternius grass patch, viewed from an RF4-style camera angle. Saved as `baseline_scene.tscn`. Screenshot taken. Feel test done, with notes. (The KayKit GLBs' built-in clips replaced Mixamo.)
