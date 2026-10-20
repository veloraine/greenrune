class_name ShopScreen
extends PanelContainer

var _slot_scene: PackedScene = load("res://ui/hotbar_slot.tscn")
var _shop: ShopDef
var _buttons: Array[Button] = []

@onready var _rows: VBoxContainer = $Box/Rows


func _ready() -> void:
	hide()


## Pausing the tree stops the clock, so nothing ships while the screen is up.
func open(shop: ShopDef) -> void:
	_shop = shop
	$Box/Title.text = "%s's Shop" % shop.keeper_name
	for row in _rows.get_children():
		row.free()
	_buttons.clear()
	for item in shop.stock:
		var row := HBoxContainer.new()
		_rows.add_child(row)
		var slot: HotbarSlot = _slot_scene.instantiate()
		row.add_child(slot)
		slot.show_stack(ItemStack.new(item, 1, 1))
		var button := Button.new()
		button.text = "%s   %d G" % [item.display_name, item.buy_price]
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		# No focus, or Space would buy again through the focused button.
		button.focus_mode = Control.FOCUS_NONE
		button.pressed.connect(_buy.bind(item))
		row.add_child(button)
		_buttons.append(button)
	show()
	_refresh()
	get_tree().paused = true


func _unhandled_input(event: InputEvent) -> void:
	if visible and (event.is_action_pressed("interact") or event.is_action_pressed("menu")):
		# Handled, or the town would read the same F press once unpaused and open the screen again.
		get_viewport().set_input_as_handled()
		hide()
		get_tree().paused = false


func _buy(item: ItemDef) -> void:
	# A console load can change gold or the bag while the screen is open.
	if Game.gold < item.buy_price or Game.inventory.room_for(item, 1) == 0:
		_refresh()
		return
	Game.gold -= item.buy_price
	Game.inventory.add(item, 1, 1)
	_refresh()


## A button is disabled when its item costs more than the gold left or the bag has no room for one.
func _refresh() -> void:
	for i in _buttons.size():
		var item: ItemDef = _shop.stock[i]
		_buttons[i].disabled = Game.gold < item.buy_price or Game.inventory.room_for(item, 1) == 0
