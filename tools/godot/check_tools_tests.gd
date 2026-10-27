extends RefCounted

## The tests run by check_tools.gd. Loaded at runtime, after the autoloads exist, because a --script
## file can't compile anything that names an autoload such as Game.

const FACINGS: Array[Vector2i] = [Vector2i(0, -1), Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0)]

var failed: int = 0
var tree: SceneTree


func _init(p_tree: SceneTree) -> void:
	tree = p_tree


func run() -> int:
	for test: Callable in [test_tiers, test_bronze_models, test_cheap_never_charges, test_old_save_tools, test_charge_block, test_charge_off_field, test_charged_sow, test_water_per_plot, test_short_can, test_target_marker, test_charge_cues, test_water_gauge, test_no_effect, test_sounds_overlap, test_walk_water, test_walk_locked_facing, test_swing_timing, test_hit_stop]:
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
	farm.get_node("ToolFeedback/Impact").stop()
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
	farm.get_node("ToolFeedback/Impact").stop()
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
	farm.get_node("ToolFeedback/Impact").stop()
	return true


## The visible target shadows' cells, read back from their positions.
func _shadow_cells(grid: FarmGrid) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for quad in grid._targets:
		if quad.visible:
			check(is_equal_approx(quad.position.y, FarmGrid.TARGET_HEIGHT), "a target shadow sits at y %.3f, want %.3f" % [quad.position.y, FarmGrid.TARGET_HEIGHT])
			cells.append(Vector2i(floori(quad.position.x / grid.tile_size), floori(quad.position.z / grid.tile_size)))
	return _sorted(cells)


## The rectangle the visible outline strips cover, or an empty one if none shows.
func _outline_rect(grid: FarmGrid) -> Rect2:
	var rect := Rect2()
	for strip in grid._outline:
		if strip.visible:
			var part := Rect2(Vector2(strip.position.x - strip.scale.x / 2.0, strip.position.z - strip.scale.z / 2.0), Vector2(strip.scale.x, strip.scale.z))
			rect = part if rect.size == Vector2.ZERO else rect.merge(part)
	return rect


## The marker's tip height, in field space.
func _marker_tip(grid: FarmGrid) -> float:
	return grid._marker.position.y - FarmGrid.MARKER_LENGTH * grid._marker.scale.y / 2.0


## A tap's marker and shadow sit on the plot in front over untilled, tilled and watered soil and over each
## debris, the marker's tip above the debris, and a tap, or use held with a cheap tool, shows no charge outline.
func test_target_marker() -> bool:
	var farm: Node = await _farm()
	var grid: FarmGrid = farm.get_node("Field")
	var player: Player = farm.get_node("Player")
	var cell := Vector2i(4, 3)
	var middle: Vector3 = grid._cell_center(cell)
	Game.inventory.replace_slots([ItemStack.new(Game.items[&"cheap_hoe"], 1, 1)])
	Game.inventory.selected = 0
	_stand(player, grid, Vector2i(4, 4), Vector2i(0, -1))
	# What the target sits over, and the height the marker's tip must clear.
	var looks: Dictionary[String, float] = {"untilled": FarmGrid.TARGET_HEIGHT, "tilled": FarmGrid.TARGET_HEIGHT, "watered": FarmGrid.TARGET_HEIGHT}
	for id: StringName in Game.debris:
		var model: Node3D = Game.debris[id].model.instantiate()
		looks[id] = FarmGrid.SOIL_TOP + grid._mesh_bounds(model, Transform3D.IDENTITY).end.y
		model.free()
	for look: String in looks:
		var debris: Dictionary[Vector2i, DebrisDef] = {}
		if Game.debris.has(StringName(look)):
			debris[cell] = Game.debris[StringName(look)]
			Game.field.replace_plots({})
		elif look == "untilled":
			Game.field.replace_plots({})
		elif look == "tilled":
			_set_plots([cell], [])
		else:
			_set_plots([], [cell])
		Game.field.replace_debris(debris)
		farm._process(0.0)
		check(_shadow_cells(grid) == [cell], "over %s the target shadow covers %s, want %s" % [look, _shadow_cells(grid), [cell]])
		check(grid._marker.visible and is_equal_approx(grid._marker.position.x, middle.x) and is_equal_approx(grid._marker.position.z, middle.z), "over %s the marker is at %s (visible %s), want over %s" % [look, grid._marker.position, grid._marker.visible, middle])
		check(_marker_tip(grid) > looks[look], "over %s the marker's tip is at y %.2f, want above %.2f" % [look, _marker_tip(grid), looks[look]])
		check(_outline_rect(grid).size == Vector2.ZERO, "a tap over %s shows a charge outline" % look)
	Game.field.replace_debris({})
	# Pressed and held, a cheap tool still shows no outline.
	Input.action_press(&"use_tool")
	await _physics_step()
	farm._process(0.0)
	check(_outline_rect(grid).size == Vector2.ZERO, "use held with cheap_hoe shows a charge outline")
	Input.action_release(&"use_tool")
	player.cancel_tool()
	farm.get_node("ToolFeedback/NoEffect").stop()
	Game.inventory.replace_slots([])
	return true


## While a bronze charge is held, the outline frames exactly the cells the full charge hits. At the tap level the
## marker covers one plot; on reaching level 1 the marker grows over the whole block, the tool glows and the
## level's tone plays once. A charge whose block is all off the field shows no outline.
func test_charge_cues() -> bool:
	var farm: Node = await _farm()
	var grid: FarmGrid = farm.get_node("Field")
	var player: Player = farm.get_node("Player")
	var cue: AudioStreamPlayer = farm.get_node("ToolFeedback/Cue")
	var hoe: ToolDef = Game.items[&"bronze_hoe"]
	var feel: ToolFeelDef = Game.tool_feel
	var inset: float = grid.tile_size * (1.0 - FarmGrid.TILE_FILL) / 2.0
	var reached: Array[int] = []
	var on_reached: Callable = func(level: int) -> void: reached.append(level)
	player.charge_level_reached.connect(on_reached)
	Game.inventory.replace_slots([ItemStack.new(hoe, 1, 1)])
	Game.inventory.selected = 0
	check(feel.marker_scales.size() > 1 and feel.marker_scales[1] > feel.marker_scales[0], "marker_scales %s don't grow at level 1" % [feel.marker_scales])
	var want: Array[Vector2i] = []
	var tap: Array[Vector2i] = []
	for cell: Vector2i in [Vector2i(4, 4), Vector2i(0, 0), Vector2i(8, 11), Vector2i(3, 5)]:
		for facing in FACINGS:
			reached.clear()
			cue.stream = null
			_stand(player, grid, cell, facing)
			Input.action_press(&"use_tool")
			await _physics_step()
			check(player.is_charging(), "pressing use with bronze_hoe from %s didn't charge" % cell)
			farm._process(0.0)
			grid.cells_hit(player.global_position, player.global_position, hoe.charges[-1].size, facing, want)
			var low: Vector2i = want[0]
			var high: Vector2i = want[0]
			for hit in want:
				low = low.min(hit)
				high = high.max(hit)
			var frame := Rect2(Vector2(low) * grid.tile_size + Vector2.ONE * inset, Vector2(high - low + Vector2i.ONE) * grid.tile_size - Vector2.ONE * inset * 2.0)
			check(_outline_rect(grid).is_equal_approx(frame), "a bronze charge from %s facing %s is outlined at %s, want %s" % [cell, facing, _outline_rect(grid), frame])
			grid.cells_hit(player.global_position, player.tool_point(hoe), Vector2i.ONE, facing, tap)
			check(_shadow_cells(grid) == tap, "at the tap level from %s facing %s the shadow covers %s, want %s" % [cell, facing, _shadow_cells(grid), tap])
			check(tap.is_empty() or is_equal_approx(grid._marker.scale.x, feel.marker_scales[0]), "the marker is %.2f at the tap, want %.2f" % [grid._marker.scale.x, feel.marker_scales[0]])
			for mesh in player._hand_meshes:
				check(mesh.material_overlay == null, "the tool glows at the tap level")
			player._charge_time = hoe.charges[1].hold_seconds - 0.001
			await _physics_step()
			farm._process(0.0)
			check(reached == [1], "charging from %s facing %s reached levels %s, want [1]" % [cell, facing, reached])
			check(_shadow_cells(grid) == _sorted(want), "at level 1 the shadow covers %s, want %s" % [_shadow_cells(grid), _sorted(want)])
			check(is_equal_approx(grid._marker.scale.x, feel.marker_scales[1]), "the marker is %.2f at level 1, want %.2f" % [grid._marker.scale.x, feel.marker_scales[1]])
			check(_outline_rect(grid).is_equal_approx(frame), "the level 1 outline moved to %s, want %s" % [_outline_rect(grid), frame])
			check(not player._hand_meshes.is_empty(), "the bronze hoe has no meshes to glow")
			for mesh in player._hand_meshes:
				check(mesh.material_overlay != null, "the tool doesn't glow at level 1")
			check(cue.stream == feel.charge_sound and is_equal_approx(cue.pitch_scale, feel.charge_pitches[0]), "reaching level 1 played %s at pitch %.2f" % [cue.stream, cue.pitch_scale])
			Input.action_release(&"use_tool")
			player.cancel_tool()
			await tree.physics_frame
	# The tap plot is on the field, but the player's block isn't.
	_stand(player, grid, Vector2i(-1, 4), Vector2i(1, 0))
	Input.action_press(&"use_tool")
	await _physics_step()
	farm._process(0.0)
	check(player.is_charging() and _shadow_cells(grid) == [Vector2i(0, 4)], "charging from off the field targets %s, want the tap plot" % [_shadow_cells(grid)])
	check(_outline_rect(grid).size == Vector2.ZERO, "a charge whose block is off the field shows an outline at %s" % _outline_rect(grid))
	Input.action_release(&"use_tool")
	player.cancel_tool()
	# One frame that crosses two levels cues each of them, in order.
	var silver: ToolDef = hoe.duplicate()
	silver.charges = hoe.charges.duplicate()
	var line := ToolCharge.new()
	# Close behind level 1, so one physics frame crosses both.
	line.hold_seconds = hoe.charges[1].hold_seconds + 0.002
	line.size = Vector2i(3, 6)
	silver.charges.append(line)
	Game.inventory.replace_slots([ItemStack.new(silver, 1, 1)])
	_stand(player, grid, Vector2i(4, 4), Vector2i(0, -1))
	reached.clear()
	await tree.physics_frame
	Input.action_press(&"use_tool")
	await _physics_step()
	player._charge_time = hoe.charges[1].hold_seconds - 0.001
	await _physics_step()
	check(reached == [1, 2], "a frame crossing levels 1 and 2 cued %s, want [1, 2]" % [reached])
	Input.action_release(&"use_tool")
	player.cancel_tool()
	player.charge_level_reached.disconnect(on_reached)
	cue.stop()
	Game.inventory.replace_slots([])
	return true


## The HUD gauge shows only while a can is selected, holds each can's capacity, follows the can's water one
## step per plot watered, stays put on a swing that waters nothing, and refills at the well with the refill sound.
func test_water_gauge() -> bool:
	var farm: Node = await _farm()
	var grid: FarmGrid = farm.get_node("Field")
	var player: Player = farm.get_node("Player")
	var gauge: ProgressBar = farm.get_node("HUD/WaterGauge")
	var refill: AudioStreamPlayer3D = farm.get_node("ToolFeedback/Refill")
	var cheap := ItemStack.new(Game.items[&"cheap_watering_can"], 1, 1)
	var bronze := ItemStack.new(Game.items[&"bronze_watering_can"], 1, 1)
	Game.inventory.replace_slots([cheap, bronze, ItemStack.new(Game.items[&"cheap_hoe"], 1, 1)])
	for slot in 3:
		Game.inventory.select(slot)
		var stack: ItemStack = Game.inventory.slots[slot]
		var capacity: int = (stack.item as ToolDef).capacity
		check(gauge.visible == (capacity > 0), "with %s selected the gauge's visible is %s" % [stack.item.id, gauge.visible])
		if capacity > 0:
			check(gauge.max_value == capacity and gauge.value == stack.water, "with %s selected the gauge shows %d / %d, want %d / %d" % [stack.item.id, gauge.value, gauge.max_value, stack.water, capacity])
	Game.inventory.select(1)
	var block: Array[Vector2i] = _block_cells(Vector2i(1, 1))
	_stand(player, grid, Vector2i(4, 4), Vector2i(0, -1))
	# 4 dry, 3 wet, 2 untilled.
	_set_plots(block.slice(0, 4), block.slice(4, 7))
	farm._on_tool_used(bronze, 1)
	check(gauge.value == 32 and bronze.water == 32, "watering 4 plots left the gauge at %d and the can at %d, want 32" % [gauge.value, bronze.water])
	farm._on_tool_used(bronze, 1)
	check(gauge.value == 32, "a swing that waters nothing moved the gauge to %d" % gauge.value)
	_set_plots([Vector2i(4, 3)], [])
	farm._on_tool_used(bronze, 0)
	check(gauge.value == 31, "a tap on a dry plot left the gauge at %d, want 31" % gauge.value)
	player.rotation.y = 0.0
	player.global_position = farm.get_node("Well").global_position + Vector3(0.0, 0.0, 1.4)
	await tree.physics_frame
	farm._on_tool_used(bronze, 0)
	check(gauge.value == 36, "a refill left the gauge at %d, want 36" % gauge.value)
	check(refill.playing, "a refill didn't play the refill sound")
	farm.get_node("ToolFeedback/Impact").stop()
	refill.stop()
	Game.inventory.replace_slots([])
	return true


## A swing that changes nothing, including an empty can's, plays the dull "no effect" sound instead of the
## impact, costs no RP and pops nothing. A swing that changes a plot plays the tool's impact sound and pops
## "-N RP" over the player.
func test_no_effect() -> bool:
	var farm: Node = await _farm()
	var grid: FarmGrid = farm.get_node("Field")
	var player: Player = farm.get_node("Player")
	var impact: AudioStreamPlayer3D = farm.get_node("ToolFeedback/Impact")
	var dull: AudioStreamPlayer3D = farm.get_node("ToolFeedback/NoEffect")
	var popup: Label3D = farm.get_node("ToolFeedback/RpPopup")
	var hoe := ItemStack.new(Game.items[&"cheap_hoe"], 1, 1)
	var can := ItemStack.new(Game.items[&"cheap_watering_can"], 1, 1)
	can.water = 0
	var cell := Vector2i(4, 3)
	_stand(player, grid, Vector2i(4, 4), Vector2i(0, -1))
	Game.stats.rp = Game.stats.max_rp()
	var rp: int = Game.stats.rp
	for stack: ItemStack in [hoe, can]:
		_set_plots([cell], [])
		impact.stop()
		dull.stop()
		farm._on_tool_used(stack, 0)
		check(Game.stats.rp == rp and can.water == 0 and Game.field.soil(cell) == Field.Soil.TILLED, "a %s swing that changes nothing changed RP %d → %d or water to %d" % [stack.item.id, rp, Game.stats.rp, can.water])
		check(dull.playing and not impact.playing, "a %s swing that changes nothing played no-effect %s, impact %s; want only no-effect" % [stack.item.id, dull.playing, impact.playing])
		check(not popup.visible, "a %s swing that changes nothing popped '%s'" % [stack.item.id, popup.text])
	Game.field.replace_plots({})
	var cost: int = Game.stats.rp_cost(hoe.item, 0)
	dull.stop()
	farm._on_tool_used(hoe, 0)
	check(Game.field.soil(cell) == Field.Soil.TILLED and Game.stats.rp == rp - cost, "a hoe tap on untilled soil left it %s and RP %d, want tilled and %d" % [Field.Soil.find_key(Game.field.soil(cell)), Game.stats.rp, rp - cost])
	check(impact.playing and impact.stream == (hoe.item as ToolDef).impact_sound and not dull.playing, "a hoe tap that tills played impact %s (%s), no-effect %s; want only its impact sound" % [impact.playing, impact.stream, dull.playing])
	check(popup.visible and popup.text == "-%d RP" % cost, "a hoe tap that tills popped '%s' (visible %s), want '-%d RP'" % [popup.text, popup.visible, cost])
	impact.stop()
	return true


## Each sound has its own player, because assigning a player's stream stops every voice it plays: a refill
## followed at once by a swing that changes nothing leaves the refill playing, then an impact leaves both
## playing, and the refill and no-effect players keep their own streams throughout. Whether a second tap cuts
## the first can't be seen headless (the dummy audio driver never retires a cut voice), so that is left to the
## guard in ToolFeedback.play() and the user's twenty-tap test.
func test_sounds_overlap() -> bool:
	var farm: Node = await _farm()
	var grid: FarmGrid = farm.get_node("Field")
	var player: Player = farm.get_node("Player")
	var impact: AudioStreamPlayer3D = farm.get_node("ToolFeedback/Impact")
	var refill: AudioStreamPlayer3D = farm.get_node("ToolFeedback/Refill")
	var dull: AudioStreamPlayer3D = farm.get_node("ToolFeedback/NoEffect")
	var can := ItemStack.new(Game.items[&"cheap_watering_can"], 1, 1)
	can.water = 0
	player.rotation.y = 0.0
	player.global_position = farm.get_node("Well").global_position + Vector3(0.0, 0.0, 1.4)
	await tree.physics_frame
	farm._on_tool_used(can, 0)
	_stand(player, grid, Vector2i(4, 4), Vector2i(0, -1))
	_set_plots([], [Vector2i(4, 3)])
	farm._on_tool_used(can, 0)
	check(refill.playing and dull.playing, "after a refill and a swing that changes nothing, refill playing %s and no-effect playing %s; want both" % [refill.playing, dull.playing])
	_set_plots([Vector2i(4, 3)], [])
	farm._on_tool_used(can, 0)
	check(impact.playing and refill.playing and dull.playing, "after an impact, impact %s, refill %s, no-effect %s; want all playing" % [impact.playing, refill.playing, dull.playing])
	check(refill.stream == Game.tool_feel.refill_sound and dull.stream == Game.tool_feel.no_effect_sound, "the refill or no-effect player's stream changed to %s / %s" % [refill.stream, dull.stream])
	for sound in [impact, refill, dull]:
		sound.stop()
	return true


## The one plot in front of the player, or none off the field.
func _front_cell(player: Player, grid: FarmGrid, tool: ToolDef) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	grid.cells_hit(player.global_position, player.tool_point(tool), Vector2i.ONE, player.facing(), cells)
	return cells


## Walking along a row of dry plots while tapping a can waters each plot passed, one water each, and the player
## keeps moving through every tap. A tap on a watered plot spends no water or RP. A hoe tap still stands still.
func test_walk_water() -> bool:
	var farm: Node = await _farm()
	var grid: FarmGrid = farm.get_node("Field")
	var player: Player = farm.get_node("Player")
	for id: StringName in [&"cheap_watering_can", &"bronze_watering_can"]:
		var tool: ToolDef = Game.items[id]
		var can := ItemStack.new(tool, 1, 1)
		# Nine plots, fewer than the cheap can's water, so it never runs dry here.
		var row: Array[Vector2i] = []
		for x in 9:
			row.append(Vector2i(x, 4))
		_set_plots(row, [])
		Game.inventory.replace_slots([can])
		Game.inventory.selected = 0
		Game.stats.rp = Game.stats.max_rp()
		_stand(player, grid, Vector2i(0, 4), Vector2i(1, 0))
		await tree.physics_frame
		var impacts: Array[Vector3] = []
		var targets: Array[Vector2i] = []
		var on_used: Callable = func(_stack: ItemStack, _level: int) -> void:
			impacts.append(player.global_position)
			targets.append_array(_front_cell(player, grid, tool))
		player.tool_used.connect(on_used)
		var starts: Array[Vector3] = []
		var was_swinging: bool = false
		Input.action_press(&"move_right")
		# Mashing use, up to ten seconds, until the player nears the row's far end.
		for i in 600:
			if grid.to_local(player.global_position).x > row.size() - 1.5:
				break
			if i % 2 == 0:
				Input.action_press(&"use_tool")
			else:
				Input.action_release(&"use_tool")
			await tree.physics_frame
			if player.is_swinging() and not was_swinging:
				starts.append(player.global_position)
			was_swinging = player.is_swinging()
		# Move stays held through the last swing, so it walks like the others.
		Input.action_release(&"use_tool")
		for i in 120:
			if player.is_idle():
				break
			await tree.physics_frame
		Input.action_release(&"move_right")
		player.tool_used.disconnect(on_used)
		var watered: Array[Vector2i] = []
		for cell in row:
			if Game.field.soil(cell) == Field.Soil.WATERED:
				watered.append(cell)
		check(impacts.size() >= 4, "walking with %s made %d impacts, want at least 4" % [id, impacts.size()])
		for i in mini(starts.size(), impacts.size()):
			check(impacts[i].x > starts[i].x + 0.1, "%s tap %d moved the player %.2f m between start and impact, want walking" % [id, i, impacts[i].x - starts[i].x])
		var first: int = watered[0].x if watered else 0
		var passed: Array[Vector2i] = []
		for x in range(first, first + watered.size()):
			passed.append(Vector2i(x, 4))
		check(watered == passed and watered.size() >= 4, "walking with %s watered %s, want each plot passed" % [id, watered])
		check(_sorted(watered) == _sorted(_unique(targets)), "walking with %s watered %s, want the plots in front at each impact %s" % [id, watered, targets])
		check(can.water == tool.capacity - watered.size(), "watering %d plots left %s with %d water, want %d" % [watered.size(), id, can.water, tool.capacity - watered.size()])
		# Standing in front of a watered plot, a tap spends nothing.
		_set_plots([], [Vector2i(4, 4)])
		_stand(player, grid, Vector2i(4, 5), Vector2i(0, -1))
		var water: int = can.water
		var rp: int = Game.stats.rp
		farm._on_tool_used(can, 0)
		check(can.water == water and Game.stats.rp == rp, "a %s tap on a watered plot took water %d → %d, RP %d → %d" % [id, water, can.water, rp, Game.stats.rp])
	# A hoe tap with move held stands still.
	_set_plots([], [])
	Game.inventory.replace_slots([ItemStack.new(Game.items[&"cheap_hoe"], 1, 1)])
	_stand(player, grid, Vector2i(2, 4), Vector2i(1, 0))
	await tree.physics_frame
	Input.action_press(&"move_right")
	Input.action_press(&"use_tool")
	await _physics_step()
	Input.action_release(&"use_tool")
	var at: Vector3 = player.global_position
	var still: bool = true
	for i in 120:
		if not player.is_swinging():
			break
		still = still and player.global_position.is_equal_approx(at)
		await tree.physics_frame
	Input.action_release(&"move_right")
	check(still, "a hoe tap with move held moved the player")
	for sound in ["Impact", "NoEffect"]:
		farm.get_node("ToolFeedback/" + sound).stop()
	Game.inventory.replace_slots([])
	return true


## Runs physics frames until the player is idle, up to two seconds. Returns whether the facing held, the
## speed walked in m/s, and whether the leg walk played on every moving frame and on no still one.
func _until_idle(player: Player) -> Dictionary:
	var rotation: float = player.rotation.y
	var at: Vector3 = player.global_position
	var held: bool = true
	var legs_match: bool = true
	var frames: int = 0
	for i in 120:
		if player.is_idle():
			break
		var before: Vector3 = player.global_position
		await tree.physics_frame
		frames += 1
		held = held and is_equal_approx(player.rotation.y, rotation)
		legs_match = legs_match and player._legs.is_playing() != player.global_position.is_equal_approx(before)
	var moved: Vector3 = player.global_position - at
	return {"held": held, "speed": Vector2(moved.x, moved.z).length() * Engine.physics_ticks_per_second / maxi(frames, 1), "legs": legs_match}


## Holding a charge, the player walks at the tool walk speed in any direction with the facing locked, the legs
## walking only while moving, and the charge outline follows the player's block. After release a charged can
## swing walks on with the facing locked and a charged hoe swing stands still. A can tap with sideways input
## walks at the same speed, keeps its facing and waters the plot in front along it. Back to idle, the legs stop.
func test_walk_locked_facing() -> bool:
	var farm: Node = await _farm()
	var grid: FarmGrid = farm.get_node("Field")
	var player: Player = farm.get_node("Player")
	var speed: float = Game.tool_feel.walk_speed
	var outline: Array[Vector2i] = []
	check(is_equal_approx(speed, 1.0), "the tool walk speed is %.2f, want 1.0" % speed)
	for id: StringName in [&"bronze_hoe", &"bronze_watering_can"]:
		var tool: ToolDef = Game.items[id]
		var walks: bool = tool.effect == ToolDef.Effect.WATER
		_set_plots(_block_cells(Vector2i(1, 1)) + _block_cells(Vector2i(2, 1)), [])
		Game.inventory.replace_slots([ItemStack.new(tool, 1, 1)])
		Game.inventory.selected = 0
		# Mid-tile on the right edge of block (1, 1), facing up.
		_stand(player, grid, Vector2i(5, 4), Vector2i(0, -1))
		await tree.physics_frame
		var facing: float = player.rotation.y
		Input.action_press(&"use_tool")
		await _physics_step()
		check(player.is_charging() and not player._legs.is_playing(), "standing to charge %s plays the leg walk" % id)
		Input.action_press(&"move_right")
		await tree.physics_frame
		var at: Vector3 = player.global_position
		for i in 60:
			await tree.physics_frame
		farm._process(0.0)
		check(player.is_charging(), "holding %s with move held stopped charging" % id)
		check(absf(player.global_position.x - at.x - speed) < 0.1, "charging %s walked %.2f m in a second, want %.2f" % [id, player.global_position.x - at.x, speed])
		check(is_equal_approx(player.rotation.y, facing), "charging %s with move held turned the player %.2f rad" % [id, player.rotation.y - facing])
		check(player._legs.is_playing() and player._legs.current_animation == &"walk", "charging %s while moving doesn't play the leg walk" % id)
		grid.cells_hit(player.global_position, player.global_position, tool.charges[-1].size, player.facing(), outline)
		check(_outline_rect(grid).is_equal_approx(grid._area(outline).grow(-grid.tile_size * (1.0 - FarmGrid.TILE_FILL) / 2.0)) and grid.block_of(outline[0]) == Vector2i(2, 1), "the %s charge outline at %s doesn't follow the player into block (2, 1)" % [id, _outline_rect(grid)])
		Input.action_release(&"move_right")
		await _physics_step()
		check(player.is_charging() and not player._legs.is_playing(), "charging %s standing still again plays the leg walk" % id)
		Input.action_press(&"move_right")
		player._charge_time = 10.0
		Input.action_release(&"use_tool")
		await _physics_step()
		check(player.is_swinging() and player._swing_level == 1, "releasing %s didn't swing at level 1" % id)
		var swing: Dictionary = await _until_idle(player)
		Input.action_release(&"move_right")
		check(swing.held, "a charged %s swing with move held turned the player" % id)
		check(absf(swing.speed - (speed if walks else 0.0)) < 0.1, "a charged %s swing with move held walked at %.2f m/s, want %.2f" % [id, swing.speed, speed if walks else 0.0])
		check(swing.legs, "a charged %s swing played the leg walk when not moving, or not when moving" % id)
	# A can tap with sideways input.
	var can: ToolDef = Game.items[&"cheap_watering_can"]
	_set_plots(_block_cells(Vector2i(1, 1)) + _block_cells(Vector2i(2, 1)) + _block_cells(Vector2i(1, 0)) + _block_cells(Vector2i(2, 0)), [])
	Game.inventory.replace_slots([ItemStack.new(can, 1, 1)])
	_stand(player, grid, Vector2i(4, 4), Vector2i(0, -1))
	await tree.physics_frame
	var hit: Array[Vector2i] = []
	var on_used: Callable = func(_stack: ItemStack, _level: int) -> void: hit.assign(_front_cell(player, grid, can))
	player.tool_used.connect(on_used)
	Input.action_press(&"move_right")
	Input.action_press(&"use_tool")
	await _physics_step()
	Input.action_release(&"use_tool")
	var tap: Dictionary = await _until_idle(player)
	player.tool_used.disconnect(on_used)
	check(tap.held and absf(tap.speed - speed) < 0.1, "a can tap with sideways input held its facing %s and walked at %.2f m/s, want held and %.2f" % [tap.held, tap.speed, speed])
	check(tap.legs, "a can tap played the leg walk when not moving, or not when moving")
	check(hit.size() == 1 and hit[0].y == 3 and Game.field.soil(hit[0]) == Field.Soil.WATERED, "a can tap facing up with sideways input watered %s, want a plot in row 3" % [hit])
	await tree.physics_frame
	Input.action_release(&"move_right")
	await tree.physics_frame
	check(player.is_idle() and not player._legs.is_playing(), "back to idle, the leg walk still plays")
	for sound in ["Impact", "NoEffect"]:
		farm.get_node("ToolFeedback/" + sound).stop()
	Game.inventory.replace_slots([])
	return true


func _unique(cells: Array[Vector2i]) -> Array[Vector2i]:
	var out: Array[Vector2i] = []
	for cell in cells:
		if not out.has(cell):
			out.append(cell)
	return out


## Each tool's swing plays at its swing_speed and its impact fires at impact_time into the clip, so
## impact_time / swing_speed seconds after the swing starts. Drives the real input path.
func test_swing_timing() -> bool:
	var farm: Node = await _farm()
	var grid: FarmGrid = farm.get_node("Field")
	var player: Player = farm.get_node("Player")
	var anim: AnimationPlayer = player.get_node("Model/AnimationPlayer")
	var frame: float = 1.0 / Engine.physics_ticks_per_second
	var impact: Array[float] = []
	var on_used: Callable = func(_stack: ItemStack, _level: int) -> void:
		impact.assign([anim.current_animation_position, anim.get_playing_speed(), Time.get_ticks_usec() / 1e6])
	player.tool_used.connect(on_used)
	for id: StringName in [&"cheap_hoe", &"bronze_hoe", &"cheap_watering_can", &"bronze_watering_can", &"cheap_sickle", &"bronze_sickle"]:
		var tool: ToolDef = Game.items[id]
		_set_plots([], [])
		Game.inventory.replace_slots([ItemStack.new(tool, 1, 1)])
		Game.inventory.selected = 0
		_stand(player, grid, Vector2i(4, 4), Vector2i(0, -1))
		await tree.physics_frame
		impact.clear()
		Input.action_press(&"use_tool")
		await tree.physics_frame
		Input.action_release(&"use_tool")
		var start: float = 0.0
		for i in 600:
			if start == 0.0 and player.is_swinging():
				start = Time.get_ticks_usec() / 1e6
			if not impact.is_empty():
				break
			await tree.physics_frame
		check(not impact.is_empty(), "%s's swing never hit" % id)
		if impact.is_empty():
			continue
		check(is_equal_approx(impact[1], tool.swing_speed), "%s swung at speed %.2f, want %.2f" % [id, impact[1], tool.swing_speed])
		check(impact[0] >= tool.impact_time and impact[0] < tool.impact_time + 3.0 * frame * tool.swing_speed, "%s hit %.3f s into its clip, want %.3f" % [id, impact[0], tool.impact_time])
		var want: float = tool.impact_time / tool.swing_speed
		check(absf(impact[2] - start - want) < 4.0 * frame, "%s hit %.3f s after its swing started, want %.3f" % [id, impact[2] - start, want])
		for i in 120:
			if player.is_idle():
				break
			await tree.physics_frame
	player.tool_used.disconnect(on_used)
	farm.get_node("ToolFeedback/NoEffect").stop()
	Game.inventory.replace_slots([])
	return true


## A hit that changes a plot freezes the game only for a tool with hit_stop, and shakes the camera only for one
## with shake: the hoe freezes for its 50 ms, the sickle for a shorter one, and the can never freezes or shakes. Each such hit
## plays its tool's sound and bursts dust, after any hit-stop.
func test_hit_stop() -> bool:
	var farm: Node = await _farm()
	var grid: FarmGrid = farm.get_node("Field")
	var player: Player = farm.get_node("Player")
	var rig: FollowCamera = farm.get_node("CameraRig")
	var dust: GPUParticles3D = farm.get_node("ToolFeedback/Dust")
	var impact: AudioStreamPlayer3D = farm.get_node("ToolFeedback/Impact")
	var turnip: CropDef = Game.crops[&"turnip_seed"]
	for id: StringName in [&"cheap_hoe", &"bronze_hoe", &"cheap_watering_can", &"bronze_watering_can", &"cheap_sickle", &"bronze_sickle"]:
		var tool: ToolDef = Game.items[id]
		match tool.effect:
			ToolDef.Effect.TILL:
				check(is_equal_approx(tool.hit_stop, 0.05) and tool.shake > 0.0, "%s has hit-stop %.3f and shake %.3f, want 0.05 and some" % [id, tool.hit_stop, tool.shake])
			ToolDef.Effect.WATER:
				check(tool.hit_stop == 0.0 and tool.shake == 0.0, "%s has hit-stop %.3f and shake %.3f, want none" % [id, tool.hit_stop, tool.shake])
			ToolDef.Effect.REAP:
				check(tool.hit_stop > 0.0 and tool.hit_stop < 0.05 and tool.shake > 0.0, "%s has hit-stop %.3f and shake %.3f, want a short one and some" % [id, tool.hit_stop, tool.shake])
		var cell := Vector2i(4, 3)
		var tilled: Array[Vector2i] = []
		if tool.effect != ToolDef.Effect.TILL:
			tilled.append(cell)
		_set_plots(tilled, [])
		if tool.effect == ToolDef.Effect.REAP:
			Game.field.sow(cell, turnip, 1)
			Game.field.crop(cell).days = turnip.stage_days[0]
		_stand(player, grid, Vector2i(4, 4), Vector2i(0, -1))
		rig._shake_left = 0.0
		dust.emitting = false
		impact.stop()
		Game.stats.rp = Game.stats.max_rp()
		# The freeze's timer counts the delta of the frame it starts in, so a long frame (the scene load) shortens it.
		await tree.process_frame
		await tree.process_frame
		var hit_at: float = Time.get_ticks_usec() / 1e6
		farm._on_tool_used(ItemStack.new(tool, 1, 1), 0)
		check(Game.field.soil(cell) != Field.Soil.UNTILLED and (tool.effect != ToolDef.Effect.REAP or Game.field.crop(cell) == null), "%s's hit changed nothing" % id)
		check((Engine.time_scale == 0.0) == (tool.hit_stop > 0.0), "after a %s hit time_scale is %.1f, want hit-stop only with hit_stop %.3f" % [id, Engine.time_scale, tool.hit_stop])
		check((rig._shake_left > 0.0) == (tool.shake > 0.0), "after a %s hit the camera shake is %.3f, want shake only with shake %.3f" % [id, rig._shake_left, tool.shake])
		while Engine.time_scale != 1.0 and Time.get_ticks_usec() / 1e6 - hit_at < 1.0:
			await tree.process_frame
		var frozen: float = Time.get_ticks_usec() / 1e6 - hit_at
		check(Engine.time_scale == 1.0, "%s's hit-stop never ended" % id)
		# The timer ticks on process frames, so it can end up to a frame early or late.
		check(tool.hit_stop == 0.0 or (frozen >= tool.hit_stop - 0.02 and frozen < tool.hit_stop + 0.03), "a %s hit froze for %.3f s, want %.3f" % [id, frozen, tool.hit_stop])
		check(impact.playing and impact.stream == tool.impact_sound and dust.emitting, "a %s hit played its sound %s and burst dust %s, want both" % [id, impact.playing, dust.emitting])
	farm.get_node("ToolFeedback/Impact").stop()
	return true
