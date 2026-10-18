class_name SaveGame
extends RefCounted

## Bump when the format changes, and teach read() to upgrade older versions.
const VERSION: int = 1
const PATH: String = "user://save.json"


static func write(tree: SceneTree) -> Error:
	var player: Node3D = tree.get_first_node_in_group(&"player")
	if player == null:
		return ERR_UNCONFIGURED
	var inventory: Array = []
	for stack in Game.inventory.slots:
		inventory.append({"id": stack.item.id, "level": stack.level, "count": stack.count} if stack else null)
	var data: Dictionary = {
		"version": VERSION,
		"day": Game.day,
		"gold": Game.gold,
		"player_position": [player.global_position.x, player.global_position.y, player.global_position.z],
		"inventory": inventory,
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
	var player: Node3D = tree.get_first_node_in_group(&"player")
	if player == null:
		return ERR_UNCONFIGURED
	if not FileAccess.file_exists(PATH):
		return ERR_FILE_NOT_FOUND
	var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(PATH))
	if not _is_valid(data):
		return ERR_FILE_UNRECOGNIZED

	# Everything below runs only on a fully valid file, so a load never half-applies.
	# JSON numbers come back as floats, hence the int() casts.
	var slots: Array[ItemStack] = []
	for entry: Variant in data.inventory:
		var item: ItemDef = Game.items.get(StringName(entry.id)) if entry else null
		if entry and item == null:
			push_warning("Save has unknown item '%s'; dropping it" % entry.id)
		slots.append(ItemStack.new(item, int(entry.level), clampi(int(entry.count), 1, item.max_stack)) if item else null)
	Game.inventory.replace_slots(slots)
	Game.day = int(data.day)
	Game.gold = int(data.gold)
	var p: Array = data.player_position
	player.global_position = Vector3(p[0], p[1], p[2])
	return OK


static func _is_valid(data: Variant) -> bool:
	if not data is Dictionary:
		return false
	if not (_is_number(data.get("version")) and data.version == VERSION):
		return false
	if not (_is_number(data.get("day")) and _is_number(data.get("gold"))):
		return false
	var p: Variant = data.get("player_position")
	if not (p is Array and p.size() == 3 and p.all(_is_number)):
		return false
	var inventory: Variant = data.get("inventory")
	if not (inventory is Array and inventory.size() <= Inventory.SIZE):
		return false
	for entry: Variant in inventory:
		if entry == null:
			continue
		if not (entry is Dictionary and entry.get("id") is String and _is_number(entry.get("level")) and _is_number(entry.get("count"))):
			return false
	return true


# JSON reads huge numbers like 1e400 as INF, which would put the player at NaN.
static func _is_number(value: Variant) -> bool:
	return (value is float or value is int) and is_finite(value)
