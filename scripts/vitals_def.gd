class_name VitalsDef
extends Resource

## Max RP with every skill at level 1. Sized so that a morning of tilling and watering most of the
## 12×12 field empties it; the budget is worked out in docs/phases/phase-01-farm-loop.md, Step 4.
@export var base_max_rp: int = 0
@export var max_hp: int = 0
## Gold lost on a faint. Gold never drops below 0.
@export var faint_gold_penalty: int = 0
## Fraction of max RP the player wakes with after a faint.
@export_range(0.0, 1.0) var faint_wake_rp: float = 0.0
## Shown when the player wakes after a faint.
@export var faint_message: String = ""
