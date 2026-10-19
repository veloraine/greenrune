class_name SaveGame
extends RefCounted

## Bump when the format changes, and teach read() to upgrade older versions.
const VERSION: int = 2
const PATH: String = "user://save.json"


static func write(tree: SceneTree) -> Error:
	var player: Node3D = tree.get_first_node_in_group(&"player")
	if player == null:
		return ERR_UNCONFIGURED
	var field: Array = []
	var plots: Dictionary[Vector2i, Field.Plot] = Game.field.plots()
	for cell in plots:
		var crop: Field.Crop = plots[cell].crop
		field.append({
			"cell": [cell.x, cell.y],
			"watered": plots[cell].watered,
			"crop": {"seed": crop.def.seed_item.id, "level": crop.level, "days": crop.days} if crop else null,
		})
	var xp: Dictionary = {}
	for id in Game.skills:
		xp[id] = Game.stats.xp(id)
	var ailments: Array = []
	for ailment in AilmentsDef.Ailment.values():
		if Game.stats.has_ailment(ailment):
			ailments.append(AilmentsDef.Ailment.find_key(ailment).to_lower())
	var data: Dictionary = {
		"version": VERSION,
		"day": Game.day,
		"minute": Game.minute,
		"gold": Game.gold,
		"player_position": [player.global_position.x, player.global_position.y, player.global_position.z],
		"rp": Game.stats.rp,
		"hp": Game.stats.hp,
		"xp": xp,
		"ailments": ailments,
		"inventory": _stacks_to_json(Game.inventory),
		"bin": _stacks_to_json(Game.bin),
		"field": field,
	}
	# Write a temp file and swap it in, so a crash mid-write can't destroy the last good save.
	var temp_path: String = PATH + ".tmp"
	var file: FileAccess = FileAccess.open(temp_path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	if not file.store_string(JSON.stringify(data, "\t")):
		return ERR_FILE_CANT_WRITE
	file.close()
	return DirAccess.rename_absolute(temp_path, PATH)


static func read(tree: SceneTree) -> Error:
	var player: Player = tree.get_first_node_in_group(&"player")
	if player == null:
		return ERR_UNCONFIGURED
	if not FileAccess.file_exists(PATH):
		return ERR_FILE_NOT_FOUND
	var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(PATH))
	if not (data is Dictionary and _is_number(data.get("version")) and data.version >= 1 and data.version <= VERSION):
		return ERR_FILE_UNRECOGNIZED
	data.merge(_defaults())
	if not _is_valid(data):
		return ERR_FILE_UNRECOGNIZED

	# Everything below runs only on a fully valid file, so a load never half-applies.
	# JSON numbers come back as floats, hence the int() casts.
	# A charge or swing holds a stack that is about to leave the inventory.
	player.cancel_tool()
	_load_stacks(Game.inventory, data.inventory)
	_load_stacks(Game.bin, data.bin)
	var plots: Dictionary[Vector2i, Field.Plot] = {}
	for entry: Dictionary in data.field:
		var plot := Field.Plot.new()
		plot.watered = entry.watered
		if entry.crop:
			var def: CropDef = Game.crops.get(StringName(entry.crop.seed))
			if def == null:
				push_warning("Save has unknown crop '%s'; dropping it" % entry.crop.seed)
			else:
				plot.crop = Field.Crop.new(def, clampi(int(entry.crop.level), 1, ItemStack.MAX_LEVEL))
				plot.crop.days = entry.crop.days
		plots[Vector2i(int(entry.cell[0]), int(entry.cell[1]))] = plot
	Game.field.replace_plots(plots)
	var xp: Dictionary[StringName, float] = {}
	for id: String in data.xp:
		if Game.skills.has(StringName(id)):
			xp[StringName(id)] = data.xp[id]
		else:
			push_warning("Save has unknown skill '%s'; dropping it" % id)
	var ailments: Dictionary[AilmentsDef.Ailment, bool] = {}
	for name: String in data.ailments:
		var ailment: Variant = AilmentsDef.Ailment.get(name.to_upper())
		if ailment == null:
			push_warning("Save has unknown ailment '%s'; dropping it" % name)
		else:
			ailments[ailment] = true
	Game.stats.restore(xp, int(data.rp), int(data.hp), ailments)
	Game.day = int(data.day)
	Game.minute = data.minute
	Game.gold = int(data.gold)
	var p: Array = data.player_position
	player.global_position = Vector3(p[0], p[1], p[2])
	return OK


## What a save lacking these fields loads with: a new game's values. v1 saves lack them all.
## A missing watering-can water level stays full, as ItemStack starts it.
static func _defaults() -> Dictionary:
	return {
		"minute": Game.clock.wake_hour * 60.0,
		# Full RP, since the XP default below leaves every skill at level 1.
		"rp": Game.vitals.base_max_rp,
		"hp": Game.vitals.max_hp,
		"xp": {},
		"ailments": [],
		"bin": [],
		"field": [],
	}


static func _is_valid(data: Dictionary) -> bool:
	for key: String in ["day", "minute", "gold", "rp", "hp"]:
		if not _is_number(data.get(key)):
			return false
	# Outside one waking day, the clock would run a DayTick on the next frame.
	if data.minute < Game.clock.wake_hour * 60.0 or data.minute >= (24 + Game.clock.wake_hour) * 60.0:
		return false
	var p: Variant = data.get("player_position")
	if not (p is Array and p.size() == 3 and p.all(_is_number)):
		return false
	var xp: Variant = data.get("xp")
	if not (xp is Dictionary and xp.values().all(_is_number)):
		return false
	var ailments: Variant = data.get("ailments")
	if not (ailments is Array and ailments.all(func(name: Variant) -> bool: return name is String)):
		return false
	if not (_is_valid_stacks(data.get("inventory"), Inventory.SIZE) and _is_valid_stacks(data.get("bin"), Game.shipping.bin_size)):
		return false
	var field: Variant = data.get("field")
	if not field is Array:
		return false
	for entry: Variant in field:
		if not (entry is Dictionary and entry.get("watered") is bool):
			return false
		var cell: Variant = entry.get("cell")
		if not (cell is Array and cell.size() == 2 and cell.all(_is_number)):
			return false
		var crop: Variant = entry.get("crop")
		if crop != null and not (crop is Dictionary and crop.get("seed") is String and _is_number(crop.get("level")) and _is_number(crop.get("days"))):
			return false
	return true


static func _stacks_to_json(inventory: Inventory) -> Array:
	var entries: Array = []
	for stack in inventory.slots:
		entries.append({"id": stack.item.id, "level": stack.level, "count": stack.count, "water": stack.water} if stack else null)
	return entries


## A stack over its item's max_stack, from a save written when stacks were bigger, keeps its slot capped
## and the rest is added back to the same bag or bin rather than clamped, so nothing is lost while there is room.
static func _load_stacks(inventory: Inventory, entries: Array) -> void:
	var slots: Array[ItemStack] = []
	var overflow: Array[ItemStack] = []
	for entry: Variant in entries:
		var item: ItemDef = Game.items.get(StringName(entry.id)) if entry else null
		if entry and item == null:
			push_warning("Save has unknown item '%s'; dropping it" % entry.id)
		var count: int = maxi(int(entry.count), 1) if item else 0
		var stack: ItemStack = ItemStack.new(item, int(entry.level), mini(count, item.max_stack)) if item else null
		if item is ToolDef and entry.has("water"):
			stack.water = clampi(int(entry.water), 0, item.capacity)
		if item and count > item.max_stack:
			overflow.append(ItemStack.new(item, stack.level, count - item.max_stack))
		slots.append(stack)
	inventory.replace_slots(slots)
	for extra in overflow:
		var lost: int = inventory.add(extra.item, extra.level, extra.count)
		if lost > 0:
			push_warning("Save has %d more %s Lv%d than fits; dropping them" % [lost, extra.item.id, extra.level])


static func _is_valid_stacks(entries: Variant, size: int) -> bool:
	if not (entries is Array and entries.size() <= size):
		return false
	for entry: Variant in entries:
		if entry == null:
			continue
		if not (entry is Dictionary and entry.get("id") is String and _is_number(entry.get("level")) and _is_number(entry.get("count")) and _is_number(entry.get("water", 0))):
			return false
	return true


# JSON reads huge numbers like 1e400 as INF, which would put the player at NaN.
static func _is_number(value: Variant) -> bool:
	return (value is float or value is int) and is_finite(value)
