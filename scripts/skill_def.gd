class_name SkillDef
extends Resource

@export var id: StringName
@export var display_name: String
## Total XP needed to reach level 2, 3, 4 and so on. The skill tops out one level past the last entry.
@export var level_xp: Array[int] = []
## XP for each use. For walking, a use is one metre walked.
@export var xp_per_use: float = 0.0
## Each level past 1 cuts this skill's RP costs by this fraction of the base cost.
@export_range(0.0, 0.1) var rp_cost_cut_per_level: float = 0.0
## Each level past 1 adds this much max RP.
@export var max_rp_per_level: int = 0
