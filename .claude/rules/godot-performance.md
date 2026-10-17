---
paths:
  - "**/*.gd"
---

# GDScript Performance & Allocation Habits

Godot uses reference counting (not a tracing GC), but per-frame allocations still cause refcount churn, heap fragmentation, and cache misses that surface as frame hitches. When writing or reviewing GDScript, enforce these habits.

## Hot paths

`_process`, `_physics_process`, `_input`, `_unhandled_input`, and signal callbacks fired every frame. **Avoid all unnecessary allocations here.** Allocate at `_ready()`, reuse forever.

```gdscript
# BAD — new array every frame
func _process(delta: float) -> void:
    var nearby: Array = []
    for e in get_tree().get_nodes_in_group("enemies"):
        if global_position.distance_to(e.global_position) < 5.0:
            nearby.append(e)

# GOOD — reuse a pre-allocated buffer
var _nearby: Array = []
func _process(delta: float) -> void:
    _nearby.clear()
    for e in get_tree().get_nodes_in_group("enemies"):
        if global_position.distance_to(e.global_position) < 5.0:
            _nearby.append(e)
```

## Hidden allocations to flag in review

- `[]` or `{}` literals inside hot paths → move to a member var, `.clear()` to reuse
- `String` concatenation / `"%s" % x` per frame → cache the string, or skip
- `Array.duplicate()`, `slice()`, `filter()`, `map()` per frame → iterate in place
- Lambdas (`func(): ...`) created per frame → define a method instead
- `get_tree().get_nodes_in_group(...)` per frame in many actors → cache when possible
- `Vector2`/`Vector3`/`Color` constructors are value types — **fine**, not heap allocations

## Pool short-lived nodes

Particles, floating damage numbers, projectiles, crop highlight FX, UI popups → **pre-instantiate a pool at load time** and reuse. Do not `PackedScene.instantiate()` per spawn in steady state.

## Break refcount cycles with `WeakRef`

If `A.target = B` and `B.owner = A`, neither frees. Use `weakref(node)` for back-references, and check `wr.get_ref()` before use.

## Pre-size arrays when capacity is known

```gdscript
var slots: Array = []
slots.resize(INVENTORY_SIZE)
```

## Profile before optimizing

Use Godot's built-in profiler (Debug → Profiler) to find real hot spots. Order: correctness → readability → performance, until the profiler disagrees.
