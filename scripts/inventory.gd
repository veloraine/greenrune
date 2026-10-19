class_name Inventory
extends RefCounted

signal changed

const SIZE: int = 24
## The first HOTBAR_SIZE slots are the hotbar.
const HOTBAR_SIZE: int = 8

## null means an empty slot.
var slots: Array[ItemStack] = []
var selected: int = 0


func _init(size: int = SIZE) -> void:
	slots.resize(size)


## Fills stacks of the same item and level first, then empty slots. Returns what didn't fit.
func add(item: ItemDef, level: int, count: int) -> int:
	# Clamp first, or an out-of-range level would never match the clamped stacks.
	level = clampi(level, 1, ItemStack.MAX_LEVEL)
	for stack in slots:
		if count > 0 and stack and stack.item == item and stack.level == level:
			var moved: int = mini(item.max_stack - stack.count, count)
			stack.count += moved
			count -= moved
	for i in slots.size():
		if count > 0 and slots[i] == null:
			var moved: int = mini(item.max_stack, count)
			slots[i] = ItemStack.new(item, level, moved)
			count -= moved
	changed.emit()
	return count


## How many of item at level would fit.
func room_for(item: ItemDef, level: int) -> int:
	level = clampi(level, 1, ItemStack.MAX_LEVEL)
	var room: int = 0
	for stack in slots:
		if stack == null:
			room += item.max_stack
		elif stack.item == item and stack.level == level:
			room += item.max_stack - stack.count
	return room


## Moves the stack at index into to, all of it or none: onto stacks of the same item and level first,
## then the stack itself into the first empty slot, so a watering can keeps its water.
func move(index: int, to: Inventory) -> void:
	var stack: ItemStack = slots[index]
	if stack == null or to.room_for(stack.item, stack.level) < stack.count:
		return
	slots[index] = null
	for other in to.slots:
		if other and other.item == stack.item and other.level == stack.level:
			var moved: int = mini(stack.item.max_stack - other.count, stack.count)
			other.count += moved
			stack.count -= moved
	if stack.count > 0:
		to.slots[to.slots.find(null)] = stack
	changed.emit()
	to.changed.emit()


func select(index: int) -> void:
	selected = posmod(index, HOTBAR_SIZE)
	changed.emit()


func replace_slots(new_slots: Array[ItemStack]) -> void:
	var size: int = slots.size()
	slots = new_slots
	slots.resize(size)
	changed.emit()
