extends Label

var _shown: int = -1


func _process(_delta: float) -> void:
	var minute: int = int(Game.minute)
	# Rebuild the text only when it changes, not every frame.
	var key: int = Game.day * 1440 + minute
	if key == _shown:
		return
	_shown = key
	text = "Day %d  %02d:%02d" % [Game.day, int(minute / 60.0) % 24, minute % 60]
