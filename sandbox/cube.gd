extends CharacterBody3D

@export_range(1.0, 20.0) var speed: float = 6.0

const GRAVITY: float = 20.0
const TURN_SPEED: float = 10.0


func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_W):
		input_dir.y -= 1.0
	if Input.is_physical_key_pressed(KEY_S):
		input_dir.y += 1.0
	if Input.is_physical_key_pressed(KEY_A):
		input_dir.x -= 1.0
	if Input.is_physical_key_pressed(KEY_D):
		input_dir.x += 1.0

	input_dir = input_dir.normalized()

	velocity.x = input_dir.x * speed
	velocity.z = input_dir.y * speed

	# No input means no direction to face, so keep the last facing.
	if input_dir != Vector2.ZERO:
		var target_angle: float = atan2(-velocity.x, -velocity.z)
		rotation.y = lerp_angle(rotation.y, target_angle, TURN_SPEED * delta)

	if is_on_floor():
		velocity.y = 0.0
	else:
		velocity.y -= GRAVITY * delta

	move_and_slide()
