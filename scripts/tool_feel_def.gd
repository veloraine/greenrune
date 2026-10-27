class_name ToolFeelDef
extends Resource

@export_group("Target marker")
## The shadow laid on each plot the tool will hit.
@export var shadow_color: Color = Color.RED
## The marker floating over the target, tip down.
@export var marker_color: Color = Color.RED
## Metres above the soil of the marker's tip, clear of debris.
@export var marker_height: float = 0.0
## The marker's scale at each charge level. Levels past the end use the last.
@export var marker_scales: Array[float] = [1.0]
## The line around the full charge area while a charge is held.
@export var outline_color: Color = Color.RED
@export var outline_width: float = 0.0

@export_group("Charge cues")
## The held tool's glow at each charge level. Alpha 0 is no glow; levels past the end use the last.
@export var glow_colors: Array[Color] = [Color.TRANSPARENT]
## Plays on reaching each charge level after the tap.
@export var charge_sound: AudioStream
## charge_sound's pitch on reaching level i + 1. Levels past the end use the last.
@export var charge_pitches: Array[float] = [1.0]
