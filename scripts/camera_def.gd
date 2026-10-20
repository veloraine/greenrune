class_name CameraDef
extends Resource

## Framing everywhere outside, like RF4's high, far, narrow-lens view of the town.
## The camera follows the player.
@export var outdoor: CameraFraming
## Framing while the player stands in an area of the "indoors" group, so a small room fills the screen.
## The camera holds on the area's centre, so size the area to the room.
@export var indoor: CameraFraming
