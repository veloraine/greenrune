class_name Field
extends RefCounted

signal changed(cell: Vector2i)

enum Soil { UNTILLED, TILLED, WATERED }

## Only cells that differ from UNTILLED are stored.
var _soil: Dictionary[Vector2i, Soil] = {}


func soil(cell: Vector2i) -> Soil:
	return _soil.get(cell, Soil.UNTILLED)


func apply(effect: ToolDef.Effect, cell: Vector2i) -> void:
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
		return
	_soil[cell] = after
	changed.emit(cell)
