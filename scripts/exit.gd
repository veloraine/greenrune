class_name Exit
extends Area3D

## Walking in takes the player to another area, or to another room of this one.

@export var to: Areas.Id
## Path from the root of the `to` area's scene to the Marker3D the player arrives on.
## Keep the marker outside every exit, or the player leaves again on arrival.
@export var spawn: String


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(_body: Node3D) -> void:
	Travel.go(to, spawn)
