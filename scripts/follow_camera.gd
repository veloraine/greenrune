class_name FollowCamera
extends Node3D

@export var target: Node3D
## The camera that shake() moves.
@export var shake_camera: Camera3D

var _offset: Vector3
var _shake_strength: float = 0.0
var _shake_seconds: float = 0.0
var _shake_left: float = 0.0


func _ready() -> void:
	_offset = global_position - target.global_position


func _process(delta: float) -> void:
	global_position = target.global_position + _offset
	if _shake_left <= 0.0:
		return
	_shake_left = maxf(_shake_left - delta, 0.0)
	var amount: float = _shake_strength * _shake_left / _shake_seconds
	shake_camera.h_offset = randf_range(-amount, amount)
	shake_camera.v_offset = randf_range(-amount, amount)


func shake(strength: float, seconds: float) -> void:
	_shake_strength = strength
	_shake_seconds = seconds
	_shake_left = seconds
