extends SceneTree

## Phase 1.1 field checks: the field resource, cell → block, a 12×12 save loading onto the 9×12 field,
## the starting debris and its save, tools skipping debris, the soil tile models, and the well and bin by the field.
## Run: Godot --headless --path . --script res://tools/godot/check_field.gd


func _initialize() -> void:
	await process_frame
	# A signal that never fires would otherwise hang the run.
	create_timer(60.0).timeout.connect(quit.bind(1))
	var tests: GDScript = load("res://tools/godot/check_field_tests.gd")
	var failed: int = 1 if tests == null or not tests.can_instantiate() else await tests.new(self).run()
	print("check_field: %s" % ("FAIL" if failed > 0 else "PASS"))
	quit(1 if failed > 0 else 0)
