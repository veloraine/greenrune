extends RefCounted

## The tests run by check_tools.gd. Loaded at runtime, after the autoloads exist, because a --script
## file can't compile anything that names an autoload such as Game.

const FACINGS: Array[Vector2i] = [Vector2i(0, -1), Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0)]

var failed: int = 0
var tree: SceneTree


func _init(p_tree: SceneTree) -> void:
	tree = p_tree


func run() -> int:
	for test: Callable in [test_charge_block, test_charge_off_field, test_charged_sow]:
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
