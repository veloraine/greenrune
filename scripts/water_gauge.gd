extends ProgressBar

## The selected watering can's water, one step per plot. Hidden unless a can is selected.

@onready var _label: Label = $Label


func _ready() -> void:
	Game.inventory.changed.connect(_refresh)
	_refresh()


func _refresh() -> void:
	var stack: ItemStack = Game.inventory.slots[Game.inventory.selected]
	var can: ToolDef = stack.item as ToolDef if stack else null
	visible = can != null and can.capacity > 0
	if not visible:
		return
	max_value = can.capacity
	value = stack.water
	_label.text = "Water %d / %d" % [stack.water, can.capacity]
