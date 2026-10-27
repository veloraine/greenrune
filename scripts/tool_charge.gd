class_name ToolCharge
extends Resource

@export var hold_seconds: float = 0.0
## RP spent per swing at skill level 1.
@export var rp_cost: int = 1
## Skill XP added to the skill's xp_per_use when a swing at this level changes at least one tile.
@export var xp_bonus: float = 0.0
## Width × depth in tiles of the area hit, depth along the facing. (1, 1) is the tile in front of the player; a
## larger area starts at the field block holding the player's tile and runs depth / block size blocks along the facing.
@export var size: Vector2i = Vector2i.ONE
