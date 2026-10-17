extends CharacterBody3D
## Scene tree (see main.tscn):
##   Main (Node3D)             empty root; every scene needs one root node
##   |- Sun (DirectionalLight3D) parallel light like the sun; without light everything is black
##   |- Camera3D               your eyes; placed above and behind, tilted down
##   |- Floor (StaticBody3D)   an immovable physics body the cube can stand on
##   |  |- CollisionShape3D    invisible shape physics uses for the floor
##   |  `- MeshInstance3D      the visible gray slab (looks and collision are separate)
##   `- Cube (CharacterBody3D) this script; a body you move by code, not by physics forces
##      |- CollisionShape3D    invisible box so the cube cannot fall through the floor
##      `- MeshInstance3D      the visible box

@export_range(1.0, 20.0) var speed: float = 6.0

const GRAVITY: float = 20.0


func _physics_process(delta: float) -> void:
	# _physics_process runs at a fixed rate (60/s); movement code belongs here.
	var input_dir: Vector2 = Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_W):
		input_dir.y -= 1.0
	if Input.is_physical_key_pressed(KEY_S):
		input_dir.y += 1.0
	if Input.is_physical_key_pressed(KEY_A):
		input_dir.x -= 1.0
	if Input.is_physical_key_pressed(KEY_D):
		input_dir.x += 1.0

	# normalized() stops diagonal movement being faster than straight movement.
	input_dir = input_dir.normalized()

	# In 3D, X is left/right and Z is forward/back (forward is -Z). Y is up.
	velocity.x = input_dir.x * speed
	velocity.z = input_dir.y * speed

	if is_on_floor():
		velocity.y = 0.0
	else:
		velocity.y -= GRAVITY * delta

	# Applies velocity, slides along surfaces, and updates is_on_floor().
	move_and_slide()
