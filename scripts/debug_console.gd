extends VBoxContainer

const HELP: String = "add <item> [level] [count] | inv | save | load | rp <n> | hp <n> | xp <skill> <amount> | skills | time [hh:mm, 25:30 is 01:30 that night] | day [n], runs the DayTick n times | ailment [fatigue|cold], toggles it"

var _was_paused: bool = false

@onready var _log: Label = $Log
@onready var _line: LineEdit = $Line


func _ready() -> void:
	if not OS.is_debug_build():
		queue_free()
		return
	hide()
	_line.text_submitted.connect(_on_text_submitted)


# _input runs before the LineEdit, so the toggle key never gets typed into it.
func _input(event: InputEvent) -> void:
	if not event.is_action("debug_console"):
		return
	# Swallow the key's release and held-down repeats too, not just the press.
	get_viewport().set_input_as_handled()
	if not event.is_action_pressed("debug_console"):
		return
	visible = not visible
	# Pausing stops the player walking while you type WASD.
	if visible:
		_was_paused = get_tree().paused
		get_tree().paused = true
		_line.grab_focus()
	else:
		# The sleep prompt can unpause while the console is open; don't restore a stale pause.
		get_tree().paused = _was_paused and get_tree().paused


# A load into another area frees the open console with its scene, along with whatever paused the game.
func _exit_tree() -> void:
	if visible:
		get_tree().paused = false


func _on_text_submitted(text: String) -> void:
	_line.clear()
	_log.text = _run(text.split(" ", false))


func _run(args: PackedStringArray) -> String:
	if args.is_empty():
		return HELP
	match args[0]:
		"add":
			return _add(args)
		"inv":
			return _list()
		"save":
			var err: Error = SaveGame.write(get_tree())
			return "Saved to %s" % ProjectSettings.globalize_path(SaveGame.path) if err == OK else "Save failed: %s" % error_string(err)
		"load":
			var err: Error = SaveGame.read(get_tree())
			return "Loaded" if err == OK else "Load failed: %s" % error_string(err)
		"rp":
			if args.size() > 1:
				Game.stats.rp = clampi(int(args[1]), 0, Game.stats.max_rp())
				Game.stats.changed.emit()
			return _skills()
		"hp":
			if args.size() > 1:
				Game.stats.hp = clampi(int(args[1]), 0, Game.vitals.max_hp)
				Game.stats.changed.emit()
			return _skills()
		"xp":
			if args.size() < 3 or not Game.skills.has(StringName(args[1])):
				return "Skills: %s" % ", ".join(Game.skills.keys())
			Game.stats.add_xp(StringName(args[1]), float(args[2]))
			return _skills()
		"skills":
			return _skills()
		"time":
			if args.size() > 1:
				var hm: PackedStringArray = args[1].split(":")
				var minute: float = int(hm[0]) * 60.0 + (int(hm[1]) if hm.size() > 1 else 0)
				Game.minute = maxf(minute, Game.clock.wake_hour * 60.0)
			return "Day %d, %02d:%02d" % [Game.day, int(Game.minute / 60.0) % 24, int(Game.minute) % 60]
		"day":
			for i in int(args[1]) if args.size() > 1 else 1:
				Game.day_tick()
			return _run(["time"])
		"ailment":
			var ailment: Variant = AilmentsDef.Ailment.get(args[1].to_upper()) if args.size() > 1 else null
			if ailment == null:
				return "Ailments: fatigue, cold"
			Game.stats.set_ailment(ailment, not Game.stats.has_ailment(ailment))
			return "%s %s" % [Game.ailments.names[ailment], "on" if Game.stats.has_ailment(ailment) else "off"]
	return HELP


func _add(args: PackedStringArray) -> String:
	if args.size() < 2 or not Game.items.has(StringName(args[1])):
		return "Items: %s" % ", ".join(Game.items.keys())
	var level: int = int(args[2]) if args.size() > 2 else 1
	var count: int = int(args[3]) if args.size() > 3 else 1
	if level < 1 or level > ItemStack.MAX_LEVEL or count < 1:
		return "Level must be 1-%d and count at least 1" % ItemStack.MAX_LEVEL
	var left: int = Game.inventory.add(Game.items[StringName(args[1])], level, count)
	return "Added %d %s Lv%d%s" % [count - left, args[1], level, " (%d didn't fit)" % left if left else ""]


func _list() -> String:
	var lines: PackedStringArray = ["Day %d, %d G" % [Game.day, Game.gold]]
	for i in Inventory.SIZE:
		var stack: ItemStack = Game.inventory.slots[i]
		if stack:
			lines.append("%2d: %s Lv%d x%d" % [i, stack.item.id, stack.level, stack.count])
	return "\n".join(lines)


func _skills() -> String:
	var lines: PackedStringArray = ["RP %d/%d, HP %d/%d" % [Game.stats.rp, Game.stats.max_rp(), Game.stats.hp, Game.vitals.max_hp]]
	for id in Game.skills:
		lines.append("%s Lv%d (%.1f XP)" % [id, Game.stats.level(id), Game.stats.xp(id)])
	return "\n".join(lines)
