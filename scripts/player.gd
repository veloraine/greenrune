extends CharacterBody3D

@export_range(1.0, 10.0) var speed: float = 3.0

const GRAVITY: float = 20.0
const TURN_SPEED: float = 10.0
const ANIM_BLEND: float = 0.2

@onready var _anim: AnimationPlayer = $Model/AnimationPlayer


func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	velocity.x = input_dir.x * speed
	velocity.z = input_dir.y * speed

	var anim_name: StringName = &"Idle"
	if input_dir != Vector2.ZERO:
		rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), TURN_SPEED * delta)
		anim_name = &"Running_A"
	# play() with a blend queues a new blend every call, even for the current animation.
	if _anim.current_animation != anim_name:
		_anim.play(anim_name, ANIM_BLEND)

	if is_on_floor():
		velocity.y = 0.0
	else:
		velocity.y -= GRAVITY * delta

	move_and_slide()
