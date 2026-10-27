extends RefCounted

## The tests run by check_tools.gd. Loaded at runtime, after the autoloads exist, because a --script
## file can't compile anything that names an autoload such as Game.

const FACINGS: Array[Vector2i] = [Vector2i(0, -1), Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0)]

var failed: int = 0
var tree: SceneTree


func _init(p_tree: SceneTree) -> void:
	tree = p_tree


func run() -> int:
	for test: Callable in [test_tiers, test_bronze_models, test_cheap_never_charges, test_old_save_tools, test_charge_block, test_charge_off_field, test_charged_sow]:
		if (await test.call()) != true:
			failed += 1
			printerr("FAIL: %s did not finish" % test.get_method())
	return failed


func check(cond: bool, msg: String) -> void:
	if not cond:
		failed += 1
		printerr("FAIL: " + msg)


## Opens the farm with no debris and nothing tilled.
func _farm() -> Node:
	tree.change_scene_to_file("res://scenes/farm.tscn")
	await tree.scene_changed
	Game.field.replace_debris({})
	Game.field.replace_plots({})
	return tree.current_scene


## Stands the player at offset inside cell, facing along the grid as a started charge does.
func _stand(player: Player, grid: FarmGrid, cell: Vector2i, facing: Vector2i, offset: Vector2 = Vector2(0.5, 0.5)) -> void:
	player.rotation.y = atan2(-facing.x, -facing.y)
	player.global_position = grid.to_global(Vector3(cell.x + offset.x, 0.0, cell.y + offset.y) * grid.tile_size)


func _block_cells(block: Vector2i) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	var size: int = Game.field.def.block_size
	for y in size:
		for x in size:
			cells.append(block * size + Vector2i(x, y))
	return cells


func _sorted(cells: Array[Vector2i]) -> Array[Vector2i]:
	var copy: Array[Vector2i] = cells.duplicate()
	copy.sort()
	return copy


## A 3×3 charge hits exactly the block holding the player's tile, for every facing, from the centre,
## edge and corner tiles of several blocks, standing anywhere in the tile.
func test_charge_block() -> bool:
	var farm: Node = await _farm()
	var grid: FarmGrid = farm.get_node("Field")
	var player: Player = farm.get_node("Player")
	var hit: Array[Vector2i] = []
	for cell: Vector2i in [Vector2i(4, 4), Vector2i(3, 3), Vector2i(5, 5), Vector2i(3, 5), Vector2i(4, 3), Vector2i(0, 0), Vector2i(8, 11), Vector2i(6, 8)]:
		var want: Array[Vector2i] = _sorted(_block_cells(grid.block_of(cell)))
		for facing in FACINGS:
			for offset: Vector2 in [Vector2(0.5, 0.5), Vector2(0.02, 0.98), Vector2(0.98, 0.02)]:
				_stand(player, grid, cell, facing, offset)
				check(player.facing() == facing, "player faces %s, want %s" % [player.facing(), facing])
				grid.cells_hit(player.global_position, player.global_position, Vector2i(3, 3), player.facing(), hit)
				check(_sorted(hit) == want, "a 3×3 charge from %s+%s facing %s hits %s, want %s" % [cell, offset, facing, _sorted(hit), want])
	return true


## A 3×6 line hits the player's block and the next one along the facing, and skips the part off the field.
func test_charge_off_field() -> bool:
	var farm: Node = await _farm()
	var grid: FarmGrid = farm.get_node("Field")
	var player: Player = farm.get_node("Player")
	var hit: Array[Vector2i] = []
	var cases: Array = [
		[Vector2i(1, 1), Vector2i(-1, 0), [Vector2i(0, 0)]],
		[Vector2i(1, 1), Vector2i(0, -1), [Vector2i(0, 0)]],
		[Vector2i(1, 1), Vector2i(1, 0), [Vector2i(0, 0), Vector2i(1, 0)]],
		[Vector2i(7, 10), Vector2i(0, 1), [Vector2i(2, 3)]],
		[Vector2i(7, 10), Vector2i(1, 0), [Vector2i(2, 3)]],
		[Vector2i(7, 10), Vector2i(0, -1), [Vector2i(2, 3), Vector2i(2, 2)]],
	]
	for case: Array in cases:
		var want: Array[Vector2i] = []
		for block: Vector2i in case[2]:
			want.append_array(_block_cells(block))
		_stand(player, grid, case[0], case[1])
		grid.cells_hit(player.global_position, player.global_position, Vector2i(3, 6), player.facing(), hit)
		check(_sorted(hit) == _sorted(want), "a 3×6 charge from %s facing %s hits %s, want blocks %s" % [case[0], case[1], _sorted(hit), case[2]])
	# A player standing just off the field has no block on it.
	_stand(player, grid, Vector2i(-1, 4), Vector2i(1, 0))
	grid.cells_hit(player.global_position, player.global_position, Vector2i(3, 3), player.facing(), hit)
	check(hit.is_empty(), "a 3×3 charge from off the field hits %s" % [hit])
	return true


## A charged sow sows the block holding the player's tile; a tap sows the one plot in front.
func test_charged_sow() -> bool:
	var farm: Node = await _farm()
	var grid: FarmGrid = farm.get_node("Field")
	var player: Player = farm.get_node("Player")
	var seed: ItemDef = Game.items[&"turnip_seed"]
	for charge_level in [1, 0]:
		var plots: Dictionary[Vector2i, Field.Plot] = {}
		for x in Game.field.def.size.x:
			for y in Game.field.def.size.y:
				plots[Vector2i(x, y)] = Field.Plot.new()
		Game.field.replace_plots(plots)
		_stand(player, grid, Vector2i(3, 5), Vector2i(0, -1))
		var stack := ItemStack.new(seed, 1, seed.max_stack)
		Game.inventory.replace_slots([stack])
		farm._sow(stack, charge_level)
		var sown: Array[Vector2i] = []
		for cell in plots:
			if plots[cell].crop:
				sown.append(cell)
		var want: Array[Vector2i] = [Vector2i(3, 4)]
		if charge_level == 1:
			want = _block_cells(Vector2i(1, 1))
		check(_sorted(sown) == _sorted(want), "sow at charge %d sowed %s, want %s" % [charge_level, _sorted(sown), _sorted(want)])
	Game.inventory.replace_slots([])
	return true


## Each tool has a cheap tier that only taps and a bronze tier that taps or charges to the 3×3 block,
## each with an icon. The pre-tier ids are gone.
func test_tiers() -> bool:
	for tool: String in ["hoe", "watering_can", "sickle"]:
		check(not Game.items.has(StringName(tool)), "item '%s' still exists" % tool)
		var cheap: ToolDef = Game.items.get(StringName("cheap_" + tool))
		var bronze: ToolDef = Game.items.get(StringName("bronze_" + tool))
		check(cheap != null and bronze != null, "cheap_%s or bronze_%s is missing" % [tool, tool])
		if cheap == null or bronze == null:
			continue
		check(cheap.charges.size() == 1 and cheap.charges[0].size == Vector2i.ONE, "cheap_%s has %d charges, want only the tap" % [tool, cheap.charges.size()])
		check(bronze.charges.size() == 2 and bronze.charges[0].size == Vector2i.ONE and bronze.charges[1].size == Vector2i(3, 3), "bronze_%s charges aren't a tap and a 3×3" % tool)
		check(cheap.icon != null and bronze.icon != null, "cheap_%s or bronze_%s has no icon" % [tool, tool])
		check(cheap.effect == bronze.effect and cheap.skill == bronze.skill, "bronze_%s doesn't do what cheap_%s does" % [tool, tool])
	check(Game.items[&"cheap_watering_can"].capacity == 15, "cheap can holds %d, want 15" % Game.items[&"cheap_watering_can"].capacity)
	check(Game.items[&"bronze_watering_can"].capacity == 36, "bronze can holds %d, want 36" % Game.items[&"bronze_watering_can"].capacity)
	return true


## Holding the use button with a cheap tool, however long, never reaches a charge level; with a bronze
## tool the same hold reaches the 3×3. Drives the player's real input path.
func test_cheap_never_charges() -> bool:
	var farm: Node = await _farm()
	var player: Player = farm.get_node("Player")
	for id: StringName in [&"cheap_hoe", &"cheap_watering_can", &"cheap_sickle", &"bronze_hoe"]:
		Game.inventory.replace_slots([ItemStack.new(Game.items[id], 1, 1)])
		Game.inventory.selected = 0
		Input.action_press(&"use_tool")
		for i in 5:
			await tree.physics_frame
			if not player.is_idle():
				break
		check(not player.is_idle(), "pressing use with %s didn't start the tool" % id)
		var max_level: int = 0
		# Ten seconds of holding, in physics frames.
		for i in 600:
			player._charge_time += 1.0 / 60.0
			max_level = maxi(max_level, player.charge_level())
		await tree.physics_frame
		max_level = maxi(max_level, player.charge_level())
		var want: int = 1 if id == &"bronze_hoe" else 0
		check(max_level == want, "holding %s reached charge level %d, want %d" % [id, max_level, want])
		Input.action_release(&"use_tool")
		player.cancel_tool()
		await tree.physics_frame
	Game.inventory.replace_slots([])
	return true


## A save from before the tiers loads its hoe, can and sickle as the cheap tools, keeping the can's water.
func test_old_save_tools() -> bool:
	SaveGame.path = "user://check_tools_save.json"
	await _farm()
	var data: Dictionary = {
		"version": 2, "day": 1, "minute": 400.0, "gold": 0, "area": "farm",
		"player_position": [0.0, 0.0, -12.0], "rp": 50, "hp": 50,
		"inventory": [
			{"id": "hoe", "level": 1, "count": 1, "water": 0},
			{"id": "watering_can", "level": 2, "count": 1, "water": 7},
			{"id": "sickle", "level": 1, "count": 1, "water": 0},
		],
		"bin": [], "field": [],
	}
	var file: FileAccess = FileAccess.open(SaveGame.path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	var result: Error = SaveGame.read(tree)
	DirAccess.remove_absolute(SaveGame.path)
	check(result == OK, "SaveGame.read returned %s" % error_string(result))
	var slots: Array[ItemStack] = Game.inventory.slots
	var ids: Array = slots.slice(0, 3).map(func(stack: ItemStack) -> Variant: return stack.item.id if stack else null)
	check(ids == [&"cheap_hoe", &"cheap_watering_can", &"cheap_sickle"], "old tools loaded as %s" % [ids])
	if slots[1]:
		check(slots[1].water == 7 and slots[1].level == 2, "old can loaded with water %d at Lv%d, want 7 at Lv2" % [slots[1].water, slots[1].level])
	Game.inventory.replace_slots([])
	return true


## Each bronze tool holds the cheap tool's model with at least one surface tinted, and the console adds one.
func test_bronze_models() -> bool:
	for tool: String in ["hoe", "watering_can", "sickle"]:
		var cheap: Node3D = Game.items[StringName("cheap_" + tool)].hand_model.instantiate()
		var bronze: Node3D = Game.items[StringName("bronze_" + tool)].hand_model.instantiate()
		var cheap_mesh: MeshInstance3D = cheap.find_children("*", "MeshInstance3D")[0]
		var bronze_mesh: MeshInstance3D = bronze.find_children("*", "MeshInstance3D")[0]
		check(bronze_mesh.mesh == cheap_mesh.mesh, "bronze_%s doesn't use the cheap model" % tool)
		var tinted: int = 0
		for surface in cheap_mesh.mesh.get_surface_count():
			if bronze_mesh.get_active_material(surface) != cheap_mesh.get_active_material(surface):
				tinted += 1
		check(tinted > 0, "bronze_%s looks the same as cheap_%s" % [tool, tool])
		cheap.free()
		bronze.free()
	var farm: Node = await _farm()
	Game.inventory.replace_slots([])
	farm.get_node("HUD/DebugConsole")._run(["add", "bronze_hoe"])
	var first: ItemStack = Game.inventory.slots[0]
	check(first != null and first.item == Game.items[&"bronze_hoe"], "console 'add bronze_hoe' added %s" % (first.item.id if first else null))
	Game.inventory.replace_slots([])
	return true
