extends Label

var _shown: int = -1


func _process(_delta: float) -> void:
	# Rebuild the text only when it changes, not every frame.
	if Game.gold == _shown:
		return
	_shown = Game.gold
	text = "%d G" % _shown
