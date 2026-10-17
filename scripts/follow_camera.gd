extends Node3D

@export var target: Node3D

var _offset: Vector3


func _ready() -> void:
	_offset = global_position - target.global_position


func _process(_delta: float) -> void:
	global_position = target.global_position + _offset
