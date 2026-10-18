extends Node

const ITEMS_DIR: String = "res://data/items/"

var items: Dictionary[StringName, ItemDef] = {}
var inventory: Inventory = Inventory.new()
var day: int = 1
var gold: int = 0


func _ready() -> void:
	for file in ResourceLoader.list_directory(ITEMS_DIR):
		if not file.ends_with(".tres"):
			continue
		var item: ItemDef = load(ITEMS_DIR + file)
		if items.has(item.id):
			push_error("Duplicate item id '%s' in %s" % [item.id, file])
		if item.max_stack < 1:
			push_error("Item %s has max_stack %d; skipping it" % [file, item.max_stack])
			continue
		items[item.id] = item
