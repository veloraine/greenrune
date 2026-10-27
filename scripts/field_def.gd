class_name FieldDef
extends Resource

## Plots across (x) and deep (y).
@export var size: Vector2i = Vector2i.ZERO
## Plots per side of a square block, the area a bronze charge covers.
@export var block_size: int = 0
## The faint line drawn around each block, just above the soil.
@export var outline_color: Color = Color.WHITE
@export var outline_width: float = 0.0
