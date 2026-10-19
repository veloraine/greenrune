extends VBoxContainer

@onready var _hp: ProgressBar = $HP
@onready var _hp_label: Label = $HP/Label
@onready var _rp: ProgressBar = $RP
@onready var _rp_label: Label = $RP/Label
@onready var _ailments: Label = $HP/Ailments


func _ready() -> void:
	Game.stats.changed.connect(_refresh)
	_refresh()


func _refresh() -> void:
	var max_rp: int = Game.stats.max_rp()
	_hp.max_value = Game.vitals.max_hp
	_hp.value = Game.stats.hp
	_hp_label.text = "HP %d / %d" % [Game.stats.hp, Game.vitals.max_hp]
	_rp.max_value = max_rp
	_rp.value = Game.stats.rp
	_rp_label.text = "RP %d / %d" % [Game.stats.rp, max_rp]
	var active: PackedStringArray = []
	for ailment in Game.ailments.names:
		if Game.stats.has_ailment(ailment):
			active.append(Game.ailments.names[ailment])
	_ailments.text = " ".join(active)
