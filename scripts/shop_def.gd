class_name ShopDef
extends Resource

## Shown as the shop screen's title until NPCs have their own data.
@export var keeper_name: String
## What the shop sells, in display order, each at its item's buy_price. Like RF4, shops don't buy.
@export var stock: Array[ItemDef] = []
