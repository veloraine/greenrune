extends SceneTree

## Phase 1.2 tool checks: cheap and bronze tools, charged areas snapped to blocks along the facing,
## charged sowing, water per plot, old saves' tool ids, the target marker and charge cues, the water gauge,
## and the feedback for RP spent and for a swing that changes nothing.
## Run: Godot --headless --path . --script res://tools/godot/check_tools.gd


func _initialize() -> void:
	await process_frame
	# A signal that never fires would otherwise hang the run.
	create_timer(60.0).timeout.connect(quit.bind(1))
	var tests: GDScript = load("res://tools/godot/check_tools_tests.gd")
	var failed: int = 1 if tests == null or not tests.can_instantiate() else await tests.new(self).run()
	# The audio server lets go of stopped streams on a later mix; quitting at once leaks them.
	await create_timer(0.2).timeout
	print("check_tools: %s" % ("FAIL" if failed > 0 else "PASS"))
	quit(1 if failed > 0 else 0)
