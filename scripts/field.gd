class_name Field
extends RefCounted

signal changed(cell: Vector2i)

enum Soil { UNTILLED, TILLED, WATERED }

## Only cells that differ from UNTILLED are stored.
var _soil: Dictionary[Vector2i, Soil] = {}


func soil(cell: Vector2i) -> Soil:
	return _soil.get(cell, Soil.UNTILLED)


## Returns whether the cell's soil changed.
func apply(effect: ToolDef.Effect, cell: Vector2i) -> bool:
	var before: Soil = soil(cell)
	var after: Soil = before
	match effect:
		ToolDef.Effect.TILL:
			if before == Soil.UNTILLED:
				after = Soil.TILLED
		ToolDef.Effect.WATER:
			if before == Soil.TILLED:
				after = Soil.WATERED
	if after == before:
		return false
	_soil[cell] = after
	changed.emit(cell)
	return true


## Step 5b: each crop grows by one day here.
func grow_crops() -> void:
	pass


## Watered soil dries back to tilled overnight.
func dry() -> void:
	for cell in _soil:
		if _soil[cell] == Soil.WATERED:
			_soil[cell] = Soil.TILLED
			changed.emit(cell)
