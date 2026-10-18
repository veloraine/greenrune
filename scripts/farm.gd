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
@onready var _wake_point: Marker3D = $WakePoint


func _ready() -> void:
	_player.tool_used.connect(_on_tool_used)
	Game.stats.fainted.connect(_on_fainted)
	_water_query.collide_with_areas = true
	_water_query.collide_with_bodies = false
	_water_query.collision_mask = WATER_LAYER


func _process(_delta: float) -> void:
	var tool: ToolDef = _player.held_tool()
	if tool == null or _player.is_swinging():
		_cells.clear()
	else:
		_field.cells_hit(_player.global_position, _player.tool_point(tool), tool.charges[_player.charge_level()], _cells)
	_field.show_target(_cells)


func _on_tool_used(stack: ItemStack, charge_level: int) -> void:
	var tool: ToolDef = stack.item
	var point: Vector3 = _player.tool_point(tool)
	_field.cells_hit(_player.global_position, point, tool.charges[charge_level], _cells)
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
	# XP first, so a level-up popup can't replace the faint message.
	Game.stats.add_xp(tool.skill, Game.skills[tool.skill].xp_per_use)
	Game.stats.spend(Game.stats.rp_cost(tool, charge_level))
	for cell in _cells:
		Game.field.apply(tool.effect, cell)
	_pop(point, tool)


# Until Step 5's day tick, a faint skips straight to the next morning here.
func _on_fainted() -> void:
	Game.day += 1
	Game.gold = maxi(0, Game.gold - Game.vitals.faint_gold_penalty)
	Game.stats.recover(Game.vitals.faint_wake_rp)
	_player.global_position = _wake_point.global_position


func _pop(point: Vector3, tool: ToolDef) -> void:
	_feedback.play(point, tool)
	if tool.shake > 0.0:
		_camera_rig.shake(tool.shake, tool.shake_seconds)


func _is_water(point: Vector3) -> bool:
	_water_query.position = point + Vector3(0.0, 0.1, 0.0)
	return not get_world_3d().direct_space_state.intersect_point(_water_query, 1).is_empty()
