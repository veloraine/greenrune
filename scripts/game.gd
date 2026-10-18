extends Node

## Emitted at the end of the DayTick, after every overnight change.
signal day_started
## Emitted once a night, when the clock passes the bedtime hour.
signal yawned

const ITEMS_DIR: String = "res://data/items/"
const SKILLS_DIR: String = "res://data/skills/"
const CROPS_DIR: String = "res://data/crops/"

var items: Dictionary[StringName, ItemDef] = {}
var skills: Dictionary[StringName, SkillDef] = {}
## Keyed by the seed item's id.
var crops: Dictionary[StringName, CropDef] = {}
var vitals: VitalsDef = load("res://data/vitals.tres")
var clock: ClockDef = load("res://data/clock.tres")
var stats: Stats
var inventory: Inventory = Inventory.new()
var field: Field = Field.new()
var day: int = 1
## Minutes since 00:00 of the current day. Past midnight it runs on beyond 1440.
var minute: float = clock.wake_hour * 60.0
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
	for file in ResourceLoader.list_directory(CROPS_DIR):
		if file.ends_with(".tres"):
			var crop: CropDef = load(CROPS_DIR + file)
			crops[crop.seed_item.id] = crop
	stats = Stats.new(vitals, skills)


func _process(delta: float) -> void:
	var before: float = minute
	minute += delta / clock.seconds_per_minute
	if before < clock.bedtime_hour * 60.0 and minute >= clock.bedtime_hour * 60.0:
		yawned.emit()
	# Like RF4, staying up all night costs nothing: the next morning simply starts.
	if minute >= (24 + clock.wake_hour) * 60.0:
		day_tick()


## The DayTick: the one pipeline that starts each day at the wake hour, after a sleep, a faint or an all-nighter.
## Steps run in this order.
func day_tick() -> void:
	day += 1
	minute = clock.wake_hour * 60.0
	# Crops grow on last night's water, so they go before the soil dries.
	field.grow_crops()
	field.dry()
	day_started.emit()
