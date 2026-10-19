class_name BinScreen
extends PanelContainer

var _slot_scene: PackedScene = load("res://ui/hotbar_slot.tscn")
var _bag_slots: Array[HotbarSlot] = []
var _bin_slots: Array[HotbarSlot] = []


func _ready() -> void:
	hide()
	_fill($Box/Bag/Grid, _bag_slots, Game.inventory, Game.bin)
	_fill($Box/Bin/Grid, _bin_slots, Game.bin, Game.inventory)
	Game.inventory.changed.connect(_refresh)
	Game.bin.changed.connect(_refresh)


## Pausing the tree stops the clock, so nothing ships while the screen is up.
func open() -> void:
	show()
	_refresh()
	get_tree().paused = true


func _unhandled_input(event: InputEvent) -> void:
	# Hidden, it still hears input while the sleep prompt or the console pauses the tree.
	if visible and (event.is_action_pressed("interact") or event.is_action_pressed("menu")):
		# Handled, or the farm would read the same F press once unpaused and open the screen again.
		get_viewport().set_input_as_handled()
		hide()
		get_tree().paused = false


## One clickable slot per slot of from; a click moves that slot's stack into to.
func _fill(grid: GridContainer, slots: Array[HotbarSlot], from: Inventory, to: Inventory) -> void:
	for i in from.slots.size():
		var slot: HotbarSlot = _slot_scene.instantiate()
		slot.mouse_filter = Control.MOUSE_FILTER_STOP
		slot.gui_input.connect(_on_slot_input.bind(from, i, to))
		slot.mouse_entered.connect(slot.set_selected.bind(true))
		slot.mouse_exited.connect(slot.set_selected.bind(false))
		grid.add_child(slot)
		slots.append(slot)


func _on_slot_input(event: InputEvent, from: Inventory, index: int, to: Inventory) -> void:
	if not (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		return
	# Like RF4's key items, something with no price can't be shipped; a tool would sell for 0 G and be gone.
	var stack: ItemStack = from.slots[index]
	if to == Game.bin and stack and stack.item.sell_price == 0:
		return
	from.move(index, to)


func _refresh() -> void:
	# The bag changes on every watering and sowing; open() catches up instead.
	if not visible:
		return
	for i in _bag_slots.size():
		_bag_slots[i].show_stack(Game.inventory.slots[i])
	for i in _bin_slots.size():
		_bin_slots[i].show_stack(Game.bin.slots[i])
