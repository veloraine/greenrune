extends Node3D

## Physics layer 5, "water": ponds and wells that refill the watering can.
const WATER_LAYER: int = 1 << 4

# Reused every frame for the target highlight, so nothing is allocated per frame.
var _cells: Array[Vector2i] = []
var _water_query := PhysicsPointQueryParameters3D.new()

@onready var _player: Player = $Player
@onready var _field: FarmGrid = $Field
@onready var _feedback: ToolFeedback = $ToolFeedback
@onready var _camera_rig: FollowCamera = $CameraRig
@onready var _wake_point: Marker3D = $HouseInterior/WakePoint
@onready var _bed: Area3D = $HouseInterior/Bed/Reach
@onready var _sleep_prompt: SleepPrompt = $HUD/SleepPrompt
@onready var _bin: Area3D = $ShippingBin/Reach
@onready var _bin_screen: BinScreen = $HUD/BinScreen


func _ready() -> void:
	_player.tool_used.connect(_on_tool_used)
	Game.stats.fainted.connect(_on_fainted)
	_sleep_prompt.confirmed.connect(_sleep)
	$HouseDoor.body_entered.connect(_go_through_door.bind($HouseInterior/Entrance))
	$HouseInterior/Door.body_entered.connect(_go_through_door.bind($HouseEntrance))
	_water_query.collide_with_areas = true
	_water_query.collide_with_bodies = false
	_water_query.collision_mask = WATER_LAYER


func _process(_delta: float) -> void:
	var tool: ToolDef = _player.held_tool()
	if _player.is_swinging():
		_cells.clear()
	elif tool:
		_field.cells_hit(_player.global_position, _player.tool_point(tool), tool.charges[_player.charge_level()].size, _cells)
	elif _held_crop():
		_field.cells_hit(_player.global_position, _front(), 1, _cells)
	else:
		_cells.clear()
	_field.show_target(_cells)


func _unhandled_input(event: InputEvent) -> void:
	if not _player.is_idle():
		return
	if event.is_action_pressed("interact"):
		if _bed.overlaps_body(_player):
			_sleep_prompt.open()
		elif _bin.overlaps_body(_player):
			_bin_screen.open()
		else:
			_harvest()
	elif event.is_action_pressed("use_tool") and _held_crop():
		_sow(_held_crop())


func _on_tool_used(stack: ItemStack, charge_level: int) -> void:
	var tool: ToolDef = stack.item
	var point: Vector3 = _player.tool_point(tool)
	_field.cells_hit(_player.global_position, point, tool.charges[charge_level].size, _cells)
	# Debug → Visible Collision Shapes turns this on.
	if get_tree().debug_collisions_hint:
		_field.flash_hitbox(_cells)
	if tool.capacity > 0:
		if _is_water(point):
			stack.water = tool.capacity
			Game.inventory.changed.emit()
			_pop(point, tool)
			return
		if stack.water == 0:
			return
		stack.water -= 1
		Game.inventory.changed.emit()
	var field_changed: bool = false
	for cell in _cells:
		var crop: Field.Crop = Game.field.crop(cell)
		# Like Rune Factory 4, a reaped ripe crop gives no harvest but one seed, sometimes a level higher.
		var seed_level: int = 0
		if tool.effect == ToolDef.Effect.REAP and crop and crop.is_ripe():
			seed_level = crop.level + (1 if randf() < crop.def.reap_level_up_chance else 0)
			# With no room for the seed, the ripe crop stays rather than being lost.
			if Game.inventory.room_for(crop.def.seed_item, seed_level) == 0:
				continue
		if Game.field.apply(tool.effect, cell):
			field_changed = true
			if seed_level > 0:
				Game.inventory.add(crop.def.seed_item, seed_level, 1)
	# Priced before the XP, so a swing that levels up still pays the old cost.
	var cost: int = Game.stats.rp_cost(tool, charge_level)
	if field_changed:
		Game.stats.add_xp(tool.skill, Game.skills[tool.skill].xp_per_use + tool.charges[charge_level].xp_bonus)
	Game.stats.spend(cost)
	_pop(point, tool)


func _on_fainted() -> void:
	Game.gold = maxi(0, Game.gold - Game.vitals.faint_gold_penalty)
	Game.stats.recover(Game.vitals.faint_wake_hp)
	_player.global_position = _wake_point.global_position


## The XP comes first, so a sleeping level-up's extra max RP is refilled too.
func _sleep() -> void:
	if Game.minute < Game.clock.bedtime_hour * 60.0:
		Game.stats.add_xp(&"sleeping", Game.skills[&"sleeping"].xp_per_use)
	Game.stats.rest(Game.vitals.sleep_rp_restore, Game.vitals.sleep_hp_restore)
	Game.day_tick()


## The crop that the selected hotbar item sows, or null.
func _held_crop() -> CropDef:
	var stack: ItemStack = Game.inventory.slots[Game.inventory.selected]
	return Game.crops.get(stack.item.id) if stack else null


## Sows one seed on the tile in front, if it is tilled and empty.
func _sow(crop: CropDef) -> void:
	var stack: ItemStack = Game.inventory.slots[Game.inventory.selected]
	_field.cells_hit(_player.global_position, _front(), 1, _cells)
	if _cells.is_empty() or not Game.field.sow(_cells[0], crop, stack.level):
		return
	stack.count -= 1
	if stack.count == 0:
		Game.inventory.slots[Game.inventory.selected] = null
	Game.inventory.changed.emit()


## Picks the ripe crop in front into the bag, at the crop's level. It stays unless all of it fits.
func _harvest() -> void:
	_field.cells_hit(_player.global_position, _front(), 1, _cells)
	if _cells.is_empty():
		return
	var crop: Field.Crop = Game.field.crop(_cells[0])
	if crop and crop.is_ripe() and Game.inventory.room_for(crop.def.harvest, crop.level) >= crop.def.harvest_count:
		Game.inventory.add(crop.def.harvest, crop.level, crop.def.harvest_count)
		Game.field.clear_crop(_cells[0])


## The point one tile ahead of the player.
func _front() -> Vector3:
	var f: Vector2i = _player.facing()
	return _player.global_position + Vector3(f.x, 0.0, f.y) * _field.tile_size


func _go_through_door(_body: Node3D, to: Marker3D) -> void:
	_player.global_position = to.global_position
	_player.rotation.y = to.rotation.y


func _pop(point: Vector3, tool: ToolDef) -> void:
	_feedback.play(point, tool)
	if tool.shake > 0.0:
		_camera_rig.shake(tool.shake, tool.shake_seconds)


func _is_water(point: Vector3) -> bool:
	_water_query.position = point + Vector3(0.0, 0.1, 0.0)
	return not get_world_3d().direct_space_state.intersect_point(_water_query, 1).is_empty()
