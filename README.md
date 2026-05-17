# Greenrune

A solo hobby farming and town life-sim inspired by Rune Factory 3 Special and Rune Factory 4.

Working title; may change before release.

## Status

Phase 0 — learning Godot 3D, Blender basics, and the toon-shader pipeline.

## Visual target

Chibi 3D characters with toon shading on a tile-designed 3D world. Asset-packs-only commitment through Phase 3 (KayKit, Quaternius, Mixamo + community cel shader).

## Tech

- Godot 4 stable + GDScript
- Blender (minimal use)
- Cursor with `godot-tools` extension for scripts
- Git + Git LFS for binary assets

## Roadmap

See [docs/plan.md](docs/plan.md) for the full roadmap (~12–15 months to playable vertical slice).

Phase summary:

- Phase 0 — Learn Godot 3D, Blender, toon shader (~6–8 weeks)
- Phase 1 — 3D farming prototype (~2–3 months)
- Phase 2 — 3D town + NPCs + dialogue (~3–4 months)
- Phase 3 — Seasons + festivals + weather (~2 months)
- Phase 3.5 — Re-evaluate, ship vertical slice, or continue to combat

## Scope

- [SCOPE.md](SCOPE.md) — what is in scope right now
- [NOT_IN_SCOPE.md](NOT_IN_SCOPE.md) — deferred features (combat, marriage, dungeons, etc.)
- [PHASE_0_CHECKLIST.md](PHASE_0_CHECKLIST.md) — current learning checklist

## Setup

```bash
# Install Git LFS first
git lfs install

git clone <your-repo-url>
cd runefactory-clone
git lfs pull
```

Open the project in Godot 4 stable and Cursor side-by-side. See the "Cursor + Godot workflow" section in [docs/plan.md](docs/plan.md) for editor integration.

## License

Personal hobby project. Asset packs retain their original licenses (see [assets/README.md](assets/README.md)).
