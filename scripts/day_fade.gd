extends ColorRect

var _tween: Tween
@onready var _label: Label = $Label


func _ready() -> void:
	modulate.a = 0.0
	Game.day_started.connect(_on_day_started)


func _on_day_started() -> void:
	_label.text = Game.clock.wake_message % Game.day
	modulate.a = 1.0
	if _tween:
		_tween.kill()
	_tween = create_tween()
	# Ease in, so the screen stays dark for a moment before it clears.
	_tween.tween_property(self, "modulate:a", 0.0, Game.clock.wake_fade_seconds).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
