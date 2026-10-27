class_name Player
extends CharacterBody3D

## Emitted at the swing's impact frame.
signal tool_used(stack: ItemStack, charge_level: int)
## Emitted when Space is released with seeds. charge_level is 1 for a charged sow, else 0.
signal sow_released(stack: ItemStack, charge_level: int)
## Emitted while charging, on reaching each charge level after the tap.
signal charge_level_reached(level: int)

enum State { MOVE, CHARGE, SWING }

@export_range(1.0, 10.0) var speed: float = 8.0
## Real seconds after the impact before the player can move or swing again.
@export_range(0.0, 0.5) var swing_follow_through: float = 0.15

const GRAVITY: float = 20.0
const TURN_SPEED: float = 10.0
const ANIM_BLEND: float = 0.2
## Speed at which Running_A's planted foot moves backward, measured at floor height (4.0 to 4.4).
const RUN_ANIM_SPEED: float = 4.0
## Walking_A's planted-foot speed, measured the same way (about 0.5 to 1.4 through a step).
const WALK_ANIM_SPEED: float = 0.8
## The bones the leg walk drives over a charge or swing pose. The hips stay with the pose.
const LEG_BONES: Array[String] = ["upperleg.l", "lowerleg.l", "foot.l", "toes.l", "upperleg.r", "lowerleg.r", "foot.r", "toes.r"]

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
var _hand_meshes: Array[MeshInstance3D] = []
var _glow := StandardMaterial3D.new()
## Plays only Walking_A's leg tracks, after the main player, so the legs step while the arms hold the tool.
var _legs := AnimationPlayer.new()

@onready var _anim: AnimationPlayer = $Model/AnimationPlayer
@onready var _hand: Node3D = $Model/Rig/Skeleton3D/handslot_r


func _ready() -> void:
	_glow.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_glow.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_glow.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	var walk: Animation = _anim.get_animation(&"Walking_A").duplicate()
	for track in range(walk.get_track_count() - 1, -1, -1):
		if not LEG_BONES.has(String(walk.track_get_path(track).get_concatenated_subnames())):
			walk.remove_track(track)
	var library := AnimationLibrary.new()
	library.add_animation(&"walk", walk)
	_legs.add_animation_library(&"", library)
	# A later sibling of the main AnimationPlayer, so it poses the legs after it each frame.
	$Model.add_child(_legs)


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


func is_charging() -> bool:
	return _state == State.CHARGE


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
	if _legs.is_playing():
		_legs.stop()

	var input_dir: Vector2 = _walk(speed)
	var anim_name: StringName = &"Idle"
	var anim_speed: float = 1.0
	if input_dir != Vector2.ZERO:
		rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), TURN_SPEED * delta)
		anim_name = &"Running_A"
		anim_speed = speed / RUN_ANIM_SPEED
	# play() with a blend queues a new blend every call, even for the current animation.
	if _anim.current_animation != anim_name:
		_anim.play(anim_name, ANIM_BLEND, anim_speed)


## Walks along the move input at walk_speed without turning. Returns the input.
func _walk(walk_speed: float) -> Vector2:
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	velocity.x = input_dir.x * walk_speed
	velocity.z = input_dir.y * walk_speed
	return input_dir


## Walks with the facing held, the legs stepping under the charge or swing pose while moving.
func _tool_walk(walk_speed: float) -> void:
	_walk(walk_speed)
	var moving: bool = velocity.x != 0.0 or velocity.z != 0.0
	if moving and not _legs.is_playing():
		_legs.play(&"walk", -1, walk_speed / WALK_ANIM_SPEED)
	elif not moving and _legs.is_playing():
		_legs.stop()


func _start_charge() -> bool:
	_buffered = false
	var stack: ItemStack = Game.inventory.slots[Game.inventory.selected]
	if stack == null or not (stack.item is ToolDef or Game.crops.has(stack.item.id)):
		return false
	_stack = stack
	_state = State.CHARGE
	_charge_time = 0.0
	# Face exactly along the grid, so the tool lands on the targeted tile. The facing holds until the swing ends.
	var f: Vector2i = facing()
	rotation.y = atan2(-f.x, -f.y)
	if stack.item is ToolDef:
		_equip(stack.item)
		_set_glow(0)
		# A tool with only a tap swings at once, so holding the button never charges it.
		if stack.item.charges.size() == 1:
			_start_swing(0)
			return true
	if _anim.current_animation != &"Idle":
		_anim.play(&"Idle", ANIM_BLEND)
	return true


func _charge(delta: float) -> void:
	_tool_walk(Game.tool_feel.walk_speed)
	var before: int = charge_level()
	_charge_time += delta
	var reached: int = charge_level()
	if reached > before:
		_set_glow(reached)
		# A long frame can cross more than one level; each gets its cue.
		for level in range(before + 1, reached + 1):
			charge_level_reached.emit(level)
	if Input.is_action_pressed("use_tool"):
		return
	if not _stack.item is ToolDef:
		var level: int = charge_level()
		var stack: ItemStack = _stack
		_state = State.MOVE
		_stack = null
		sow_released.emit(stack, level)
		return
	_start_swing(charge_level())


func _start_swing(level: int) -> void:
	var tool: ToolDef = _stack.item
	_swing_level = level
	_state = State.SWING
	_impact_sent = false
	_anim.play(tool.swing_animation, ANIM_BLEND, tool.swing_speed)
	# play() continues a clip that is still running, which would skip straight past the impact.
	_anim.seek(0.0, true)


func _swing() -> void:
	if Input.is_action_just_pressed("use_tool"):
		_buffered = true
	var tool: ToolDef = _stack.item
	# Like RF4, the can waters as you walk; the other tools stand still to swing.
	_tool_walk(Game.tool_feel.walk_speed if tool.effect == ToolDef.Effect.WATER else 0.0)
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
		_hand_meshes.clear()
		if _hand_tool:
			_hand.add_child(_hand_tool)
			_hand_meshes.assign(_hand_tool.find_children("*", "MeshInstance3D"))
		_hand_tool_def = tool
	if _hand_tool:
		_hand_tool.visible = true


## Tints the held tool with the charge level's glow; alpha 0 clears it.
func _set_glow(level: int) -> void:
	var colors: Array[Color] = Game.tool_feel.glow_colors
	_glow.albedo_color = colors[mini(level, colors.size() - 1)]
	var overlay: Material = _glow if _glow.albedo_color.a > 0.0 else null
	for mesh in _hand_meshes:
		mesh.material_overlay = overlay
