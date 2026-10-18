class_name HotbarSlot
extends PanelContainer

@onready var _icon: TextureRect = $Icon
@onready var _name: Label = $Name
@onready var _level: Label = $Level
@onready var _count: Label = $Count
@onready var _highlight: Panel = $Highlight


func show_stack(stack: ItemStack) -> void:
	_icon.texture = stack.item.icon if stack else null
	# Until an item has a painted icon, its name stands in for it.
	_name.text = stack.item.display_name if stack and stack.item.icon == null else ""
	_level.text = "Lv%d" % stack.level if stack else ""
	_count.text = str(stack.count) if stack and stack.count > 1 else ""


func set_selected(selected: bool) -> void:
	_highlight.visible = selected
