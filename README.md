# Greenrune

A solo hobby farming and town life-sim inspired by Rune Factory 3 Special and Rune Factory 4.

Working title; may change before release.

## Status

Phase 1 — farm loop. Steps 1–6 are built; sub-phases 1.1–1.6 polish it one area at a time.

## Visual target

Chibi 3D characters with toon shading on a tile-designed 3D world. Asset packs are the base (KayKit, Quaternius + community cel shader); Blender edits them and makes crops, terrain and small props from Phase 1. One custom adult base body on the KayKit skeleton arrives in Phase 2.0; no custom buildings before Phase 4.

## Tech

- Godot 4 stable + GDScript
- Blender from Phase 1 for crops, terrain, soil, debris and small props (Claude builds the base, the user polishes)
- Claude Code for scripts (project rules in [CLAUDE.md](CLAUDE.md))
- Git + Git LFS for binary assets

## Roadmap

See [docs/plan.md](docs/plan.md) for the full roadmap. There is no schedule: each phase is split into sub-phases, worked one at a time until polished.

Phase summary:

- Phase 0 — Learn Godot 3D, asset pipeline, toon shader, feel test (done)
- Phase 1 — 3D farm loop: field, tool feel, hands and carrying, crops, the day's frame, five-day gate
- Phase 2 — 3D town, NPCs, dialogue, shop, request box
- Phase 3 — Seasons, weather, town orders, cooking, harvest festival
- After Phase 3 — Re-evaluate, ship vertical slice, or continue to combat

## Scope

- [SCOPE.md](SCOPE.md) — what is in scope right now
- [NOT_IN_SCOPE.md](NOT_IN_SCOPE.md) — deferred features (combat, marriage, dungeons, etc.)
- [PHASE_0_CHECKLIST.md](PHASE_0_CHECKLIST.md) — the finished Phase 0 learning checklist
- [docs/rf4-research.md](docs/rf4-research.md) — sourced RF4 research the plan is based on
- [docs/endgame.md](docs/endgame.md) — road to 1.0: scope targets, milestones, definition of done
- [docs/phases/](docs/phases/) — one plan per phase: steps, checklists, and what counts as done

## Setup

```bash
# Install Git LFS first
git lfs install

git clone <your-repo-url>
cd runefactory-clone
git lfs pull
```

Open the project in Godot 4 stable and run Claude Code in the same folder. See the "Claude Code + Godot workflow" section in [docs/plan.md](docs/plan.md) for setup.

## License

Personal hobby project. Asset packs retain their original licenses (see [assets/README.md](assets/README.md)).
