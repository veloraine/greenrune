# Assets

This folder holds downloaded asset packs. Each pack retains its original license — see the source links.

## Folder structure

```
assets/
├── characters/         KayKit Adventurers, Mixamo retargeted animations
├── environment/        KayKit Dungeon, Quaternius nature/buildings
├── shaders/            Toon/cel shader files
└── audio/              CC0 audio (Phase 1+ only)
```

## Character packs

### KayKit Adventurers

- Source: <https://kaylousberg.com/game-assets>
- License: per KayKit terms (typically CC0 or low-cost commercial)
- Location: `characters/kaykit-adventurers/`
- Used for: player + NPC chibi character models, pre-rigged for Mixamo

## Environment packs

### KayKit Dungeon Pack

- Source: <https://kaylousberg.com/game-assets>
- Location: `environment/kaykit-dungeon/`
- Used for: buildings, doors, fences, props

### Quaternius Ultimate Nature

- Source: <https://quaternius.com/>
- License: CC0
- Location: `environment/quaternius-nature/`
- Used for: trees, rocks, grass, terrain props

## Animations

### Mixamo

- Source: <https://www.mixamo.com> (free, Adobe account required)
- Location: `characters/mixamo/<character_name>/`
- Used for: walk, idle, attack, sit, etc. — retargeted to KayKit characters
- Workflow: <https://antzgames.github.io/godot/demo/tutorial/Mixamo/>

## Shaders

### Complete Cel Shader for Godot 4

- Source: <https://godotshaders.com/shader/complete-cel-shader-for-godot-4/>
- Code: <https://github.com/eldskald/godot4-cel-shader> (`src/`, unmodified)
- License: MIT, see `shaders/cel/LICENSE`
- Location: `shaders/cel/`
- Used for: toon/cel shading on all 3D models
- Ours: `outline_material.tres`, `cel-shader-double-sided.gdshader` (a cull-disabled copy for capes). `diffuse_curve.tres` is the upstream demo's `diffuse-texture.tres`.

## Audio

Empty until Phase 1+. Use CC0 packs like [Kenney audio](https://kenney.nl/assets?q=audio) or [freesound.org](https://freesound.org/).

## Asset cohesion rule

**Pick ONE character pack and ONE environment pack and stick to them.** Mixing chibi proportions with realistic ones is the #1 visual sin and instantly looks amateur.
