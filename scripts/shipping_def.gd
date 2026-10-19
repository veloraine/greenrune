class_name ShippingDef
extends Resource

## The bin's contents sell when the clock passes this hour each morning.
@export_range(0, 24) var sell_hour: int = 0
@export var bin_size: int = 0
## Ship price per level as a percentage of the item's sell_price, index 0 being level 1.
## Whole percentages, so the rounding down is exact: 90 × 1.4 in floats is 125.99….
@export var level_percent: Dictionary[ItemDef.Category, PackedInt32Array] = {}


## What one item of this kind and level ships for, rounded down.
func price(item: ItemDef, level: int) -> int:
	return item.sell_price * level_percent[item.category][level - 1] / 100
