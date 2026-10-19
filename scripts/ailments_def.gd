class_name AilmentsDef
extends Resource

enum Ailment { FATIGUE, COLD }

## Chance an all-nighter causes Fatigue.
@export_range(0.0, 1.0) var fatigue_chance: float = 0.0
## Chance an all-nighter while Fatigued causes Cold too.
@export_range(0.0, 1.0) var cold_chance: float = 0.0
## A tool use's RP cost is multiplied by this while Fatigued, then rounded.
@export var fatigue_rp_cost_multiplier: float = 0.0
## While Cold, RP drops each time the clock passes a multiple of this many game minutes.
@export_range(1, 1440) var cold_drain_minutes: int = 1
## Share of max RP each Cold drop takes, rounded up.
@export_range(0.0, 1.0) var cold_drain_share: float = 0.0
## Shown beside the RP bar while active, and in the popups.
@export var names: Dictionary[Ailment, String] = {}
## Popups when an ailment starts and when it is cured. %s is its name.
@export var caught_message: String = ""
@export var cured_message: String = ""
