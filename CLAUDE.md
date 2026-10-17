# Project context
This is Greenrune (working title) — a solo hobby Rune Factory-inspired farming/town life sim built in Godot 4 stable.
The target aesthetic is RF4 / RF3 Special: chibi 3D toon-shaded characters on a tile-designed 3D world.
We use free pre-rigged asset packs (KayKit, Quaternius, Mixamo) and a community toon shader.
No custom humanoid or building modeling until at least Phase 4.

Repo folder is still named `runefactory-clone` as a placeholder; may be renamed to `greenrune` later. This does not affect any code paths.

# Phase status
Currently in Phase 0 (learning Godot 3D and the toon-shader pipeline). See PHASE_0_CHECKLIST.md.
Phase 1 starts only after Phase 0 exit criteria are met (see SCOPE.md and docs/phases/phase-01-farm-loop.md).
Combat, dungeons, monsters, marriage, magic, fishing, mining, crafting/forging, and taming are OUT OF SCOPE until Phase 4+. Cooking arrives in Phase 3. RP and use-based skills are farming systems and start in Phase 1. See NOT_IN_SCOPE.md.
Every checklist item must meet the definition of done in docs/endgame.md.

# Engine and language
- Engine: Godot 4 stable (4.5+). NEVER use Godot 3 syntax or APIs.
- Language: GDScript (not C#).
- Prefer typed GDScript (var x: int = 0, func foo(arg: String) -> void).

# Godot 4 API specifics to always honor
- Use CharacterBody2D / CharacterBody3D — NOT KinematicBody (that's Godot 3).
- Use Area2D / Area3D — NOT Area (Godot 3 name).
- Signal connection syntax: signal_name.connect(callable) — NOT connect("signal_name", target, "method").
- Use @onready, @export, @export_range annotations — NOT the old `onready var` keyword (deprecated).
- _process(delta) for frame logic, _physics_process(delta) for movement/physics.
- Scene tree paths: $NodePath or get_node("NodePath").
- For new scenes, prefer load() and PackedScene.instantiate() over preload + .instance() (Godot 3).

# Code style
- snake_case for variables and functions.
- PascalCase for class names and node types.
- SCREAMING_SNAKE_CASE for constants.
- Prefer composition over inheritance.
- Favor signals over direct cross-node references.
- One scene per concern; build complex scenes from instanced subscenes.

# 3D specifics
- Models use GLB format (binary glTF 2.0).
- Mixamo animations imported via the Antz workflow (see docs/plan.md).
- KayKit characters retextured for variety, not custom-modeled.
- Toon shader is a community cel shader applied via ShaderMaterial.
- Fixed semi-top-down camera using Camera3D on a SpringArm3D.

# Hybrid 2D/3D convention (see docs/plan.md "Hybrid 2D/3D — design convention")
- The world is 3D; abstractions of things are 2D. Default to this split.
- Inventory icons, hotbar, shop UI, tooltips, recipes, quest items: 2D Texture2D in Control nodes. NEVER put a 3D mesh in an inventory slot.
- Dropped/floating items on the ground (pre-pickup): 2D billboard Sprite3D (always-face-camera), reusing the same icon asset as the inventory.
- FX, "+N" pickup popups, sparkles, dust, distant filler grass: Sprite3D or sprite-textured GPUParticles3D.
- Crop growth stages: Sprite3D billboards (RF4-style), not per-stage 3D models.
- Things that occupy real space (player, NPCs, trees, buildings, terrain, props): 3D models, toon-shaded.
- Each item has ONE icon asset that serves both the inventory UI and the world-drop billboard. Don't author separate art for each.

# When in doubt
- Verify any Godot API call against https://docs.godotengine.org/en/stable/
- If you write code referencing a method, confirm it exists in Godot 4 docs first.
- Prefer the Antz Mixamo→Godot guide and KayKit conventions for character/animation work.
- For shaders, prefer dropping in the Godot Shaders community cel shader over writing custom.

# Godot MCP server (opt-in, Phase 1+)
- Coding-Solo/godot-mcp gives Claude Code access to launching the editor, running the project, reading debug output, and creating scenes and nodes.
- Add it at the START of Phase 1 — see docs/plan.md "Phase 1 prerequisites — Godot MCP setup".
- Not used during Phase 0 (tutorials phase) on purpose; manual practice is the point.

# AI assistant behavior in this repo
- Don't generate animated sprite frames or 3D models — placeholder text or asset-pack references only.
- Don't suggest combat, monster, or dungeon code until the user explicitly enters Phase 4.
- If asked to "add fishing/mining/etc.", remind the user it's in NOT_IN_SCOPE.md and offer to add it to a future-features list instead.
- When explaining concepts, assume the user is a first-time gamedev with prior coding experience.
- Always consult docs/plan.md, docs/endgame.md and the current phase file in docs/phases/ before making architectural suggestions.
