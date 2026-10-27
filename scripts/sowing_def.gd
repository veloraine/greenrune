class_name SowingDef
extends Resource

## Seconds Space must be held with seeds selected before release sows the area.
@export var charge_hold_seconds: float = 0.0
## Width × depth in tiles of the charged sow, placed like a charged tool's area.
@export var charge_size: Vector2i = Vector2i.ONE
