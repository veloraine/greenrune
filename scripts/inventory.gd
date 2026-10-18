class_name Inventory
extends RefCounted

signal changed

const SIZE: int = 24
## The first HOTBAR_SIZE slots are the hotbar.
const HOTBAR_SIZE: int = 8

## null means an empty slot.
var slots: Array[ItemStack] = []
var selected: int = 0


func _init() -> void:
	slots.resize(SIZE)


## Fills stacks of the same item and level first, then empty slots. Returns what didn't fit.
func add(item: ItemDef, level: int, count: int) -> int:
	# Clamp first, or an out-of-range level would never match the clamped stacks.
	level = clampi(level, 1, ItemStack.MAX_LEVEL)
	for stack in slots:
		if count > 0 and stack and stack.item == item and stack.level == level:
			var moved: int = mini(item.max_stack - stack.count, count)
			stack.count += moved
			count -= moved
	for i in SIZE:
		if count > 0 and slots[i] == null:
			var moved: int = mini(item.max_stack, count)
			slots[i] = ItemStack.new(item, level, moved)
			count -= moved
	changed.emit()
	return count


func select(index: int) -> void:
	selected = posmod(index, HOTBAR_SIZE)
	changed.emit()


func replace_slots(new_slots: Array[ItemStack]) -> void:
	slots = new_slots
	slots.resize(SIZE)
	changed.emit()
