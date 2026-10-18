class_name ToolCharge
extends Resource

@export var hold_seconds: float = 0.0
## Spent per swing from Step 4.
@export var rp_cost: int = 1
## Cells hit, relative to the target tile: x is to the player's right, y is forward.
@export var cells: Array[Vector2i] = [Vector2i.ZERO]
