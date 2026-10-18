class_name SleepPrompt
extends PanelContainer

signal confirmed

@onready var _yes: Button = $Box/Buttons/Yes


func _ready() -> void:
	hide()
	$Box/Question.text = Game.clock.sleep_question
	_yes.pressed.connect(_answer.bind(true))
	$Box/Buttons/No.pressed.connect(_answer.bind(false))


## Pausing the tree stops the clock and the player while the prompt is up.
func open() -> void:
	show()
	get_tree().paused = true
	_yes.grab_focus()


func _answer(sleep: bool) -> void:
	hide()
	get_tree().paused = false
	if sleep:
		confirmed.emit()
