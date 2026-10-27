extends SceneTree

## Screenshots the farm from the gameplay camera with untilled, tilled and watered soil side by side,
## and prints each state's mean brightness. Needs a window, so run it without --headless:
##   Godot --path . --script res://tools/godot/measure_soil.gd -- <out.png> <hour>
## Brightness is Rec. 709 luma of the screenshot's sRGB pixels, averaged over the middle half of each
## sample tile, so the block outlines at the tile edges stay out of it.
## FarmGrid names the Game autoload, so this file leaves it untyped: naming it here would compile
## farm_grid.gd before the autoload exists.

const UNTILLED: Array[Vector2i] = [Vector2i(0, 3), Vector2i(1, 3), Vector2i(2, 3), Vector2i(0, 4), Vector2i(1, 4), Vector2i(2, 4)]
const TILLED: Array[Vector2i] = [Vector2i(3, 3), Vector2i(4, 3), Vector2i(5, 3), Vector2i(3, 4), Vector2i(4, 4), Vector2i(5, 4)]
const WATERED: Array[Vector2i] = [Vector2i(6, 3), Vector2i(7, 3), Vector2i(8, 3), Vector2i(6, 4), Vector2i(7, 4), Vector2i(8, 4)]


func _initialize() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var hour: float = float(args[1])
	await process_frame
	create_timer(30.0).timeout.connect(quit.bind(1))
	change_scene_to_file("res://scenes/farm.tscn")
	await scene_changed
	var game: Node = root.get_node("Game")
	var field: Field = game.field
	var grid: Node3D = current_scene.get_node("Field")
	get_first_node_in_group(&"player").global_position = grid.to_global(Vector3(4.5, 0.0, 10.5))
	# Debris and a crop on each state in row 7, to see that they sit on the new tiles.
	var debris: Dictionary[Vector2i, DebrisDef] = {}
	for id: StringName in [&"weed", &"stone", &"branch"]:
		debris[Vector2i(debris.size(), 7)] = game.debris[id]
	field.replace_debris(debris)
	# A loaded save's plots would otherwise land in the samples.
	var no_plots: Dictionary[Vector2i, Field.Plot] = {}
	field.replace_plots(no_plots)
	var crop: CropDef = game.crops.values()[0]
	for x in range(3, 9):
		for y in [3, 4, 7]:
			field.apply(ToolDef.Effect.TILL, Vector2i(x, y))
			if x >= 6:
				field.apply(ToolDef.Effect.WATER, Vector2i(x, y))
		field.sow(Vector2i(x, 7), crop, 1)
		field.crop(Vector2i(x, 7)).days = (x % 3) * 3.0
		field.changed.emit(Vector2i(x, 7))
	for i in 30:
		game.minute = hour * 60.0
		await process_frame
	var image: Image = root.get_texture().get_image()
	image.save_png(args[0])
	var camera: Camera3D = root.get_camera_3d()
	var untilled: float = _mean_luma(image, camera, grid, UNTILLED)
	var tilled: float = _mean_luma(image, camera, grid, TILLED)
	var watered: float = _mean_luma(image, camera, grid, WATERED)
	print("%05.2f untilled %.3f  tilled %.3f  watered %.3f  watered vs tilled %.1f%% darker" % [hour, untilled, tilled, watered, (1.0 - watered / tilled) * 100.0])
	quit(0)


func _mean_luma(image: Image, camera: Camera3D, grid: Node3D, cells: Array[Vector2i]) -> float:
	var total: float = 0.0
	var count: int = 0
	for cell in cells:
		var a: Vector2 = camera.unproject_position(grid.to_global(Vector3(cell.x + 0.25, 0.02, cell.y + 0.25)))
		var b: Vector2 = camera.unproject_position(grid.to_global(Vector3(cell.x + 0.75, 0.02, cell.y + 0.75)))
		for y in range(ceili(minf(a.y, b.y)), floori(maxf(a.y, b.y))):
			for x in range(ceili(minf(a.x, b.x)), floori(maxf(a.x, b.x))):
				var c: Color = image.get_pixel(x, y)
				total += 0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b
				count += 1
	return total / count
