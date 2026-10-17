class_name Player
extends CharacterBody3D

signal tool_impact(target: Vector3)

enum State { MOVE, SWING }

@export_range(1.0, 10.0) var speed: float = 6.0
@export_range(0.5, 6.0) var swing_speed: float = 2.5
## Real seconds after the impact before the player can move or swing again.
@export_range(0.0, 0.5) var swing_follow_through: float = 0.15

const GRAVITY: float = 20.0
const TURN_SPEED: float = 10.0
const ANIM_BLEND: float = 0.2
## Speed at which Running_A's planted foot moves backward, measured at floor height (4.0 to 4.4).
const RUN_ANIM_SPEED: float = 4.0
const SWING_ANIM: StringName = &"2H_Melee_Attack_Chop"
## Seconds into SWING_ANIM for the hit. The axe head first touches the ground at 0.84 and is lowest at 1.0.
const SWING_IMPACT_TIME: float = 1.0
const TOOL_REACH: float = 1.0

var _state: State = State.MOVE
var _impact_sent: bool = false
var _swing_end_time: float = 0.0

@onready var _anim: AnimationPlayer = $Model/AnimationPlayer
@onready var _tool: Node3D = $Model/Rig/Skeleton3D/handslot_r/Hoe


func _physics_process(delta: float) -> void:
	match _state:
		State.MOVE:
			_move(delta)
		State.SWING:
			_swing()

	if is_on_floor():
		velocity.y = 0.0
	else:
		velocity.y -= GRAVITY * delta

	move_and_slide()


func _move(delta: float) -> void:
	if Input.is_action_just_pressed("use_tool"):
		_state = State.SWING
		_impact_sent = false
		_tool.visible = true
		velocity.x = 0.0
		velocity.z = 0.0
		_anim.play(SWING_ANIM, ANIM_BLEND, swing_speed)
		# play() continues a clip that is still running, which would skip straight past the impact.
		_anim.seek(0.0, true)
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


func _swing() -> void:
	var anim_time: float = _anim.current_animation_position
	if _anim.current_animation != SWING_ANIM or (_impact_sent and anim_time >= _swing_end_time):
		_state = State.MOVE
		_tool.visible = false
		return
	if not _impact_sent and anim_time >= SWING_IMPACT_TIME:
		_impact_sent = true
		# Animation time runs swing_speed times faster than real time.
		_swing_end_time = anim_time + swing_follow_through * swing_speed
		tool_impact.emit(global_position - global_basis.z * TOOL_REACH)
