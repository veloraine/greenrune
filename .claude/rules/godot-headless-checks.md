---
paths:
  - "tools/godot/**"
---

# Headless check scripts

Checks are `extends SceneTree` scripts run with:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script res://tools/godot/<check>.gd
```

They exit 0 on pass and 1 on fail. The exit code is the result, not the printed text.

- **Import first** after a fresh checkout or after adding a GLB or texture: `--headless --path . --import`. Without it, `class_name` types and new assets don't resolve.
- **Never use a bare `assert()`.** A failed assert in `_initialize()` stops the function before it reaches `quit()`, and the process hangs. Use a `check(cond, msg)` helper that counts failures and keeps going.
- **Call `quit(1 if failed > 0 else 0)` yourself.** `push_error()` doesn't change the exit code.
- **Tests return `-> bool` and end with `return true`.** A runtime error aborts only that function and returns a default value. Count any result other than `true` as a failure, or a crashed test passes silently.
- **`root` isn't in the tree during `_initialize()`.** Timers added there never fire. `await process_frame` before you add nodes, start timers or wait on signals.
- **Back every signal `await` with a timeout.** A signal that never fires hangs the run forever.
