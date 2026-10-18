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
const CROP_HEIGHT: float = 0.35

var _tiles: Dictionary[Vector2i, MeshInstance3D] = {}
# One billboard per tile, made once and shown only while a crop grows there.
# A placeholder Label3D until the stage sprites are painted.
var _crops: Dictionary[Vector2i, Label3D] = {}
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
			var crop := Label3D.new()
			crop.billboard = BaseMaterial3D.BILLBOARD_ENABLED
			crop.pixel_size = 0.003
			crop.position = _cell_center(cell) + Vector3(0, CROP_HEIGHT, 0)
			add_child(crop)
			_crops[cell] = crop
			_on_soil_changed(cell)
	Game.field.changed.connect(_on_soil_changed)


func _process(delta: float) -> void:
	if _hitbox_left <= 0.0:
		return
	_hitbox_left -= delta
	if _hitbox_left <= 0.0:
		_place(_hitboxes, _no_cells, hitbox_material, 0.04)


## Fills out with the field cells a tool hits: the size × size block around the player, like
## Rune Factory 4, or for size 1 the tile at point in front of them. Cells off the field are left out.
func cells_hit(player: Vector3, point: Vector3, size: int, out: Array[Vector2i]) -> void:
	out.clear()
	var center: Vector3 = to_local(point if size == 1 else player) / tile_size
	var offset: float = (size - 1) / 2.0
	var origin := Vector2i(floori(center.x - offset), floori(center.z - offset))
	for y in size:
		for x in size:
			var cell: Vector2i = origin + Vector2i(x, y)
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
	if not _tiles.has(cell):
		return
	_tiles[cell].material_override = _soil_materials[Game.field.soil(cell)]
	var crop: Field.Crop = Game.field.crop(cell)
	_crops[cell].visible = crop != null
	if crop:
		_crops[cell].text = "%s\n%d/%d" % [crop.def.harvest.display_name, crop.stage() + 1, crop.def.stage_days.size() + 1]
