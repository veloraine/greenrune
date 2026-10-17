class_name FarmGrid
extends Node3D

@export var size: Vector2i = Vector2i(5, 5)
@export var tile_size: float = 1.0
@export var untilled_material: Material
@export var tilled_material: Material

var _tiles: Dictionary[Vector2i, MeshInstance3D] = {}


func _ready() -> void:
	var mesh := BoxMesh.new()
	mesh.size = Vector3(tile_size * 0.95, 0.02, tile_size * 0.95)
	for x in size.x:
		for y in size.y:
			var cell := Vector2i(x, y)
			var tile := MeshInstance3D.new()
			tile.mesh = mesh
			tile.material_override = untilled_material
			tile.position = Vector3((x + 0.5) * tile_size, 0.01, (y + 0.5) * tile_size)
			add_child(tile)
			_tiles[cell] = tile


func world_to_cell(world: Vector3) -> Vector2i:
	var local: Vector3 = to_local(world)
	return Vector2i(floori(local.x / tile_size), floori(local.z / tile_size))


func till(cell: Vector2i) -> void:
	if _tiles.has(cell):
		_tiles[cell].material_override = tilled_material
