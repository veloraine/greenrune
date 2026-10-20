class_name Player
extends CharacterBody3D

## Emitted at the swing's impact frame.
signal tool_used(stack: ItemStack, charge_level: int)
## Emitted when Space is released with seeds. charge_level is 1 for a charged sow, else 0.
signal sow_released(stack: ItemStack, charge_level: int)

enum State { MOVE, CHARGE, SWING }

@export_range(1.0, 10.0) var speed: float = 8.0
## Real seconds after the impact before the player can move or swing again.
@export_range(0.0, 0.5) var swing_follow_through: float = 0.15

const GRAVITY: float = 20.0
const TURN_SPEED: float = 10.0
const ANIM_BLEND: float = 0.2
## Speed at which Running_A's planted foot moves backward, measured at floor height (4.0 to 4.4).
const RUN_ANIM_SPEED: float = 4.0

var _state: State = State.MOVE
## The stack being charged or swung, fixed even if the hotbar selection changes mid-swing.
var _stack: ItemStack
var _charge_time: float = 0.0
var _swing_level: int = 0
var _impact_sent: bool = false
var _swing_end_time: float = 0.0
## A press during a swing, carried over so it isn't lost.
var _buffered: bool = false
var _hand_tool: Node3D
var _hand_tool_def: ToolDef

@onready var _anim: AnimationPlayer = $Model/AnimationPlayer
@onready var _hand: Node3D = $Model/Rig/Skeleton3D/handslot_r


func _physics_process(delta: float) -> void:
	match _state:
		State.MOVE:
			_move(delta)
		State.CHARGE:
			_charge(delta)
		State.SWING:
			_swing()

	if is_on_floor():
		velocity.y = 0.0
	else:
		velocity.y -= GRAVITY * delta

	move_and_slide()
	var moved: Vector3 = get_position_delta()
	if moved.x != 0.0 or moved.z != 0.0:
		Game.stats.add_xp(&"walking", Vector2(moved.x, moved.z).length() * Game.skills[&"walking"].xp_per_use)


## The stack being charged or swung, or else the selected hotbar slot's. null if neither.
func held_stack() -> ItemStack:
	return _stack if _state != State.MOVE else Game.inventory.slots[Game.inventory.selected]


func is_swinging() -> bool:
	return _state == State.SWING


## True when not charging or swinging.
func is_idle() -> bool:
	return _state == State.MOVE


## Drops any charge or swing, and any buffered press, back to idle.
func cancel_tool() -> void:
	_state = State.MOVE
	_stack = null
	_buffered = false
	if _hand_tool:
		_hand_tool.visible = false


## The grid direction the player faces, snapped to the nearest of four.
func facing() -> Vector2i:
	var forward: Vector3 = -global_basis.z
	if absf(forward.x) > absf(forward.z):
		return Vector2i(int(signf(forward.x)), 0)
	return Vector2i(0, int(signf(forward.z)))


## Where the tool lands: reach metres ahead along the snapped facing.
func tool_point(tool: ToolDef) -> Vector3:
	var f: Vector2i = facing()
	return global_position + Vector3(f.x, 0.0, f.y) * tool.reach


## The highest charge level whose hold time has passed. 0 unless charging.
func charge_level() -> int:
	if _state != State.CHARGE:
		return 0
	var tool: ToolDef = _stack.item as ToolDef
	if tool == null:
		return 1 if _charge_time >= Game.sowing.charge_hold_seconds else 0
	var level: int = 0
	for i in tool.charges.size():
		if _charge_time >= tool.charges[i].hold_seconds:
			level = i
	return level


func _move(delta: float) -> void:
	if (Input.is_action_just_pressed("use_tool") or _buffered) and _start_charge():
		return

	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	velocity.x = input_dir.x * speed
	velocity.z = input_dir.y * speed

	var anim_name: StringName = &"Idle"
	var anim_speed: float = 1.0
	if input_dir != Vector2.ZERO:
		rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), TURN_SPEED * delta)
		anim_name = &"Running_A"
		anim_speed = speed / RUN_ANIM_SPEED
	# play() with a blend queues a new blend every call, even for the current animation.
	if _anim.current_animation != anim_name:
		_anim.play(anim_name, ANIM_BLEND, anim_speed)


func _start_charge() -> bool:
	_buffered = false
	var stack: ItemStack = Game.inventory.slots[Game.inventory.selected]
	if stack == null or not (stack.item is ToolDef or Game.crops.has(stack.item.id)):
		return false
	_stack = stack
	_state = State.CHARGE
	_charge_time = 0.0
	velocity.x = 0.0
	velocity.z = 0.0
	# Face exactly along the grid, so the tool lands on the targeted tile.
	var f: Vector2i = facing()
	rotation.y = atan2(-f.x, -f.y)
	if stack.item is ToolDef:
		_equip(stack.item)
	if _anim.current_animation != &"Idle":
		_anim.play(&"Idle", ANIM_BLEND)
	return true


func _charge(delta: float) -> void:
	_charge_time += delta
	if Input.is_action_pressed("use_tool"):
		return
	if not _stack.item is ToolDef:
		var level: int = charge_level()
		var stack: ItemStack = _stack
		_state = State.MOVE
		_stack = null
		sow_released.emit(stack, level)
		return
	var tool: ToolDef = _stack.item
	_swing_level = charge_level()
	_state = State.SWING
	_impact_sent = false
	_anim.play(tool.swing_animation, ANIM_BLEND, tool.swing_speed)
	# play() continues a clip that is still running, which would skip straight past the impact.
	_anim.seek(0.0, true)


func _swing() -> void:
	if Input.is_action_just_pressed("use_tool"):
		_buffered = true
	var tool: ToolDef = _stack.item
	var anim_time: float = _anim.current_animation_position
	if _anim.current_animation != tool.swing_animation or (_impact_sent and anim_time >= _swing_end_time):
		_state = State.MOVE
		_stack = null
		if _hand_tool:
			_hand_tool.visible = false
		return
	if not _impact_sent and anim_time >= tool.impact_time:
		_impact_sent = true
		# Animation time runs swing_speed times faster than real time.
		_swing_end_time = anim_time + swing_follow_through * tool.swing_speed
		tool_used.emit(_stack, _swing_level)


func _equip(tool: ToolDef) -> void:
	if tool != _hand_tool_def:
		if _hand_tool:
			_hand_tool.queue_free()
		_hand_tool = tool.hand_model.instantiate() if tool.hand_model else null
		if _hand_tool:
			_hand.add_child(_hand_tool)
		_hand_tool_def = tool
	if _hand_tool:
		_hand_tool.visible = true
