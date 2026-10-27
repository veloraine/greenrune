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
	for test: Callable in [test_field_def, test_block_of, test_old_save]:
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
