extends SceneTree

## Tills, waters and plants all 108 plots with ripe crops at 12:00, puts the player at the field centre,
## and prints the frame rate and frame times over a few seconds, with vsync on and then off.
## Needs a window, so run it without --headless:
##   Godot --path . --script res://tools/godot/measure_fps.gd
## It never saves, so the player's save is untouched.

const WARMUP_SECONDS: float = 2.0
const SAMPLE_SECONDS: float = 5.0


func _initialize() -> void:
	await process_frame
	create_timer(60.0).timeout.connect(quit.bind(1))
	change_scene_to_file("res://scenes/farm.tscn")
	await scene_changed
	var game: Node = root.get_node("Game")
	var field: Field = game.field
	var grid: Node3D = current_scene.get_node("Field")
	get_first_node_in_group(&"player").global_position = grid.to_global(Vector3(field.def.size.x / 2.0, 0.0, field.def.size.y / 2.0))
	field.replace_debris({})
	var crop: CropDef = game.crops.values()[0]
	for x in field.def.size.x:
		for y in field.def.size.y:
			var cell := Vector2i(x, y)
			field.apply(ToolDef.Effect.TILL, cell)
			field.apply(ToolDef.Effect.WATER, cell)
			field.sow(cell, crop, 1)
			field.crop(cell).days = 99.0
			field.changed.emit(cell)
	for vsync: DisplayServer.VSyncMode in [DisplayServer.VSYNC_ENABLED, DisplayServer.VSYNC_DISABLED]:
		DisplayServer.window_set_vsync_mode(vsync)
		await _sample(game, "vsync on " if vsync == DisplayServer.VSYNC_ENABLED else "vsync off")
	quit(0)


func _sample(game: Node, label: String) -> void:
	var elapsed: float = 0.0
	var frames: int = 0
	var worst: float = 0.0
	while elapsed < WARMUP_SECONDS + SAMPLE_SECONDS:
		game.minute = 12 * 60.0
		await process_frame
		var delta: float = root.get_process_delta_time()
		elapsed += delta
		if elapsed > WARMUP_SECONDS:
			frames += 1
			worst = maxf(worst, delta)
	print("%s: %.1f fps average over %d frames, worst frame %.1f ms, monitor %d fps, %d draw calls, %d primitives" % [
		label, frames / SAMPLE_SECONDS, frames, worst * 1000.0,
		Performance.get_monitor(Performance.TIME_FPS),
		Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME),
		Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME),
	])
