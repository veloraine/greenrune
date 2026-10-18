class_name ClockDef
extends Resource

## Real seconds per game minute.
@export_range(0.05, 5.0) var seconds_per_minute: float = 0.0
## The DayTick runs and the player wakes at this hour, after a sleep or after staying up all night.
@export_range(0, 24) var wake_hour: int = 0
## Hour, counted on from 00:00 of the current day, by which bedtime still earns sleeping XP.
## 25 is 01:00 that night. The player yawns when it passes.
@export_range(0, 48) var bedtime_hour: int = 0
## Shown when bedtime_hour passes.
@export var yawn_message: String = ""
## Asked when the player uses the bed.
@export var sleep_question: String = ""
## Shown on the black screen each morning. %d is the day.
@export var wake_message: String = ""
## Real seconds the morning black screen takes to fade out.
@export_range(0.0, 5.0) var wake_fade_seconds: float = 0.0
