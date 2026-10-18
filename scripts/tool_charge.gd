class_name ToolCharge
extends Resource

@export var hold_seconds: float = 0.0
## Spent per swing from Step 4.
@export var rp_cost: int = 1
## Tiles per side of the field block hit (1 is the target tile only; 2 is one of the field's 2×2 sections).
@export_range(1, 8) var size: int = 1
