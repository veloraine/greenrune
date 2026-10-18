extends Node

# An autoload, so a scene change mid-freeze can't leave the game stuck at time_scale 0.


func freeze(seconds: float) -> void:
	Engine.time_scale = 0.0
	# ignore_time_scale, or the timer never fires while time is stopped.
	await get_tree().create_timer(seconds, true, false, true).timeout
	Engine.time_scale = 1.0
