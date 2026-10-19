class_name VitalsDef
extends Resource

## Max RP with every skill at level 1. Sized so that a morning of tilling and watering most of the
## 12×12 field empties it; the budget is worked out in docs/phases/phase-01-farm-loop.md, Step 4.
@export var base_max_rp: int = 0
@export var max_hp: int = 0
## Share of max HP a tool use costs at 0 RP, rounded up.
@export_range(0.0, 1.0) var rp_short_hp_cost: float = 0.0
## Share of max HP lost, rounded up, when some RP is left but less than a tool use costs. That RP is emptied too.
@export_range(0.0, 1.0) var rp_leftover_hp_cost: float = 0.0
## Gold lost on a faint. Gold never drops below 0.
@export var faint_gold_penalty: int = 0
## Fraction of max HP the player wakes with after a faint.
@export_range(0.0, 1.0) var faint_wake_hp: float = 0.0
## Fractions of max RP and max HP a sleep restores.
@export_range(0.0, 1.0) var sleep_rp_restore: float = 0.0
@export_range(0.0, 1.0) var sleep_hp_restore: float = 0.0
## Shown when the player wakes after a faint.
@export var faint_message: String = ""
