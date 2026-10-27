extends RefCounted

## The tests run by check_field.gd. Loaded at runtime, after the autoloads exist, because a --script
## file can't compile anything that names an autoload such as Game.

var failed: int = 0
var tree: SceneTree


class WarningLog extends Logger:
	var messages: Array[String] = []

	func _log_error(_function: String, _file: String, _line: int, code: String, rationale: String, _editor_notify: bool, error_type: int, _script_backtraces: Array[ScriptBacktrace]) -> void:
		if error_type == ERROR_TYPE_WARNING:
			messages.append(code + " " + rationale)


func _init(p_tree: SceneTree) -> void:
	tree = p_tree


func run() -> int:
	for test: Callable in [test_field_def, test_block_of, test_old_save, test_debris_scatter, test_debris_save, test_save_without_debris, test_tool_skips_debris]:
		if (await test.call()) != true:
			failed += 1
			printerr("FAIL: %s did not finish" % test.get_method())
	return failed


func check(cond: bool, msg: String) -> void:
	if not cond:
		failed += 1
		printerr("FAIL: " + msg)


func test_field_def() -> bool:
	var def: FieldDef = load("res://data/field.tres")
	check(def.size == Vector2i(9, 12), "field size is %s, want (9, 12)" % def.size)
	check(def.block_size == 3, "block size is %d, want 3" % def.block_size)
	return true


func test_block_of() -> bool:
	var grid := FarmGrid.new()
	var cases: Dictionary[Vector2i, Vector2i] = {
		Vector2i(0, 0): Vector2i(0, 0),
		Vector2i(8, 0): Vector2i(2, 0),
		Vector2i(0, 11): Vector2i(0, 3),
		Vector2i(8, 11): Vector2i(2, 3),
		Vector2i(4, 5): Vector2i(1, 1),
		Vector2i(3, 6): Vector2i(1, 2),
	}
	for cell in cases:
		check(grid.block_of(cell) == cases[cell], "block_of(%s) is %s, want %s" % [cell, grid.block_of(cell), cases[cell]])
	grid.free()
	return true


## Writes a synthetic v2 save tilling all 12×12 cells and loads it through SaveGame.read() on the farm.
## It uses its own save file, so the player's save is never touched.
func test_old_save() -> bool:
	SaveGame.path = "user://check_field_save.json"
	tree.change_scene_to_file("res://scenes/farm.tscn")
	await tree.scene_changed
	var field: Array = []
	for x in 12:
		for y in 12:
			field.append({"cell": [x, y], "watered": false, "crop": null})
	var data: Dictionary = {
		"version": 2, "day": 1, "minute": 400.0, "gold": 0, "area": "farm",
		"player_position": [0.0, 0.0, -12.0], "rp": 50, "hp": 50,
		"inventory": [], "bin": [], "field": field,
	}
	var file: FileAccess = FileAccess.open(SaveGame.path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()

	var log := WarningLog.new()
	OS.add_logger(log)
	var result: Error = SaveGame.read(tree)
	OS.remove_logger(log)

	DirAccess.remove_absolute(SaveGame.path)

	check(result == OK, "SaveGame.read returned %s" % error_string(result))
	var plots: Dictionary[Vector2i, Field.Plot] = Game.field.plots()
	check(plots.size() == 108, "%d plots loaded, want 108" % plots.size())
	for cell in plots:
		check(Rect2i(0, 0, 9, 12).has_point(cell), "plot %s is off the 9×12 field" % cell)
	check(log.messages.any(func(m: String) -> bool: return m.contains("36 plots outside the field")), "no warning about 36 plots outside the field; got %s" % [log.messages])
	return true


func test_debris_scatter() -> bool:
	var def: FieldDef = load("res://data/field.tres")
	var field := Field.new(def)
	field.scatter_debris()
	var debris: Dictionary[Vector2i, DebrisDef] = field.all_debris()
	var counts: Dictionary[DebrisDef, int] = {}
	for cell in debris:
		check(field.has_cell(cell), "debris %s is off the field" % cell)
		check(not def.debris_free.has_point(cell), "debris %s is in the clear area by the player's start" % cell)
		counts[debris[cell]] = counts.get(debris[cell], 0) + 1
	check(counts == def.starting_debris, "debris counts are %s, want %s" % [counts, def.starting_debris])
	var again := Field.new(def)
	again.scatter_debris()
	check(again.all_debris() == debris, "a second new game placed different debris")
	return true


## Saves the farm, clears the debris, loads, and expects the same debris back.
func test_debris_save() -> bool:
	SaveGame.path = "user://check_field_save.json"
	tree.change_scene_to_file("res://scenes/farm.tscn")
	await tree.scene_changed
	Game.field.scatter_debris()
	var before: Dictionary[Vector2i, DebrisDef] = Game.field.all_debris().duplicate()
	var written: Error = SaveGame.write(tree)
	Game.field.replace_debris({})
	var result: Error = SaveGame.read(tree)
	DirAccess.remove_absolute(SaveGame.path)
	check(written == OK and result == OK, "save → load returned %s, %s" % [error_string(written), error_string(result)])
	check(not before.is_empty() and Game.field.all_debris() == before, "debris after load is %s, want %s" % [Game.field.all_debris(), before])
	return true


## A v2 save from before debris has no "debris" key and loads with a clear field.
func test_save_without_debris() -> bool:
	SaveGame.path = "user://check_field_save.json"
	tree.change_scene_to_file("res://scenes/farm.tscn")
	await tree.scene_changed
	Game.field.scatter_debris()
	var data: Dictionary = {
		"version": 2, "day": 1, "minute": 400.0, "gold": 0, "area": "farm",
		"player_position": [0.0, 0.0, -12.0], "rp": 50, "hp": 50,
		"inventory": [], "bin": [], "field": [],
	}
	var file: FileAccess = FileAccess.open(SaveGame.path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	var result: Error = SaveGame.read(tree)
	DirAccess.remove_absolute(SaveGame.path)
	check(result == OK, "SaveGame.read returned %s" % error_string(result))
	check(Game.field.all_debris().is_empty(), "%d debris loaded from a save without debris" % Game.field.all_debris().size())
	return true


## A hoe tap on a debris plot leaves it untilled and costs no RP. The same tap on a clear plot tills it
## and costs RP, so the check can tell the two apart.
func test_tool_skips_debris() -> bool:
	tree.change_scene_to_file("res://scenes/farm.tscn")
	await tree.scene_changed
	var farm: Node = tree.current_scene
	var grid: FarmGrid = farm.get_node("Field")
	var player: Player = farm.get_node("Player")
	var stack := ItemStack.new(Game.items[&"hoe"], 1, 1)
	var tool: ToolDef = stack.item
	var debris_cell := Vector2i(4, 6)
	var clear_cell := Vector2i(4, 8)
	var cells: Dictionary[Vector2i, DebrisDef] = {debris_cell: Game.debris[&"stone"]}
	Game.field.replace_debris(cells)
	Game.field.replace_plots({})
	for cell: Vector2i in [debris_cell, clear_cell]:
		var rp: int = Game.stats.rp
		var xp: float = Game.stats.xp(tool.skill)
		# Facing +z, one reach short of the plot's centre.
		player.rotation.y = PI
		player.global_position = grid.to_global(Vector3(cell.x + 0.5, 0.0, cell.y + 0.5 - tool.reach / grid.tile_size))
		var hit: Array[Vector2i] = []
		grid.cells_hit(player.global_position, player.tool_point(tool), tool.charges[0].size, hit)
		check(hit == [cell], "a tap aimed at %s hits %s" % [cell, hit])
		farm._on_tool_used(stack, 0)
		var on_debris: bool = cell == debris_cell
		check((Game.field.soil(cell) == Field.Soil.UNTILLED) == on_debris, "a hoe tap on %s left soil %s" % [cell, Field.Soil.find_key(Game.field.soil(cell))])
		check((Game.stats.rp == rp) == on_debris, "a hoe tap on %s took RP %d → %d" % [cell, rp, Game.stats.rp])
		check((Game.stats.xp(tool.skill) == xp) == on_debris, "a hoe tap on %s took XP %.1f → %.1f" % [cell, xp, Game.stats.xp(tool.skill)])
	check(Game.field.debris(debris_cell) == Game.debris[&"stone"], "the debris at %s is gone" % debris_cell)
	return true
