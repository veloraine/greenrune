# Assets

This folder holds downloaded asset packs. Each pack retains its original license — see the source links.

## Folder structure

```
assets/
├── characters/         KayKit Adventurers, tool models
├── crops/              Crop growth stage models, one folder per crop
├── environment/        Quaternius nature, farm props, village
├── icons/              Item icons, shared by the inventory UI and world drops
├── shaders/            Toon/cel shader files
└── audio/              CC0 audio
```

## Character packs

### KayKit Adventurers

- Source: <https://kaylousberg.com/game-assets>
- License: per KayKit terms (typically CC0 or low-cost commercial)
- Location: `characters/kaykit-adventurers/`
- Used for: player + NPC chibi character models, pre-rigged for Mixamo
- Animations: built into each GLB, 76 clips on one 41-joint skeleton that all 5 bodies share

### Tool models

- Source: [Poly Pizza](https://poly.pizza), each CC0 per its model page:
  [Tool Hoe](https://poly.pizza/m/YFNA1jgfjG) by Kenney (`hoe.glb`),
  [Watering Can](https://poly.pizza/m/V8J1TC441f) by Isa Lousberg (`watering_can.glb` and its extracted texture),
  [Sickle](https://poly.pizza/m/tQOrJKM3pz) by Pichuliru (`sickle.glb`)
- Location: `characters/tools/`
- Used for: the tools held in the player's hand. `scenes/tools/` sizes each one for `handslot_r`.
- Ours: the `*_cel.tres` materials, mapped in each `.glb.import`.

## Environment packs

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

### Quaternius Medieval Village Pack

- Source: [LowPoly Medieval Village Pack](https://opengameart.org/content/lowpoly-medieval-village-pack) by quaternius (the Dec 2020 zip), the same pack as <https://quaternius.com/packs/medievalvillage.html>
- License: CC0, see `environment/quaternius-village/License.txt` (from the zip, identical to the farm pack's)
- Location: `environment/quaternius-village/` (only 19 FBX models; the pack has 44)
- Files: buildings `Inn`, `House_1` to `House_4`, `Blacksmith`; props `MarketStand_1`, `MarketStand_2`, `Bench_1`, `Well`, `Gazebo`, `Barrel`, `Crate`, `Cart`, `Fence`, `Path_Square`, `Path_Straight`, `Door_Round`, `Window_1`
- Used for: the Phase 2 town
- Scale: each `.fbx.import` sets `nodes/root_scale=3.0`, so `House_3` covers about the farm house's footprint and the fence stands about as tall as the farm fence
- Ours: the `*_cel.tres` materials, one per pack color, mapped in each `.fbx.import`. The pack's `Beige` and `Red` share `plaster_cel.tres` and `roof_tiles_red_cel.tres`, because their colors match `Plaster` and `RoofTiles_Red`.

### LowPoly Crops Pack

- Source: [LowPoly Crops Pack](https://opengameart.org/content/lowpoly-crops-pack) by quaternius
- License: CC0, per the OpenGameArt page (the zip has no license file)
- Location: `crops/turnip/`, `crops/potato/` (only 6 FBX models; the pack has 102)
- Files: the pack has no turnip or potato, so the turnip uses `Beet_1`, `Beet_3` and `Beet_4`, and the potato uses `Lettuce_1`, `Lettuce_3` and `Lettuce_4`, renamed `stage_0.fbx` to `stage_2.fbx`
- Stages: each pack crop grows through `_1` (sprout) to `_4` (grown). We use `_1` for the seed stage, `_3` for the middle stage and `_4` for the ripe crop. `_2`, `_Crop` (the picked produce) and `_Harvested` are unused.
- Ours: the `*_cel.tres` materials, with the pack's DarkGreen and DarkRed colors, mapped in each `.fbx.import`. `scripts/farm_grid.gd` sizes each crop so its ripe model fills 0.8 of a tile.

### Greenrune models (ours)

- Location: `environment/greenrune/`; Blender sources in `environment/greenrune/source/` (a `.gdignore` keeps Godot from importing the `.blend`)
- `palette.png`: the shared palette, a 128x128 atlas of flat colour squares written by `tools/blender/palette.py`. Every model we build in Blender UVs its faces onto these squares.
- `palette_cel.tres`: the one cel `ShaderMaterial` for the palette. Each `.glb.import` maps the `palette` material to it with Use External.
- Built by `tools/blender/build_field_tiles.py`, exported by `tools/blender/export_glb.py` (see each script's header for the command)

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

### Kenney RPG Audio

- Source: <https://kenney.nl/assets/rpg-audio>
- License: CC0, see `audio/kenney-rpg-audio/License.txt`
- Location: `audio/kenney-rpg-audio/` (only `knifeSlice.ogg` and `knifeSlice2.ogg`; the pack has 51)
- Used for: the sickle's slice

### 40 CC0 water / splash / slime SFX

- Source: [40 CC0 water / splash / slime SFX](https://opengameart.org/content/40-cc0-water-splash-slime-sfx) by rubberduck
- License: CC0, per the OpenGameArt page (the zip has no license file)
- Location: `audio/rubberduck-water/` (only `splash_06`, `splash_09`, `splash_10` and `splash_15`, the four shortest splashes; the pack has 40)
- Used for: the watering can's splash

Add more from CC0 packs like [Kenney audio](https://kenney.nl/assets?q=audio) or [freesound.org](https://freesound.org/).

## Sprites and icons (placeholders)

All of these are placeholders, to be replaced with our own art. Each PNG is one 16x16 frame, so you can overwrite one file at a time.

### Farming crops 16x16

- Source: [Farming crops 16x16](https://opengameart.org/content/farming-crops-16x16) by josehzz
- License: CC0
- Files: `icons/turnip.png`, `icons/potato.png`, `icons/turnip_seed.png`, `icons/potato_seed.png`, cut from `Crop_Spritesheet.png`
- Frames: the crop icons are the sheet's portraits. The seed icons are the first sprout frame, because the pack has no seed bags.

### The Sprite Stuff

- Source: [The Sprite Stuff](https://opengameart.org/node/29290) by FacadeGaikan
- License: CC0
- Files: `icons/hoe.png` (the pack's `Hoe.png`), `icons/watering_can.png` (the pack's `watercan.png`)
- The sickle has no icon yet, so the hotbar shows its name.

## Asset cohesion rule

**Pick ONE character pack and ONE environment pack and stick to them.** Mixing chibi proportions with realistic ones is the #1 visual sin and instantly looks amateur.
