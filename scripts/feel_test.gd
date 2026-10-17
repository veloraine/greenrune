extends Node3D

@export_group("Hit-stop")
@export_range(0.0, 0.2) var hit_stop_seconds: float = 0.05

@export_group("Camera shake")
@export_range(0.0, 1.0) var shake_strength: float = 0.15
@export_range(0.0, 1.0) var shake_seconds: float = 0.2

@onready var _player: Player = $Player
@onready var _grid: FarmGrid = $FarmGrid
@onready var _camera: Camera3D = $CameraRig/SpringArm3D/Camera3D
@onready var _dust: GPUParticles3D = $Dust

var _shake_left: float = 0.0


func _ready() -> void:
	_player.tool_impact.connect(_on_tool_impact)


func _process(delta: float) -> void:
	if _shake_left <= 0.0:
		return
	_shake_left = maxf(_shake_left - delta, 0.0)
	var amount: float = shake_strength * _shake_left / shake_seconds
	_camera.h_offset = randf_range(-amount, amount)
	_camera.v_offset = randf_range(-amount, amount)


func _on_tool_impact(target: Vector3) -> void:
	_grid.till(_grid.world_to_cell(target))
	_dust.global_position = target
	_shake_left = shake_seconds
	_hit_stop()


func _hit_stop() -> void:
	Engine.time_scale = 0.0
	# ignore_time_scale, or the timer never fires while time is stopped.
	await get_tree().create_timer(hit_stop_seconds, true, false, true).timeout
	Engine.time_scale = 1.0
	# A particle restart during a zero-delta frame loses the whole burst.
	_dust.restart()


func _exit_tree() -> void:
	Engine.time_scale = 1.0
