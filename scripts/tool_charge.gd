class_name ToolCharge
extends Resource

@export var hold_seconds: float = 0.0
## Spent per swing from Step 4.
@export var rp_cost: int = 1
## Tiles per side of the area hit. 1 is the tile in front of the player; larger sizes are centred on the player.
@export_range(1, 8) var size: int = 1
