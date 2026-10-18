extends Label

const SECONDS: float = 1.5
const RISE: float = 24.0

var _tween: Tween
@onready var _start_y: float = position.y


func _ready() -> void:
	modulate.a = 0.0
	Game.stats.leveled_up.connect(_on_leveled_up)
	Game.stats.fainted.connect(_on_fainted)


func _on_leveled_up(skill: SkillDef, level: int) -> void:
	_show("%s Lv %d!" % [skill.display_name, level])


func _on_fainted() -> void:
	_show(Game.vitals.faint_message)


func _show(message: String) -> void:
	# A level-up and a faint can land on the same swing; show both.
	text = message if modulate.a == 0.0 else text + "\n" + message
	position.y = _start_y
	modulate.a = 1.0
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "position:y", _start_y - RISE, SECONDS)
	_tween.parallel().tween_property(self, "modulate:a", 0.0, SECONDS / 2.0).set_delay(SECONDS / 2.0)
