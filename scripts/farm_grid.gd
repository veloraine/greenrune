class_name FarmGrid
extends Node3D

@export var tile_size: float = 1.0
@export var untilled_material: Material
@export var tilled_material: Material
@export var watered_material: Material
@export var target_material: Material
@export var hitbox_material: Material

const HITBOX_SECONDS: float = 0.3
## How much of a tile's width a ripe crop fills. Earlier stages keep their size relative to it.
const CROP_WIDTH: float = 0.8
## How much of its cell a soil tile covers, leaving a thin gap between tiles.
const TILE_FILL: float = 0.95

var _tiles: Dictionary[Vector2i, MeshInstance3D] = {}
# One slot per tile on its top face, holding the model of the stage that grows there.
var _crops: Dictionary[Vector2i, Node3D] = {}
var _shown: Dictionary[Vector2i, PackedScene] = {}
var _bounds: Dictionary[PackedScene, AABB] = {}
var _debris: Dictionary[Vector2i, Node3D] = {}
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
	tile_mesh.size = Vector3(tile_size * TILE_FILL, 0.02, tile_size * TILE_FILL)
	_quad = BoxMesh.new()
	_quad.size = Vector3(tile_size * TILE_FILL, 0.01, tile_size * TILE_FILL)
	var def: FieldDef = Game.field.def
	for x in def.size.x:
		for y in def.size.y:
			var cell := Vector2i(x, y)
			var tile := MeshInstance3D.new()
			tile.mesh = tile_mesh
			tile.position = _cell_center(cell)
			add_child(tile)
			_tiles[cell] = tile
			var slot := Node3D.new()
			slot.position = _cell_center(cell) + Vector3(0, 0.01, 0)
			add_child(slot)
			_crops[cell] = slot
			_on_soil_changed(cell)
	_add_block_outlines(def)
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


## The block holding cell, counted in blocks from the field's corner.
func block_of(cell: Vector2i) -> Vector2i:
	return cell / Game.field.def.block_size


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


# One mesh of flat strips tracing each block's edge, inset to the tiles' edges so neighbouring blocks
# keep separate lines. It sits just above the soil, so a crop's leaves cover it.
func _add_block_outlines(def: FieldDef) -> void:
	var inset: float = tile_size * (1.0 - TILE_FILL) / 2.0
	var w: float = def.outline_width
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	var blocks: Vector2i = def.size / def.block_size
	for bx in blocks.x:
		for by in blocks.y:
			var start: Vector2 = Vector2(bx, by) * def.block_size * tile_size + Vector2.ONE * inset
			var end: Vector2 = Vector2(bx + 1, by + 1) * def.block_size * tile_size - Vector2.ONE * inset
			_add_strip(surface, start, Vector2(end.x, start.y + w))
			_add_strip(surface, Vector2(start.x, end.y - w), end)
			_add_strip(surface, Vector2(start.x, start.y + w), Vector2(start.x + w, end.y - w))
			_add_strip(surface, Vector2(end.x - w, start.y + w), Vector2(end.x, end.y - w))
	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	material.albedo_color = def.outline_color
	var outlines := MeshInstance3D.new()
	outlines.mesh = surface.commit()
	outlines.material_override = material
	outlines.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	outlines.position.y = 0.025
	add_child(outlines)


func _add_strip(surface: SurfaceTool, from: Vector2, to: Vector2) -> void:
	for corner: Vector2 in [from, Vector2(to.x, from.y), to, from, to, Vector2(from.x, to.y)]:
		surface.add_vertex(Vector3(corner.x, 0.0, corner.y))


func _cell_center(cell: Vector2i) -> Vector3:
	return Vector3((cell.x + 0.5) * tile_size, 0.01, (cell.y + 0.5) * tile_size)


func _on_soil_changed(cell: Vector2i) -> void:
	if not _tiles.has(cell):
		return
	_tiles[cell].material_override = _soil_materials[Game.field.soil(cell)]
	_show_debris(cell)
	var crop: Field.Crop = Game.field.crop(cell)
	var model: PackedScene = crop.def.stage_models[crop.stage()] if crop else null
	if _shown.get(cell) == model:
		return
	_shown[cell] = model
	var slot: Node3D = _crops[cell]
	for old in slot.get_children():
		old.free()
	if model:
		var ripe: AABB = _bounds_of(crop.def.stage_models[-1])
		slot.scale = Vector3.ONE * tile_size * CROP_WIDTH / maxf(ripe.size.x, ripe.size.z)
		var instance: Node3D = model.instantiate()
		instance.position.y -= _bounds_of(model).position.y
		slot.add_child(instance)


func _show_debris(cell: Vector2i) -> void:
	var debris: DebrisDef = Game.field.debris(cell)
	var shown: Node3D = _debris.get(cell)
	if shown and debris and shown.scene_file_path == debris.model.resource_path:
		return
	if shown:
		shown.free()
		_debris.erase(cell)
	if debris:
		var model: Node3D = debris.model.instantiate()
		model.position = _cell_center(cell) + Vector3(0, 0.01, 0)
		add_child(model)
		_debris[cell] = model


func _bounds_of(scene: PackedScene) -> AABB:
	if not _bounds.has(scene):
		var model: Node3D = scene.instantiate()
		_bounds[scene] = _mesh_bounds(model, Transform3D.IDENTITY)
		model.free()
	return _bounds[scene]


func _mesh_bounds(node: Node3D, parent: Transform3D) -> AABB:
	var xf: Transform3D = parent * node.transform
	var box := AABB()
	if node is MeshInstance3D:
		box = xf * (node as MeshInstance3D).mesh.get_aabb()
	for child in node.get_children():
		if child is Node3D:
			var inner: AABB = _mesh_bounds(child, xf)
			if inner.size != Vector3.ZERO:
				box = inner if box.size == Vector3.ZERO else box.merge(inner)
	return box
