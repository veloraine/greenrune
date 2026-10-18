class_name Stats
extends RefCounted

## RP, HP or max RP changed.
signal changed
signal leveled_up(skill: SkillDef, level: int)
signal fainted

var rp: int
var hp: int

var _vitals: VitalsDef
var _skills: Dictionary[StringName, SkillDef]
var _xp: Dictionary[StringName, float] = {}


func _init(vitals: VitalsDef, skills: Dictionary[StringName, SkillDef]) -> void:
	_vitals = vitals
	_skills = skills
	rp = max_rp()
	hp = vitals.max_hp


func max_rp() -> int:
	var total: int = _vitals.base_max_rp
	for id in _skills:
		total += (level(id) - 1) * _skills[id].max_rp_per_level
	return total


func xp(id: StringName) -> float:
	return _xp.get(id, 0.0)


func level(id: StringName) -> int:
	var reached: int = 1
	for needed in _skills[id].level_xp:
		if xp(id) >= needed:
			reached += 1
	return reached


func rp_cost(tool: ToolDef, charge_level: int) -> int:
	var cut: float = _skills[tool.skill].rp_cost_cut_per_level * (level(tool.skill) - 1)
	return maxi(1, roundi(tool.charges[charge_level].rp_cost * (1.0 - cut)))


## If RP can't cover the cost, a flat share of max HP is lost instead and RP is left alone.
func spend(cost: int) -> void:
	if rp >= cost:
		rp -= cost
		changed.emit()
		return
	hp = maxi(0, hp - maxi(1, ceili(snappedf(_vitals.max_hp * _vitals.rp_short_hp_cost, 0.001))))
	changed.emit()
	if hp == 0:
		fainted.emit()


func add_xp(id: StringName, amount: float) -> void:
	var before: int = level(id)
	_xp[id] = xp(id) + amount
	var after: int = level(id)
	if after > before:
		leveled_up.emit(_skills[id], after)
		changed.emit()


## Sets HP to this fraction of its max. RP is left as it is.
func recover(hp_fraction: float) -> void:
	hp = maxi(1, roundi(_vitals.max_hp * hp_fraction))
	changed.emit()
