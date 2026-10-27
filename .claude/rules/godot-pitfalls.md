---
paths:
  - "**/*.gd"
  - "**/*.tscn"
  - "**/*.tres"
  - "**/*.gdshader"
---

# Godot 4.7 pitfalls

These are traps that compile fine and then fail quietly. The CLAUDE.md Godot 3 → 4 rules still apply.

## GDScript (4.7)

- An overriding method inherits the parent's typed return, so every code path must `return` a value.
- Setting one element of a packed-array property (`points[0] = v`) skips that property's setter. Reassign the whole array when the setter must run.

## Resources (`*_def.gd`, `.tres`)

- A `.tres` is one shared object. Mutating it at runtime changes every user and the saved file. Call `duplicate(true)` for per-instance state.
- `duplicate(true)` still shares sub-resources saved as their own `.tres`. Use `duplicate_deep(Resource.DEEP_DUPLICATE_ALL)` when those must be copied too.
- `res://` is read-only in exports. Runtime saves go to `user://`.

## Signals and scenes

- Connecting again after re-adding a node stacks handlers. Guard with `is_connected()`.
- A lambda that captures a node keeps firing after that node is freed. Connect methods instead, or disconnect the lambda.
- `call_group()` ignores nodes that lack the method, so a typo fails silently. Use a typed signal when the contract matters.
- `change_scene_to_file()` takes the old scene out of the tree at once, so `get_tree()` returns `null` after the call. Do follow-up work in the new scene's `_ready()`, or in an autoload after `await get_tree().scene_changed`.

## 3D and animation

- `look_at()` fails when the target sits on the node or the direction is parallel to `up`, as in a straight-down camera. Pass a different `up` vector.
- Non-uniform `scale` on a `Node3D` distorts child collisions and lights. Scale the mesh asset instead.
- When an `AnimationTree` is active, don't call `AnimationPlayer.play()` on the same tracks. A wrong `parameters/...` path does nothing and raises no error.
- `node.create_tween()` pauses while the node is out of the tree. Tweens run once: make a new one per animation, and tween sub-properties with `"modulate:a"`.

## UI

- A container resets its children's transforms. For a hover pop or nudge, set `offset_transform_enabled = true` and tween `offset_transform_*` (4.7+).
- A full-rect decorative `Control` swallows clicks meant for nodes under it. Set `mouse_filter = MOUSE_FILTER_IGNORE` on it.
- Gamepad navigation needs a focused control. Call `grab_focus()` on the first control when a menu opens.

## Shaders (toon/cel)

- A color uniform without `: source_color` skips the sRGB conversion and looks washed out.
- Reading or writing `ALPHA` in a spatial shader moves the material to the transparent pass, which costs it shadows and draw order, even when `ALPHA` is 1.0. For hard cut-outs, use `ALPHA_SCISSOR_THRESHOLD`.
- `TIME` wraps every hour (`time_rollover_secs`). Pick loop periods that divide 3600, or pass your own time in through a uniform.

## After moving or renaming files

Run `python3 tools/check_godot_project.py .` and fix every `ERROR`. It catches broken `res://` paths, wrong-case paths that break on export, bad `parent=` paths and dangling connections.
