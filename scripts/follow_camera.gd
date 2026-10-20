class_name FollowCamera
extends Node3D

@export var target: Node3D
## The camera this rig frames and shakes.
@export var camera: Camera3D
@export var def: CameraDef

var _offset: Vector3
var _shake_strength: float = 0.0
var _shake_seconds: float = 0.0
var _shake_left: float = 0.0
var _framing: CameraFraming
var _rooms: Array[AABB] = []

@onready var _arm: SpringArm3D = $SpringArm3D


func _ready() -> void:
	_offset = global_position - target.global_position
	# Read once as boxes rather than through Area3D signals, which arrive a physics frame after a door teleport.
	for area in get_tree().get_nodes_in_group(&"indoors"):
		for shape: CollisionShape3D in area.find_children("*", "CollisionShape3D", false):
			var size: Vector3 = (shape.shape as BoxShape3D).size
			_rooms.append(shape.global_transform * AABB(-size / 2.0, size))


func _process(delta: float) -> void:
	var focus: Vector3 = target.global_position
	var room: int = _room_at(focus)
	# Indoors the camera holds on the room's centre so the whole room stays in view.
	if room != -1:
		var centre: Vector3 = _rooms[room].get_center()
		focus = Vector3(centre.x, focus.y, centre.z)
	global_position = focus + _offset
	# Without a def (the Phase 0 baseline scene) the rig keeps the framing set in its scene.
	if def:
		var framing: CameraFraming = def.outdoor if room == -1 else def.indoor
		if framing != _framing:
			_frame(framing)
	if _shake_left <= 0.0:
		return
	_shake_left = maxf(_shake_left - delta, 0.0)
	var amount: float = _shake_strength * _shake_left / _shake_seconds
	camera.h_offset = randf_range(-amount, amount)
	camera.v_offset = randf_range(-amount, amount)


func shake(strength: float, seconds: float) -> void:
	_shake_strength = strength
	_shake_seconds = seconds
	_shake_left = seconds


func _frame(framing: CameraFraming) -> void:
	_framing = framing
	_arm.rotation.x = deg_to_rad(-framing.pitch_degrees)
	_arm.spring_length = framing.arm_length
	# The arm only moves the camera on its physics tick, so place it now to snap on this frame.
	camera.position = Vector3(0.0, 0.0, framing.arm_length)
	camera.fov = framing.fov


## Index of the indoor room containing the point, or -1 outdoors.
func _room_at(point: Vector3) -> int:
	for i in _rooms.size():
		if _rooms[i].has_point(point):
			return i
	return -1
