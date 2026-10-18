class_name ItemStack
extends RefCounted

const MAX_LEVEL: int = 10

var item: ItemDef
var level: int
var count: int


func _init(p_item: ItemDef, p_level: int, p_count: int) -> void:
	item = p_item
	level = clampi(p_level, 1, MAX_LEVEL)
	count = p_count
