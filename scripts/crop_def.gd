class_name CropDef
extends Resource

## The seeds that sow this crop, one per tile.
@export var seed_item: ItemDef
## What a ripe crop gives when picked. Its sell price is on the item.
@export var harvest: ItemDef
## How many a ripe crop gives when picked by hand.
@export_range(1, 99) var harvest_count: int = 1
## Watered days spent in each stage before the next. Stage 0 is the unsprouted seed. The crop is ripe once it has grown through them all.
@export var stage_days: Array[int] = []
## The sprite for each stage, from the seed to the ripe crop: one more than stage_days.
@export var stage_textures: Array[Texture2D] = []
## Days of growth from a day it wasn't watered.
@export_range(0.0, 1.0) var dry_growth: float = 0.5
## Chance that reaping a ripe crop with the sickle returns its seeds one level higher.
@export_range(0.0, 1.0) var reap_level_up_chance: float = 0.0
