# Assets

This folder holds downloaded asset packs. Each pack retains its original license — see the source links.

## Folder structure

```
assets/
├── characters/         KayKit Adventurers, Mixamo retargeted animations
├── environment/        KayKit Dungeon, Quaternius nature/buildings
├── shaders/            Toon/cel shader files
└── audio/              CC0 audio
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

- Source: <https://quaternius.com/packs/ultimatenature.html> (the pack's official Google Drive, `FBX/` folder)
- License: CC0, see `environment/quaternius-nature/License.txt`
- Location: `environment/quaternius-nature/` (only `CommonTree_1`–`3`, `Grass` and `Grass_Short`; the pack has 150 models)
- Used for: trees and grass in the baseline scene
- Format: FBX, because the pack ships no glTF. Godot 4 imports FBX natively.
- Ours: the `*_cel.tres` materials. Each `.fbx.import` maps the model's Wood/Green/DarkGreen materials to them, so every instance is cel-shaded.

### Quaternius farm props

- Source: three Quaternius packs, each from its official Google Drive `FBX/` folder:
  [Farm Buildings](https://quaternius.com/packs/farmbuildings.html) (`SmallBarn`, `Fence`),
  [Ultimate House Interior](https://quaternius.com/packs/ultimatehomeinterior.html) (`Bed_Single`),
  [Ultimate RPG](https://quaternius.com/packs/ultimaterpg.html) (`Chest_Closed`)
- License: CC0, see `environment/quaternius-farm/License.txt` (identical in all three packs)
- Location: `environment/quaternius-farm/`
- Used for: the farm house, field fences, bed and shipping bin. `scenes/props/` wraps each in a `StaticBody3D` with a collider.
- Ours: the `*_cel.tres` materials, mapped in each `.fbx.import` like the nature pack.

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

### Kenney Impact Sounds

- Source: <https://kenney.nl/assets/impact-sounds>
- License: CC0, see `audio/kenney-impact/License.txt`
- Location: `audio/kenney-impact/` (only the 5 `impactSoft_heavy` files; the pack has 130)
- Used for: the hoe thud in the Week 8 feel test

Add more from CC0 packs like [Kenney audio](https://kenney.nl/assets?q=audio) or [freesound.org](https://freesound.org/).

## Asset cohesion rule

**Pick ONE character pack and ONE environment pack and stick to them.** Mixing chibi proportions with realistic ones is the #1 visual sin and instantly looks amateur.
