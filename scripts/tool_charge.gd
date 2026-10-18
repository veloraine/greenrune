class_name ToolCharge
extends Resource

@export var hold_seconds: float = 0.0
## RP spent per swing at skill level 1.
@export var rp_cost: int = 1
## Skill XP added to the skill's xp_per_use when a swing at this level changes at least one tile.
@export var xp_bonus: float = 0.0
## Tiles per side of the area hit. 1 is the tile in front of the player; larger sizes are centred on the player.
@export_range(1, 8) var size: int = 1
