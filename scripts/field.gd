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


var _plots: Dictionary[Vector2i, Plot] = {}


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


## Returns whether the cell changed.
func apply(effect: ToolDef.Effect, cell: Vector2i) -> bool:
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
