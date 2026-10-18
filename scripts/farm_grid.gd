class_name FarmGrid
extends Node3D

@export var size: Vector2i = Vector2i(5, 5)
@export var tile_size: float = 1.0
@export var untilled_material: Material
@export var tilled_material: Material
@export var watered_material: Material
@export var target_material: Material
@export var hitbox_material: Material

const HITBOX_SECONDS: float = 0.3

var _tiles: Dictionary[Vector2i, MeshInstance3D] = {}
var _soil_materials: Dictionary[Field.Soil, Material] = {}
# Reused quads for the target highlight and the debug hitbox, so nothing is allocated per frame.
var _targets: Array[MeshInstance3D] = []
var _hitboxes: Array[MeshInstance3D] = []
var _hitbox_left: float = 0.0
var _no_cells: Array[Vector2i] = []
var _quad: BoxMesh


func _ready() -> void:
	_soil_materials = {
		Field.Soil.UNTILLED: untilled_material,
		Field.Soil.TILLED: tilled_material,
		Field.Soil.WATERED: watered_material,
	}
	var tile_mesh := BoxMesh.new()
	tile_mesh.size = Vector3(tile_size * 0.95, 0.02, tile_size * 0.95)
	_quad = BoxMesh.new()
	_quad.size = Vector3(tile_size * 0.95, 0.01, tile_size * 0.95)
	for x in size.x:
		for y in size.y:
			var cell := Vector2i(x, y)
			var tile := MeshInstance3D.new()
			tile.mesh = tile_mesh
			tile.position = _cell_center(cell)
			add_child(tile)
			_tiles[cell] = tile
			_on_soil_changed(cell)
	Game.field.changed.connect(_on_soil_changed)


func _process(delta: float) -> void:
	if _hitbox_left <= 0.0:
		return
	_hitbox_left -= delta
	if _hitbox_left <= 0.0:
		_place(_hitboxes, _no_cells, hitbox_material, 0.04)


func world_to_cell(world: Vector3) -> Vector2i:
	var local: Vector3 = to_local(world)
	return Vector2i(floori(local.x / tile_size), floori(local.z / tile_size))


## Fills out with the field cells a tool hits when it lands at point.
## facing is a grid direction such as Vector2i(0, -1); offsets are ToolCharge.cells.
func cells_hit(point: Vector3, facing: Vector2i, offsets: Array[Vector2i], out: Array[Vector2i]) -> void:
	out.clear()
	var base: Vector2i = world_to_cell(point)
	var right := Vector2i(-facing.y, facing.x)
	for offset in offsets:
		var cell: Vector2i = base + right * offset.x + facing * offset.y
		if _tiles.has(cell):
			out.append(cell)


func show_target(cells: Array[Vector2i]) -> void:
	_place(_targets, cells, target_material, 0.03)


func flash_hitbox(cells: Array[Vector2i]) -> void:
	_place(_hitboxes, cells, hitbox_material, 0.04)
	_hitbox_left = HITBOX_SECONDS


func _place(pool: Array[MeshInstance3D], cells: Array[Vector2i], material: Material, height: float) -> void:
	while pool.size() < cells.size():
		var quad := MeshInstance3D.new()
		quad.mesh = _quad
		quad.material_override = material
		add_child(quad)
		pool.append(quad)
	for i in pool.size():
		pool[i].visible = i < cells.size()
		if pool[i].visible:
			pool[i].position = _cell_center(cells[i]) + Vector3(0, height, 0)


func _cell_center(cell: Vector2i) -> Vector3:
	return Vector3((cell.x + 0.5) * tile_size, 0.01, (cell.y + 0.5) * tile_size)


func _on_soil_changed(cell: Vector2i) -> void:
	if _tiles.has(cell):
		_tiles[cell].material_override = _soil_materials[Game.field.soil(cell)]
