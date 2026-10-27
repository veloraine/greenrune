class_name ToolDef
extends ItemDef

enum Effect { TILL, WATER, REAP }

@export var effect: Effect
## The skill that gains XP from this tool.
@export var skill: StringName
## Index 0 is a tap; each later level needs a longer hold.
@export var charges: Array[ToolCharge] = []
## Uses before a refill at water. 0 means the tool never runs dry.
@export var capacity: int = 0

@export_group("Swing")
@export var hand_model: PackedScene
@export var swing_animation: StringName
@export var swing_speed: float = 1.0
## Seconds into swing_animation where the tool hits.
@export var impact_time: float = 0.5
## Metres ahead of the player where the tool lands.
@export var reach: float = 1.0
## Metres per second the player keeps walking during a tap; 0 stands still. RF4's can waters as you walk.
@export var walk_speed: float = 0.0

@export_group("Feedback")
@export var impact_sound: AudioStream
@export var dust_color: Color = Color.WHITE
@export_range(0.0, 0.2) var hit_stop: float = 0.0
@export_range(0.0, 1.0) var shake: float = 0.0
@export_range(0.0, 0.5) var shake_seconds: float = 0.1
