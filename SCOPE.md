# Current scope

This document lists ONLY what is in scope for the current phase. If a feature is not on this list, it is not in scope.

When you have a "wouldn't it be cool if..." idea, write it in [NOT_IN_SCOPE.md](NOT_IN_SCOPE.md), not in the code.

## Phase 0 — Learning (current)

Goal: gain the technical skills to build Phase 1. No game development in this phase.

- [ ] Install Godot 4 stable
- [ ] Set up Claude Code + Godot (script auto-reload, `CLAUDE.md`)
- [x] Complete Godot Docs "Your First 3D Game"
- [ ] Complete GDQuest "Survivor Arena FPS"
- [ ] Complete Coding Quests "3D Action RPG Remastered" (8 hours, spread across weeks)
- [ ] Apply community cel shader to a test scene
- [ ] Import a KayKit character + Mixamo animation
- [ ] Build `baseline_scene.tscn` as visual proof
- [ ] Feel test: a throwaway hoe swing that feels good

**Exit criterion:** a KayKit chibi character with Mixamo idle animation, toon-shaded, standing on a Quaternius grass patch, viewed from an RF4-style camera angle. Saved as `baseline_scene.tscn`. Screenshot taken. Feel test done, with notes.

See [PHASE_0_CHECKLIST.md](PHASE_0_CHECKLIST.md) for the weekly breakdown.

## Phase 1 — Farming prototype (future)

Will be unlocked when Phase 0 exit criterion is met. Until then, do not start.

When unlocked, scope will be:

- Player movement (KayKit chibi + Mixamo) with fixed RF4-angle camera
- One 3D farm scene built from Quaternius + KayKit Dungeon props
- Tools: hoe, watering can, sickle, seeds, harvest — each a swing with a hitbox, RP cost and skill XP
- RP bar spent by every tool action; empty RP drains HP; sleep refills
- 4–6 skills that level by use (lower RP cost, raise max RP)
- 2 crop types with 3 growth-stage 3D models
- Crop and seed levels 1–10; sickle-reaping returns seeds, sometimes a level higher
- Data-driven item definitions (Godot `Resource` or CSV), no hard-coded items
- Inventory + hotbar (2D UI over 3D), stacks stored as item id + level
- Day cycle with sleep-to-next-day; one ordered 06:00 daily tick
- Save/load (implemented in week 2–3, NOT later), including item levels, RP and skill XP
- Single shop NPC with sell economy

Step-by-step checklist: [docs/phases/phase-01-farm-loop.md](docs/phases/phase-01-farm-loop.md). See [docs/rf4-research.md](docs/rf4-research.md) for why each of these is here.
