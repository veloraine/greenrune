class_name SowingDef
extends Resource

## Seconds Space must be held with seeds selected before release sows the area.
@export var charge_hold_seconds: float = 0.0
## Tiles per side of the charged sow, centred on the player like a charged tool.
@export_range(1, 8) var charge_size: int = 1
