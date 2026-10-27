class_name Field
extends RefCounted

signal changed(cell: Vector2i)

## How a cell's ground looks.
enum Soil { UNTILLED, TILLED, WATERED }


## A sown crop. Its stage follows from days, the days of growth it has had.
class Crop:
	var def: CropDef
	var level: int
	var days: float = 0.0

	func _init(p_def: CropDef, p_level: int) -> void:
		def = p_def
		level = p_level

	func stage() -> int:
		var stage_end: int = 0
		for i in def.stage_days.size():
			stage_end += def.stage_days[i]
			if days < stage_end:
				return i
		return def.stage_days.size()

	func is_ripe() -> bool:
		return stage() == def.stage_days.size()


## A tilled cell. Untilled cells have no Plot, so an untilled cell can't be watered or sown.
class Plot:
	var watered: bool = false
	## null when nothing is sown.
	var crop: Crop


var def: FieldDef
var _plots: Dictionary[Vector2i, Plot] = {}
var _debris: Dictionary[Vector2i, DebrisDef] = {}


func _init(p_def: FieldDef) -> void:
	def = p_def


func has_cell(cell: Vector2i) -> bool:
	return Rect2i(Vector2i.ZERO, def.size).has_point(cell)


func soil(cell: Vector2i) -> Soil:
	var plot: Plot = _plots.get(cell)
	if plot == null:
		return Soil.UNTILLED
	return Soil.WATERED if plot.watered else Soil.TILLED


## null when nothing grows there.
func crop(cell: Vector2i) -> Crop:
	var plot: Plot = _plots.get(cell)
	return plot.crop if plot else null


## Every tilled cell's Plot.
func plots() -> Dictionary[Vector2i, Plot]:
	return _plots


## Replaces every plot at once, as a load does, and emits changed for each cell that had or has one.
func replace_plots(new_plots: Dictionary[Vector2i, Plot]) -> void:
	var old: Dictionary[Vector2i, Plot] = _plots
	_plots = new_plots
	for cell in old:
		changed.emit(cell)
	for cell in new_plots:
		if not old.has(cell):
			changed.emit(cell)


## null when the cell is clear.
func debris(cell: Vector2i) -> DebrisDef:
	return _debris.get(cell)


## Every cell holding debris.
func all_debris() -> Dictionary[Vector2i, DebrisDef]:
	return _debris


## Replaces all debris at once, as a load does, and emits changed for each cell that had or has some.
func replace_debris(new_debris: Dictionary[Vector2i, DebrisDef]) -> void:
	var old: Dictionary[Vector2i, DebrisDef] = _debris
	_debris = new_debris
	for cell in old:
		changed.emit(cell)
	for cell in new_debris:
		if not old.has(cell):
			changed.emit(cell)


## A new game's debris: def.starting_debris scattered outside def.debris_free, on the same cells every time.
func scatter_debris() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = def.debris_seed
	var free_cells: Array[Vector2i] = []
	for x in def.size.x:
		for y in def.size.y:
			if not def.debris_free.has_point(Vector2i(x, y)):
				free_cells.append(Vector2i(x, y))
	var placed: Dictionary[Vector2i, DebrisDef] = {}
	var wanted: int = 0
	for debris_def in def.starting_debris:
		wanted += def.starting_debris[debris_def]
		for i in def.starting_debris[debris_def]:
			if free_cells.is_empty():
				break
			placed[free_cells.pop_at(rng.randi_range(0, free_cells.size() - 1))] = debris_def
	if placed.size() < wanted:
		push_error("starting_debris wants %d pieces but only %d cells are free" % [wanted, placed.size()])
	replace_debris(placed)


## Returns whether the cell changed. Debris blocks every tool until it is cleared.
func apply(effect: ToolDef.Effect, cell: Vector2i) -> bool:
	if _debris.has(cell):
		return false
	var plot: Plot = _plots.get(cell)
	match effect:
		ToolDef.Effect.TILL:
			if plot:
				return false
			_plots[cell] = Plot.new()
		ToolDef.Effect.WATER:
			if plot == null or plot.watered:
				return false
			plot.watered = true
		ToolDef.Effect.REAP:
			# A seed that hasn't sprouted is safe from the sickle, like Rune Factory 4.
			if plot == null or plot.crop == null or plot.crop.stage() == 0:
				return false
			plot.crop = null
	changed.emit(cell)
	return true


## Sows a crop on a tilled, empty cell. Returns whether it did.
func sow(cell: Vector2i, def: CropDef, level: int) -> bool:
	var plot: Plot = _plots.get(cell)
	if plot == null or plot.crop:
		return false
	plot.crop = Crop.new(def, level)
	changed.emit(cell)
	return true


func clear_crop(cell: Vector2i) -> void:
	_plots[cell].crop = null
	changed.emit(cell)


## Each crop grows by one day, or by its dry_growth if it wasn't watered.
func grow_crops() -> void:
	for cell in _plots:
		var plot: Plot = _plots[cell]
		if plot.crop and not plot.crop.is_ripe():
			plot.crop.days += 1.0 if plot.watered else plot.crop.def.dry_growth
			changed.emit(cell)


## Watered soil dries back to tilled overnight. Crops stay.
func dry() -> void:
	for cell in _plots:
		if _plots[cell].watered:
			_plots[cell].watered = false
			changed.emit(cell)
