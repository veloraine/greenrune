class_name ItemDef
extends Resource

enum Category { TOOL, SEED, CROP }

@export var id: StringName
@export var display_name: String
@export var icon: Texture2D
@export var category: Category
@export var sell_price: int = 0
@export_range(1, 999) var max_stack: int = 99
