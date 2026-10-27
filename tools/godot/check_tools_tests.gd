extends RefCounted

## The tests run by check_tools.gd. Loaded at runtime, after the autoloads exist, because a --script
## file can't compile anything that names an autoload such as Game.

const FACINGS: Array[Vector2i] = [Vector2i(0, -1), Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0)]

var failed: int = 0
var tree: SceneTree


func _init(p_tree: SceneTree) -> void:
	tree = p_tree


func run() -> int:
	for test: Callable in [test_tiers, test_bronze_models, test_cheap_never_charges, test_old_save_tools, test_charge_block, test_charge_off_field, test_charged_sow, test_water_per_plot, test_short_can]:
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


## Waits until the player's _physics_process has run once. physics_frame fires before the physics step.
func _physics_step() -> void:
	await tree.physics_frame
	await tree.physics_frame


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


## A cheap tool swings on the press and never enters the charge state, and the still-held button doesn't
## stop the player walking once the swing ends. A bronze tool held the same way charges to the 3×3.
## Drives the player's real input path.
func test_cheap_never_charges() -> bool:
	var farm: Node = await _farm()
	var grid: FarmGrid = farm.get_node("Field")
	var player: Player = farm.get_node("Player")
	for id: StringName in [&"cheap_hoe", &"cheap_watering_can", &"cheap_sickle"]:
		_stand(player, grid, Vector2i(4, 4), Vector2i(0, -1))
		Game.inventory.replace_slots([ItemStack.new(Game.items[id], 1, 1)])
		Game.inventory.selected = 0
		Input.action_press(&"use_tool")
		await _physics_step()
		check(player.is_swinging(), "pressing use with %s didn't swing on the first frame" % id)
		var charged: bool = false
		# Held through the whole swing, up to ten seconds of physics frames.
		for i in 600:
			charged = charged or player._state == Player.State.CHARGE
			if player.is_idle():
				break
			await tree.physics_frame
		check(not charged, "holding use with %s entered the charge state" % id)
		check(player.is_idle(), "the %s swing never ended" % id)
		var before: Vector3 = player.global_position
		Input.action_press(&"move_right")
		for i in 10:
			await tree.physics_frame
		Input.action_release(&"move_right")
		check(player.is_idle() and player.global_position.x > before.x + 0.1, "with use held after a %s swing, the player moved %.2f m, want walking" % [id, player.global_position.x - before.x])
		Input.action_release(&"use_tool")
		await tree.physics_frame
	farm.get_node("ToolFeedback/Sound").stop()
	Game.inventory.replace_slots([ItemStack.new(Game.items[&"bronze_hoe"], 1, 1)])
	Input.action_press(&"use_tool")
	await _physics_step()
	check(player._state == Player.State.CHARGE, "pressing use with bronze_hoe didn't start a charge")
	player._charge_time = 10.0
	check(player.charge_level() == 1, "holding bronze_hoe reached charge level %d, want 1" % player.charge_level())
	Input.action_release(&"use_tool")
	player.cancel_tool()
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


## Tills these cells, wetting the wet ones, and leaves the rest untilled.
func _set_plots(tilled: Array[Vector2i], wet: Array[Vector2i]) -> void:
	var plots: Dictionary[Vector2i, Field.Plot] = {}
	for cell in tilled + wet:
		plots[cell] = Field.Plot.new()
		plots[cell].watered = wet.has(cell)
	Game.field.replace_plots(plots)


## A bronze can charge spends 1 water per plot it waters; wet and untilled plots cost nothing, and a
## swing that waters nothing costs neither water nor RP.
func test_water_per_plot() -> bool:
	var farm: Node = await _farm()
	var grid: FarmGrid = farm.get_node("Field")
	var player: Player = farm.get_node("Player")
	var can := ItemStack.new(Game.items[&"bronze_watering_can"], 1, 1)
	var block: Array[Vector2i] = _block_cells(Vector2i(1, 1))
	_stand(player, grid, Vector2i(4, 4), Vector2i(0, -1))
	# 4 dry, 3 wet, 2 untilled.
	_set_plots(block.slice(0, 4), block.slice(4, 7))
	Game.stats.rp = Game.stats.max_rp()
	farm._on_tool_used(can, 1)
	check(can.water == 36 - 4, "watering 4 dry plots of a mixed block left %d water, want %d" % [can.water, 36 - 4])
	for cell in block.slice(0, 7):
		check(Game.field.soil(cell) == Field.Soil.WATERED, "tilled %s isn't watered" % cell)
	for cell in block.slice(7):
		check(Game.field.soil(cell) == Field.Soil.UNTILLED, "untilled %s changed" % cell)
	var rp: int = Game.stats.rp
	farm._on_tool_used(can, 1)
	check(can.water == 32 and Game.stats.rp == rp, "a swing that waters nothing took water %d → %d, RP %d → %d" % [32, can.water, rp, Game.stats.rp])
	_set_plots([Vector2i(4, 3)], [])
	farm._on_tool_used(can, 0)
	check(can.water == 31, "a tap on a dry plot left %d water, want 31" % can.water)
	farm.get_node("ToolFeedback/Sound").stop()
	return true


## A can holding less water than the block has dry plots waters exactly that many, nearest the player's
## tile first; at equal distance, further ahead first, then left to right as the player sees it.
func test_short_can() -> bool:
	var farm: Node = await _farm()
	var grid: FarmGrid = farm.get_node("Field")
	var player: Player = farm.get_node("Player")
	var cases: Array = [
		[Vector2i(4, 4), Vector2i(0, -1), [Vector2i(4, 4), Vector2i(4, 3), Vector2i(3, 4), Vector2i(5, 4)]],
		[Vector2i(4, 4), Vector2i(0, -1), [Vector2i(4, 4), Vector2i(4, 3), Vector2i(3, 4)]],
		[Vector2i(4, 4), Vector2i(-1, 0), [Vector2i(4, 4), Vector2i(3, 4), Vector2i(4, 5)]],
		[Vector2i(3, 3), Vector2i(1, 0), [Vector2i(3, 3), Vector2i(4, 3)]],
		[Vector2i(5, 5), Vector2i(0, 1), [Vector2i(5, 5), Vector2i(4, 5), Vector2i(5, 4), Vector2i(4, 4), Vector2i(3, 5)]],
	]
	for case: Array in cases:
		var want: Array[Vector2i] = []
		want.assign(case[2])
		var can := ItemStack.new(Game.items[&"bronze_watering_can"], 1, 1)
		can.water = want.size()
		_set_plots(_block_cells(Vector2i(1, 1)), [])
		_stand(player, grid, case[0], case[1])
		farm._on_tool_used(can, 1)
		var watered: Array[Vector2i] = []
		for cell in Game.field.plots():
			if Game.field.plots()[cell].watered:
				watered.append(cell)
		check(can.water == 0, "a can with %d water ended with %d" % [want.size(), can.water])
		check(_sorted(watered) == _sorted(want), "a can with %d water from %s facing %s watered %s, want %s" % [want.size(), case[0], case[1], _sorted(watered), _sorted(want)])
	farm.get_node("ToolFeedback/Sound").stop()
	return true
