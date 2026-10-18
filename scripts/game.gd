extends Node

const ITEMS_DIR: String = "res://data/items/"
const SKILLS_DIR: String = "res://data/skills/"

var items: Dictionary[StringName, ItemDef] = {}
var skills: Dictionary[StringName, SkillDef] = {}
var vitals: VitalsDef = load("res://data/vitals.tres")
var stats: Stats
var inventory: Inventory = Inventory.new()
var field: Field = Field.new()
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
	for file in ResourceLoader.list_directory(SKILLS_DIR):
		if file.ends_with(".tres"):
			var skill: SkillDef = load(SKILLS_DIR + file)
			skills[skill.id] = skill
	stats = Stats.new(vitals, skills)
