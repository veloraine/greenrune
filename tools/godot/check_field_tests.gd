extends RefCounted

## The tests run by check_field.gd. Loaded at runtime, after the autoloads exist, because a --script
## file can't compile anything that names an autoload such as Game.

var failed: int = 0
var tree: SceneTree


## Records warnings and errors.
class WarningLog extends Logger:
	var messages: Array[String] = []

	func _log_error(_function: String, _file: String, _line: int, code: String, rationale: String, _editor_notify: bool, _error_type: int, _script_backtraces: Array[ScriptBacktrace]) -> void:
		messages.append(code + " " + rationale)


func _init(p_tree: SceneTree) -> void:
	tree = p_tree


func run() -> int:
	for test: Callable in [test_field_def, test_block_of, test_old_save, test_debris_scatter, test_debris_save, test_save_without_debris, test_debris_off_field, test_debris_under_plot, test_debris_overfull, test_tool_skips_debris, test_soil_tiles, test_farm_props]:
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
	# An earlier test leaves every cell tilled, and tilled cells load no debris.
	Game.field.replace_plots({})
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


## Loads a synthetic v2 save holding these plots and debris on the farm, and returns read()'s result.
func _load_save(field: Array, debris: Array, log: WarningLog) -> Error:
	SaveGame.path = "user://check_field_save.json"
	tree.change_scene_to_file("res://scenes/farm.tscn")
	await tree.scene_changed
	var data: Dictionary = {
		"version": 2, "day": 1, "minute": 400.0, "gold": 0, "area": "farm",
		"player_position": [0.0, 0.0, -12.0], "rp": 50, "hp": 50,
		"inventory": [], "bin": [], "field": field, "debris": debris,
	}
	var file: FileAccess = FileAccess.open(SaveGame.path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	OS.add_logger(log)
	var result: Error = SaveGame.read(tree)
	OS.remove_logger(log)
	DirAccess.remove_absolute(SaveGame.path)
	return result


func test_debris_off_field() -> bool:
	var log := WarningLog.new()
	var result: Error = await _load_save([], [
		{"cell": [0, 0], "id": "stone"}, {"cell": [9, 0], "id": "stone"}, {"cell": [10, 11], "id": "weed"},
	], log)
	check(result == OK, "SaveGame.read returned %s" % error_string(result))
	check(Game.field.all_debris().keys() == [Vector2i(0, 0)], "debris loaded on %s, want only (0, 0)" % [Game.field.all_debris().keys()])
	check(log.messages.any(func(m: String) -> bool: return m.contains("2 debris outside the field")), "no warning about 2 debris outside the field; got %s" % [log.messages])
	return true


## A hand-edited save with a crop and debris on one cell keeps the crop.
func test_debris_under_plot() -> bool:
	var result: Error = await _load_save(
		[{"cell": [2, 2], "watered": false, "crop": {"seed": "turnip_seed", "level": 1, "days": 0}}],
		[{"cell": [2, 2], "id": "weed"}, {"cell": [3, 3], "id": "weed"}],
		WarningLog.new())
	check(result == OK, "SaveGame.read returned %s" % error_string(result))
	check(Game.field.debris(Vector2i(2, 2)) == null, "debris loaded on the planted plot (2, 2)")
	check(Game.field.crop(Vector2i(2, 2)) != null, "the crop on (2, 2) is gone")
	check(Game.field.debris(Vector2i(3, 3)) != null, "the debris on clear (3, 3) is gone")
	return true


## More starting debris than free cells fills every free cell and reports one error instead of crashing.
func test_debris_overfull() -> bool:
	var def: FieldDef = load("res://data/field.tres").duplicate()
	def.starting_debris = {load("res://data/debris/weed.tres"): 200}
	var field := Field.new(def)
	var log := WarningLog.new()
	OS.add_logger(log)
	field.scatter_debris()
	OS.remove_logger(log)
	var free: int = def.size.x * def.size.y - def.debris_free.get_area()
	check(field.all_debris().size() == free, "%d debris placed, want every free cell (%d)" % [field.all_debris().size(), free])
	check(log.messages.filter(func(m: String) -> bool: return m.contains("only %d cells are free" % free)).size() == 1, "want one error about free cells; got %s" % [log.messages])
	return true


## Each soil state shows its own model on the shared palette material. Each model covers the tile
## footprint the block outlines are inset by, stands on y = 0, stays under the target highlight and
## keeps the triangle budget; untilled's top is where crops and debris stand.
func test_soil_tiles() -> bool:
	tree.change_scene_to_file("res://scenes/farm.tscn")
	await tree.scene_changed
	var grid: FarmGrid = tree.current_scene.get_node("Field")
	var cell := Vector2i(1, 1)
	Game.field.replace_debris({})
	Game.field.replace_plots({})
	var shown: Array[Mesh] = []
	var palette: Material = load("res://assets/environment/greenrune/palette_cel.tres")
	for effect: Variant in [null, ToolDef.Effect.TILL, ToolDef.Effect.WATER]:
		if effect != null:
			Game.field.apply(effect, cell)
		var mesh: Mesh = grid._tiles[cell].mesh
		var soil: String = Field.Soil.find_key(Game.field.soil(cell))
		check(mesh != null and not shown.has(mesh), "%s soil shows %s, which is missing or another state's" % [soil, mesh])
		if mesh == null:
			continue
		shown.append(mesh)
		var box: AABB = mesh.get_aabb()
		var fill: float = FarmGrid.TILE_FILL * grid.tile_size
		var footprint := Vector2(box.size.x, box.size.z)
		check(footprint.is_equal_approx(Vector2(fill, fill)) and is_zero_approx(box.get_center().x) and is_zero_approx(box.get_center().z), "%s tile spans %s, want %s centred" % [soil, box, Vector2(fill, fill)])
		check(is_zero_approx(box.position.y), "%s tile's base is at y %.3f, want 0" % [soil, box.position.y])
		check(box.end.y < FarmGrid.TARGET_HEIGHT - 0.005, "%s tile's top is at y %.3f, want under the target highlight at %.3f" % [soil, box.end.y, FarmGrid.TARGET_HEIGHT])
		if Game.field.soil(cell) == Field.Soil.UNTILLED:
			check(is_equal_approx(box.end.y, FarmGrid.SOIL_TOP), "untilled tile's top is at y %.3f, want SOIL_TOP %.3f" % [box.end.y, FarmGrid.SOIL_TOP])
		check(mesh.surface_get_material(0) == palette, "%s tile's material is %s, want palette_cel.tres" % [soil, mesh.surface_get_material(0)])
		var triangles: int = 0
		for surface in mesh.get_surface_count():
			var arrays: Array = mesh.surface_get_arrays(surface)
			# A mesh without an index array lists three vertices per triangle.
			var points: Variant = arrays[Mesh.ARRAY_INDEX] if arrays[Mesh.ARRAY_INDEX] != null else arrays[Mesh.ARRAY_VERTEX]
			triangles += points.size() / 3
		check(triangles < 500, "%s tile has %d triangles, want under 500" % [soil, triangles])
	return true


## The well refills the can from beside the field's north-east corner, without any field point counting
## as water, and the bin's reach covers the field's north edge beside it.
func test_farm_props() -> bool:
	tree.change_scene_to_file("res://scenes/farm.tscn")
	await tree.scene_changed
	var farm: Node = tree.current_scene
	var grid: FarmGrid = farm.get_node("Field")
	var player: Player = farm.get_node("Player")
	var extent := Vector2(Game.field.def.size) * grid.tile_size
	await tree.physics_frame
	# A water point on the field would refill the can instead of watering that plot.
	for x in int(extent.x * 4.0) + 1:
		for z in int(extent.y * 4.0) + 1:
			var point: Vector3 = grid.to_global(Vector3(x * 0.25, 0.0, z * 0.25))
			check(not farm._is_water(point), "field point %s is water" % point)
	var well: Node3D = farm.get_node("Well")
	var corner: Vector3 = grid.to_global(Vector3(extent.x, 0.0, 0.0))
	check(well.global_position.distance_to(corner) < 2.0, "the well is %.1f m from the field's north-east corner, want under 2" % well.global_position.distance_to(corner))
	var can := ItemStack.new(Game.items[&"watering_can"], 1, 1)
	can.water = 0
	# Facing -z, just south of the well.
	player.rotation.y = 0.0
	player.global_position = well.global_position + Vector3(0.0, 0.0, 1.4)
	farm._on_tool_used(can, 0)
	# A splash still playing at exit leaks its stream in a headless run.
	farm.get_node("ToolFeedback/Sound").stop()
	check(can.water == (can.item as ToolDef).capacity, "a can tap at the well left %d water" % can.water)
	var bin: Node3D = farm.get_node("ShippingBin")
	player.global_position = grid.to_global(Vector3(grid.to_local(bin.global_position).x, 0.0, 0.0))
	await tree.physics_frame
	await tree.physics_frame
	check(farm.get_node("ShippingBin/Reach").overlaps_body(player), "the bin's reach misses the field's north edge beside it")
	return true
