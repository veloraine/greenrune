extends HBoxContainer

var _slots: Array[HotbarSlot] = []


func _ready() -> void:
	_slots.assign(get_children())
	Game.inventory.changed.connect(_refresh)
	_refresh()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hotbar_next"):
		Game.inventory.select(Game.inventory.selected + 1)
	elif event.is_action_pressed("hotbar_prev"):
		Game.inventory.select(Game.inventory.selected - 1)


func _refresh() -> void:
	for i in _slots.size():
		_slots[i].show_stack(Game.inventory.slots[i])
		_slots[i].set_selected(i == Game.inventory.selected)
