extends CanvasLayer

## Moves the player between areas, and between rooms of one area, behind a fade to black.
## An autoload, so the black screen outlives the scene it hides.

var def: TravelDef = load("res://data/travel.tres")

@onready var _black: ColorRect = $Black


## Fades to black, makes `to` the current area, puts the player on the marker at `spawn`, a path from
## the area's root, and fades back in. The player keeps the way they faced before the trip.
## The game pauses until the player is placed, so the clock stops and nothing else can start a trip.
func go(to: Areas.Id, spawn: NodePath) -> void:
	var tree: SceneTree = get_tree()
	tree.paused = true
	var player: Player = tree.get_first_node_in_group(&"player")
	player.cancel_tool()
	var facing: float = player.rotation.y
	await _fade(1.0)
	await _enter(to)
	player = tree.get_first_node_in_group(&"player")
	player.global_position = tree.current_scene.get_node(spawn).global_position
	player.rotation.y = facing
	tree.paused = false
	_fade(0.0)


## Puts the player at position in `to` with no fade, as a loaded save does.
func place(to: Areas.Id, position: Vector3) -> void:
	await _enter(to)
	(get_tree().get_first_node_in_group(&"player") as Node3D).global_position = position


func _enter(to: Areas.Id) -> void:
	if get_tree().current_scene.scene_file_path != Areas.SCENES[to]:
		get_tree().change_scene_to_file(Areas.SCENES[to])
		await get_tree().scene_changed


func _fade(alpha: float) -> Signal:
	var tween: Tween = create_tween()
	tween.tween_property(_black, "modulate:a", alpha, def.fade_seconds)
	return tween.finished
