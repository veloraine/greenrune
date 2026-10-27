class_name DebrisDef
extends Resource

## How a piece of debris is cleared off the field. Clearing itself arrives in Phase 1.3.
enum Clear { HAND }

@export var id: StringName
## Sits centred on its tile's top face.
@export var model: PackedScene
@export var cleared_by: Clear
## What clearing it gives. null gives nothing.
@export var drop: ItemDef
