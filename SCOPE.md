# Current scope

This document lists ONLY what is in scope for the current phase. If a feature is not on this list, it is not in scope.

When you have a "wouldn't it be cool if..." idea, write it in [NOT_IN_SCOPE.md](NOT_IN_SCOPE.md), not in the code.

## Phase 0 — Learning (current)

Goal: gain the technical skills to build Phase 1. No game development in this phase.

- [ ] Install Godot 4 stable + Blender LTS
- [ ] Configure Cursor + Godot integration (`godot-tools`, external editor, `.cursorrules`)
- [ ] Complete Godot Docs "Your First 3D Game"
- [ ] Complete GDQuest "Survivor Arena FPS"
- [ ] Start Blender Guru's Donut Tutorial
- [ ] Complete Coding Quests "3D Action RPG Remastered" (8 hours, spread across weeks)
- [ ] Master Blender → Godot GLTF export pipeline
- [ ] Apply community cel shader to a test scene
- [ ] Import a KayKit character + Mixamo animation
- [ ] Build `baseline_scene.tscn` as visual proof

**Exit criterion:** a KayKit chibi character with Mixamo idle animation, toon-shaded, standing on a Quaternius grass patch, viewed from an RF4-style camera angle. Saved as `baseline_scene.tscn`. Screenshot taken.

See [PHASE_0_CHECKLIST.md](PHASE_0_CHECKLIST.md) for the weekly breakdown.

## Phase 1 — Farming prototype (future)

Will be unlocked when Phase 0 exit criterion is met. Until then, do not start.

When unlocked, scope will be:

- Player movement (KayKit chibi + Mixamo) with fixed RF4-angle camera
- One 3D farm scene built from Quaternius + KayKit Dungeon props
- Tools: hoe, watering can, seeds, harvest
- 2 crop types with 3 growth-stage 3D models
- Inventory + hotbar (2D UI over 3D)
- Day cycle with sleep-to-next-day
- Save/load (implemented in week 2–3, NOT later)
- Single shop NPC with sell economy
